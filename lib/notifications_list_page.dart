/// Notifications list screen for the GEARUP gear-rental flow.
///
/// Displays a feed of rental, promotion, and system notifications. Tapping a
/// notification card navigates to the [NotificationDetailsPage] for that item.
library;

import 'package:flutter/material.dart';

import 'notification_details_page.dart';

// Light theme palette matching the HTML design tokens.
const _background = Color(0xFFFBF9F9);
const _surface = Color(0xFFFFFFFF);
const _surfaceContainerHigh = Color(0xFFE9E8E7);
const _surfaceContainer = Color(0xFFEFEDED);
const _surfaceContainerLow = Color(0xFFF5F3F3);
const _primary = Color(0xFF914D00);
const _primaryContainer = Color(0xFFF28C28);
const _onSurface = Color(0xFF1B1C1C);
const _onSurfaceVariant = Color(0xFF5F5E5E);
const _secondary = Color(0xFF5F5E5E);
const _onPrimaryContainer = Color(0xFFFFFFFF);

/// A single notification card matching the HTML design.
class NotificationCard extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String category;
  final bool read;
  final VoidCallback? onTap;

  NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    this.read = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = read;
    final isRental = category == 'rentals';
    final badgeBg = isRental ? _surfaceContainer : _surfaceContainerLow;
    final badgeColor = isRental ? _onSurfaceVariant : _secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isRead ? _surfaceContainer : _surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardHeader(
              title: title,
              time: time,
              badgeBg: badgeBg,
              badgeColor: badgeColor,
              isRead: isRead,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
                color: _onSurfaceVariant,
              ),
              maxLines: 2,
            ),
            if (!isRead && !isRental) ...[
              const SizedBox(height: 6),
              _UnreadBadge(),
            ],
            if (isRead && isRental) ...[
              const SizedBox(height: 6),
              _ReadActionRow(),
            ],
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final String time;
  final Color badgeBg;
  final Color badgeColor;
  final bool isRead;

  const _CardHeader({
    required this.title,
    required this.time,
    required this.badgeBg,
    required this.badgeColor,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _surfaceContainerHigh,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: _getNotificationIcon(isRead, badgeBg, badgeColor),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: _onSurface,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  if (isRead)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _surfaceContainer,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'READ',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _secondary,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 12,
                    color: _secondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getNotificationIcon(bool isRead, Color badgeBg, Color badgeColor) {
    if (!isRead) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 16,
              color: _onPrimaryContainer,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _primaryContainer,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
    return const Icon(
      Icons.assessment,
      size: 20,
      color: _secondary,
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _primaryContainer,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, size: 12, color: _onPrimaryContainer),
          SizedBox(width: 4),
          Text(
            'PIN code arrives 2h prior',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadActionRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: _surfaceContainer,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_forward,
            size: 14,
            color: _primary,
          ),
          const SizedBox(width: 4),
          Text(
            'Extend rental',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Main notifications list screen.
class NotificationsListPage extends StatelessWidget {
  const NotificationsListPage({super.key});

  void _navigateToDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const NotificationDetailsPage()),
    );
  }

  static void _showMarkAllReadDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Mark all as read'),
        content: const Text('This will mark all notifications as read. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read')),
              );
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        leading: null,
        actions: [
          IconButton(
            onPressed: () => _showMarkAllReadDialog(context),
            icon: const Icon(Icons.check_circle, size: 20, color: _onSurfaceVariant),
            tooltip: 'Mark all read',
          ),
        ],
      ),
      body: Column(
        children: [
          _HeaderBar(),
          const SizedBox(height: 8),
          _FilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _NotificationCardItem(
                  title: 'Booking Confirmed #GR-00142',
                  message: 'Your Hiking Backpack 45L reservation is secured for 15 Nov - 18 Nov. Locker #14 will be ready.',
                  time: '10m ago',
                  category: 'rentals',
                  read: false,
                  onTap: () => _navigateToDetails(context),
                ),
                const SizedBox(height: 8),
                _NotificationCardItem(
                  title: 'Payment Verified (Rp85.000)',
                  message: 'Mandiri Virtual Account payment has cleared. Zero deposit hold authorized.',
                  time: '1h ago',
                  category: 'rentals',
                  read: false,
                  onTap: () => _navigateToDetails(context),
                ),
                const SizedBox(height: 8),
                _NotificationCardItem(
                  title: 'Return Window in 2 Days',
                  message: 'MSR Hubba Hubba 2P Tent is due back on 18 Nov, 17:00 WIB at Basecamp Station.',
                  time: 'Yesterday',
                  category: 'rentals',
                  read: true,
                  onTap: () => _navigateToDetails(context),
                ),
                const SizedBox(height: 8),
                _NotificationCardItem(
                  title: 'Summit Season Promo: 15% Off',
                  message: 'Use code ALPINE15 on mountaineering apparel and sleeping systems through November.',
                  time: '2 days ago',
                  category: 'promos',
                  read: true,
                  onTap: () => _navigateToDetails(context),
                ),
                const SizedBox(height: 8),
                _NotificationCardItem(
                  title: 'Inspection Passed & Rental Completed',
                  message: 'Trekking poles returned in excellent condition. Deposit security release finalized.',
                  time: '5 days ago',
                  category: 'rentals',
                  read: true,
                  onTap: () => _navigateToDetails(context),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 10,
                backgroundColor: _primaryContainer,
                child: Icon(Icons.notifications, size: 16, color: _onPrimaryContainer),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: _onSurface,
                    ),
                  ),
                  Text(
                    'You have 2 unread',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => NotificationsListPage._showMarkAllReadDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryContainer,
              foregroundColor: _onPrimaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            child: const Text(
              'Mark all read',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FilterChip(
            label: 'All (5)',
            active: true,
            onTap: () => _filterAll(context),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Rentals (3)',
            active: false,
            onTap: () => _filterRentals(context),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Promos (2)',
            active: false,
            onTap: () => _filterPromos(context),
          ),
        ],
      ),
    );
  }

  static void _filterAll(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter: All')));
  }

  static void _filterRentals(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter: Rentals')));
  }

  static void _filterPromos(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Filter: Promos')));
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _primaryContainer : _surfaceContainer,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: active ? _onPrimaryContainer : _onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _NotificationCardItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String category;
  final bool read;
  final VoidCallback? onTap;

  const _NotificationCardItem({
    required this.title,
    required this.message,
    required this.time,
    required this.category,
    required this.read,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      title: title,
      message: message,
      time: time,
      category: category,
      read: read,
      onTap: onTap,
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'GEARUP Alpine Vault',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _secondary,
                ),
              ),
              const Text(
                'High Reliability Hardware',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _secondary,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _simulateExploreAction(context),
            child: const Row(
              children: [
                Icon(Icons.explore, size: 18, color: _primary),
                SizedBox(width: 6),
                Text(
                  'Explore Equipment',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _simulateExploreAction(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exploring equipment...')),
    );
  }
}