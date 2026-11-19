/// Help Center screen for the GEARUP gear-rental flow.
///
/// Mirrors the "Help Center" HTML design: a light-themed help center with a
/// search bar, category cards, frequently searched FAQs, 24/7 basecamp support
/// contact options and a live equipment-status banner.
///
/// This page is accessible from the main navigation (Help Center menu item).
library;

import 'package:flutter/material.dart';

// Light theme palette matching the HTML design tokens.
const _background = Color(0xFFFBF9F9);
const _surfaceContainerHigh = Color(0xFFE9E8E7);
const _surfaceContainerLow = Color(0xFFF5F3F3);
const _primaryContainer = Color(0xFFF28C28);
const _onSurface = Color(0xFF1B1C1C);
const _onSurfaceVariant = Color(0xFF5F5E5E);
const _inverseSurface = Color(0xFF303031);
const _inverseOnSurface = Color(0xFFFFFFFF);
const _outlineVariant = Color(0xFF887364);

/// Main Help Center screen.
class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 14),
              _SearchBar(),
              const SizedBox(height: 16),
              _CategoriesSection(),
              const SizedBox(height: 14),
              _SupportSection(),
              const SizedBox(height: 14),
              _FrequentlySearchedSection(),
              const SizedBox(height: 14),
              _EquipmentStatusBanner(),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Header
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _onSurface, size: 24),
          tooltip: 'Back',
        ),
        const Spacer(),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help Center',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _onSurface,
              ),
            ),
            Text(
              'Get help with your expedition',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Search Bar
// ---------------------------------------------------------------------------

class _SearchBar extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  void _clear() {
    if (mounted) {
      setState(() {
        // Clear search text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: _outlineVariant,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search help articles, locker guides...',
                hintStyle: TextStyle(
                  color: _outlineVariant,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _clear,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.close,
                color: _outlineVariant,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Categories Section
// ---------------------------------------------------------------------------

class _CategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _surfaceContainerLow,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Text(
                'Field Manuals',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _CategoryCard(
              icon: Icons.explore,
              title: 'Booking & Rental',
              subtitle: 'Rental duration, extend dates, specs',
              onTap: () => _showToast('Booking & Rental FAQs', context),
            ),
            _CategoryCard(
              icon: Icons.account_balance_wallet,
              title: 'Payment & Fees',
              subtitle: 'Bank transfer, QRIS, deposit holds',
              onTap: () => _showToast('Payment & Fees FAQs', context),
            ),
            _CategoryCard(
              icon: Icons.lock_clock,
              title: 'Locker & Returns',
              subtitle: '24/7 locker PIN codes, return drop',
              onTap: () => _showToast('Locker & Returns FAQs', context),
            ),
            _CategoryCard(
              icon: Icons.verified_user,
              title: 'Gear Care',
              subtitle: 'Alpine ID verification, damage waiver',
              onTap: () => _showToast('Account & Gear Care FAQs', context),
            ),
          ],
        ),
      ],
    );
  }

  static void _showToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: _primaryContainer,
                size: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: _onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Support Section (24/7 Basecamp)
// ---------------------------------------------------------------------------

class _SupportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          // Accent bar on top
          Container(
            width: double.infinity,
            height: 4,
            decoration: const BoxDecoration(
              color: _primaryContainer,
              borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 6, color: _primaryContainer),
                          SizedBox(width: 6),
                          Text(
                            'Standby Ready',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Need immediate field assistance?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Our alpine logistics crew is on standby 24/7 for active trekkers.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: _onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              _SupportActionButton(
                icon: Icons.chat,
                label: 'Start Basecamp Live Chat',
                backgroundColor: _inverseSurface,
                foregroundColor: _inverseOnSurface,
                onTap: () => _showToast('Starting Basecamp Chat Session...', context),
              ),
              const SizedBox(height: 8),
              _SupportLinkButton(
                icon: Icons.forum,
                label: 'Chat on WhatsApp',
                url: 'https://wa.me/6281243278747',
                phone: '+62 812-GEARUP-HQ',
              ),
              const SizedBox(height: 8),
              _SupportLinkButton(
                icon: Icons.mail,
                label: 'Email Dispatch',
                url: 'mailto:support@gearup.io',
                phone: 'support@gearup.io',
              ),
            ],
          ),
        ],
      ),
    );
  }

  static void _showToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _SupportActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onTap;

  const _SupportActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 48,
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportLinkButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final String phone;

  const _SupportLinkButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url.startsWith('mailto:')) {
          _showToast('Opening email: $url', context);
        } else if (url.startsWith('https://')) {
          _showToast('Opening: $url', context);
        } else {
          _showToast('Copied: $url', context);
        }
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: _onSurface, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _onSurface,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              phone,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: _onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _showToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// ---------------------------------------------------------------------------
// Frequently Searched Section
// ---------------------------------------------------------------------------

class _FrequentlySearchedSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Frequently Searched',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _onSurface,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _surfaceContainerLow,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: const Text(
                'Alpine FAQ',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemCount: 3,
          itemBuilder: (context, index) {
            final items = [
              'How do I unlock Basecamp Locker #14 with my PIN?',
              'What happens if gear gets wet or muddy on trail?',
              'Can I cancel a booking within 24 hours of pickup?',
            ];
            return _FAQItem(
              icon: _getIconForFAQ(index),
              title: items[index],
              onTap: () => _showToast(items[index], context),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconForFAQ(int index) {
    switch (index) {
      case 0: return Icons.pin;
      case 1: return Icons.water_drop;
      case 2: return Icons.event_busy;
      default: return Icons.question_mark;
    }
  }

  static void _showToast(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _FAQItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: _primaryContainer, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _onSurface,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.chevron_right,
              color: _outlineVariant,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Equipment Status Banner
// ---------------------------------------------------------------------------

class _EquipmentStatusBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info,
            color: _primaryContainer,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Inclement weather warning along Alpine Sector 3. Gear drop-offs extended by 4 hours with no late fees.',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: _onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
