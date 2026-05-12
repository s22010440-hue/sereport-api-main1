// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sereports/screen/auth_screen/login.dart';
import 'package:sereports/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final SharedPreferences _preferences;
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  AuthRepo(this._preferences);
  final String _tokenKey = 'jwt_token';
  final String _expiryKey = 'jwt_expiry';

  Future<bool> login(
      String username, String password, String pinnumber) async {
    try {
      final statusCode =
          await Api.loginCompany(username, password, pinnumber);
      return statusCode == 200;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> saveToken(String token, {int expiryDays = 1}) async {
    await _preferences.setString(_tokenKey, token);
    final expiry =
        DateTime.now().add(Duration(days: expiryDays)).millisecondsSinceEpoch;
    await _preferences.setInt(_expiryKey, expiry);
  }

  Future<String?> getToken() async {
    final token = _preferences.getString(_tokenKey);
    final expiry = _preferences.getInt(_expiryKey);

    if (token == null || expiry == null) {
      return null;
    }

    if (DateTime.now().millisecondsSinceEpoch > expiry) {
      await logout();
      return null;
    }

    return token;
  }

  Future<void> logout() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_expiryKey);
  }

  Future<bool> isLoggedIn() async {
    return await getToken() != null;
  }

  void redirectToLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }
}