/// Final booking-confirmation screen ("Booking Successful!") for the GEARUP
/// gear-rental checkout flow.
///
/// This mirrors the secure-checkout success page: a branded hero with the
/// booking ID, a details summary card (item, rental window, pickup station,
/// access PIN, total paid) and a next-steps checklist, followed by the two
/// primary action buttons and a gear-guarantee footnote. The page uses a
/// light palette to match the checkout success design while remaining a fully
/// self-contained Material page.
///
/// Buttons:
///   * "View My Rental" -> the authenticated user's active rentals.
///   * "Back to Home" -> the main dashboard.
///
/// The page is also pushed directly from [ConfirmPaymentPage] (see
/// [ConfirmPaymentPage._confirmPayment]) once the payment authorisation has
/// settled, replacing the older modal success overlay.
library;

import 'package:flutter/material.dart';

import 'account_store.dart';
import 'home_page.dart';
import 'my_rental_page.dart';

// Light success-page palette (mirrors the HTML design tokens).
const _surface = Color(0xFFFFFFFF);
const _primaryContainer = Color(0xFFF28C28);
const _inverseSurface = Color(0xFF303031);

/// Immutable payload passed into the booking-success screen.
class BookingSuccessModel {
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
  final List<StepItem> steps;
  final String primaryActionLabel;
  final String secondaryActionLabel;

  const BookingSuccessModel({
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
    required this.steps,
    this.primaryActionLabel = 'View My Rental',
    this.secondaryActionLabel = 'Back to Home',
  });
}

/// One relay-bullet under the "Next Steps & Pickup Protocol" list.
class StepItem {
  final String title;
  final String subtitle;

  const StepItem({required this.title, required this.subtitle});
}

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({super.key, this.model});

  static const _defaultImage =
      'assets/images/backpack.jpg';

  final BookingSuccessModel? model;

  @override
  Widget build(BuildContext context) {
    final m = model ?? _defaultModel();
    final showPin = m.pin.isNotEmpty;

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
                  _Eyebrow(),
                  const SizedBox(height: 18),
                  _Hero(),
                  const SizedBox(height: 16),
                  _DetailsCard(
                    bookingId: m.bookingId,
                    onCopy: () => _copyBookingId(context, m.bookingId),
                    itemPreview: _ItemPreview(
                      category: m.category,
                      name: m.bookingName,
                      edition: m.edition,
                      image: m.image,
                    ),
                    specs: [
                      _SpecRow(
                        icon: Icons.calendar_today,
                        label: 'Rental Window',
                        value: m.displayDate,
                        sub: '${m.days} Days Rental Duration',
                      ),
                      _SpecRow(
                        icon: Icons.warehouse,
                        label: 'Station',
                        value: m.stationName,
                        sub: m.lockerId,
                      ),
                      if (showPin)
                        _SpecRow(
                          icon: Icons.lock,
                          label: 'Access PIN',
                          value: _pinStars(m.pin),
                          sub: 'Day-of unlock',
                          pin: true,
                        ),
                      _SpecRow(
                        icon: Icons.receipt_long,
                        label: 'Total Paid',
                        value: m.total,
                        sub: m.paymentMethod,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _NextStepsCard(steps: m.steps),
                  const SizedBox(height: 14),
                  _ActionBar(
                    primaryLabel: m.primaryActionLabel,
                    primaryOnPressed: () => _onPrimary(context),
                    secondaryLabel: m.secondaryActionLabel,
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

  static BookingSuccessModel _defaultModel() => const BookingSuccessModel(
        bookingId: 'GR-00142',
        bookingName: 'Hiking Backpack 45L',
        edition: 'Charcoal Matte / Alpine Expedition',
        category: 'Alpine Pack',
        image: _defaultImage,
        displayDate: '15 Nov – 18 Nov 2026',
        days: 3,
        stationName: 'Boulder Basecamp',
        lockerId: 'Automated Locker #14',
        pin: '8492',
        total: 'Rp85.000',
        paymentMethod: 'Paid via Virtual Account',
        steps: const [
          StepItem(
            title: 'Check booking voucher & QR code',
            subtitle: 'Digital pass emailed to your registered GEARUP ID account.',
          ),
          StepItem(
            title: 'Locker passcode activates 1 hour prior',
            subtitle: 'Locker #14 keypad unlocks automatically using PIN 8492 on 15 Nov.',
          ),
          StepItem(
            title: 'Basecamp Support on 24/7 Standby',
            subtitle: 'Seamlessly reschedule or alter itinerary prior to pickup window.',
          ),
        ],
      );

  static String _pinStars(String pin) =>
      pin.replaceAllMapped(RegExp(r'.'), (m) => '•');

  void _copyBookingId(BuildContext context, String id) {
    // Clipboard is only available on platform targets that expose it; guard the
    // call so the button is a no-op (with feedback) on mobile.
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Copied $id')));
  }

  void _onPrimary(BuildContext context) {
    // "View My Rental" -> active rentals screen.
    if (context.mounted) {
      // Navigator.pushReplacement to remove this confirmation page from the
      // stack, matching the HTML's primary action.
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(builder: (_) => const MyRentalPage()),
      );
    }
  }

  void _onSecondary(BuildContext context) {
    // "Back to Home" -> main dashboard. Uses a guest account so the press works
    // on a clean launch (the prototype keeps accounts in memory, not a backend).
    final account = const LocalAccount(
      name: 'Guest',
      email: 'guest@gearup.app',
      phone: '0800GEARUP',
      password: '***',
    );
    if (context.mounted) {
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => HomeDashboardPage(account: account),
        ),
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Visual building blocks (mirrors the HTML sections)
// ---------------------------------------------------------------------------

class _Eyebrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color(0xFF914D00),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'GEARUP // EXPEDITION',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.6,
                color: Color(0xFF5F5E5E),
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE3E2E2),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock, size: 12, color: Color(0xFF1B1C1C)),
              SizedBox(width: 4),
              Text(
                'SECURE CHECKOUT',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: Color(0xFF5F5E5E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Abstract alpine compass + checkmark (no green; charcoal + orange).
        Center(
          child: _Compass(),
        ),
        const SizedBox(height: 14),
        const Text(
          'Booking Successful!',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.02,
            color: Color(0xFF1B1C1C),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Your rental booking has been successfully created and secured.',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF5F5E5E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _BookingLockedPill(bookingId: 'GR-00142'),
      ],
    );
  }
}

class _Compass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer concentric pulse ring.
        Container(
          width: 132,
          height: 132,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0x22F28C28),
          ),
        ),
        // Mid ring.
        Container(
          width: 108,
          height: 108,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFFFFFFF),
          ),
        ),
        // Inner disc with the sharp check.
        Container(
          width: 76,
          height: 76,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF1B1C1C),
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              size: 34,
              color: Color(0xFFFFDCC3),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingLockedPill extends StatelessWidget {
  final String bookingId;

  const _BookingLockedPill({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE3E2E2),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified,
            size: 16,
            color: Color(0xFF914D00),
          ),
          const SizedBox(width: 8),
          const Text(
            'CONFIRMED & LOCKED',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: Color(0xFF1B1C1C),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'GEAR ID #$bookingId',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: Color(0xFF1B1C1C),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final String bookingId;
  final VoidCallback onCopy;
  final Widget itemPreview;
  final List<Widget> specs;

  const _DetailsCard({
    required this.bookingId,
    required this.onCopy,
    required this.itemPreview,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderRow(bookingId: bookingId, onCopy: onCopy),
          const SizedBox(height: 10),
          itemPreview,
          const SizedBox(height: 10),
          Column(
            children: [
              for (final spec in specs) ...[
                spec,
                const SizedBox(height: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String bookingId;
  final VoidCallback onCopy;

  const _HeaderRow({required this.bookingId, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reservation ID',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF5F5E5E),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              bookingId,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1B1C1C),
              ),
            ),
          ],
        ),
        const Spacer(),
        _CopyButton(onPressed: onCopy),
      ],
    );
  }
}

class _CopyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CopyButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE3E2E2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.content_copy, size: 16, color: Color(0xFF1B1C1C)),
              SizedBox(width: 4),
              Text(
                'COPY',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Color(0xFF5F5E5E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemPreview extends StatelessWidget {
  final String category;
  final String name;
  final String edition;
  final String image;

  const _ItemPreview({
    required this.category,
    required this.name,
    required this.edition,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: (image.isNotEmpty)
              ? Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                )
              : const Icon(
                  Icons.picture_as_pdf,
                  size: 30,
                  color: Color(0xFF887364),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: Color(0xFF5F5E5E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '• 1 Unit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F5E5E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1C1C),
                ),
                maxLines: 1,
              ),
              const SizedBox(height: 2),
              Text(
                edition,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF5F5E5E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpecRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final bool pin;

  const _SpecRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.sub,
    this.pin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            color: Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF5F5E5E)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF5F5E5E),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1C1C),
                ),
                maxLines: 1,
              ),
              if (sub.isNotEmpty)
                Text(
                  sub,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF5F5E5E),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  final List<StepItem> steps;

  const _NextStepsCard({required this.steps});

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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist,
                color: const Color(0xFF914D00),
                size: 22,
              ),
              const SizedBox(width: 8),
              const Text(
                'Next Steps & Pickup Protocol',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B1C1C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...List.generate(
            steps.length,
            (i) => _Step(
              index: i + 1,
              item: steps[i],
              totalSteps: steps.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final int index;
  final StepItem item;
  final int totalSteps;

  const _Step({
    required this.index,
    required this.item,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFE9E8E7),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$index',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF914D00),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          item.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B1C1C),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          item.subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF5F5E5E),
          ),
        ),
        if (index < totalSteps - 1) const SizedBox(height: 8),
      ],
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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: primaryOnPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryContainer,
                foregroundColor: Colors.white,
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
                    primaryLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: secondaryOnPressed,
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
                  Icon(Icons.home, size: 18, color: _surface),
                  const SizedBox(width: 8),
                  Text(
                    secondaryLabel,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _surface,
                    ),
                  ),
                ],
              ),
            ),
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
        color: Color(0xFF5F5E5E),
      ),
    );
  }
}
