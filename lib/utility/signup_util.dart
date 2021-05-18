import 'package:flutter/material.dart';

class SignUpUtils{
  static String emailRegexValidate(BuildContext context, String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(email)) {
      return 'Email tidak valid';
    }
    return null;
  }

  static String passwordRegexValidate(BuildContext context, String password) {
    Pattern pattern =
        r'^(?:(?=.*[a-z])(?:(?=.*[A-Z])(?=.*[\d\W])|(?=.*\W)(?=.*\d))|(?=.*\W)(?=.*[A-Z])(?=.*\d)).{8,}$';
    RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(password)) {
      return 'Kata sandi harus memiliki setidaknya 8 karakter, termasuk setidaknya satu huruf besar, satu huruf kecil, dan satu digit angka.';
    }
    return null;
  }

  static String isConfirmPasswordValid(
      BuildContext context, String password, String confirmPassword) {
    if (password != confirmPassword) {
      return 'Kata sandi tidak cocok';
    } else if (confirmPassword.isEmpty) {
      return 'Kata sandi tidak cocok';
    }
    return null;
  }
}