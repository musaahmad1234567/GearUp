/// Profile screen ("My Profile") for the GEARUP app, matching the secure-profile
/// design: a fixed translucent header with the member card, a quick-rental stats
/// row, a vertical preference menu, a logout area plus a locker-PIN micro-card,
/// and a fixed bottom navigation.
///
/// Programmatic equivalent of the `My Profile` HTML shell. The tab list is
/// shared with the home-dashboard shell (`HomeDashboardPage._bottomNav`),
/// whose Profile tab now navigates here.
library;

import 'package:flutter/material.dart';

import 'account_store.dart';
import 'edit_profile_page.dart';
import 'explore_page.dart';
import 'login_page.dart';
import 'my_address_page.dart';
import 'my_rental_page.dart';
import 'payment_methods_page.dart';
import 'settings_page.dart';
import 'wishlist_page.dart';


// ---------------------------------------------------------------------------
// Tab data used by the profile screen's preference menu
// ---------------------------------------------------------------------------
class _NavItem {
  final IconData icon;
  final String title;
  final String subtitle;

  const _NavItem(this.icon, this.title, this.subtitle);
}

// ---------------------------------------------------------------- palette ---
// Mirrors the HTML design tokens (surface bg #FBF9F9, primary #914D00,
// blaze-orange #F28C28, green #1B6D24, charcoal #303031, red #BA1A1A).
const _surface = Color(0xFFFBF9F9);
const _onSurface = Color(0xFF1B1C1C);
const _onSurfaceVariant = Color(0xFF554336);
const _secondary = Color(0xFF5F5E5E);
const _muted = Color(0xFF777777);
const _tertiary = Color(0xFF1B6D24);
const _tertiaryContainer = Color(0xFF67B764);
const _primary = Color(0xFF914D00);
const _primaryContainer = Color(0xFFF28C28);
const _primaryFixed = Color(0xFFFFDCC3);
const _inverseSurface = Color(0xFF303031);
const _inverseOnSurface = Color(0xFFF2F0F0);
const _error = Color(0xBA1A1A);
const _surfaceVariant = Color(0xFFE3E2E2);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _outline = Color(0xFF887364);

/// Minimalist alpine-peak badge (no faces), drawn as a custom painter so it
/// renders consistently across web/desktop/mobile.
class MountainBadge extends StatelessWidget {
  final double size;
  final Color color;
  final Color strokeColor;

  const MountainBadge({
    super.key,
    this.size = 64,
    this.color = const Color(0xFF252525),
    this.strokeColor = const Color(0xFFF0F0F0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _MountainBadgePainter(
          color: color,
          strokeColor: strokeColor,
        ),
      ),
    );
  }
}

class _MountainBadgePainter extends CustomPainter {
  final Color color;
  final Color strokeColor;

  _MountainBadgePainter({required this.color, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final p = size.width / 32;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    // Outer alpine peak silhouette.
    final Path outer = Path();
    outer.moveTo(4 * p, 25 * p);
    outer.lineTo(14 * p, 8 * p);
    outer.lineTo(20 * p, 18 * p);
    outer.lineTo(23 * p, 13 * p);
    outer.lineTo(28 * p, 25 * p);
    outer.close();
    canvas.drawPath(outer, paint..color = color);

    // Inner highlight polygon (lift the mountain off the charcoal disc).
    final Path inner = Path();
    inner.moveTo(14 * p, 8 * p);
    inner.lineTo(20 * p, 18 * p);
    inner.lineTo(23 * p, 13 * p);
    inner.lineTo(28 * p, 25 * p);
    inner.lineTo(4 * p, 25 * p);
    inner.close();
    canvas.drawPath(inner, paint..color = strokeColor);

    // Two minimal peak-hikers (no faces), strictly no faces.
    final Path hiker1 = Path()..moveTo(10.5 * p, 14 * p);
    hiker1.lineTo(14 * p, 17 * p);
    hiker1.lineTo(17.5 * p, 14 * p);
    canvas.drawPath(hiker1, paint);

    final Path hiker2 = Path()..moveTo(21 * p, 16.5 * p);
    hiker2.lineTo(23 * p, 19 * p);
    hiker2.lineTo(25.5 * p, 16.5 * p);
    canvas.drawPath(hiker2, paint);
  }

  @override
  bool shouldRepaint(covariant _MountainBadgePainter oldDelegate) => false;
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.account});

  final LocalAccount account;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _tabIndex = 4; // Profile is the active tab.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      appBar: _ProfileHeader(),
      body: _body(),
      bottomNavigationBar: _ProfileBottomNav(),
    );
  }

  Widget _body() {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Card(),
            const SizedBox(height: 14),
            _EditProfileButton(),
            const SizedBox(height: 14),
            _StatsRow(),
            const SizedBox(height: 14),
            _SectionHeader('Basecamp & Preferences'),
            const SizedBox(height: 8),
            _MenuList(),
            const SizedBox(height: 24),
            _LogOutButton(),
            const SizedBox(height: 14),
            _LockerPinCard(),
          ],
        ),
      ),
    );
  }

  Widget _Card() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderRow(),
          const SizedBox(height: 12),
          _IdentityStack(),
        ],
      ),
    );
  }

  Widget _HeaderRow() {
    return Row(
      children: [
        _ProfileAvatar(64),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Alpine Member',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Color(0xFF554336),
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Tier 2',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF554336)),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                widget.account.name.isNotEmpty ? widget.account.name : 'Alex Morgan',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: _onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                widget.account.email.isNotEmpty ? widget.account.email : 'alexmorgan@email.com',
                style: const TextStyle(fontSize: 13, color: _muted),
              ),
              const SizedBox(height: 2),
              Text(
                widget.account.phone.isNotEmpty ? widget.account.phone : '+62 812 3456 7890',
                style: const TextStyle(fontSize: 13, color: _muted),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _IdentityStack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 34),
          child: Row(
            children: [
              Icon(Icons.mail, size: 14, color: _muted),
              SizedBox(width: 6),
              Text('alexmorgan@email.com', style: TextStyle(fontSize: 12, color: _muted)),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 34),
          child: Row(
            children: [
              Icon(Icons.call, size: 14, color: _muted),
              SizedBox(width: 6),
              Text('+62 812 3456 7890', style: TextStyle(fontSize: 12, color: _muted)),
            ],
          ),
        ),
      ],
    );
  }

Widget _ProfileAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _primaryContainer, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/avatar.jpg',
          fit: BoxFit.cover,
          width: size,
          height: size,
          errorBuilder: (_, __, ___) => Container(
            color: _primaryContainer,
            child: Icon(Icons.person, color: Colors.white, size: size * 0.5),
          ),
        ),
      ),
    );
  }

  Widget _EditProfileButton() {
    return InkWell(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const EditProfilePage()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: _surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.edit, size: 16, color: _primaryContainer),
            const SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _StatsRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          _StatTile('12', 'Expeditions\nDone', Icons.shield_outlined, _onSurface),
          _StatTile('3', 'Active\nBookings', Icons.backpack_outlined, _primaryContainer),
          _StatTile('6', 'Wishlist\nSaved', Icons.favorite_border, _onSurface),
        ],
      ),
    );
  }

  Widget _StatTile(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: _muted, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _SectionHeader(String label) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.2, color: _muted),
        ),
        const Spacer(),
        Text(
          'Toward the peak',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _secondary),
        ),
      ],
    );
  }

  Widget _MenuList() {
    final items = const [
      _NavItem(Icons.location_on, 'My Address', 'Delivery & Basecamp lockers'),
      _NavItem(Icons.account_balance_wallet, 'Payment Methods', 'Virtual accounts, E-wallets, QRIS'),
      _NavItem(Icons.history, 'My Rental History', 'Past completed and ongoing gear rentals'),
      _NavItem(Icons.notifications, 'Notifications', 'Rental alerts, locker PIN codes'),
      _NavItem(Icons.support_agent, 'Help Center', '24/7 Basecamp Support & FAQ'),
      _NavItem(Icons.info, 'About GEARUP', 'Version 2.4.0 • Alpine Rentals'),
      _NavItem(Icons.tune, 'Settings', 'Account preferences, security, language'),
    ];
    return Column(
      children: [
        for (final item in items)
          _MenuItem(item.icon, item.title, item.subtitle),
      ],
    );
  }

  Widget _MenuItem(IconData icon, String title, String subtitle) {
    return InkWell(
      onTap: () => _onNavTap(title),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: _surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: _secondary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: _onSurface)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: _muted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: _secondary),
          ],
        ),
      ),
    );
  }

  Widget _LogOutButton() {
    return InkWell(
      onTap: _showLogoutModal,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _error,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          children: [
            Icon(Icons.logout, size: 20, color: Colors.white),
            SizedBox(width: 10),
            Text('Log Out', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _LockerPinCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.pin, size: 20, color: _primaryContainer),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Basecamp Locker PIN', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _onSurface)),
                Text('Next pickup ready: #BC-8492', style: TextStyle(fontSize: 12, color: _secondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: _secondary),
        ],
      ),
    );
  }

  PreferredSizeWidget _ProfileHeader() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(64),
      child: Container(
        color: _surface.withOpacity(0.92),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
        children: [
          Row(
            children: [
              MountainBadge(size: 36),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('GEARUP', style: TextStyle(fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w800, color: _muted)),
                  Text('My Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _onSurface)),
                ],
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings, size: 22, color: _secondary),
          ),
          const SizedBox(width: 8),
          _ProfileAvatar(30),
        ],
      ),
    ));
  }

  Widget _ProfileBottomNav() {
    return SafeArea(
      top: false,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: _surface.withOpacity(0.98),
          boxShadow: const [
            BoxShadow(color: Color(0x10000000), blurRadius: 10, offset: Offset(0, -2)),
          ],
        ),
        child: _ProfileTabRow(),
      ),
    );
  }

  Widget _ProfileTabRow() {
    final items = const [
      ('Home', Icons.cottage_outlined),
      ('Explore', Icons.explore_outlined),
      ('Wishlist', Icons.favorite_border),
      ('My Rental', Icons.backpack_outlined),
      ('Profile', Icons.account_circle_outlined),
    ];
    return Row(
      children: List.generate(items.length, (index) {
        final selected = index == _tabIndex;
        return Expanded(
          child: InkWell(
            onTap: () => _onTabTapped(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(items[index].$2, size: 21, color: selected ? _primaryContainer : _muted),
                const SizedBox(height: 3),
                Text(
                  items[index].$1,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? _primaryContainer : _muted,
                  ),
                ),
                if (selected)
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: const BoxDecoration(color: _primaryContainer, shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _onTabTapped(int index) {
    switch (index) {
      case 0:
        // Returning home: pop the profile screen back onto the dashboard.
        Navigator.of(context).pop();
        break;
      case 1:
        Navigator.of(context).push<void>(
          MaterialPageRoute<void>(builder: (_) => ExplorePage(account: widget.account)),
        );
      case 2:
        Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const WishlistPage()));
      case 3:
        Navigator.of(context).push<void>(MaterialPageRoute<void>(builder: (_) => const MyRentalPage()));
      case 4:
        // Active tab: nothing to do (stays on the profile screen).
        break;
    }
  }

  void _showLogoutModal() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LogoutDialog(),
    );
  }

  void _logout() {
    // Return the user to the login screen.
    Navigator.of(context).pushAndRemoveUntil<void>(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _LogoutDialog() {
    return Center(
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: _surfaceContainerLowest,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 24, offset: Offset(0, 12))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(color: _error, shape: BoxShape.circle),
              child: const Center(child: Icon(Icons.power_settings_new, size: 24, color: Colors.white)),
            ),
            const SizedBox(height: 14),
            const Text('Log Out of GEARUP?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _onSurface)),
            const SizedBox(height: 6),
            Text('You will need to re-verify your technical member access upon logging back in.', style: const TextStyle(fontSize: 12, color: _muted, height: 1.4)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: _inverseSurface, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(Icons.logout, size: 18, color: _onSurface), SizedBox(width: 8), Text('Yes, Log Out', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _onSurface))],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(color: _surfaceContainerLowest, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: _onSurface))],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(String title) {
    if (title == 'My Address') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const MyAddressPage()),
      );
    } else if (title == 'Payment Methods') {
      Navigator.of(context).push<void>(
        MaterialPageRoute<void>(builder: (_) => const PaymentMethodsPage()),
      );
    } else if (title == 'Settings') {
      _openSettings();
    } else {
      _notice(title);
    }
  }

  void _openSettings() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
    );
  }

  void _notice(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
