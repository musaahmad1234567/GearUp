/// Settings page for the GEARUP app.
///
/// Mirrors the HTML reference (`Settings` screen): quick-summary card,
/// ACCOUNT / PREFERENCES / SUPPORT & ABOUT sections, a logout button with a
/// confirmation dialog, and a toast for preference changes.
library;

import 'package:flutter/material.dart';

import 'edit_profile_page.dart';

// ---------------------------------------------------------------------------
// Design tokens (mirrors the HTML theme)
// ---------------------------------------------------------------------------
const _surface = Color(0xFFFBF9F9);
const _onSurface = Color(0xFF1B1C1C);
const _secondary = Color(0xFF5F5E5E);
const _muted = Color(0xFF777777);
const _primary = Color(0xFF914D00);
const _primaryContainer = Color(0xFFF28C28);
const _primaryFixed = Color(0xFFFFDCC3);
const _onPrimaryFixed = Color(0xFF2F1500);
const _inverseSurface = Color(0xFF303031);
const _error = Color(0xFFBA1A1A);
const _errorContainer = Color(0xFFFFDAD6);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _surfaceContainerLow = Color(0xFFF5F3F3);
const _surfaceContainer = Color(0xFFEFEDED);
const _surfaceContainerHigh = Color(0xFFE9E8E7);
const _surfaceContainerHighest = Color(0xFFE3E2E2);

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _push = true;
  bool _email = true;
  bool _reminder = false;
  bool _logoutOpen = false;

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
          'Settings',
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
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              const _QuickSummaryCard(),
              const SizedBox(height: 20),
              const _SectionLabel('ACCOUNT'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _SettingsTile(
                  icon: Icons.badge,
                  title: 'Edit Profile',
                  subtitle: 'Name, email, phone number, gear sizes',
                  onTap: _openEditProfile,
                ),
                _SettingsDivider(),
                _SettingsTile(
                  icon: Icons.lock_reset,
                  title: 'Change Password',
                  subtitle: 'Update master password and biometrics',
                  onTap: _toastSecurity,
                ),
              ]),
              const SizedBox(height: 20),
              const _SectionLabel('PREFERENCES'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _SwitchTile(
                  icon: Icons.notifications_active,
                  title: 'Push Notifications',
                  subtitle: 'Real-time locker PIN & return alerts',
                  value: _push,
                  onChanged: (v) {
                    setState(() => _push = v);
                    _toast('Push notifications ${v ? 'enabled' : 'disabled'}');
                  },
                ),
                _SettingsDivider(),
                _SwitchTile(
                  icon: Icons.mail,
                  title: 'Email Notifications',
                  subtitle: 'Booking vouchers, receipts, gear guides',
                  value: _email,
                  onChanged: (v) {
                    setState(() => _email = v);
                    _toast('Email alerts ${v ? 'enabled' : 'disabled'}');
                  },
                ),
                _SettingsDivider(),
                _SwitchTile(
                  icon: Icons.alarm,
                  title: 'Rental Reminder Alarms',
                  subtitle: 'Alert 3 hours prior to locker return window',
                  value: _reminder,
                  onChanged: (v) {
                    setState(() => _reminder = v);
                    _toast('Return reminder alarms ${v ? 'enabled' : 'disabled'}');
                  },
                ),
                _SettingsDivider(),
                _SettingsTile(
                  icon: Icons.language,
                  title: 'Language',
                  subtitle: 'English (US)',
                  trailing: const _LangChip(label: 'EN'),
                  onTap: () => _toast('Language selection modal opened'),
                ),
              ]),
              const SizedBox(height: 20),
              const _SectionLabel('SUPPORT & ABOUT'),
              const SizedBox(height: 8),
              _SettingsGroup(children: [
                _SettingsTile(
                  icon: Icons.help_center,
                  title: 'Help Center & FAQ',
                  subtitle: 'Rental terms, damage waivers, FAQ',
                  onTap: _toastKnowledgeBase,
                ),
                _SettingsDivider(),
                _SettingsTile(
                  icon: Icons.policy,
                  title: 'Privacy Policy',
                  subtitle: 'Personal data and geolocation policy',
                  onTap: _toastPrivacy,
                ),
                _SettingsDivider(),
                _SettingsTile(
                  icon: Icons.gavel,
                  title: 'Terms & Conditions',
                  subtitle: 'Field liability, pickup windows',
                  onTap: _toastTerms,
                ),
                _SettingsDivider(),
                _SettingsTile(
                  icon: Icons.info,
                  title: 'App Version',
                  subtitle: 'Alpine Engine Release',
                  trailing: const Text(
                    'v2.4.0 (Build 184)',
                    style: TextStyle(fontSize: 12, color: _secondary),
                  ),
                  onTap: () {},
                ),
              ]),
              const SizedBox(height: 20),
              _LogOutButton(onTap: () => setState(() => _logoutOpen = true)),
              const SizedBox(height: 24),
              const _TrailTrustFootnote(),
            ],
          ),
          if (_logoutOpen) _buildLogoutDialog(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- helpers --
  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(milliseconds: 2200),
          behavior: SnackBarBehavior.floating,
          backgroundColor: _surfaceContainerHighest,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Row(
            children: [
              const Icon(Icons.check_circle, size: 18, color: _primaryContainer),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(fontSize: 12, color: _onSurface),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _openEditProfile() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const EditProfilePage()),
    );
  }

  void _toastSecurity() => _toast('Opening Security Panel...');
  void _toastKnowledgeBase() => _toast('Loading Knowledge Base...');
  void _toastPrivacy() => _toast('Loading Privacy Policy...');
  void _toastTerms() => _toast('Loading Rental Agreement...');

  Widget _buildLogoutDialog() {
    return GestureDetector(
      onTap: () => setState(() => _logoutOpen = false),
      child: Container(
        color: _inverseSurface.withOpacity(0.6),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.logout, color: _error, size: 24),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Log out of GEARUP?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You will need to sign back in with your credentials to manage '
                  'active expedition bookings and locker keys.',
                  style: TextStyle(fontSize: 14, color: _secondary),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () => setState(() => _logoutOpen = false),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _surfaceContainerHigh,
                            foregroundColor: _onSurface,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: FilledButton(
                          onPressed: () {
                            setState(() => _logoutOpen = false);
                            _toast('Signed out of GEARUP');
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: _primaryContainer,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
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

// ---------------------------------------------------------------------------
// Building blocks
// ---------------------------------------------------------------------------
class _QuickSummaryCard extends StatelessWidget {
  const _QuickSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryContainer, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/images/avatar.jpg',
                fit: BoxFit.cover,
                width: 48,
                height: 48,
                errorBuilder: (_, __, ___) => Container(
                  color: _surfaceContainerHigh,
                  child: const Icon(Icons.hiking,
                      color: _primaryContainer, size: 26),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Backcountry Tier',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _primaryFixed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _onPrimaryFixed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'alex.morgan@basecamp.io',
                  style: TextStyle(fontSize: 12, color: _secondary),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: _primaryContainer,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
          color: _secondary,
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: _surfaceContainer,
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: _onSurface),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: _secondary),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, size: 20, color: _secondary),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: _onSurface),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: _secondary),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _primaryContainer,
            activeTrackColor: _primaryContainer.withOpacity(0.4),
            inactiveThumbColor: _surfaceContainerLowest,
            inactiveTrackColor: _surfaceContainerHighest,
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;

  const _LangChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _surfaceContainerHigh,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _onSurface,
        ),
      ),
    );
  }
}

class _LogOutButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LogOutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: _surfaceContainerLowest,
          foregroundColor: _error,
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
        ),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          'Log Out',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _TrailTrustFootnote extends StatelessWidget {
  const _TrailTrustFootnote();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.terrain, size: 16, color: _secondary),
            SizedBox(width: 6),
            Text(
              'GEARUP BACKCOUNTRY SYSTEMS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: _secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Engineered for Alpine Expeditions',
          style: TextStyle(fontSize: 12, color: _secondary),
        ),
      ],
    );
  }
}
