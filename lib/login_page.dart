import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'account_store.dart';
import 'home_page.dart';
import 'password_flow.dart';
import 'register_page.dart';

const _loginOrange = Color(0xFFF28C28);
const _loginInk = Color(0xFF1B1C1C);
const _loginMuted = Color(0xFF5F5E5E);
const _loginSurface = Color(0xFFFBF9F9);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openRegister() async {
    final email = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(builder: (_) => const RegisterPage()),
    );
    if (email != null && mounted) {
      _emailController.text = email;
      _showMessage('Akun berhasil dibuat. Masukkan password untuk Log In.');
    }
  }

  void _login() {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showMessage('Masukkan email dan password terlebih dahulu.');
      return;
    }
    final account = LocalAccountStore.authenticate(
      _emailController.text,
      _passwordController.text,
    );
    if (account == null) {
      _showMessage(
        'Email atau password salah. Buat akun lewat Sign Up jika belum punya akun.',
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeDashboardPage(account: account),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _loginSurface,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: math.max(0.0, constraints.maxHeight - 50),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 460),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      margin: const EdgeInsets.only(bottom: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xFF303031),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Color(0x14000000), blurRadius: 8),
                        ],
                      ),
                      child: const Icon(
                        Icons.landscape,
                        color: _loginOrange,
                        size: 42,
                      ),
                    ),
                    const Text(
                      'GEARUP',
                      style: TextStyle(
                        color: _loginInk,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .4,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'RENT • EXPLORE',
                      style: TextStyle(
                        color: _loginOrange,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      'Welcome Back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _loginInk,
                        fontSize: 27,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Sign in to continue your outdoor adventure.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _loginMuted, fontSize: 14),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(color: Color(0x10000000), blurRadius: 12),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FieldLabel('Email Address'),
                          const SizedBox(height: 7),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            decoration: _inputDecoration(
                              hint: 'alex.chen@expedition.com',
                              icon: Icons.mail_outline,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Password'),
                          const SizedBox(height: 7),
                          TextField(
                            controller: _passwordController,
                            obscureText: !_showPassword,
                            textInputAction: TextInputAction.done,
                            decoration: _inputDecoration(
                              hint: 'Enter your password',
                              icon: Icons.lock_outline,
                              suffix: IconButton(
                                tooltip: _showPassword
                                    ? 'Sembunyikan password'
                                    : 'Tampilkan password',
                                onPressed: () => setState(
                                  () => _showPassword = !_showPassword,
                                ),
                                icon: Icon(
                                  _showPassword
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: _loginOrange,
                                visualDensity: VisualDensity.compact,
                                onChanged: (value) => setState(
                                  () => _rememberMe = value ?? false,
                                ),
                              ),
                              const Expanded(
                                child: Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: _loginInk,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: _loginOrange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _loginOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _login,
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: const Text(
                                'Log In',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const SizedBox(height: 22),
                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: _loginMuted, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: _openRegister,
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: _loginOrange,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          size: 16,
                          color: _loginMuted,
                        ),
                        SizedBox(width: 7),
                        Text(
                          'ALPINE TESTED • BACKCOUNTRY CERTIFIED',
                          style: TextStyle(
                            color: _loginMuted,
                            fontSize: 9,
                            letterSpacing: .8,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13),
    prefixIcon: Icon(icon, color: _loginMuted, size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: _loginSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFDBC2B0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFDBC2B0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _loginOrange, width: 1.5),
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
    label,
    style: const TextStyle(
      color: _loginInk,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );
}
