import 'package:flutter/material.dart';
import 'rental_details_page.dart';

const _rInk = Color(0xFF252525);
const _rMuted = Color(0xFF777777);
const _rOrange = Color(0xFFF28C28);
const _rBg = Color(0xFFF7F7F7);

class MyRentalPage extends StatefulWidget {
  const MyRentalPage({super.key});

  @override
  State<MyRentalPage> createState() => _MyRentalPageState();
}

class _MyRentalPageState extends State<MyRentalPage> {
  bool _history = false;

  static const _tent = 'assets/images/tent.jpg';
  static const _pack = 'assets/images/backpack.jpg';
  static const _shoes = 'assets/images/boots.jpg';
  static const _bag = 'assets/images/sleepingbag.jpg';
  static const _cook = 'assets/images/cookware.jpg';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: _rBg,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 1,
          titleSpacing: 16,
          title: Row(children: [
            const Icon(Icons.landscape, color: _rOrange, size: 28),
            const SizedBox(width: 9),
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('GEARUP', style: TextStyle(fontSize: 10, color: _rMuted, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
              Text('My Rental', style: TextStyle(fontSize: 16, color: _rInk, fontWeight: FontWeight.w700)),
            ]),
          ]),
          actions: [
            IconButton(onPressed: () => _notice('Cari peralatan melalui Explore.'), icon: const Icon(Icons.search, color: _rInk)),
            IconButton(onPressed: () => _notice('Belum ada notifikasi baru.'), icon: const Icon(Icons.notifications_none, color: _rInk)),
          ],
        ),
        body: SafeArea(top: false, child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('My Rental', style: TextStyle(color: _rInk, fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            const Text('Manage your equipment rentals.', style: TextStyle(color: _rMuted, fontSize: 12)),
            const SizedBox(height: 16),
            Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(12)), child: Row(children: [
              _tab('Active', false), _tab('History', true),
            ])),
          ])),
          Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(16, 0, 16, 20), children: [
            if (!_history) ...[
              _rentalCard(booking: 'GR-00124', status: 'Ongoing', statusType: 0, category: 'Shelter • 3-Season', name: 'MSR Hubba Hubba 2-Person Expedition Tent', date: '15 Nov - 18 Nov 2026', image: _tent, icon: Icons.park_outlined, detail: 'Due back in 2 days', totalLabel: 'Total Fee', total: 'Rp150.000', primaryAction: 'Return Info', secondaryAction: 'View Details'),
              _rentalCard(booking: 'GR-00129', status: 'Confirmed', statusType: 1, category: 'Backpacks & Apparel', name: "Arc'teryx Bora 65L & Technical Shell Kit", date: '22 Nov - 25 Nov 2026 (3 Days)', image: _pack, icon: Icons.backpack_outlined, detail: 'Ready for Basecamp Pickup', totalLabel: 'Total Fee', total: 'Rp210.000', primaryAction: 'View Details'),
              _rentalCard(booking: 'GR-00135', status: 'Pending Approval', statusType: 2, category: 'Footwear • Size 42', name: 'Salomon Quest 4D Gore-Tex Trail Shoes', date: '28 Nov - 30 Nov 2026 (2 Days)', image: _shoes, icon: Icons.hiking_outlined, detail: 'Awaiting gear depot inspection', totalLabel: 'Estimated', total: 'Rp60.000', primaryAction: 'Cancel Booking', secondaryAction: 'View Details'),
            ] else ...[
              _rentalCard(booking: 'GR-00098', status: 'Completed', statusType: 3, category: 'Sleep System • Sub-Zero', name: 'Ultralight Alpine 4-Season Sleeping Bag', date: '02 Oct - 05 Oct 2026', image: _bag, icon: Icons.bed_outlined, detail: 'Returned & Inspected', totalLabel: 'Paid', total: 'Rp84.000', primaryAction: 'Rent Again', secondaryAction: 'View Receipt'),
              _rentalCard(booking: 'GR-00085', status: 'Completed', statusType: 3, category: 'Camp Kitchen • Ultralight', name: 'Titanium Camp Cookware & Stove System', date: '18 Sep - 21 Sep 2026', image: _cook, icon: Icons.outdoor_grill_outlined, detail: 'Returned & Inspected', totalLabel: 'Paid', total: 'Rp54.000', primaryAction: 'Rent Again', secondaryAction: 'View Receipt'),
              _rentalCard(booking: 'GR-00072', status: 'Cancelled', statusType: 4, category: 'Shelter • 4-Season', name: 'Geodesic 4-Person Alpine Expedition Tent', date: '10 Aug - 14 Aug 2026', image: _tent, icon: Icons.park_outlined, detail: 'Refunded to original card', totalLabel: 'Amount', total: 'Rp200.000', primaryAction: 'View Details'),
              _rentalCard(booking: 'GR-00061', status: 'Completed', statusType: 3, category: 'Footwear • Trail', name: 'Salomon Quest 4D Hiking Shoes', date: '05 Jul - 08 Jul 2026', image: _shoes, icon: Icons.hiking_outlined, detail: 'Returned & Inspected', totalLabel: 'Paid', total: 'Rp90.000', primaryAction: 'Rent Again', secondaryAction: 'View Receipt'),
            ],
            const SizedBox(height: 4),
            Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(13)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.verified_user_outlined, size: 21, color: _rOrange), SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('GEARUP Clean & Ready Guarantee', style: TextStyle(color: _rInk, fontSize: 12, fontWeight: FontWeight.w700)), SizedBox(height: 4), Text('All rentals undergo sanitization and equipment inspection prior to dispatch.', style: TextStyle(color: _rMuted, fontSize: 11, height: 1.4))])),
            ])),
          ])),
        ])),
      );

  Widget _tab(String label, bool history) {
    final selected = _history == history;
    final count = history ? '4' : '3';
    return Expanded(child: InkWell(onTap: () => setState(() => _history = history), borderRadius: BorderRadius.circular(9), child: Container(height: 38, decoration: BoxDecoration(color: selected ? _rInk : Colors.transparent, borderRadius: BorderRadius.circular(9), boxShadow: selected ? const [BoxShadow(color: Color(0x14000000), blurRadius: 4)] : null), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: TextStyle(color: selected ? Colors.white : _rMuted, fontSize: 12, fontWeight: FontWeight.w600)), const SizedBox(width: 7), Container(width: 18, height: 18, alignment: Alignment.center, decoration: BoxDecoration(color: selected ? _rOrange : const Color(0xFFE3E2E2), shape: BoxShape.circle), child: Text(count, style: TextStyle(color: selected ? Colors.white : _rMuted, fontSize: 10, fontWeight: FontWeight.w700)))]))));
  }

  Widget _rentalCard({required String booking, required String status, required int statusType, required String category, required String name, required String date, required String image, required IconData icon, required String detail, required String totalLabel, required String total, required String primaryAction, String? secondaryAction}) {
    final statusBg = statusType == 0 || statusType == 3 ? _rInk : statusType == 1 ? _rOrange.withOpacity(.14) : statusType == 4 ? const Color(0xFFFCE8E6) : const Color(0xFFEAEAEA);
    final statusFg = statusType == 0 || statusType == 3 ? Colors.white : statusType == 1 ? _rOrange : statusType == 4 ? const Color(0xFFBA1A1A) : _rMuted;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Color(0x09000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('BOOKING', style: TextStyle(color: _rMuted, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600)),
            const SizedBox(width: 6),
            Text(booking, style: const TextStyle(color: _rInk, fontSize: 10, fontWeight: FontWeight.w700, fontFamily: 'monospace')),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                if (statusType != 0)
                  Icon(statusType == 1 ? Icons.verified : statusType == 2 ? Icons.hourglass_top : statusType == 3 ? Icons.check : Icons.close, size: 13, color: statusFg)
                else
                  Container(width: 7, height: 7, decoration: const BoxDecoration(color: _rOrange, shape: BoxShape.circle)),
                if (statusType != 0) const SizedBox(width: 4),
                Text(status, style: TextStyle(color: statusFg, fontSize: 9, fontWeight: FontWeight.w600)),
              ]),
            ),
          ]),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 78,
                  height: 78,
                  child: Image.asset(image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback(icon)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _rMuted, fontSize: 9, letterSpacing: .4, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _rInk, fontSize: 13, height: 1.25, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.calendar_today, size: 13, color: _rOrange),
                      const SizedBox(width: 5),
                      Expanded(child: Text(date, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _rMuted, fontSize: 10))),
                    ]),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(9)),
            child: Row(children: [
              Icon(statusType == 0 ? Icons.schedule : statusType == 3 ? Icons.star : statusType == 4 ? Icons.assignment_return : Icons.storefront, size: 17, color: statusType == 0 || statusType == 3 ? _rOrange : _rMuted),
              const SizedBox(width: 7),
              Expanded(child: Text(detail, maxLines: 2, style: TextStyle(color: statusType == 2 ? _rMuted : _rInk, fontSize: 10, fontWeight: FontWeight.w500))),
              const SizedBox(width: 4),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(totalLabel, style: const TextStyle(color: _rMuted, fontSize: 9)),
                const SizedBox(height: 2),
                Text(total, style: const TextStyle(color: _rInk, fontSize: 14, fontWeight: FontWeight.w800)),
              ]),
            ]),
          ),
          const SizedBox(height: 10),
          Row(children: [
            if (secondaryAction != null) ...[
              Expanded(child: _actionButton(secondaryAction, secondaryAction == 'Return Info' ? Icons.assignment_return : null, false, booking)),
              const SizedBox(width: 8),
            ],
            Expanded(child: _actionButton(primaryAction, primaryAction == 'Rent Again' ? Icons.replay : null, statusType == 0 || statusType == 1 || primaryAction == 'Rent Again', booking)),
          ]),
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData? icon, bool strong, String booking) => SizedBox(height: 38, child: OutlinedButton(onPressed: () {
    if (label == 'View Details' && booking == 'GR-00124') {
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => const RentalDetailsPage()));
    } else {
      _notice('$label • $booking');
    }
  }, style: OutlinedButton.styleFrom(backgroundColor: strong ? (label == 'Rent Again' ? _rOrange : _rInk) : const Color(0xFFEAEAEA), foregroundColor: strong ? Colors.white : (label == 'Cancel Booking' ? const Color(0xFFBA1A1A) : _rInk), side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 7), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [if (icon != null) ...[Icon(icon, size: 15), const SizedBox(width: 4)], Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))), if (label == 'View Details') const Icon(Icons.arrow_forward, size: 14)])));

  Widget _fallback(IconData icon) => Container(color: const Color(0xFFEAEAEA), child: Center(child: Icon(icon, color: const Color(0xFF887364), size: 36)));

  void _notice(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
