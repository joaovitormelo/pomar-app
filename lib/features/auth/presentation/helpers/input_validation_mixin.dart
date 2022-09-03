mixin InputValidationMixin {
  final atLeastOneNumberRegex = RegExp(r'[0-9]');
  final atLeastOneUpperCaseRegex = RegExp(r'[A-Z]');
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //Mínimo 8 caracteres, uma letra maiúscula e um número
  final passwordRegex =
      RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$');

  String? validatePassword(String password) {
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
    return null;
  }

  String? validateEmail(String email) {
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
}
