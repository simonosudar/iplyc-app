validatePassword(String password) {
  final passwordReg =
      new RegExp(r"^(?=.*[A-Za-z])(?=*[a-z])(?=.*\d[A-Za-z]\d){8,}");
  return passwordReg.hasMatch(password);
}
