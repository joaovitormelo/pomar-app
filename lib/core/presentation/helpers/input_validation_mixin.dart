mixin InputValidationMixin {
  final atLeastOneNumberRegex = RegExp(r'[0-9]');
  final atLeastOneUpperCaseRegex = RegExp(r'[A-Z]');
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //Mínimo 8 caracteres, uma letra maiúscula e um número
  final passwordRegex =
      RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');
  final invalidCharacterRegex = RegExp(r'[^a-zA-Z\u00C0-\u00FF ]+');
  final notNumberRegex = RegExp(r'[^0-9]');

  String? validatePassword(
    password, {
    extraValidation,
  }) {
    if (password == null) {
      return "Informe uma senha";
    }
    password = password as String;
    if (password.isEmpty) {
      return "Informe uma senha";
    }
    if (password.length > 100) {
      return "Senha excedeu o limite de caracteres";
    }
    if (password.length < 8) {
      return "Deve conter 8 caracteres";
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
    if (email == null) {
      return "Informe um email";
    }
    email = email as String;
    if (email.isEmpty) {
      return "Informe um email";
    }
    if (email.length > 320) {
      return "Email excedeu o limite de caracteres";
    }
    if (!emailRegex.hasMatch(email)) {
      return "Email inválido";
    }
    return null;
  }

  String? validateName(name) {
    if (name == null) {
      return "Informe um nome";
    }
    name = name as String;
    if (name.isEmpty) {
      return "Informe um nome";
    } else if (name.length > 100) {
      return "Nome excedeu o limite de caracteres";
    } else if (invalidCharacterRegex.hasMatch(name)) {
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
