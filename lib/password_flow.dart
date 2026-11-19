import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'account_store.dart';

const _passwordOrange = Color(0xFFF28C28);
const _passwordInk = Color(0xFF1B1C1C);
const _passwordMuted = Color(0xFF5F5E5E);
const _passwordSurface = Color(0xFFFBF9F9);

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _linkSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendResetLink() {
    FocusScope.of(context).unfocus();
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      _message('Masukkan alamat email yang valid.');
      return;
    }
    if (!LocalAccountStore.contains(email)) {
      _message('Email belum terdaftar. Periksa email atau buat akun lewat Sign Up.');
      return;
    }
    setState(() => _linkSent = true);
  }

  void _message(String message) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  void _continueToReset() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ResetPasswordPage(email: _emailController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _passwordSurface,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: _passwordInk),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: const Color(0xFF303031),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.landscape, color: _passwordOrange, size: 20),
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text('Forgot Password?', style: TextStyle(color: _passwordInk, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircleAvatar(radius: 16, backgroundColor: Color(0xFF914D00), child: Icon(Icons.person, size: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(color: Color(0xFFFFDCC3), shape: BoxShape.circle),
                            child: Stack(alignment: Alignment.center, children: [
                              Container(width: 56, height: 56, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.lock_reset, color: _passwordOrange, size: 28)),
                              Positioned(right: 0, bottom: 0, child: Container(width: 28, height: 28, decoration: const BoxDecoration(color: _passwordInk, shape: BoxShape.circle), child: const Icon(Icons.shield_outlined, color: Colors.white, size: 15))),
                            ]),
                          ),
                          const SizedBox(height: 18),
                          const Text('Forgot Password?', textAlign: TextAlign.center, style: TextStyle(color: _passwordInk, fontSize: 26, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          const Text('Enter your email address to receive password reset instructions.', textAlign: TextAlign.center, style: TextStyle(color: _passwordMuted, fontSize: 14, height: 1.5)),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 10)]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(11),
                                  decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)),
                                  child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Icon(Icons.info_outline, color: _passwordOrange, size: 19),
                                    SizedBox(width: 8),
                                    Expanded(child: Text('We will send a 6-digit verification code or secure reset link to your registered inbox.', style: TextStyle(color: _passwordMuted, fontSize: 12, height: 1.4))),
                                  ]),
                                ),
                                if (!_linkSent) ...[
                                  const SizedBox(height: 18),
                                  const Text('EMAIL ADDRESS', style: TextStyle(color: _passwordMuted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 7),
                                  TextField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    onSubmitted: (_) => _sendResetLink(),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your registered email',
                                      prefixIcon: const Icon(Icons.mail_outline, color: _passwordMuted, size: 20),
                                      filled: true,
                                      fillColor: const Color(0xFFF5F3F3),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _passwordOrange, width: 1.5)),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(height: 48, child: FilledButton.icon(
                                    onPressed: _sendResetLink,
                                    style: FilledButton.styleFrom(backgroundColor: _passwordOrange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                    iconAlignment: IconAlignment.end,
                                    icon: const Icon(Icons.arrow_forward, size: 19),
                                    label: const Text('Send Reset Link', style: TextStyle(fontWeight: FontWeight.w700)),
                                  )),
                                ] else ...[
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)),
                                    child: Column(children: [
                                      Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFFFDCC3), shape: BoxShape.circle), child: const Icon(Icons.mark_email_read, color: _passwordOrange, size: 21)),
                                      const SizedBox(height: 8),
                                      const Text('Link Sent!', style: TextStyle(color: _passwordInk, fontSize: 16, fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 4),
                                      Text('Check your inbox at ${_emailController.text.trim()} for instructions to reset your GEARUP passkey.', textAlign: TextAlign.center, style: const TextStyle(color: _passwordMuted, fontSize: 12, height: 1.4)),
                                      const SizedBox(height: 12),
                                      SizedBox(width: double.infinity, height: 44, child: FilledButton(onPressed: _continueToReset, style: FilledButton.styleFrom(backgroundColor: _passwordOrange, foregroundColor: Colors.white), child: const Text('Continue to Reset Password'))),
                                      TextButton(onPressed: () => _message('Link reset dikirim ulang (simulasi lokal).'), child: const Text("Didn't receive email? Tap to resend", style: TextStyle(fontSize: 12))),
                                    ]),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(13)),
                            child: const Row(children: [
                              SizedBox(width: 48, height: 48, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(10))), child: Icon(Icons.support_agent, color: _passwordInk, size: 24))),
                              SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Expedition support?', style: TextStyle(color: _passwordInk, fontSize: 14, fontWeight: FontWeight.w700)), SizedBox(height: 3), Text('Reach our trailhead gear specialists 24/7', style: TextStyle(color: _passwordMuted, fontSize: 11))])),
                            ]),
                          ),
                          const SizedBox(height: 24),
                          Wrap(alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, children: [
                            const Text('Remember your password? ', style: TextStyle(color: _passwordMuted, fontSize: 13)),
                            TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Back to Login', style: TextStyle(color: _passwordInk, fontWeight: FontWeight.w700))),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email});

  final String email;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _showPassword = false;
  bool _showConfirm = false;
  String get _password => _passwordController.text;
  String get _confirmation => _confirmController.text;
  bool get _hasLength => _password.length >= 8;
  bool get _hasNumberOrSymbol => RegExp(r'[0-9]|[^A-Za-z]').hasMatch(_password);
  bool get _matches => _password.isNotEmpty && _password == _confirmation;
  int get _strength => [_hasLength, _hasNumberOrSymbol, _matches].where((ok) => ok).length;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_hasLength || !_hasNumberOrSymbol || !_matches) {
      _message('Penuhi semua kriteria password terlebih dahulu.');
      return;
    }
    if (!LocalAccountStore.updatePassword(widget.email, _passwordController.text)) {
      _message('Email belum terdaftar. Buat akun terlebih dahulu lewat Sign Up.');
      return;
    }
    _showSuccessDialog();
  }

  Future<void> _showSuccessDialog() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFBF9F9),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: _passwordInk, shape: BoxShape.circle),
                child: const Icon(Icons.key, color: _passwordOrange, size: 28),
              ),
              const SizedBox(height: 18),
              const Text('Password Updated', style: TextStyle(color: _passwordInk, fontSize: 21, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text(
                'Your GEARUP account credentials have been updated. Ready for your next alpine expedition.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _passwordMuted, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _passwordInk,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Continue to Dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _message(String value) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _passwordSurface,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: _passwordInk)),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: const Color(0xFF303031), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.landscape, color: _passwordOrange, size: 20),
                    ),
                    const SizedBox(width: 9),
                    const Expanded(child: Text('Reset Password', style: TextStyle(color: _passwordInk, fontSize: 16, fontWeight: FontWeight.w700))),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircleAvatar(radius: 16, backgroundColor: Color(0xFF914D00), child: Icon(Icons.person, size: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(children: [Icon(Icons.circle, size: 8, color: _passwordOrange), SizedBox(width: 6), Text('SECURITY CLEARANCE // GEAR ID', style: TextStyle(color: _passwordMuted, fontSize: 9, letterSpacing: .7, fontWeight: FontWeight.w700))]),
                              Row(children: [Container(width: 16, height: 4, decoration: BoxDecoration(color: _passwordOrange, borderRadius: BorderRadius.circular(4))), const SizedBox(width: 4), _progressMark(false), const SizedBox(width: 4), _progressMark(false)]),
                            ],
                          ),
                          const SizedBox(height: 26),
                          const Text('Create New Password', style: TextStyle(color: _passwordInk, fontSize: 26, height: 1.3, fontWeight: FontWeight.w800, letterSpacing: -.4)),
                          const SizedBox(height: 7),
                          const Text("Enter your new password below. Make sure it's at least 8 characters long with a mix of letters and numbers.", style: TextStyle(color: _passwordMuted, fontSize: 14, height: 1.5)),
                          const SizedBox(height: 24),
                          _PasswordEntry(
                            label: 'NEW PASSWORD',
                            controller: _passwordController,
                            visible: _showPassword,
                            onToggle: () => setState(() => _showPassword = !_showPassword),
                            onChanged: (_) => setState(() {}),
                            icon: Icons.lock_outline,
                          ),
                          const SizedBox(height: 18),
                          _PasswordEntry(
                            label: 'CONFIRM NEW PASSWORD',
                            controller: _confirmController,
                            visible: _showConfirm,
                            onToggle: () => setState(() => _showConfirm = !_showConfirm),
                            onChanged: (_) => setState(() {}),
                            icon: Icons.lock_clock_outlined,
                          ),
                          const SizedBox(height: 22),
                          const Text('VERIFICATION CRITERIA', style: TextStyle(color: _passwordMuted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 10),
                          Wrap(spacing: 7, runSpacing: 7, children: [
                            _RequirementChip(label: 'At least 8 characters', satisfied: _hasLength),
                            _RequirementChip(label: 'Contains a number or symbol', satisfied: _hasNumberOrSymbol),
                            _RequirementChip(label: 'Passwords match', satisfied: _matches),
                          ]),
                          const SizedBox(height: 18),
                          _strengthCard(),
                          const SizedBox(height: 16),
                          _securityTip(),
                          const SizedBox(height: 22),
                          SizedBox(
                            height: 48,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(backgroundColor: _passwordOrange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                              onPressed: _submit,
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: const Text('Reset Password', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ),
                          TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Cancel & Return to Login', style: TextStyle(color: _passwordMuted))),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _progressMark(bool active) => Container(width: active ? 16 : 8, height: 4, decoration: BoxDecoration(color: active ? _passwordOrange : const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(4)));

  Widget _strengthCard() {
    final labels = ['Awaiting Entry', 'Base Camp', 'Ridge Line', 'Summit Certified'];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('ALPINE KEY RESILIENCE', style: TextStyle(color: _passwordMuted, fontSize: 10, fontWeight: FontWeight.w700)), Text(_password.isEmpty ? labels[0] : labels[_strength], style: const TextStyle(color: _passwordInk, fontSize: 11, fontWeight: FontWeight.w700))]),
        const SizedBox(height: 10),
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Container(
                height: 6,
                margin: EdgeInsets.only(right: i == 2 ? 0 : 3),
                decoration: BoxDecoration(
                  color: i < _strength
                      ? (i == 2 ? _passwordOrange : _passwordInk)
                      : const Color(0xFFE3E2E2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _securityTip() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)]),
        child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 34, height: 34, child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFE9E8E7), borderRadius: BorderRadius.all(Radius.circular(9))), child: Icon(Icons.verified_user_outlined, color: _passwordOrange, size: 19))),
          SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Expedition-grade Security', style: TextStyle(color: _passwordInk, fontSize: 14, fontWeight: FontWeight.w700)), SizedBox(height: 3), Text('Your new credentials protect your active reservations, backcountry permits, and locker access keys.', style: TextStyle(color: _passwordMuted, fontSize: 11, height: 1.4))])),
        ]),
      );
}

class _PasswordEntry extends StatelessWidget {
  const _PasswordEntry({required this.label, required this.controller, required this.visible, required this.onToggle, required this.onChanged, required this.icon});

  final String label;
  final TextEditingController controller;
  final bool visible;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 7), child: Text(label, style: const TextStyle(color: _passwordMuted, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700))),
          TextField(
            controller: controller,
            obscureText: !visible,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: '••••••••••••',
              prefixIcon: Icon(icon, color: _passwordMuted, size: 20),
              suffixIcon: IconButton(tooltip: visible ? 'Hide password' : 'Show password', onPressed: onToggle, icon: Icon(visible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20)),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0x18000000))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _passwordOrange, width: 1.5)),
            ),
          ),
        ],
      );
}

class _RequirementChip extends StatelessWidget {
  const _RequirementChip({required this.label, required this.satisfied});
  final String label;
  final bool satisfied;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        decoration: BoxDecoration(color: satisfied ? _passwordInk : const Color(0xFFEFEDED), borderRadius: BorderRadius.circular(30)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(satisfied ? Icons.check_circle : Icons.radio_button_unchecked, size: 15, color: satisfied ? _passwordOrange : _passwordMuted),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: satisfied ? Colors.white : _passwordMuted, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      );
}

class PasswordUpdatedPage extends StatelessWidget {
  const PasswordUpdatedPage({super.key});

  static const _tentImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuADHsbFw6snxiBRCX36b5XLB6uf8wI-s31pcc2uq236XI6yzg8BBSaEjjwiIDGWUX_tQJvYLq8f3BfWA48vZtl4L8NRCOByZ4OJQC_v5rSSjb0iLkibeQmx2BYoGGbzbqu4K1znCZXWaX7kj55dwWIdHbNZfkkD4YpHNmdFgYCtFlqfXkvBxNfBngrCBISI2Fw6dzYRuHutV5CvKW3B2gB00NFpRaevBV3AtvOFBmE';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _passwordSurface,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Kembali',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: _passwordInk),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(color: const Color(0xFF252525), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.landscape, color: _passwordOrange, size: 20),
                    ),
                    const SizedBox(width: 9),
                    const Expanded(
                      child: Text('Verification Success', style: TextStyle(color: _passwordInk, fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Color(0xFF914D00),
                        child: Icon(Icons.person, size: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 22),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: math.max(0.0, constraints.maxHeight - 30)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                                decoration: BoxDecoration(color: const Color(0xFFEFEDED), borderRadius: BorderRadius.circular(30)),
                                child: const Row(
                                  children: [
                                    _PulsingStatusDot(),
                                    SizedBox(width: 7),
                                    Text('SECURITY SYSTEM', style: TextStyle(color: _passwordMuted, fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                              const Row(
                                children: [
                                  Icon(Icons.verified_user_outlined, color: _passwordMuted, size: 15),
                                  SizedBox(width: 5),
                                  Text('256-BIT ENCRYPTION', style: TextStyle(color: _passwordMuted, fontSize: 9, letterSpacing: .4, fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const _SuccessEmblem(),
                          const SizedBox(height: 18),
                          const Text(
                            'Password Updated!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _passwordInk, fontSize: 26, height: 1.2, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 9),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'Your password has been successfully updated. You can now use your new credentials to access your GEARUP expedition account.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: _passwordMuted, fontSize: 13, height: 1.5),
                            ),
                          ),
                          const SizedBox(height: 22),
                          _securityCard(),
                          const SizedBox(height: 16),
                          _expeditionCard(),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: _passwordOrange,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                              iconAlignment: IconAlignment.end,
                              icon: const Icon(Icons.arrow_forward, size: 20),
                              label: const Text('Sign In Now', style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .4)),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Silakan hubungi dukungan GEARUP untuk bantuan.')),
                            ),
                            icon: const Icon(Icons.support_agent, size: 18),
                            label: const Text('Need help? Contact Gear Support'),
                            style: TextButton.styleFrom(foregroundColor: _passwordMuted),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _securityCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 8)]),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFEFEDED), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.shield, color: _passwordOrange),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text('Credential Vault', overflow: TextOverflow.ellipsis, style: TextStyle(color: _passwordInk, fontSize: 14, fontWeight: FontWeight.w700))),
                          SizedBox(width: 7),
                          _ActiveTag(),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text('Updated Just Now • Device Secured', style: TextStyle(color: _passwordMuted, fontSize: 10)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const CircleAvatar(radius: 14, backgroundColor: Color(0xFFF5F3F3), child: Icon(Icons.done_all, size: 16, color: _passwordInk)),
              ],
            ),
            const SizedBox(height: 13),
            const Row(
              children: [
                Expanded(child: _SecurityMeta(icon: Icons.devices, title: 'Active Sessions', value: 'Current Only')),
                SizedBox(width: 9),
                Expanded(child: _SecurityMeta(icon: Icons.fingerprint, title: 'Security Protocol', value: 'TLS 1.3 Strict')),
              ],
            ),
          ],
        ),
      );

  Widget _expeditionCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(13)),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NEXT EXPEDITION', style: TextStyle(color: _passwordOrange, fontSize: 10, letterSpacing: .8, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('Ready for the wild?', style: TextStyle(color: _passwordInk, fontSize: 14, fontWeight: FontWeight.w700)),
                  SizedBox(height: 4),
                  Text('Review saved tents, packs, and trail kits.', style: TextStyle(color: _passwordMuted, fontSize: 10, height: 1.3)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                width: 76,
                height: 76,
                child: Image.network(
                  _tentImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    color: const Color(0xFFE3E2E2),
                    child: const Icon(Icons.terrain, color: Color(0xFF887364)),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _SuccessEmblem extends StatelessWidget {
  const _SuccessEmblem();

  @override
  Widget build(BuildContext context) => Container(
        width: 112,
        height: 112,
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: const Color(0xFFE9E8E7), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 8)]),
        child: Container(
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.landscape_outlined, color: Color(0x331B1C1C), size: 55),
              const Icon(Icons.check, color: _passwordOrange, size: 55),
              Positioned(
                top: -1,
                right: -1,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(color: Color(0xFF303031), shape: BoxShape.circle),
                  child: const Icon(Icons.lock_open, color: Colors.white, size: 15),
                ),
              ),
            ],
          ),
        ),
      );
}

class _SecurityMeta extends StatelessWidget {
  const _SecurityMeta({required this.icon, required this.title, required this.value});
  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(9)),
        child: Row(
          children: [
            Icon(icon, color: _passwordOrange, size: 18),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _passwordMuted, fontSize: 9)),
                  const SizedBox(height: 2),
                  Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _passwordInk, fontSize: 10, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ActiveTag extends StatelessWidget {
  const _ActiveTag();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(color: const Color(0xFFEFEDED), borderRadius: BorderRadius.circular(4)),
        child: const Text('Active', style: TextStyle(color: _passwordMuted, fontSize: 9, fontWeight: FontWeight.w600)),
      );
}

class _PulsingStatusDot extends StatefulWidget {
  const _PulsingStatusDot();

  @override
  State<_PulsingStatusDot> createState() => _PulsingStatusDotState();
}

class _PulsingStatusDotState extends State<_PulsingStatusDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween<double>(begin: .4, end: 1).animate(_controller),
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(color: _passwordOrange, shape: BoxShape.circle),
        ),
      );
}
