import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _dInk = Color(0xFF252525);
const _dMuted = Color(0xFF777777);
const _dOrange = Color(0xFFF28C28);
const _dBg = Color(0xFFF7F7F7);
const _tentImage = 'assets/images/tent.jpg';

class RentalDetailsPage extends StatefulWidget {
  const RentalDetailsPage({super.key});

  @override
  State<RentalDetailsPage> createState() => _RentalDetailsPageState();
}

class _RentalDetailsPageState extends State<RentalDetailsPage> {
  bool _copied = false;

  void _notice(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  Future<void> _copyPin() async {
    await Clipboard.setData(const ClipboardData(text: '8492'));
    if (!mounted) return;
    setState(() => _copied = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _dBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 1,
          leading: IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back, color: _dInk)),
          title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('GEARUP', style: TextStyle(fontSize: 10, color: _dMuted, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
            Text('Rental Details', style: TextStyle(fontSize: 16, color: _dInk, fontWeight: FontWeight.w700)),
          ]),
          actions: [IconButton(onPressed: () => _notice(context, 'Rental details siap dibagikan.'), icon: const Icon(Icons.share_outlined, color: _dInk))],
        ),
        body: ListView(padding: const EdgeInsets.fromLTRB(16, 14, 16, 28), children: [
          _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Text('BOOKING REF', style: TextStyle(color: _dMuted, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600)), const SizedBox(width: 8), const Text('GR-00124', style: TextStyle(color: _dInk, fontSize: 15, fontWeight: FontWeight.w800)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: _dInk, borderRadius: BorderRadius.circular(20)), child: const Row(children: [Icon(Icons.circle, color: _dOrange, size: 8), SizedBox(width: 6), Text('Ongoing Rental', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600))]))]),
            const SizedBox(height: 14),
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: _dBg, borderRadius: BorderRadius.circular(10)), child: Row(children: [Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFEAEAEA), borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.schedule, color: _dOrange)), const SizedBox(width: 10), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Remaining Rental Window', style: TextStyle(color: _dMuted, fontSize: 10)), SizedBox(height: 3), Text('Due back in 2 days (Nov 18, 17:00)', style: TextStyle(color: _dInk, fontSize: 12, fontWeight: FontWeight.w700))]))])),
            const SizedBox(height: 16),
            const Text('RENTAL PROGRESSION', style: TextStyle(color: _dMuted, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            const _ProgressStep(title: 'Booked', subtitle: 'Confirmed on 12 Nov, 14:32', state: 1),
            const _ProgressStep(title: 'Dispatched & Picked Up', subtitle: 'Basecamp Locker #14 • 15 Nov, 09:15', state: 1),
            const _ProgressStep(title: 'In Use (Active)', subtitle: 'Expedition ongoing in alpine territory', state: 2),
            const _ProgressStep(title: 'Return Inspection', subtitle: 'Automated hardware diagnostic & check', state: 0),
            const _ProgressStep(title: 'Completed', subtitle: 'Deposit release & final summary', state: 0, last: true),
          ])),
          const SizedBox(height: 12),
          _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionHeading('EQUIPMENT DETAILS', trailing: 'Active Item'),
            const SizedBox(height: 14),
            Row(children: [ClipRRect(borderRadius: BorderRadius.circular(10), child: SizedBox(width: 90, height: 90, child: Image.asset(_tentImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: const Color(0xFFEAEAEA), child: const Icon(Icons.park_outlined, size: 40, color: _dMuted))))), const SizedBox(width: 12), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Shelter • 3-Season Ultralight', style: TextStyle(color: _dMuted, fontSize: 10)), SizedBox(height: 5), Text('MSR Hubba Hubba 2-Person Expedition Tent', maxLines: 2, style: TextStyle(color: _dInk, fontSize: 14, height: 1.25, fontWeight: FontWeight.w700)), SizedBox(height: 7), Text('Rp50.000 / day', style: TextStyle(color: _dInk, fontSize: 15, fontWeight: FontWeight.w800))]))]),
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: _dBg, borderRadius: BorderRadius.circular(9)), child: const Row(children: [_Spec('Weight', '1.3 kg'), _Spec('Capacity', '2 Person'), _Spec('Waterproof', '3,000mm')])),
            const SizedBox(height: 10),
            _infoTile(Icons.verified_user_outlined, 'Alpine Inspected & Sanitized', 'Certified storm-proofed prior to hand-off'),
          ])),
          const SizedBox(height: 12),
          _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionHeading('LOGISTICS & ACCESS', icon: Icons.lock_clock),
            const SizedBox(height: 12),
            const _KeyValue('Rental Period', '15 Nov 2026 - 18 Nov 2026'),
            const _KeyValue('Rental Duration', '3 Days (72 Hours)'),
            const _KeyValue('Quantity', '1 Unit'),
            const _KeyValue('Booking Placed', '12 Nov 2026, 14:32'),
            const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _dBg, borderRadius: BorderRadius.circular(11)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 32, height: 32, decoration: BoxDecoration(color: const Color(0xFFEAEAEA), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.location_on_outlined, size: 18, color: _dInk)), const SizedBox(width: 9), const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('PICKUP & RETURN POINT', style: TextStyle(color: _dMuted, fontSize: 9, letterSpacing: .5)), SizedBox(height: 3), Text('GEARUP Boulder Basecamp', style: TextStyle(color: _dInk, fontSize: 13, fontWeight: FontWeight.w700)), SizedBox(height: 2), Text('Station Box: Locker #14 (24/7 Accessible)', style: TextStyle(color: _dMuted, fontSize: 10))]))]),
              const SizedBox(height: 12),
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9)), child: Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Locker PIN Code', style: TextStyle(color: _dMuted, fontSize: 10)), SizedBox(height: 4), Text('• • • 8 4 9 2', style: TextStyle(color: _dInk, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w900))])), TextButton.icon(onPressed: _copyPin, icon: Icon(_copied ? Icons.done : Icons.content_copy, size: 16), label: Text(_copied ? 'Copied!' : 'Copy'), style: TextButton.styleFrom(foregroundColor: _dInk, backgroundColor: _dBg))])),
            ])),
          ])),
          const SizedBox(height: 12),
          _card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const _SectionHeading('PAYMENT BREAKDOWN', icon: Icons.receipt_long),
            const SizedBox(height: 12),
            const _KeyValue('Rental Subtotal (3 Days × Rp50.000)', 'Rp150.000'),
            const _KeyValue('Service & Maintenance Fee', 'Rp10.000'),
            const _KeyValue('Gear Protection (Damage Waiver)', 'Rp15.000'),
            const _KeyValue('Platform Discount (Alpine Promo)', '- Rp15.000', accent: true),
            const SizedBox(height: 10),
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: _dBg, borderRadius: BorderRadius.circular(10)), child: const Column(children: [Row(children: [Text('Total Payment', style: TextStyle(color: _dInk, fontSize: 14, fontWeight: FontWeight.w700)), Spacer(), Text('Rp160.000', style: TextStyle(color: _dInk, fontSize: 20, fontWeight: FontWeight.w900))]), SizedBox(height: 7), Row(children: [Icon(Icons.account_balance_wallet_outlined, size: 15, color: _dMuted), SizedBox(width: 6), Text('GEARUP Pay / Mandiri VA • Paid in Full', style: TextStyle(color: _dMuted, fontSize: 10))])])),
          ])),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => _notice(context, 'Locker #14 • PIN 8492 • Kembalikan sebelum 18 Nov, 17:00.'), iconAlignment: IconAlignment.end, icon: const Icon(Icons.arrow_forward, size: 18), label: const Text('Return Instructions & Locker Access'), style: FilledButton.styleFrom(backgroundColor: _dOrange, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)))),
          const SizedBox(height: 8),
          OutlinedButton.icon(onPressed: () => _notice(context, 'Menghubungi Basecamp Support (24/7).'), icon: const Icon(Icons.support_agent, color: _dOrange), label: const Text('Contact Basecamp Support (24/7)'), style: OutlinedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: _dInk, side: BorderSide.none, minimumSize: const Size.fromHeight(48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)))),
          const SizedBox(height: 5),
          TextButton(onPressed: () => _notice(context, 'Booking ini sudah melewati batas pembatalan.'), child: const Text('Cancel Booking (Eligible until Nov 14)', style: TextStyle(color: _dMuted, fontSize: 11))),
        ]),
      );

  Widget _card({required Widget child}) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13), boxShadow: const [BoxShadow(color: Color(0x09000000), blurRadius: 6, offset: Offset(0, 2))]), child: child);

  Widget _infoTile(IconData icon, String title, String subtitle) => Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFEAEAEA), borderRadius: BorderRadius.circular(9)), child: Row(children: [Icon(icon, size: 19, color: _dInk), const SizedBox(width: 9), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: _dInk, fontSize: 11, fontWeight: FontWeight.w700)), Text(subtitle, style: const TextStyle(color: _dMuted, fontSize: 10))]))]));
}

class _ProgressStep extends StatelessWidget {
  const _ProgressStep({required this.title, required this.subtitle, required this.state, this.last = false});
  final String title, subtitle;
  final int state;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final active = state == 2;
    final done = state == 1;
    return SizedBox(height: last ? 43 : 55, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 30, child: Column(children: [Container(width: 27, height: 27, decoration: BoxDecoration(color: active ? _dOrange : done ? _dInk : const Color(0xFFEAEAEA), shape: BoxShape.circle, boxShadow: active ? const [BoxShadow(color: Color(0x33F28C28), blurRadius: 0, spreadRadius: 4)] : null), child: Icon(done ? Icons.check : active ? Icons.navigation : state == 0 && title == 'Completed' ? Icons.task_alt : Icons.fact_check, size: 15, color: done || active ? Colors.white : _dMuted)), if (!last) Expanded(child: Container(width: 2, color: done ? _dInk : active ? _dOrange : const Color(0xFFE3E2E2)))])),
      const SizedBox(width: 9),
      Expanded(child: Padding(padding: const EdgeInsets.only(top: 3), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Flexible(child: Text(title, style: TextStyle(color: state == 0 ? _dMuted : _dInk, fontSize: 12, fontWeight: active || done ? FontWeight.w700 : FontWeight.w600))), if (active) ...[const SizedBox(width: 7), Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: _dOrange.withOpacity(.15), borderRadius: BorderRadius.circular(4)), child: const Text('NOW', style: TextStyle(color: _dInk, fontSize: 8, fontWeight: FontWeight.w800)))]]), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: _dMuted, fontSize: 10))]))),
    ]));
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(this.title, {this.trailing, this.icon});
  final String title;
  final String? trailing;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: Text(title, style: const TextStyle(color: _dMuted, fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w700))), if (trailing != null) Text(trailing!, style: const TextStyle(color: _dOrange, fontSize: 10, fontWeight: FontWeight.w700)), if (icon != null) Icon(icon, color: _dMuted, size: 18)]);
}

class _Spec extends StatelessWidget {
  const _Spec(this.label, this.value);
  final String label, value;

  @override
  Widget build(BuildContext context) => Expanded(child: Column(children: [Text(label, style: const TextStyle(color: _dMuted, fontSize: 9)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: _dInk, fontSize: 11, fontWeight: FontWeight.w700))]));
}

class _KeyValue extends StatelessWidget {
  const _KeyValue(this.label, this.value, {this.accent = false});
  final String label, value;
  final bool accent;

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 6), child: Row(children: [Expanded(child: Text(label, style: TextStyle(color: accent ? _dInk : _dMuted, fontSize: 10, fontWeight: accent ? FontWeight.w600 : FontWeight.w400))), const SizedBox(width: 8), Flexible(child: Text(value, textAlign: TextAlign.end, style: TextStyle(color: accent ? _dOrange : _dInk, fontSize: 10, fontWeight: FontWeight.w700)))]));
}
