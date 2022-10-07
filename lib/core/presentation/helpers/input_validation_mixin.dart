mixin InputValidationMixin {
  final atLeastOneNumberRegex = RegExp(r'[0-9]');
  final atLeastOneUpperCaseRegex = RegExp(r'[A-Z]');
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //Mínimo 8 caracteres, uma letra maiúscula e um número
  final passwordRegex =
      RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');
  final invalidCharacterRegex = RegExp(r'[^a-zA-Z\u00C0-\u00FF ]+');
  final notNumberRegex = RegExp(r'[^0-9]');

  String? validateString(str, min, max,
      {required = true, emptyText = "Informe um valor"}) {
    if (str == null && required) {
      return emptyText;
    }
    str = str as String;
    if (str.isEmpty && required) {
      return emptyText;
    }
    if (str.length < min && required) {
      return "Deve conter $min caracteres no mínimo";
    }
    if (str.length > max) {
      return "Limite de caracteres excedido";
    }
    return null;
  }

  String? validatePassword(
    password, {
    extraValidation,
  }) {
    String? stringValidation = validateString(password, 8, 100);
    if (stringValidation != null) {
      return stringValidation;
    }
    if (!atLeastOneNumberRegex.hasMatch(password)) {
      return "Deve conter um número";
    }
    if (!atLeastOneUpperCaseRegex.hasMatch(password)) {
      return "Deve conter uma letra maiúscula";
    }
    if (!passwordRegex.hasMatch(password)) {
      return "Deve conter uma letra minúscula";
    }
    if (extraValidation != null) return extraValidation(password);
    return null;
  }

  String? validateEmail(email) {
    String? stringValidation = validateString(email, 0, 320);
    if (stringValidation != null) {
      return stringValidation;
    }
    if (!emailRegex.hasMatch(email)) {
      return "Email inválido";
    }
    return null;
  }

  String? validateName(name) {
    String? stringValidation = validateString(name, 0, 100);
    if (stringValidation != null) {
      return stringValidation;
    }
    if (invalidCharacterRegex.hasMatch(name)) {
      return "Insira apenas caracteres válidos!";
    } else {
      return null;
    }
  }

  String? validatePhone(phone) {
    if (phone == null) {
      return "Informe um telefone";
    }
    phone = phone as String;
    phone = phone.replaceFirst("(", "");
    phone = phone.replaceFirst(")", "");
    phone = phone.replaceAll(" ", "");
    phone = phone.replaceFirst("-", "");
    if (phone.isEmpty) {
      return "Informe um telefone";
    }
    if (phone.length < 10) {
      return "Complete o número";
    }
    if (notNumberRegex.hasMatch(phone)) {
      return "Insira apenas números!";
    }
    return null;
  }
}
