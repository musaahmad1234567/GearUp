import 'package:flutter/material.dart';

import 'my_rental_page.dart';
import 'booking_form_page.dart';

const _durInk = Color(0xFF1B1C1C);
const _durMuted = Color(0xFF5F5E5E);
const _durOrange = Color(0xFFF28C28);
const _durBg = Color(0xFFFBF9F9);

class RentalDurationPage extends StatefulWidget {
  const RentalDurationPage({super.key, required this.name, required this.category, required this.price, required this.rating, required this.image, required this.icon, required this.startDate, this.initialDays = 3});

  final String name, category, price, rating, image;
  final IconData icon;
  final DateTime startDate;
  final int initialDays;

  @override
  State<RentalDurationPage> createState() => _RentalDurationPageState();
}

class _RentalDurationPageState extends State<RentalDurationPage> {
  late int _days = widget.initialDays;
  int get _dailyRate => int.tryParse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  int get _rawTotal => _days * _dailyRate;
  int get _discount => _days >= 7 ? (_rawTotal * .1).round() : 0;
  int get _total => _rawTotal - _discount;
  DateTime get _returnDate => widget.startDate.add(Duration(days: _days));

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _durBg,
        appBar: AppBar(
          backgroundColor: _durBg,
          surfaceTintColor: _durBg,
          elevation: 1,
          leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: _durInk)),
          title: const Text('Rental Duration', style: TextStyle(color: _durInk, fontSize: 16, fontWeight: FontWeight.w700)),
          centerTitle: true,
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune, color: _durInk))],
        ),
        body: Column(children: [
          Expanded(child: ListView(padding: const EdgeInsets.only(bottom: 16), children: [
            Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Column(children: [
              Row(children: [const Expanded(child: Text('STEP 2 OF 4', style: TextStyle(color: Color(0xFF914D00), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: .8)),), Text('Rental Period', style: TextStyle(color: _durMuted, fontSize: 11))]),
              const SizedBox(height: 9),
              Row(
                children: List.generate(4, (index) => Expanded(
                  child: Container(
                    height: 5,
                    margin: EdgeInsets.only(right: index == 3 ? 0 : 5),
                    decoration: BoxDecoration(
                      color: index < 2 ? _durOrange : const Color(0xFFE3E2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ))),
            ])),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _card(child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(9), child: SizedBox(width: 64, height: 64, child: Image.network(widget.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE9E8E7), child: Icon(widget.icon, size: 34, color: const Color(0xFF887364)))))),
              const SizedBox(width: 11),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(5)), child: Text(widget.category, style: const TextStyle(color: _durInk, fontSize: 9, fontWeight: FontWeight.w600))), const SizedBox(width: 7), Icon(Icons.star, color: _durOrange, size: 14), const SizedBox(width: 2), Text(widget.rating, style: const TextStyle(color: _durMuted, fontSize: 10))]),
                const SizedBox(height: 4),
                Text(widget.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _durInk, fontSize: 14, fontWeight: FontWeight.w700)),
                Text('Rate: ${widget.price} / day', style: const TextStyle(color: _durMuted, fontSize: 11)),
              ])),
            ]))),
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('BOOKING WINDOW', style: TextStyle(color: _durMuted, fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w700)), SizedBox(height: 3), Text('Rental Duration', style: TextStyle(color: _durInk, fontSize: 17, fontWeight: FontWeight.w700))])), Icon(Icons.calendar_month, color: _durOrange, size: 24)]),
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(12)), child: Row(children: [
                _stepButton(Icons.remove, enabled: _days > 1, onTap: () => setState(() => _days--)),
                Expanded(child: Column(children: [Text('$_days', style: const TextStyle(color: _durInk, fontSize: 36, height: 1.1, fontWeight: FontWeight.w800)), const Text('Days', style: TextStyle(color: _durMuted, fontSize: 13)), const SizedBox(height: 3), Text('Weekly 10% applied', style: TextStyle(color: _days >= 7 ? const Color(0xFF914D00) : Colors.transparent, fontSize: 9, fontWeight: FontWeight.w700))])),
                _stepButton(Icons.add, enabled: _days < 30, primary: true, onTap: () => setState(() => _days++)),
              ])),
              const SizedBox(height: 15),
              const Text('QUICK PRESETS', style: TextStyle(color: _durMuted, fontSize: 10, letterSpacing: .7, fontWeight: FontWeight.w700)),
              const SizedBox(height: 7),
              GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 2.45, children: [
                _preset(1, 'Weekend rush'), _preset(3, 'Popular'), _preset(5, 'Trek pack'), _preset(7, '-10% Off'),
              ]),
              const SizedBox(height: 18),
              _timelineRow(Icons.circle, 'PICKUP & DISPATCH', _formatDate(widget.startDate), '09:00 AM', true),
              Padding(padding: const EdgeInsets.only(left: 6), child: Container(width: 2, height: 20, color: const Color(0xFFE3E2E2))),
              _timelineRow(Icons.circle, 'EXPECTED RETURN', _formatDate(_returnDate), '17:00 PM', false),
            ]))),
            const SizedBox(height: 12),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [const Expanded(child: Text('Calculation Breakdown', style: TextStyle(color: _durInk, fontSize: 15, fontWeight: FontWeight.w700))), Icon(Icons.receipt_long, color: _durMuted, size: 19)]),
              const SizedBox(height: 12),
              _priceRow('Standard Daily Rate', widget.price),
              _priceRow('Rental Period', '× $_days ${_days == 1 ? 'day' : 'days'}'),
              if (_discount > 0) _priceRow('Weekly Expedition Discount', '-${_rupiah(_discount)}', accent: true),
              const Divider(height: 20),
              Row(children: [const Expanded(child: Text('Equipment Subtotal', style: TextStyle(color: _durInk, fontSize: 13, fontWeight: FontWeight.w700))), Text(_rupiah(_total), style: const TextStyle(color: _durInk, fontSize: 18, fontWeight: FontWeight.w800))]),
              const SizedBox(height: 10),
              Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(9)), child: const Row(children: [Icon(Icons.lock_clock, size: 18, color: _durInk), SizedBox(width: 8), Expanded(child: Text('Flexible drop-off with 24/7 smart locker return across all base stations.', style: TextStyle(color: _durMuted, fontSize: 10, height: 1.3)))])),
            ]))),
          ])),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, -3))]),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('ESTIMATED TOTAL', style: TextStyle(color: _durMuted, fontSize: 9, letterSpacing: .7)),
                Text(_rupiah(_total), style: const TextStyle(color: _durInk, fontSize: 18, fontWeight: FontWeight.w800)),
              ])),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: SizedBox(
                height: 46,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => BookingFormPage(name: widget.name, category: widget.category, price: widget.price, image: widget.image, icon: widget.icon, startDate: widget.startDate, days: _days))),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Continue'),
                  style: FilledButton.styleFrom(backgroundColor: _durOrange, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11))),
                ),
              )),
            ]),
          ),
        ]),
      );

  Widget _card({required Widget child}) => Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6)]), child: child);

  Widget _stepButton(IconData icon, {required bool enabled, bool primary = false, required VoidCallback onTap}) => InkWell(onTap: enabled ? onTap : null, borderRadius: BorderRadius.circular(12), child: Container(width: 52, height: 52, decoration: BoxDecoration(color: primary ? _durOrange : Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 4)]), child: Icon(icon, color: primary ? Colors.white : enabled ? _durInk : const Color(0xFFBDBDBD), size: 26)));

  Widget _preset(int days, String caption) {
    final selected = days == _days;
    return InkWell(onTap: () => setState(() => _days = days), borderRadius: BorderRadius.circular(9), child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: selected ? _durInk : const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(9)), child: Row(children: [Expanded(child: Text('$days Days', style: TextStyle(color: selected ? Colors.white : _durInk, fontSize: 12, fontWeight: FontWeight.w700))), Text(caption, style: TextStyle(color: selected ? const Color(0xFFFFB77D) : caption == '-10% Off' ? _durOrange : _durMuted, fontSize: 9, fontWeight: FontWeight.w600))])));
  }

  Widget _timelineRow(IconData icon, String title, String date, String time, bool pickup) => Row(children: [
    Container(width: 13, height: 13, decoration: BoxDecoration(color: pickup ? _durOrange : _durInk, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 6)),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(color: _durMuted, fontSize: 9, letterSpacing: .5, fontWeight: FontWeight.w600)),
      Text(date, style: const TextStyle(color: _durInk, fontSize: 13, fontWeight: FontWeight.w700)),
    ])),
    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(5)), child: Text(time, style: const TextStyle(color: _durInk, fontSize: 10, fontWeight: FontWeight.w600))),
  ]);

  Widget _priceRow(String label, String value, {bool accent = false}) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(children: [Expanded(child: Text(label, style: TextStyle(color: accent ? const Color(0xFF914D00) : _durMuted, fontSize: 11))), Text(value, style: TextStyle(color: accent ? const Color(0xFF914D00) : _durInk, fontSize: 11, fontWeight: FontWeight.w600))]));

  String _formatDate(DateTime value) => '${value.day.toString().padLeft(2, '0')} ${_month(value.month)} ${value.year}';
  String _month(int value) => const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][value - 1];
  String _rupiah(int value) => 'Rp${value.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
}
