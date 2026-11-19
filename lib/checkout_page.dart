import 'package:flutter/material.dart';


import 'checkout_models.dart';
import 'payment_method_page.dart';

/// Checkout screen matching the "Checkout" screen delivered in the design
/// (gear summary, fulfillment tabs, promo code, cost breakdown, and the
/// persistent bottom "Continue to Payment" action).

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key, required this.booking});

  final CheckoutBooking booking;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _fulfillment = 'pickup';
  bool _promoApplied = true;
  bool _processing = false;

  late final TextEditingController _promoController;

  @override
  void initState() {
    super.initState();
    _promoController = TextEditingController(text: 'ALPINE10');
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  int get _subtotal => widget.booking.days * widget.booking.rate;
  int get _lockerFee => 5000;
  int get _protectionFee => 10000;
  int get _discount => _promoApplied ? 5000 : 0;
  int get _total => _subtotal + _lockerFee + _protectionFee - _discount;

  void _selectFulfillment(String mode) {
    if (mode == _fulfillment) return;
    setState(() => _fulfillment = mode);
  }

  void _togglePromo() {
    if (_processing) return;
    final code = _promoController.text.trim().toUpperCase();
    if (_promoApplied) return;
    if (code.isEmpty) return;
    if (code != 'ALPINE10') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid promo code. Please use ALPINE10.')),
      );
      return;
    }
    setState(() {
      _promoApplied = true;
      _promoController.text = 'ALPINE10';
    });
  }

  void _clearPromo() {
    if (_processing) return;
    setState(() {
      _promoApplied = false;
      _promoController.text = '';
    });
  }

  Future<void> _changeDeliveryAddress() async {
    final controller = TextEditingController(
      text: 'Jl. Raya Alpine Ridge No. 8, Batu, Malang',
    );
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delivery Destination'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter the drop-off address. The field coordinator will receive a QR delivery pass.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Jl. Raya Alpine Ridge No. 8, Batu, Malang',
                labelText: 'Delivery address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delivery address updated to $result')),
      );
    }
  }

  void _proceedPayment() {
    if (_processing) return;
    setState(() => _processing = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Slot secured. Selecting your payment channel...'),
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => PaymentMethodPage(
                model: _buildPaymentMethodModel(),
              ),
            ),
          );
        }
      });
    });
  }

  PaymentMethodModel _buildPaymentMethodModel() => PaymentMethodModel(
        booking: widget.booking,
        bookingRef: 'GR-00142',
        total: widget.booking.days * widget.booking.rate + 10000,
      );

  int get _checkoutTotal => widget.booking.days * widget.booking.rate + 10000;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 24),
                  child: _buildContent(),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(top: false, child: _bottomBar()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() => Column(
        children: [
          _header(),
          const SizedBox(height: 18),
          _progressTracker(),
          const SizedBox(height: 18),
          _equipmentCard(),
          const SizedBox(height: 16),
          _fulfillmentCard(),
          const SizedBox(height: 16),
          _promoCard(),
          const SizedBox(height: 16),
          _breakdownCard(),
          const SizedBox(height: 14),
          _assuranceCard(),
        ],
      );

  Widget _header() => Container(
        color: Colors.white.withOpacity(0.88),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C1C)),
            ),
            InkWell(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
              onTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('GEARUP brand mark'))),
              child: Container(
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEAEA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(children: [
                  Icon(Icons.landscape, color: Color(0xFF914D00), size: 15),
                  SizedBox(width: 7),
                  Text(
                    'GEARUP',
                    style: TextStyle(
                      color: Color(0xFF1B1C1C),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                    ),
                  ),
                ]),
              ),
            ),
            const Spacer(),
            Text(
              'Checkout',
              style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 16, fontWeight: FontWeight.w700),
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

  Widget _progressTracker() => Column(
        children: [
          Row(
            children: [
              const Text(
                'Expedition Checkout',
                style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6),
              ),
              const Spacer(),
              const Text(
                'Step 1 of 3',
                style: TextStyle(color: Color(0xFF914D00), fontSize: 11, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _stepDot(color: const Color(0xFFF28C28)),
              _stepDot(color: const Color(0xFFE3E2E2)),
              _stepDot(color: const Color(0xFFE3E2E2)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.verified_user, color: Color(0xFF914D00), size: 16),
              const SizedBox(width: 6),
              Text(
                'Gear Inspected & Ready for Field Deployment',
                style: const TextStyle(color: Color(0xFF554336), fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      );

  Widget _stepDot({required Color color}) => Container(
        width: 20,
        height: 4,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE4E2E1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Technical Pack // Alpine Inspected',
                            style: TextStyle(
                              color: Color(0xFF1B1C1C),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Hiking Backpack 45L',
                          style: const TextStyle(
                            color: Color(0xFF1B1C1C),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.hiking, color: Color(0xFFF28C28), size: 22),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.booking.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      color: const Color(0xFFE3E2E2),
                      child: const Icon(Icons.hiking, size: 36, color: Color(0xFF887364)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: Color(0xFF914D00)),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.booking.startDate.day} ${_monthName(widget.booking.startDate.month)} – ${_endDay()} ${widget.booking.startDate.year}',
                              style: const TextStyle(color: Color(0xFF554336), fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 14, color: Color(0xFF914D00)),
                            const SizedBox(width: 5),
                            Text(
                              'Duration: ${widget.booking.days} Days (1 Unit)',
                              style: const TextStyle(color: Color(0xFF554336), fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.arrow_drop_down, size: 14, color: Color(0xFF5F5E5E)),
                            const SizedBox(width: 5),
                            Text('Daily Rate', style: const TextStyle(color: Color(0xFF5F5E5E), fontSize: 11)),
                            const SizedBox(width: 6),
                            Text(
                              rupiah(widget.booking.rate),
                              style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 15, fontWeight: FontWeight.w800),
                            ),
                            const Text(' / day', style: TextStyle(color: Color(0xFF554336), fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.health_and_safety, color: Color(0xFFF28C28), size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Sanitized with UV-C & Re-waterproofed',
                      style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDCC3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Grade A+',
                      style: TextStyle(
                        color: Color(0xFF6E3900),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  String _endDay() => '${widget.booking.startDate.add(Duration(days: widget.booking.days - 1)).day}';
  String _monthName(int month) => const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][month - 1];

  Widget _fulfillmentCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  const Text(
                    'Fulfillment Method',
                    style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28C28),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Contactless',
                      style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9E8E7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _tab('Basecamp Pickup', Icons.lock_clock, selected: _fulfillment == 'pickup'),
                    const SizedBox(width: 6),
                    _tab('Trailhead Delivery', Icons.local_shipping, selected: _fulfillment == 'delivery'),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (_fulfillment == 'pickup') _pickupDetails() else _deliveryDetails(),
            ],
          ),
        ),
      );

  Widget _tab(String label, IconData icon, {required bool selected}) => InkWell(
        onTap: () => _selectFulfillment(selected ? _fulfillment : (_fulfillment == 'pickup' ? 'delivery' : 'pickup')),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFF28C28) : const Color(0xFFE9E8E7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? Colors.white : const Color(0xFF5F5E5E), size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF5F5E5E),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _pickupDetails() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: const Color(0xFFE3E2E2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.domain, color: Color(0xFF5F5E5E), size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Basecamp Locker Station #14',
                          style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3E2E2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'PIN-Ready',
                            style: TextStyle(color: Color(0xFF554336), fontSize: 8, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Alpine Hub Batu, Jl. Puncak Giri No. 12', style: TextStyle(color: Color(0xFF554336), fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.schedule, color: Color(0xFF914D00), size: 14),
                        const SizedBox(width: 5),
                        Text(
                          'Available: 15 Nov 2026, 09:00 WIB',
                          style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _deliveryDetails() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(color: const Color(0xFFE3E2E2), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.pin_drop, color: Color(0xFF5F5E5E), size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Delivery Destination', style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        TextButton(onPressed: _changeDeliveryAddress, child: const Text('Change', style: TextStyle(color: Color(0xFF914D00), fontWeight: FontWeight.w600))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Jl. Raya Alpine Ridge No. 8, Batu, Malang', style: TextStyle(color: Color(0xFF554336), fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.storefront, color: Color(0xFF914D00), size: 14),
                        const SizedBox(width: 5),
                        Text('Recipient: Field Coordinator (Rented Under GEARUP Profile)', style: const TextStyle(color: Color(0xFF554336), fontSize: 11)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.alarm, color: Color(0xFF914D00), size: 14),
                        const SizedBox(width: 5),
                        Text('Drop-off by: 15 Nov 2026, 08:30 WIB', style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _promoCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Promo Code', style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _promoApplied ? const Color(0xFFF28C28) : const Color(0xFFEFEDED),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _promoApplied ? 'Code Active' : 'No Code',
                      style: _promoApplied
                          ? const TextStyle(color: Color(0xFFFFFFFF), fontSize: 9, fontWeight: FontWeight.w700)
                          : const TextStyle(color: Color(0xFF554336), fontSize: 9, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(color: const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.confirmation_number, color: Color(0xFF5F5E5E), size: 15),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      enabled: !_processing,
                      controller: _promoController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.confirmation_number, color: Color(0xFF5F5E5E)),
                        hintText: 'Enter promo code',
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _togglePromo,
                    icon: Icon(_promoApplied ? Icons.check : Icons.play_arrow, color: Color(0xFFF28C28)),
                  ),
                ],
              ),
              if (_promoApplied) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.sell, color: Color(0xFFF28C28), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'ALPINE10 applied (-Rp5.000)',
                          style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      GestureDetector(
                        onTap: _clearPromo,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(color: const Color(0xFFE3E2E2), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close, color: Color(0xFF5F5E5E), size: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      );

  Widget _breakdownCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Cost Breakdown', style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28C28),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Transparent', style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ..._priceRows(),
              const Divider(height: 20, color: Color(0xFFE9E8E7)),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Rental Cost', style: const TextStyle(color: Color(0xFF554336), fontSize: 11, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.lock_reset, color: Color(0xFFF28C28), size: 14),
                            const SizedBox(width: 5),
                            Text('Zero Deposit Hold', style: const TextStyle(color: Color(0xFF554336), fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF28C28),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      rupiah(_total),
                      style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('All taxes included', style: const TextStyle(color: Color(0xFF554336), fontSize: 10)),
            ],
          ),
        ),
      );

  List<Widget> _priceRows() => [
        _priceRow('Rental Subtotal (1 unit × ${widget.booking.days} days)', rupiah(_subtotal)),
        _priceRow('Basecamp Locker Fee', rupiah(_lockerFee)),
        _priceRow('Gear Protection & Clean Fee', rupiah(_protectionFee)),
        if (_discount > 0) _priceRow('Promo Discount (ALPINE10)', '−${rupiah(_discount)}', accent: true),
      ];

  Widget _priceRow(String label, String value, {bool accent = false}) => Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: accent ? const Color(0xFF914D00) : Color(0xFF554336), fontSize: 11))),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(color: accent ? const Color(0xFF914D00) : Color(0xFF1B1C1C), fontSize: 11, fontWeight: FontWeight.w700),
          ),
        ],
      );

  Widget _assuranceCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.flag, color: Color(0xFFF28C28), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Trail cancellation guarantee: Cancel up to 12 hours before handover time with 100% rental credit refunded to your GEARUP wallet.',
                  style: const TextStyle(color: Color(0xFF554336), fontSize: 11, height: 1.4),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _bottomBar() => Container(
        color: Colors.white.withOpacity(0.92),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Payment', style: const TextStyle(color: Color(0xFF554336), fontSize: 11, fontWeight: FontWeight.w600)),
                Text(rupiah(_total), style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 20, fontWeight: FontWeight.w800)),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 44,
              child: FilledButton(
                onPressed: _processing ? null : _proceedPayment,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                ),
                child: _processing
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Continue to Payment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
}
