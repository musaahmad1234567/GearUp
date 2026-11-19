/// Edit Profile page for the GEARUP app.
///
/// Mirrors the HTML reference (`Edit Profile` screen): avatar with edit badge,
/// basic identity fields (name / email / phone), the "Alpine Expedition Data"
/// card with emergency liaison + gear sizing selectors, a member-status row,
/// and a save button that shows a success toast.
library;

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Design tokens (mirrors the HTML theme)
// ---------------------------------------------------------------------------
const _surface = Color(0xFFFBF9F9);
const _onSurface = Color(0xFF1B1C1C);
const _secondary = Color(0xFF5F5E5E);
const _primary = Color(0xFF914D00);
const _primaryContainer = Color(0xFFF28C28);
const _inverseSurface = Color(0xFF303031);
const _inverseOnSurface = Color(0xFFF2F0F0);
const _error = Color(0xFFBA1A1A);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _surfaceContainerLow = Color(0xFFF5F3F3);
const _surfaceContainer = Color(0xFFEFEDED);
const _surfaceContainerHigh = Color(0xFFE9E8E7);
const _secondaryContainer = Color(0xFFE4E2E1);
const _onSecondaryFixed = Color(0xFF1B1C1C);

/// One selectable chip in a sizing selector (torso length / boot size).
class _SizeOption {
  final String label;
  final String? sublabel;

  const _SizeOption(this.label, [this.sublabel]);
}

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Alex Morgan');
  final _emailCtrl = TextEditingController(text: 'alexmorgan@email.com');
  final _phoneCtrl = TextEditingController(text: '+62 812 3456 7890');
  final _liaisonCtrl =
      TextEditingController(text: 'Sarah Morgan (+62 811 9876 5432)');

  String _torso = 'M/L';
  String _torsoCm = '48cm';
  String _shoe = 'EU 42';

  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _liaisonCtrl.dispose();
    super.dispose();
  }

  void _showToast(String title, String subtitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _inverseSurface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: _primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check,
                    color: _surfaceContainerLowest, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _surfaceContainerLowest,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _inverseOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () =>
                    ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                child: const Icon(Icons.close,
                    size: 18, color: _inverseOnSurface),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _saving = false);
    _showToast('Profile updated successfully!',
        'All expedition specs and liaisons saved.');
  }

  void _pickPhoto() {
    _showToast('Upload Gear Avatar',
        'Select a photo or profile emblem from your gallery.');
  }

  // ------------------------------------------------------------------ build --
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: AppBar(
        backgroundColor: _surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _onSurface,
          ),
        ),
        actions: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(right: 12),
            decoration: const BoxDecoration(
              color: _primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 18),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            _AvatarSection(onChangePhoto: _pickPhoto),
            const SizedBox(height: 24),
            _SectionLabel('Basic Identity'),
            const SizedBox(height: 12),
            _IconField(
              label: 'Full Name',
              hint: 'Enter full name',
              controller: _nameCtrl,
              icon: Icons.person,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 12),
            _IconField(
              label: 'Email Address',
              hint: 'name@domain.com',
              controller: _emailCtrl,
              icon: Icons.mail,
              keyboard: TextInputType.emailAddress,
              trailing: const _Tag(
                label: 'Verified',
                background: _inverseSurface,
                foreground: _surfaceContainerLowest,
                icon: Icons.verified,
                iconColor: _primaryContainer,
              ),
              validator: (v) =>
                  (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 12),
            _IconField(
              label: 'Phone Number',
              hint: '+62 000 0000 0000',
              controller: _phoneCtrl,
              icon: Icons.call,
              keyboard: TextInputType.phone,
              trailing: const _Tag(
                label: 'WhatsApp Ready',
                background: _secondaryContainer,
                foreground: _onSecondaryFixed,
                icon: Icons.chat_bubble,
                iconColor: _primary,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Phone is required' : null,
            ),
            const SizedBox(height: 24),
            _ExpeditionDataCard(
              liaisonCtrl: _liaisonCtrl,
              torso: _torso,
              torsoCm: _torsoCm,
              shoe: _shoe,
              onTorso: (label, cm) => setState(() {
                _torso = label;
                _torsoCm = cm;
              }),
              onShoe: (size) => setState(() => _shoe = size),
            ),
            const SizedBox(height: 16),
            const _MemberStatusRow(),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: FilledButton(
                onPressed: _saving ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: _primaryContainer,
                  disabledBackgroundColor: _primaryContainer.withOpacity(0.7),
                  foregroundColor: _surfaceContainerLowest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _saving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.check, size: 20),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Avatar
// ---------------------------------------------------------------------------
class _AvatarSection extends StatelessWidget {
  final VoidCallback onChangePhoto;

  const _AvatarSection({required this.onChangePhoto});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onChangePhoto,
          child: SizedBox(
            width: 112,
            height: 112,
            child: Stack(
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [_primaryContainer, _surfaceContainerHigh],
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: _inverseSurface,
                      shape: BoxShape.circle,
                    ),
                    child: const _PeakEmblem(size: 64),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _primaryContainer,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.edit,
                        color: _surfaceContainerLowest, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: onChangePhoto,
          child: const Text(
            'Change Photo',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _primary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Stylized alpine-peak emblem drawn with CustomPainter (no faces).
class _PeakEmblem extends StatelessWidget {
  final double size;

  const _PeakEmblem({this.size = 64});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _PeakEmblemPainter(color: _primaryContainer),
    );
  }
}

class _PeakEmblemPainter extends CustomPainter {
  final Color color;

  _PeakEmblemPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.045
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    // Outer triangle.
    final outer = Path()
      ..moveTo(w * 0.5, h * 0.18)
      ..lineTo(w * 0.78, h * 0.72)
      ..lineTo(w * 0.22, h * 0.72)
      ..close();
    canvas.drawPath(outer, fill);
    canvas.drawPath(outer, stroke);

    // Inner ridge.
    final ridge = Path()
      ..moveTo(w * 0.38, h * 0.42)
      ..lineTo(w * 0.45, h * 0.56)
      ..lineTo(w * 0.53, h * 0.50)
      ..lineTo(w * 0.60, h * 0.64);
    canvas.drawPath(
      ridge,
      stroke..strokeWidth = w * 0.03,
    );

    // Summit dot.
    canvas.drawCircle(Offset(w * 0.5, h * 0.32), w * 0.03, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _PeakEmblemPainter oldDelegate) =>
      oldDelegate.color != color;
}

// ---------------------------------------------------------------------------
// Small building blocks
// ---------------------------------------------------------------------------
class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: _secondary,
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;
  final Color iconColor;

  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: iconColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData icon;
  final Widget? trailing;
  final TextInputType? keyboard;
  final String? Function(String?)? validator;

  const _IconField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.icon,
    this.trailing,
    this.keyboard,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: _secondary,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboard,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: _onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 14, color: _secondary),
            prefixIcon: Icon(icon, size: 20, color: _secondary),
            filled: true,
            fillColor: _surfaceContainerLowest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryContainer, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Expedition data card
// ---------------------------------------------------------------------------
class _ExpeditionDataCard extends StatelessWidget {
  final TextEditingController liaisonCtrl;
  final String torso;
  final String torsoCm;
  final String shoe;
  final void Function(String label, String cm) onTorso;
  final ValueChanged<String> onShoe;

  const _ExpeditionDataCard({
    required this.liaisonCtrl,
    required this.torso,
    required this.torsoCm,
    required this.shoe,
    required this.onTorso,
    required this.onShoe,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shield, size: 20, color: _primary),
              const SizedBox(width: 8),
              const Text(
                'Alpine Expedition Data',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _IconField(
            label: 'Basecamp Liaison / Emergency',
            hint: 'Name & emergency contact number',
            controller: liaisonCtrl,
            icon: Icons.contact_emergency,
            trailing: const Text(
              'Rental Protocol',
              style: TextStyle(fontSize: 11, color: _secondary),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionLabel('Gear Sizing & Ergonomic Fit'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Backpack Torso Length',
                  style: TextStyle(fontSize: 13, color: _secondary)),
              Text(
                '$torso ($torsoCm)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final o in const [
                _SizeOption('S', '43cm'),
                _SizeOption('M/L', '48cm'),
                _SizeOption('XL', '53cm'),
              ])
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: o.label == 'XL' ? 0 : 8),
                    child: _ChoiceChip(
                      label: '${o.label} (${o.sublabel})',
                      selected: torso == o.label,
                      onTap: () => onTorso(o.label, o.sublabel!),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Mountaineering Boot Size',
                  style: TextStyle(fontSize: 13, color: _secondary)),
              Text(
                shoe,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: const ['EU 40', 'EU 41', 'EU 42', 'EU 43', 'EU 44']
                  .length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                const sizes = ['EU 40', 'EU 41', 'EU 42', 'EU 43', 'EU 44'];
                final s = sizes[i];
                return _ChoiceChip(
                  label: s.replaceFirst('EU ', ''),
                  selected: shoe == s,
                  onTap: () => onShoe(s),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _inverseSurface : _surfaceContainerLowest,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? _surfaceContainerLowest : _secondary,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Member status row
// ---------------------------------------------------------------------------
class _MemberStatusRow extends StatelessWidget {
  const _MemberStatusRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _surfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.backpack, size: 22, color: _primaryContainer),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Member Status',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _onSurface,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Alpine Verified • 14 Expeditions',
                  style: TextStyle(fontSize: 12, color: _secondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: _secondary),
        ],
      ),
    );
  }
}
