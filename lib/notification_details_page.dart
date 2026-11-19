/// Booking-notification detail screen for the GEARUP gear-rental flow.
///
/// Mirrors the "Notification Details" HTML design: a light-themed confirmation
/// card with a status chip, equipment snapshot, key-logistics summary, a locked
/// locker-access card and the primary action buttons.
///
/// The page is a self-contained light-themed Material page. The app shell is
/// dark, so this page is pushed as a full-screen route (not a scaffold inside
/// the shell). It is also the target of the "View My Rental" action.
///
/// Buttons:
///   * "View My Rental" -> the authenticated user's active rentals.
///   * "Back to Notifications" -> the main dashboard (notification list).
///   * "Contact Support" -> opens the backcountry concierge.
library;

import 'package:flutter/material.dart';
import 'account_store.dart';

import 'home_page.dart';
import 'my_rental_page.dart';

// Light palette matching the HTML design tokens.
const _surface = Color(0xFFFFFFFF);
const _primary = Color(0xFF914D00);
const _primaryContainer = Color(0xFFF28C28);
const _onPrimaryContainer = Color(0xFFFFFFFF);
const _inverseSurface = Color(0xFF303031);
const _surfaceContainer = Color(0xFFEFEDED);
const _surfaceContainerLow = Color(0xFFF5F3F3);
const _onSurface = Color(0xFF1B1C1C);
const _onSurfaceVariant = Color(0xFF5F5E5E);

/// Immutable payload passed into the notification-details screen.
class NotificationDetailsModel {
  final String bookingId;
  final String bookingName;
  final String edition;
  final String category;
  final String image;
  final String displayDate;
  final int days;
  final String stationName;
  final String lockerId;
  final String pin;
  final String total;
  final String paymentMethod;
  final String status;
  final String deposit;
  final String lockTimeRemaining;
  final String unlockDate;
  final List<StepItem> steps;

  const NotificationDetailsModel({
    required this.bookingId,
    required this.bookingName,
    required this.edition,
    required this.category,
    required this.image,
    required this.displayDate,
    required this.days,
    required this.stationName,
    required this.lockerId,
    required this.pin,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.deposit,
    required this.lockTimeRemaining,
    required this.unlockDate,
    required this.steps,
  });

  factory NotificationDetailsModel.gr00142() => NotificationDetailsModel(
        bookingId: 'GR-00142',
        bookingName: 'Hiking Backpack 45L',
        edition: 'Charcoal Matte / Alpine Expedition',
        category: 'Alpine Pack',
        image: 'assets/images/backpack.jpg',
        displayDate: '15 Nov – 18 Mar 2026',
        days: 3,
        stationName: 'Boulder Basecamp Station',
        lockerId: 'Locker #14',
        pin: '8492',
        total: 'Rp0',
        paymentMethod: 'Mandiri Virtual Account',
        status: 'Sanitized',
        deposit: 'Rp0',
        lockTimeRemaining: '2h 46m',
        unlockDate: '15 Nov 2026, 09:00 WIB',
        steps: const [
          StepItem(
            title: 'Check booking voucher & QR code',
            subtitle: 'Digital pass emailed to your registered GEARUP ID account.',
          ),
          StepItem(
            title: 'Gear passed ultrasonic sterilization',
            subtitle: 'Securely staged for pickup at Boulder Basecamp Station.',
          ),
          StepItem(
            title: 'Access PIN active 1 hour before start',
            subtitle: 'Locker unlocks on 15 Nov at 09:00 WIB.',
          ),
        ],
      );
}

/// One relay-bullet under the "Next Steps & Pickup Protocol" list.
class StepItem {
  final String title;
  final String subtitle;

  const StepItem({required this.title, required this.subtitle});
}

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({super.key, this.model});

  final NotificationDetailsModel? model;

  @override
  Widget build(BuildContext context) {
    final m = model ?? NotificationDetailsModel.gr00142();
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(),
                  const SizedBox(height: 14),
                  _StatusChip(status: m.status),
                  const SizedBox(height: 16),
                  _ConfirmationCard(
                    bookingId: m.bookingId,
                    date: '15 Nov 2026',
                    title: 'Booking Confirmed — Gear Reserved',
                    bookingRef: m.bookingId,
                  ),
                  const SizedBox(height: 14),
                  _EquipmentSnapshot(
                    category: m.category,
                    name: m.bookingName,
                    edition: m.edition,
                    image: m.image,
                    days: m.days,
                    stationName: m.stationName,
                    lockerId: m.lockerId,
                  ),
                  const SizedBox(height: 14),
                  _KeyLogisticsGrid(
                    bookingRef: m.bookingId,
                    status: m.status,
                    deposit: m.deposit,
                  ),
                  const SizedBox(height: 14),
                  _LockerAccessCard(
                    pin: m.pin,
                    lockTimeRemaining: m.lockTimeRemaining,
                    unlockDate: m.unlockDate,
                  ),
                  const SizedBox(height: 14),
                  _ActionBar(
                    primaryLabel: 'View My Rental',
                    primaryOnPressed: () => _onPrimary(context),
                    secondaryLabel: 'Back to Notifications',
                    secondaryOnPressed: () => _onSecondary(context),
                  ),
                  const SizedBox(height: 12),
                  _Footnote(),
                ],
              ),
            ),
            // Thin brand accent strip (matches the HTML eyebrow live top strip).
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 3,
              child: Container(color: _primaryContainer, child: const SizedBox.shrink()),
            ),
          ],
        ),
      ),
    );
  }

  void _onPrimary(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(builder: (_) => const MyRentalPage()),
      );
    }
  }

  void _onSecondary(BuildContext context) {
    if (context.mounted) {
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(builder: (_) => HomeDashboardPage(account: const LocalAccount(
          name: 'Guest',
          email: 'guest@gearup.app',
          phone: '0800GEARUP',
          password: '***',
        ))),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Section builders (mirror the HTML sections)
// ---------------------------------------------------------------------------

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back, color: _onSurface),
          iconSize: 24,
          tooltip: 'Back',
        ),
        const Spacer(),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _onSurface,
              ),
            ),
            Text(
              'Booking Update',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
                color: _onSurfaceVariant,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _surfaceContainerLow,
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 14, color: _primary),
              SizedBox(width: 6),
              Text(
                '10:14 WIB',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _primaryContainer,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: 14,
            color: _onPrimaryContainer,
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: _onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationCard extends StatelessWidget {
  final String bookingId;
  final String date;
  final String title;
  final String bookingRef;

  const _ConfirmationCard({
    required this.bookingId,
    required this.date,
    required this.title,
    required this.bookingRef,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: _onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F0F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified,
                  size: 16,
                  color: _primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Booking Confirmation $bookingRef',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: _onSurface,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _Narrative(),
        ],
      ),
    );
  }
}

class _Narrative extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your reservation for the Hiking Backpack 45L has been successfully locked and authorized with Mandiri Virtual Account.',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: _onSurfaceVariant,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        const Text(
          'Your gear has passed our alpine ultrasonic sterilization protocol and is securely staged for pickup at Boulder Basecamp Station (Locker #14).',
          style: TextStyle(
            fontSize: 13,
            height: 1.5,
            color: _onSurfaceVariant,
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 8),
        _PinInfoRow(),
      ],
    );
  }
}

class _PinInfoRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_clock,
            size: 18,
            color: _primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Access PIN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Active 1 hour before rental start',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _onSurface,
                  ),
                ),
                Text(
                  '15 Nov 2026, 09:00 WIB',
                  style: const TextStyle(
                    fontSize: 10,
                    color: _onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EquipmentSnapshot extends StatelessWidget {
  final String category;
  final String name;
  final String edition;
  final String image;
  final int days;
  final String stationName;
  final String lockerId;

  const _EquipmentSnapshot({
    required this.category,
    required this.name,
    required this.edition,
    required this.image,
    required this.days,
    required this.stationName,
    required this.lockerId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: (image.isNotEmpty)
              ? Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.picture_as_pdf,
                    size: 28,
                    color: _onSurfaceVariant,
                  ),
                )
              : const Icon(
                  Icons.picture_as_pdf,
                  size: 28,
                  color: _onSurfaceVariant,
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
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        category,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                          color: _onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '• 1 Unit',
                      style: TextStyle(
                        fontSize: 12,
                        color: _onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: _onSurface,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 3),
                Text(
                  edition,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _onSurfaceVariant,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: _surfaceContainer),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.date_range,
                      size: 14,
                      color: _onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '$days Days Rental',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      size: 14,
                      color: _onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        stationName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _onSurface,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyLogisticsGrid extends StatelessWidget {
  final String bookingRef;
  final String status;
  final String deposit;

  const _KeyLogisticsGrid({
    required this.bookingRef,
    required this.status,
    required this.deposit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Key Logistics',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: _onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _GridCell(
                  label: 'Booking Ref',
                  value: bookingRef,
                  icon: Icons.event,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _GridCell(
                  label: 'Status',
                  value: status,
                  icon: Icons.check_circle,
                  valueColor: _primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _GridCell(
                  label: 'Deposit',
                  value: deposit,
                  icon: Icons.account_balance_wallet,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GridCell extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _GridCell({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: _onSurfaceVariant),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: valueColor ?? _onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _LockerAccessCard extends StatelessWidget {
  final String pin;
  final String lockTimeRemaining;
  final String unlockDate;

  const _LockerAccessCard({
    required this.pin,
    required this.lockTimeRemaining,
    required this.unlockDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F9),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_clock,
              size: 20,
              color: _onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Locker Security PIN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: _onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    const Text(
                      'PIN:  ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: _onSurface,
                      ),
                    ),
                    Text(
                      pin,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                        color: _onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Unlocks in $lockTimeRemaining',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _onSurfaceVariant,
                  ),
                ),
                Text(
                  unlockDate,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback? primaryOnPressed;
  final String secondaryLabel;
  final VoidCallback? secondaryOnPressed;

  const _ActionBar({
    required this.primaryLabel,
    required this.primaryOnPressed,
    required this.secondaryLabel,
    required this.secondaryOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ActionButton(
            label: primaryLabel,
            onPressed: primaryOnPressed,
            isPrimary: true,
          ),
          const SizedBox(height: 10),
          _ActionButton(
            label: secondaryLabel,
            onPressed: secondaryOnPressed,
            isPrimary: false,
          ),
          const SizedBox(height: 10),
          _SupportButton(),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.label,
    required this.onPressed,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isPrimary ? 52 : 46,
      child: isPrimary
        ? ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryContainer,
              foregroundColor: _onPrimaryContainer,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: _onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: _inverseSurface,
              foregroundColor: _surface,
              side: const BorderSide(color: _inverseSurface),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.assessment, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _surface,
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _SupportButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showSupportDialog(context),
      child: const Text(
        'Need help with this booking? Contact Support',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _primary,
          decoration: TextDecoration.underline,
          decorationColor: _primary,
        ),
      ),
    );
  }

  void _showSupportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text(
          'Our GEARUP Backcountry concierge is available 24/7 to help with your booking.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _Footnote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Inspected & Sanitized Alpine Equipment Guarantee',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: _onSurfaceVariant,
      ),
    );
  }
}
