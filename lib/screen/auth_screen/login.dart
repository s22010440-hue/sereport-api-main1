// ignore_for_file: use_super_parameters, library_private_types_in_public_api, unused_local_variable, avoid_unnecessary_containers, avoid_print, unused_field, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sereports/constants.dart';
import 'package:sereports/repository/auth_repo.dart';
import 'package:sereports/screen/dashboard/dashbaord.dart';
import 'package:sereports/widget/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _pinnumberController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  bool _showPassword = false;
  bool _showPinnumber = false;

  String? _emailError;
  String? _passwordError;
  String? _pinnumberError;

  @override
  void initState() {
    super.initState();
    _checkExistingLogin();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pinnumberController.dispose();
    super.dispose();
  }

  bool _validateFields() {
    setState(() {
      _emailError =
          _emailController.text.trim().isEmpty ? 'Username is required' : null;
      _passwordError =
          _passwordController.text.isEmpty ? 'Password is required' : null;
      _pinnumberError = _pinnumberController.text.trim().isEmpty
          ? 'Pin number is required'
          : null;
    });

    return _emailError == null &&
        _passwordError == null &&
        _pinnumberError == null;
  }

  Future<void> _login() async {
    if (!_validateFields()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();

      final String email = _emailController.text.trim();
      final String password = _passwordController.text;
      final String pinnumber = _pinnumberController.text.trim();

      final success =
          await AuthRepo(preferences).login(email, password, pinnumber);

      if (success) {
        showSuccessSnackBar(context, 'Login successful!');
        _navigateToDashboard();
      } else {
        showErrorSnackBar(context, 'Invalid username, password or pin number');
      }
    } catch (e) {
      showErrorSnackBar(context, 'Login failed: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _checkExistingLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final isLoggedIn = await AuthRepo(preferences).isLoggedIn();
    if (isLoggedIn) {
      _navigateToDashboard();
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashbaordScreen()));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    String? errorText,
    Widget? suffixIcon,
  }) {
    final bool hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radiusValue),
            border: Border.all(
              color: hasError ? Colors.red.shade400 : const Color(0xFFDDE1E7),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: grayColorForHintText, fontSize: 14),
              prefixIcon: Icon(
                icon,
                size: 20,
                color: hasError ? Colors.red.shade400 : const Color(0xFF9AA0A6),
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 13, color: Colors.red.shade400),
              const SizedBox(width: 4),
              Text(
                errorText,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.red.shade400,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEyeToggle({
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
        size: 20,
        color: const Color(0xFF9AA0A6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      splashRadius: 18,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      child: Image.asset(
                        'assets/icon/logo.png',
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Welcome to SeReports',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Please Login!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _emailController,
                      hint: 'User Name',
                      icon: Icons.person_outline_rounded,
                      keyboardType: TextInputType.text,
                      errorText: _emailError,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _passwordController,
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      obscure: !_showPassword,
                      errorText: _passwordError,
                      suffixIcon: _buildEyeToggle(
                        isVisible: _showPassword,
                        onToggle: () =>
                            setState(() => _showPassword = !_showPassword),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: _pinnumberController,
                      hint: 'Pin Number',
                      icon: Icons.pin_outlined,
                      obscure: !_showPinnumber,
                      errorText: _pinnumberError,
                      suffixIcon: _buildEyeToggle(
                        isVisible: _showPinnumber,
                        onToggle: () =>
                            setState(() => _showPinnumber = !_showPinnumber),
                      ),
                    ),

                    if (_pinnumberError == null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5, left: 4),
                        child: Text(
                          'Enter the pin number provided by your administrator.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kButtonColor,
                          elevation: 2,
                          shadowColor: kButtonColor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radiusValue),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}