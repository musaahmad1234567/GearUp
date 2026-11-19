import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'account_store.dart';

const _registerOrange = Color(0xFFF28C28);
const _registerInk = Color(0xFF1B1C1C);
const _registerMuted = Color(0xFF5F5E5E);
const _registerSurface = Color(0xFFFBF9F9);
const _gearupLogo =
    'assets/images/backpack.jpg';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _acceptedTerms = false;
  bool _submitPressed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    setState(() => _submitPressed = true);
    Future<void>.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _submitPressed = false);
    });
    FocusScope.of(context).unfocus();
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      _showMessage('Lengkapi semua data terlebih dahulu.');
    } else if (!_emailController.text.trim().contains('@')) {
      _showMessage('Masukkan alamat email yang valid.');
    } else if (_passwordController.text.length < 8) {
      _showMessage('Password harus terdiri dari minimal 8 karakter.');
    } else if (_passwordController.text != _confirmController.text) {
      _showMessage('Konfirmasi password belum cocok.');
    } else if (!_acceptedTerms) {
      _showMessage('Setujui Terms & Conditions untuk melanjutkan.');
    } else if (!LocalAccountStore.create(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
    )) {
      _showMessage('Email ini sudah terdaftar. Silakan Log In.');
    } else {
      Navigator.of(context).pop(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _registerSurface,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: math.max(0.0, constraints.maxHeight - 48),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color(0xFF303031),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Color(0x18000000), blurRadius: 8),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              _gearupLogo,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stack) => const Icon(
                                Icons.landscape,
                                color: _registerOrange,
                                size: 42,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4E2E1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 6,
                                height: 6,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: _registerOrange, shape: BoxShape.circle),
                                ),
                              ),
                              SizedBox(width: 7),
                              Text(
                                'BASECAMP ACCESS',
                                style: TextStyle(color: _registerMuted, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 1),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _registerInk, fontSize: 27, height: 1.2, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Join GEARUP and get ready for your next alpine or backcountry adventure.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: _registerMuted, fontSize: 14, height: 1.45),
                        ),
                        const SizedBox(height: 22),
                        _RegisterField(
                          label: 'FULL NAME',
                          hint: 'Alex Chen',
                          icon: Icons.person_outline,
                          controller: _nameController,
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 14),
                        _RegisterField(
                          label: 'EMAIL ADDRESS',
                          hint: 'alex.chen@expedition.com',
                          icon: Icons.mail_outline,
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 14),
                        _RegisterField(
                          label: 'PHONE NUMBER',
                          hint: '+1 (555) 234-5678',
                          icon: Icons.call_outlined,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 14),
                        _RegisterField(
                          label: 'PASSWORD',
                          hint: 'Create strong password',
                          icon: Icons.lock_outline,
                          controller: _passwordController,
                          obscureText: !_showPassword,
                          textInputAction: TextInputAction.next,
                          suffix: IconButton(
                            tooltip: _showPassword ? 'Sembunyikan password' : 'Tampilkan password',
                            onPressed: () => setState(() => _showPassword = !_showPassword),
                            icon: Icon(_showPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _RegisterField(
                          label: 'CONFIRM PASSWORD',
                          hint: 'Confirm password',
                          icon: Icons.lock_reset_outlined,
                          controller: _confirmController,
                          obscureText: !_showConfirmPassword,
                          textInputAction: TextInputAction.done,
                          suffix: IconButton(
                            tooltip: _showConfirmPassword ? 'Sembunyikan password' : 'Tampilkan password',
                            onPressed: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                            icon: Icon(_showConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          ),
                        ),
                        const SizedBox(height: 14),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  value: _acceptedTerms,
                                  activeColor: _registerOrange,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
                                ),
                                const Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 9),
                                    child: Text.rich(
                                      TextSpan(
                                        style: TextStyle(color: _registerMuted, fontSize: 12, height: 1.4),
                                        children: [
                                          TextSpan(text: 'I agree to the '),
                                          TextSpan(text: 'Terms & Conditions', style: TextStyle(color: _registerOrange, fontWeight: FontWeight.w600)),
                                          TextSpan(text: ' and '),
                                          TextSpan(text: 'Privacy Policy', style: TextStyle(color: _registerOrange, fontWeight: FontWeight.w600)),
                                          TextSpan(text: '.'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedScale(
                          scale: _submitPressed ? .98 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _registerOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: _submit,
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: const Text('Create Account', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Already have an account? ', style: TextStyle(color: _registerMuted, fontSize: 12)),
                            TextButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              child: const Text('Log In', style: TextStyle(color: _registerOrange, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3F3),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)],
                          ),
                          child: const Row(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(color: Color(0xFFE3E2E2), borderRadius: BorderRadius.all(Radius.circular(12))),
                                  child: Icon(Icons.verified_user_outlined, color: Color(0xFF303031)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Verified Alpine Rentals', style: TextStyle(color: _registerInk, fontSize: 14, fontWeight: FontWeight.w700)),
                                    SizedBox(height: 3),
                                    Text('Every tent, pack, and harness is rigorously field-inspected before deployment.', style: TextStyle(color: _registerMuted, fontSize: 11, height: 1.3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
}

class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.obscureText = false,
    this.suffix,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              label,
              style: const TextStyle(
                color: _registerMuted,
                fontSize: 10,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            obscureText: obscureText,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFFC8C6C5), fontSize: 13),
              prefixIcon: Icon(icon, color: _registerMuted, size: 20),
              suffixIcon: suffix,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0x18000000)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _registerOrange, width: 1.5),
              ),
            ),
          ),
        ],
      );
}
