import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'booking_success_page.dart';

import 'checkout_models.dart';

/// Final confirmation screen ("Confirm Payment" — Step 3 of 3).
///
/// Shows the equipment summary, selected payment channel, cost breakdown and
/// the countdown payment window. On "Confirm Payment" a loading micro-state is
/// shown for ~1100ms, then a success overlay appears with the rental ID and the
/// PIN that unlocks the contactless pickup.
class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key, required this.model});

  final ConfirmPaymentModel model;

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  String _countdown = '14:58';
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    int total = 14 * 60 + 58; // 14:58
    const interval = Duration(seconds: 1);
    void tick() {
      if (total > 0) {
        total--;
      }
      final minutes = total ~/ 60;
      final seconds = total % 60;
      final text =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      if (mounted) setState(() => _countdown = text);
      if (total > 0) {
        // ignore: explicit_callback_lifetime
        Timer(interval, tick);
      }
    }
    // ignore: unawaited_futures
    Timer(interval, tick);
  }

  void _confirmPayment() {
    if (_processing) return;
    if (mounted) {
      setState(() {
        _processing = true;
      });
    }
    // ignore: unawaited_futures
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      _showSuccessPage();
    });
  }


  void _showSuccessPage() {
    // Replace the old modal success overlay with the polished booking-success
    // screen (see booking_success_page.dart). Its buttons navigate to the
    // active-rentals dashboard and the main dashboard.
    if (mounted) {
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (_) => BookingSuccessPage(model: _bookingSuccessModel()),
        ),
      );
    }
  }

  BookingSuccessModel _bookingSuccessModel() {
    final booking = widget.model.booking;
    final days = widget.model.days;
    final rate = widget.model.rate;
    final gearSubtotal = days * rate;
    final serviceLocker = 5000;
    final protection = 10000;
    final discount = 5000;
    final total = gearSubtotal + serviceLocker + protection - discount;

    final start = booking.startDate;
    final endDay = start.day + days - 1;
    final displayDate =
        '${start.day} ${_shortMonth(start.month)} – ${endDay} ${_shortMonth(start.month)} ${start.year}';

    return BookingSuccessModel(
      bookingId: widget.model.bookingRef,
      bookingName: widget.model.bookingName,
      edition: widget.model.edition,
      category: booking.category,
      image: widget.model.imageNetwork.isNotEmpty ? widget.model.imageNetwork : booking.image,
      displayDate: displayDate,
      days: days,
      stationName: 'Boulder Basecamp',
      lockerId: 'Automated Locker #14',
      pin: '8492',
      total: rupiah(total),
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
  }

  String _shortMonth(int month) => <int, String>{
        1: 'Jan',
        2: 'Feb',
        3: 'Mar',
        4: 'Apr',
        5: 'May',
        6: 'Jun',
        7: 'Jul',
        8: 'Aug',
        9: 'Sep',
        10: 'Oct',
        11: 'Nov',
        12: 'Dec',
      }[month]!;

  @override
  Widget build(BuildContext context) {
    final booking = widget.model.booking;
    final days = widget.model.days;
    final rate = widget.model.rate;
    final gearSubtotal = days * rate;
    final serviceLocker = 5000;
    final protection = 10000;
    final discount = 5000;
    final total = gearSubtotal + serviceLocker + protection - discount;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  _stepIndicator(),
                  _countdownBanner(),
                  _equipmentCard(),
                  _paymentDestinationCard(),
                  _costRecap(
                    gearSubtotal: gearSubtotal,
                    serviceLocker: serviceLocker,
                    protection: protection,
                    discount: discount,
                    total: total,
                  ),
                  _reassuranceCard(),
                  _actionButtons(),
                ],
              ),
            ),
                      ],
        ),
      ),
    );
  }

  Widget _header() => Container(
        color: Colors.white.withOpacity(0.88),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C1C)),
            ),
            const Spacer(),
            Row(
              children: [
                const Text(
                  'Confirm Payment',
                  style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const Text(
                  '  |  Step 3 of 3',
                  style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.lock, color: Color(0xFF5F5E5E), size: 17),
            ),
          ],
        ),
      );

  Widget _stepIndicator() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
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
                  'Final Step before confirmation',
                  style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    thickness: 3,
                    color: Color(0xFFE3E2E2),
                  ),
                ),
                Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Color(0xFFF28C28),
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Confirm Payment',
              style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const Text(
              'Review your transaction before finalizing',
              style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 11),
            ),
          ],
        ),
      );

  Widget _countdownBanner() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.timer, color: Color(0xFF914D00), size: 20),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Payment Window',
                      style: TextStyle(
                        color: const Color(0xFF554336),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Complete payment within',
                      style: TextStyle(color: const Color(0xFF554336), fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1C1C),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _countdown,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'monospace'),
              ),
            ),
          ],
        ),
      );

  Widget _equipmentCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Equipment Summary',
                          style: TextStyle(
                            color: const Color(0xFF5F5E5E),
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.model.bookingName,
                          style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 17, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3E2E2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Text(
                      widget.model.bookingRef,
                      style: TextStyle(color: const Color(0xFF1B1C1C), fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3E2E2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: widget.model.imageNetwork != null
                          ? Image.network(
                              widget.model.imageNetwork,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFFE3E2E2),
                                child: const Center(
                                  child: Icon(Icons.park_outlined, size: 36, color: Color(0xFF887364)),
                                ),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.park_outlined, size: 36, color: Color(0xFF887364)),
                            ),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.model.bookingName,
                                    style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 16, fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.model.qty} Unit • ${widget.model.edition}',
                                    style: const TextStyle(color: Color(0xFF5F5E5E), fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF5F5E5E)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3E2E2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Center(
                                child: Icon(Icons.qr_code, size: 12, color: Color(0xFF5F5E5E)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3E2E2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: widget.model.imageNetwork != null
                                    ? Image.network(
                                        widget.model.imageNetwork,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => Container(
                                          color: const Color(0xFFE3E2E2),
                                          child: const Center(
                                            child: Icon(Icons.park_outlined, size: 36, color: Color(0xFF887364)),
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(Icons.park_outlined, size: 36, color: Color(0xFF887364)),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _paymentDestinationCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Destination',
                    style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28C28),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Secure Escrow',
                      style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _paymentChannelRow(),
              const SizedBox(height: 12),
              _vaBox(),
            ],
          ),
        ),
      );

  Widget _paymentChannelRow() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F9),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(Icons.account_balance, size: 20, color: Color(0xFF1B1C1C)),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mandiri Virtual Account',
                    style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const Text(
                    'VA Channel',
                    style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9E8E7),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'VA',
                style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 9, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      );

  Widget _vaBox() => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3F3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Icon, Spacer, Expanded
            Row(
              children: [
                const Icon(Icons.account_balance, size: 20, color: Color(0xFF5F5E5E)),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Virtual Account Number',
                        style: TextStyle(color: const Color(0xFF5F5E5E), fontSize: 10, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      _vaPaymentRow(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Row 2: Icon, Spacer, Expanded
            Row(
              children: [
                const Icon(Icons.account_balance, size: 16, color: Color(0xFF5F5E5E)),
                const SizedBox(width: 7),
                const Expanded(
                  child: Text(
                    'GEARUP EXPEDITION RENTALS',
                    style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  /// Virtual account payment row (icon, VA number, copy button).
  Widget _vaPaymentRow() => Row(
        children: [
          const Icon(Icons.account_balance, size: 20, color: Color(0xFF5F5E5E)),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Virtual Account Number',
                  style: TextStyle(color: const Color(0xFF5F5E5E), fontSize: 10, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.account_balance, size: 16, color: Color(0xFF5F5E5E)),
                    const SizedBox(width: 7),
                    const Expanded(
                      child: Text(
                        '8801 2940 8592 0014',
                        style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w800, fontFamily: 'monospace'),
                      ),
                    ),
                    IconButton(
                      onPressed: _copyVaNumber,
                      icon: const Icon(Icons.content_copy, size: 18, color: Color(0xFF5F5E5E)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  void _copyVaNumber() {
    Clipboard.setData(const ClipboardData(text: '8801294085920014')).then((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Virtual account number copied')),
        );
      }
    });
  }

  Widget _costRecap({
    required int gearSubtotal,
    required int serviceLocker,
    required int protection,
    required int discount,
    required int total,
  }) => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Cost Calculation',
                    style: TextStyle(color: const Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDCC3),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.sell, size: 14, color: Color(0xFF6E3900)),
                        SizedBox(width: 5),
                        Text('Discount (ALPINE10)', style: TextStyle(color: Color(0xFF6E3900), fontSize: 9, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _costRow('Gear Subtotal (${widget.model.days} Days)', 'Rp75.000'),
              _costRow('Service & Locker Preparation', 'Rp5.000'),
              _costRow('Protection Coverage', 'Rp10.000'),
              _costRow('Discount (ALPINE10)', '-Rp5.000'),
              const Divider(height: 24, color: Color(0xFFE3E2E2)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Payable',
                          style: TextStyle(color: const Color(0xFF554336), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Includes all taxes & alpine insurance',
                          style: TextStyle(color: const Color(0xFF5F5E5E), fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28C28),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Rp85.000',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _costRow(String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF554336), fontSize: 12)),
            Text(value, style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 12, fontWeight: FontWeight.w700)),
          ],
        ),
      );

  Widget _reassuranceCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF28C28),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_clock, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'This is an instant rental authorization. Once confirmed, equipment is locked and prepared at Basecamp Locker #14 for immediate contactless pickup.',
                  style: const TextStyle(color: Color(0xFF554336), fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _actionButtons() => Container(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        constraints: const BoxConstraints(maxWidth: 520),
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: SizedBox.expand(
                child: FilledButton(
                  onPressed: _processing ? null : _confirmPayment,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF28C28),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                  ),
                  child: _processing
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            ),
                            SizedBox(width: 8),
                            Text('Authorizing', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          ],
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Confirm Payment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                            const SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B1C1C),
                side: const BorderSide(color: Color(0xFFE9E8E7)),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chevron_left, size: 16, color: Color(0xFF5F5E5E)),
                  const SizedBox(width: 6),
                  const Text('Back to Payment Method', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      );
}
