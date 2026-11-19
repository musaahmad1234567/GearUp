import 'package:flutter/material.dart';

import 'rental_duration_page.dart';

const _ink = Color(0xFF1B1C1C);
const _muted = Color(0xFF5F5E5E);
const _orange = Color(0xFFF28C28);
const _bg = Color(0xFFFBF9F9);

class RentalDatePage extends StatefulWidget {
  const RentalDatePage({super.key, required this.name, required this.category, required this.price, required this.rating, required this.image, required this.icon});

  final String name, category, rating;
  final String price;
  final String image;
  final IconData icon;

  @override
  State<RentalDatePage> createState() => _RentalDatePageState();
}

class _RentalDatePageState extends State<RentalDatePage> {
  DateTime _month = DateTime(2026, 11);
  DateTime? _start = DateTime(2026, 11, 15);
  DateTime? _end = DateTime(2026, 11, 18);

  int get _days => _start == null || _end == null ? 0 : _end!.difference(_start!).inDays;
  int get _daysInMonth => DateTime(_month.year, _month.month + 1, 0).day;
  int get _firstWeekday => DateTime(_month.year, _month.month, 1).weekday % 7;
  String get _monthLabel => '${_monthName(_month.month)} ${_month.year}';

  void _pick(DateTime date) {
    setState(() {
      if (_start == null || _end != null) {
        _start = date;
        _end = null;
      } else if (date.isBefore(_start!)) {
        _start = date;
      } else {
        _end = date;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cellCount = ((_firstWeekday + _daysInMonth + 6) ~/ 7) * 7;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        surfaceTintColor: _bg,
        elevation: 1,
        leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: _ink)),
        title: const Text('Select Rental Date', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.tune, color: _ink))],
      ),
      body: Column(children: [
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(16, 10, 16, 16), children: [
          Row(children: [
            const Expanded(child: Text('BOOKING FLOW', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: .8))),
            const Text('Step 1 of 4', style: TextStyle(color: Color(0xFF914D00), fontSize: 11, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 8),
          Row(children: List.generate(4, (i) => Expanded(child: Container(
            height: 5,
            margin: EdgeInsets.only(right: i == 3 ? 0 : 6),
            decoration: BoxDecoration(color: i == 0 ? _orange : const Color(0xFFE9E8E7), borderRadius: BorderRadius.circular(10)),
          )))),
          const SizedBox(height: 14),
          _card(child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: SizedBox(width: 64, height: 64, child: Image.network(
                widget.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE9E8E7), child: Icon(widget.icon, size: 34, color: const Color(0xFF887364))),
              )),
            ),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFE4E2E1), borderRadius: BorderRadius.circular(5)), child: const Text('✓  ALPINE INSPECTED', style: TextStyle(color: _ink, fontSize: 9, fontWeight: FontWeight.w700))),
              const SizedBox(height: 5),
              Text(widget.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 14, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('${widget.price}/day', style: const TextStyle(color: Color(0xFF914D00), fontSize: 15, fontWeight: FontWeight.w800)),
            ])),
          ])),
          const SizedBox(height: 12),
          _card(child: Column(children: [
            Row(children: [
              const Icon(Icons.calendar_month, color: Color(0xFF914D00), size: 20),
              const SizedBox(width: 7),
              Expanded(child: Text(_monthLabel, style: const TextStyle(color: _ink, fontSize: 18, fontWeight: FontWeight.w700))),
              IconButton(visualDensity: VisualDensity.compact, onPressed: () => setState(() => _month = DateTime(_month.year, _month.month - 1)), icon: const Icon(Icons.chevron_left, color: _ink)),
              IconButton(visualDensity: VisualDensity.compact, onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)), icon: const Icon(Icons.chevron_right, color: _ink)),
            ]),
            const SizedBox(height: 4),
            const Row(children: [
              Expanded(child: Center(child: Text('Su', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('Mo', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('Tu', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('We', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('Th', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('Fr', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
              Expanded(child: Center(child: Text('Sa', style: TextStyle(color: _muted, fontSize: 11, fontWeight: FontWeight.w600)))),
            ]),
            const SizedBox(height: 6),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cellCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisExtent: 40),
              itemBuilder: (context, index) {
                final number = index - _firstWeekday + 1;
                if (number < 1 || number > _daysInMonth) return const SizedBox.shrink();
                final date = DateTime(_month.year, _month.month, number);
                final unavailable = date.isBefore(DateTime(2026, 11, 15));
                final start = _start != null && _sameDay(date, _start!);
                final end = _end != null && _sameDay(date, _end!);
                final inRange = _start != null && _end != null && date.isAfter(_start!) && date.isBefore(_end!);
                final selected = start || end;
                return InkWell(
                  onTap: unavailable ? null : () => _pick(date),
                  child: Container(
                    color: inRange ? const Color(0xFFFFDCC3) : Colors.transparent,
                    alignment: Alignment.center,
                    child: Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: selected ? _orange : Colors.transparent, shape: BoxShape.circle),
                      child: Text('$number', style: TextStyle(color: unavailable ? const Color(0xFFBDBDBD) : selected ? Colors.white : _ink, decoration: unavailable ? TextDecoration.lineThrough : null, fontSize: 12, fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            Container(width: double.infinity, padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(9)), child: const Row(children: [Icon(Icons.info_outline, color: Color(0xFF914D00), size: 18), SizedBox(width: 8), Expanded(child: Text('Tap tanggal yang tersedia untuk memilih tanggal mulai dan kembali.', style: TextStyle(color: _muted, fontSize: 11)))])),
          ])),
          const SizedBox(height: 12),
          _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(child: Text('Rental Itinerary', style: TextStyle(color: _ink, fontSize: 15, fontWeight: FontWeight.w700))),
              Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFFFDCC3), borderRadius: BorderRadius.circular(20)), child: Text('$_days Days Total', style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w700))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _dateTile(Icons.flight_takeoff, 'Start Date', _formatDate(_start), 'Pickup: 09:00 AM')),
              const SizedBox(width: 10),
              Expanded(child: _dateTile(Icons.flight_land, 'Return Date', _formatDate(_end), 'Drop-off: 17:00 PM')),
            ]),
            const SizedBox(height: 10),
            const Row(children: [Icon(Icons.sanitizer_outlined, size: 16, color: _muted), SizedBox(width: 7), Expanded(child: Text('Sanitized & packed in protective waterproof sleeve', style: TextStyle(color: _muted, fontSize: 10)))]),
          ])),
        ])),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: BoxDecoration(color: _bg.withOpacity(.97), boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 12, offset: Offset(0, -3))]),
          child: Column(children: [
            Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Summary Preview', style: TextStyle(color: _muted, fontSize: 10)),
                Text('$_days Days selected • ${_totalPrice()}', style: const TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w700)),
              ])),
              const Text('Deposit: Rp0', style: TextStyle(color: Color(0xFF914D00), fontSize: 10, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 9),
            SizedBox(width: double.infinity, height: 46, child: FilledButton.icon(
              onPressed: _start != null && _end != null ? () => Navigator.of(context).pushReplacement(MaterialPageRoute<void>(builder: (_) => RentalDurationPage(name: widget.name, category: widget.category, price: widget.price, rating: widget.rating, image: widget.image, icon: widget.icon, startDate: _start!, initialDays: _days))) : null,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Continue to My Rental'),
              style: FilledButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.white, disabledBackgroundColor: const Color(0xFFD6D0CC), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13))),
            )),
          ]),
        ),
      ]),
    );
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;
  String _formatDate(DateTime? date) => date == null ? 'Select date' : '${date.day} ${_monthName(date.month)} ${date.year}';
  String _monthName(int month) => const ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][month - 1];

  String _totalPrice() {
    final amount = int.tryParse(widget.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final formatted = (amount * _days).toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
    return 'Rp$formatted';
  }

  Widget _card({required Widget child}) => Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 6, offset: Offset(0, 2))]), child: child);

  Widget _dateTile(IconData icon, String label, String date, String time) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF5F3F3), borderRadius: BorderRadius.circular(10)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, size: 16, color: const Color(0xFF914D00)), const SizedBox(width: 5), Text(label.toUpperCase(), style: const TextStyle(color: _muted, fontSize: 9, fontWeight: FontWeight.w700))]), const SizedBox(height: 7), Text(date, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 13, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(time, style: const TextStyle(color: _muted, fontSize: 10))]));
}
