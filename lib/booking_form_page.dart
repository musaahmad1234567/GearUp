import 'package:flutter/material.dart';

import 'checkout_page.dart';
import 'checkout_models.dart';

const _bookInk = Color(0xFF1B1C1C);
const _bookMuted = Color(0xFF5F5E5E);
const _bookOrange = Color(0xFFF28C28);
const _bookBg = Color(0xFFFBF9F9);

class BookingFormPage extends StatefulWidget {
  const BookingFormPage({super.key, required this.name, required this.category, required this.price, required this.image, required this.icon, required this.startDate, required this.days});

  final String name, category, price, image;
  final IconData icon;
  final DateTime startDate;
  final int days;

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  bool _delivery = false;
  bool _terms = true;
  bool _processing = false;

  int get _rate => int.tryParse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  int get _gearSubtotal => widget.days * _rate - (widget.days >= 7 ? (widget.days * _rate * .1).round() : 0);
  int get _grandTotal => _gearSubtotal + (_delivery ? 20000 : 0);

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _bookBg,
        appBar: AppBar(
          backgroundColor: _bookBg,
          surfaceTintColor: _bookBg,
          elevation: 1,
          leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: _bookInk)),
          title: const Text('Booking Form', style: TextStyle(color: _bookInk, fontSize: 16, fontWeight: FontWeight.w700)),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune, color: _bookInk))],
        ),
        body: Stack(children: [
          ListView(padding: const EdgeInsets.fromLTRB(16, 12, 16, 150), children: [
            _stepHeader(),
            const SizedBox(height: 14),
            _equipmentCard(),
            const SizedBox(height: 18),
            _sectionTitle('Contact Information', trailing: 'Encrypted'),
            const SizedBox(height: 8),
            _card(child: Form(key: _formKey, child: Column(children: [
              _textField(label: 'Full Name as per ID', icon: Icons.badge_outlined, initial: 'Alex Morgan', validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null),
              const SizedBox(height: 12),
              _textField(label: 'Phone Number (WhatsApp Active)', icon: Icons.call_outlined, initial: '+62 812-3456-7890', keyboard: TextInputType.phone, validator: (v) => (v == null || v.trim().isEmpty) ? 'Nomor telepon wajib diisi' : null),
              const SizedBox(height: 12),
              _textField(label: 'Email Address for Booking Voucher', icon: Icons.mail_outline, initial: 'alex.morgan@gearup.io', keyboard: TextInputType.emailAddress, validator: (v) => (v == null || !v.contains('@')) ? 'Masukkan email yang valid' : null),
            ]))),
            const SizedBox(height: 18),
            _sectionTitle('Rental Schedule Verification'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _scheduleTile(Icons.flight_takeoff, 'START HANDOVER', _date(widget.startDate), '09:00 WIB')),
              const SizedBox(width: 9),
              Expanded(child: _scheduleTile(Icons.flight_land, 'RETURN DUE', _date(widget.startDate.add(Duration(days: widget.days))), '17:00 WIB')),
            ]),
            const SizedBox(height: 18),
            _sectionTitle('Fulfillment Method', trailing: 'Step 2 of Delivery Plan'),
            const SizedBox(height: 8),
            _fulfillmentOption(pickup: true),
            const SizedBox(height: 8),
            _fulfillmentOption(pickup: false),
            if (_delivery) ...[
              const SizedBox(height: 8),
              _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Drop-off Location / Hotel Room / Trailhead Landmark', style: TextStyle(color: _bookMuted, fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 7),
                TextField(controller: _address, maxLines: 3, decoration: InputDecoration(hintText: 'Contoh: Rinjani Basecamp Gate 1, Sembalun...', filled: true, fillColor: const Color(0xFFF5F3F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none))),
                Row(children: [const Expanded(child: Text('Guaranteed courier check-in before 08:30', style: TextStyle(color: _bookMuted, fontSize: 9))), TextButton.icon(onPressed: () => setState(() => _address.text = 'Rinjani Lodge & Trailhead Base, Senaru, North Lombok Regency (Detected GPS)'), icon: const Icon(Icons.my_location, size: 15), label: const Text('Set Current', style: TextStyle(fontSize: 10)))]),
              ])),
            ],
            const SizedBox(height: 18),
            _sectionTitle('Expedition Notes', trailing: 'Optional'),
            const SizedBox(height: 8),
            _card(child: TextField(maxLines: 2, decoration: InputDecoration(hintText: 'Preferensi ukuran torso, cover ransel, atau detail kedatangan...', filled: true, fillColor: const Color(0xFFF5F3F3), border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none)))),
            const SizedBox(height: 12),
            _card(child: InkWell(onTap: () => setState(() => _terms = !_terms), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 21, height: 21, margin: const EdgeInsets.only(right: 10, top: 1), decoration: BoxDecoration(color: _terms ? _bookOrange : Colors.white, borderRadius: BorderRadius.circular(5), border: Border.all(color: _terms ? _bookOrange : _bookMuted)), child: _terms ? const Icon(Icons.check, size: 16, color: Colors.white) : null), const Expanded(child: Text('I agree to the rental terms & conditions, equipment care liability, and return guarantee protocol.', style: TextStyle(color: _bookMuted, fontSize: 11, height: 1.45)))]))),
            const SizedBox(height: 12),
            _card(child: const Row(children: [Icon(Icons.verified_user, color: Color(0xFF914D00), size: 23), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Sanitized & Field-Tested', style: TextStyle(color: _bookInk, fontSize: 12, fontWeight: FontWeight.w700)), Text('Cleaned with technical solution prior to dispatch.', style: TextStyle(color: _bookMuted, fontSize: 10))]))])),
          ]),
          Align(alignment: Alignment.bottomCenter, child: Container(padding: const EdgeInsets.fromLTRB(16, 11, 16, 16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .97), boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, -3))]), child: Column(mainAxisSize: MainAxisSize.min, children: [Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('ESTIMATED TOTAL', style: TextStyle(color: _bookMuted, fontSize: 9, letterSpacing: .7)), Text(_rupiah(_grandTotal), style: const TextStyle(color: _bookInk, fontSize: 21, fontWeight: FontWeight.w800))])), const Text('Zero Deposit Hold', style: TextStyle(color: Color(0xFF914D00), fontSize: 10, fontWeight: FontWeight.w600))]), const SizedBox(height: 8), SizedBox(width: double.infinity, height: 47, child: FilledButton.icon(onPressed: _terms && !_processing ? _submit : null, iconAlignment: IconAlignment.end, icon: _processing ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.arrow_forward, size: 18), label: Text(_processing ? 'Securing Booking…' : 'Continue to Checkout'), style: FilledButton.styleFrom(backgroundColor: _bookOrange, foregroundColor: Colors.white, disabledBackgroundColor: const Color(0xFFBDBDBD), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)))))]))),
        ]),
      );

  Widget _stepHeader() => Column(
    children: [
      Row(
        children: [
          const Expanded(
            child: Text(
              'FINAL VERIFICATION',
              style: TextStyle(color: _bookMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .8),
            ),
          ),
          const Text(
            'Step 4 of 4',
            style: TextStyle(color: Color(0xFF914D00), fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
      const SizedBox(height: 8),
      Row(
        children: List.generate(
          4,
          (i) => Expanded(
            child: Container(
              height: 5,
              margin: EdgeInsets.only(right: i == 3 ? 0 : 5),
              decoration: BoxDecoration(color: _bookOrange, borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    ],
  );

  Widget _equipmentCard() => _card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'SELECTED EQUIPMENT',
                style: TextStyle(color: _bookMuted, fontSize: 9, letterSpacing: .7, fontWeight: FontWeight.w700),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(16)),
              child: const Text(
                'Confirmed Spec',
                style: TextStyle(color: _bookInk, fontSize: 9, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(
                width: 74,
                height: 74,
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE9E8E7), child: Icon(widget.icon, size: 38, color: const Color(0xFF887364))),
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    maxLines: 2,
                    style: const TextStyle(color: _bookInk, fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '1 Unit • ${widget.category}',
                    style: const TextStyle(color: _bookMuted, fontSize: 10),
                  ),
                  Text(
                    '${_date(widget.startDate)} - ${_date(widget.startDate.add(Duration(days: widget.days)))} (${widget.days} Days)',
                    style: const TextStyle(color: _bookMuted, fontSize: 10),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Gear Subtotal',
                          style: TextStyle(color: _bookMuted, fontSize: 10),
                        ),
                      ),
                      Text(
                        _rupiah(_gearSubtotal),
                        style: const TextStyle(color: _bookInk, fontSize: 13, fontWeight: FontWeight.w800),
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
  );

  Widget _sectionTitle(String title, {String? trailing}) => Row(children: [Container(width: 7, height: 17, decoration: BoxDecoration(color: _bookOrange, borderRadius: BorderRadius.circular(5))), const SizedBox(width: 8), Expanded(child: Text(title, style: const TextStyle(color: _bookInk, fontSize: 16, fontWeight: FontWeight.w700))), if (trailing != null) Text(trailing, style: const TextStyle(color: Color(0xFF914D00), fontSize: 9, fontWeight: FontWeight.w600))]);

  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6)]), child: child);

  Widget _textField({required String label, required IconData icon, required String initial, TextInputType keyboard = TextInputType.text, String? Function(String?)? validator}) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: _bookMuted, fontSize: 10, fontWeight: FontWeight.w600)), const SizedBox(height: 5), TextFormField(initialValue: initial, keyboardType: keyboard, validator: validator, decoration: InputDecoration(prefixIcon: Icon(icon, size: 18, color: _bookMuted), filled: true, fillColor: const Color(0xFFF5F3F3), contentPadding: const EdgeInsets.symmetric(vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: BorderSide.none)))]);

  Widget _scheduleTile(IconData icon, String label, String date, String time) => _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: const Color(0xFF914D00), size: 18), const SizedBox(width: 5), Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF914D00), fontSize: 9, fontWeight: FontWeight.w700)))]), const SizedBox(height: 7), Text(date, style: const TextStyle(color: _bookInk, fontSize: 13, fontWeight: FontWeight.w700)), Text(time, style: const TextStyle(color: _bookMuted, fontSize: 10))]));

  Widget _fulfillmentOption({required bool pickup}) {
    final selected = _delivery != pickup;
    final title = pickup ? 'Self Pickup at Basecamp' : 'Trailhead / Hotel Delivery';
    return InkWell(onTap: () => setState(() => _delivery = !pickup), borderRadius: BorderRadius.circular(12), child: Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: selected ? Colors.white : const Color(0xFFEFEDED), borderRadius: BorderRadius.circular(12), boxShadow: selected ? const [BoxShadow(color: Color(0x08000000), blurRadius: 5)] : null), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 20, height: 20, margin: const EdgeInsets.only(right: 10, top: 1), decoration: BoxDecoration(color: selected ? _bookOrange : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: selected ? _bookOrange : const Color(0xFFBDBDBD), width: 2)), child: selected ? const Icon(Icons.circle, color: Colors.white, size: 8) : null), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(color: _bookInk, fontSize: 12, fontWeight: FontWeight.w700))), Text(pickup ? 'FREE' : '+Rp20.000', style: TextStyle(color: pickup ? _bookInk : const Color(0xFF914D00), fontSize: 10, fontWeight: FontWeight.w700))]), const SizedBox(height: 4), Text(pickup ? 'GEARUP Locker #14, Station Box North' : 'Delivery to your basecamp, hotel, or trailhead.', style: const TextStyle(color: _bookMuted, fontSize: 10)), if (pickup) const Padding(padding: EdgeInsets.only(top: 6), child: Text('Available 24/7 with QR passcode', style: TextStyle(color: _bookMuted, fontSize: 9)))]))])));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_delivery && _address.text.trim().isEmpty) {
      _message('Alamat delivery wajib diisi.');
      return;
    }
    setState(() => _processing = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _processing = false);
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CheckoutPage(booking: _buildCheckoutBooking())),
    );
  }

  CheckoutBooking _buildCheckoutBooking() => CheckoutBooking(
        name: widget.name,
        category: widget.category,
        price: widget.price,
        image: widget.image,
        startDate: widget.startDate,
        days: widget.days,
        rate: _rate,
      );

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  String _date(DateTime d) => '${d.day} ${const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][d.month - 1]} ${d.year}';
  String _rupiah(int value) => 'Rp${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
}
