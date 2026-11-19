import 'package:flutter/material.dart';

import 'checkout_models.dart';
import 'my_rental_page.dart';

/// Payment-method screen matching the "Checkout Step 2/3" deliverable:
/// a box for choosing the payment channel and a sticky bottom dock with the
/// total payment and a "Pay Now" action.
class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key, required this.model});

  final PaymentMethodModel model;

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String _selectedMethod = 'va';
  bool _processing = false;

  void _selectMethod(String method) {
    if (method == _selectedMethod) return;
    setState(() => _selectedMethod = method);
  }

  void _payNow() {
    if (_processing) return;
    setState(() => _processing = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _processing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment secured. Redirecting to booking confirmation...')),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const MyRentalPage()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 12, 16, bottomInset + 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                const SizedBox(height: 16),
                _progressTracker(),
                const SizedBox(height: 16),
                _recapCard(),
                const SizedBox(height: 16),
                _paymentOptionsSection(),
                const SizedBox(height: 16),
                _securityCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(top: false, child: _bottomDock()),
          ),
        ],
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
            Text(
              'Payment Method',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Checkout Step 2/3',
                style: TextStyle(color: Color(0xFF5F5E5E), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.6),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.timer, color: Color(0xFF914D00), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '14:59 hold',
                    style: const TextStyle(color: Color(0xFF914D00), fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Payment Method',
            style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose your preferred payment method.',
            style: const TextStyle(color: Color(0xFF554336), fontSize: 12, height: 1.4),
          ),
        ],
      );

  Widget _recapCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E2E2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.backpack, color: Color(0xFF887364), size: 17),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Ref: ${widget.model.bookingRef}',
                      style: const TextStyle(color: Color(0xFF5F5E5E), fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${widget.model.booking.name} (${widget.model.booking.days} Days)',
                      style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF28C28),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Total Due',
                  style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 10, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                rupiah(widget.model.total),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      );

  Widget _paymentOptionsSection() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Select Channel',
                    style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.verified_user, color: Color(0xFF914D00), size: 14),
                      const SizedBox(width: 5),
                      Text(
                        'No Admin Fee',
                        style: TextStyle(color: Color(0xFF914D00), fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _payOption(
                selected: _selectedMethod == 'va',
                onTap: () => _selectMethod('va'),
                icon: Icons.account_balance,
                title: 'Bank Transfer (Virtual Account)',
                subtitle: 'BCA, Mandiri, BNI, BRI • Instant auto-check',
                pills: [
                  _pill('Mandiri VA (Recommended)', icon: Icons.bolt, bg: const Color(0xFFFFDCC3), text: const Color(0xFF2F1500)),
                  _pill('Automated 24/7', bg: const Color(0xFFE9E8E7)),
                ],
              ),
              const SizedBox(height: 10),
              _payOption(
                selected: _selectedMethod == 'ewallet',
                onTap: () => _selectMethod('ewallet'),
                icon: Icons.account_balance_wallet,
                title: 'E-Wallet',
                subtitle: 'GoPay, OVO, Dana, ShopeePay',
                pills: [
                  _pill('GoPay', bg: const Color(0xFFE9E8E7)),
                  _pill('OVO', bg: const Color(0xFFE9E8E7)),
                  _pill('Dana', bg: const Color(0xFFE9E8E7)),
                  _pill('ShopeePay', bg: const Color(0xFFE9E8E7)),
                ],
              ),
              const SizedBox(height: 10),
              _payOption(
                selected: _selectedMethod == 'qris',
                onTap: () => _selectMethod('qris'),
                icon: Icons.qr_code_scanner,
                title: 'QRIS Instant Pay',
                subtitle: 'Scan with any Indonesian banking or e-wallet app',
                pills: [
                  _pill('Instant Verification', bg: const Color(0xFFE9E8E7)),
                ],
              ),
              const SizedBox(height: 10),
              _payOption(
                selected: _selectedMethod == 'cash',
                onTap: () => _selectMethod('cash'),
                icon: Icons.payments,
                title: 'Cash on Pickup',
                subtitle: 'Pay directly at GEARUP Basecamp Station Locker #14',
                pills: [
                  _pill('Halimun Alpine Hub, Jakarta Selatan', icon: Icons.pin_drop, bg: const Color(0xFFE9E8E7)),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _payOption({
    required bool selected,
    required VoidCallback onTap,
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Widget> pills,
  }) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFFBF9F9) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? const [BoxShadow(color: Color(0xFFF28C28), blurRadius: 6, offset: Offset(0, 2))]
                : const [BoxShadow(color: Color(0x08000000), blurRadius: 6)],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF1B1C1C) : const Color(0xFFE9E8E7),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: selected ? Colors.white : const Color(0xFF5F5E5E), size: 24),
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
                              color: selected ? Colors.white : const Color(0xFF1B1C1C),
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (selected)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDCC3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SELECTED',
                              style: TextStyle(color: Color(0xFF2F1500), fontSize: 8, fontWeight: FontWeight.w700),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: selected ? const Color(0xFFF28C28) : const Color(0xFF554336),
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              _radioIndicator(selected: selected),
            ],
          ),
        ),
      );

  Widget _radioIndicator({required bool selected}) => Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF28C28) : const Color(0xFFE9E8E7),
          shape: BoxShape.circle,
        ),
        child: selected
            ? Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              )
            : null,
      );

  Widget _pill(String label, {IconData? icon, Color? bg, Color? text}) => Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: bg == const Color(0xFFFFDCC3) ? const Color(0xFF2F1500) : text ?? Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: text ?? (bg == const Color(0xFFFFDCC3) ? const Color(0xFF2F1500) : Colors.white),
                fontSize: 9,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );

  Widget _securityCard() => Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3E2E2),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.shield, color: Color(0xFF887364), size: 16),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          '256-Bit Encrypted Transaction',
                          style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Zero Deposit Hold activated with your validated Alpine ID. Your reserved high-altitude gear remains locked for 15 minutes after confirmation before returning to public trail inventory.',
                      style: TextStyle(color: Color(0xFF554336), fontSize: 11, height: 1.4),
                    ),
                  ],
                ),
              ),
              Container(
                width: 140,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF28C28),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock, color: Color(0xFFFFFFFF), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'PCI-DSS Certified',
                          style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.handshake, color: Color(0xFFFFDCC3), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Gear Protection Guarantee',
                          style: TextStyle(color: Color(0xFF2F1500), fontSize: 10, fontWeight: FontWeight.w700),
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

  Widget _bottomDock() => Container(
        color: Colors.white.withOpacity(0.92),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Payment',
                  style: const TextStyle(color: Color(0xFF554336), fontSize: 11, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  rupiah(widget.model.total),
                  style: const TextStyle(color: Color(0xFF1B1C1C), fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              height: 46,
              child: FilledButton(
                onPressed: _processing ? null : _payNow,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _processing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Pay Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
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
