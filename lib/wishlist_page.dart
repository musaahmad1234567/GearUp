import 'package:flutter/material.dart';

const _ink = Color(0xFF252525);
const _muted = Color(0xFF777777);
const _orange = Color(0xFFF28C28);
const _page = Color(0xFFF7F7F7);

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  String _filter = 'all';
  bool _forceEmpty = false;
  final Set<String> _removed = {};

  static const _products = <_WishlistProduct>[
    _WishlistProduct('tent', 'MSR Hubba Hubba 2P Tent', 'Shelter', '5.0', '112', 'Rp50.000', Icons.park_outlined, 'assets/images/tent.jpg'),
    _WishlistProduct('pack', "Arc'teryx Bora 65L Alpine", 'Backpacks', '4.9', '128', 'Rp35.000', Icons.backpack_outlined, 'assets/images/backpack.jpg'),
    _WishlistProduct('shoes', 'Salomon Quest 4D Shoes', 'Footwear', '4.8', '86', 'Rp30.000', Icons.hiking_outlined, 'assets/images/boots.jpg'),
    _WishlistProduct('bag', 'Alpine Sleeping Bag', 'Sleep System', '4.9', '104', 'Rp28.000', Icons.bed_outlined, 'assets/images/sleepingbag.jpg'),
    _WishlistProduct('cookware', 'Titanium Camp Cookware', 'Cookware', '4.8', '88', 'Rp18.000', Icons.outdoor_grill_outlined, 'assets/images/cookware.jpg'),
    _WishlistProduct('jacket', 'Alpha SV Technical Shell', 'Apparel', '4.9', '94', 'Rp35.000', Icons.checkroom_outlined, 'assets/images/backpack.jpg', reserved: true),
  ];

  List<_WishlistProduct> get _saved => _products.where((p) => !_removed.contains(p.id)).toList();
  List<_WishlistProduct> get _visible => _saved.where((p) => _filter == 'all' || !p.reserved).toList();

  @override
  Widget build(BuildContext context) {
    final saved = _saved;
    final showEmpty = _forceEmpty || saved.isEmpty;
    return Scaffold(
      backgroundColor: _page,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        titleSpacing: 16,
        title: Row(children: [
          const Icon(Icons.landscape, color: _orange, size: 28),
          const SizedBox(width: 9),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('GEARUP', style: TextStyle(fontSize: 10, color: _muted, letterSpacing: 1.2, fontWeight: FontWeight.w700)),
            Text('Wishlist', style: TextStyle(fontSize: 16, color: _ink, fontWeight: FontWeight.w700)),
          ]),
        ]),
        actions: [
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Search equipment from Explore.'))), icon: const Icon(Icons.search, color: _ink)),
          IconButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications.'))), icon: const Icon(Icons.notifications_none, color: _ink)),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(children: [
              Row(children: [
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('My Wishlist', style: TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w700)),
                  SizedBox(height: 3),
                  Text('Your favorite outdoor equipment.', style: TextStyle(color: _muted, fontSize: 12)),
                ])),
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7), decoration: BoxDecoration(color: const Color(0xFFF0F0F0), borderRadius: BorderRadius.circular(30)), child: Text('${saved.length} Items', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
              ]),
              const SizedBox(height: 14),
              Row(children: [
                _filterChip('All Saved (${saved.length})', 'all'),
                const SizedBox(width: 8),
                _filterChip('Available (${saved.where((p) => !p.reserved).length})', 'available'),
                const Spacer(),
                InkWell(onTap: () => setState(() => _forceEmpty = !_forceEmpty), borderRadius: BorderRadius.circular(20), child: const Padding(padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7), child: Icon(Icons.visibility_outlined, size: 18, color: _muted))),
              ]),
            ]),
          ),
          Expanded(
            child: showEmpty ? _emptyState() : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: .58),
              itemCount: _visible.length,
              itemBuilder: (context, index) => _productCard(_visible[index]),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final active = _filter == value;
    return InkWell(onTap: () => setState(() => _filter = value), borderRadius: BorderRadius.circular(24), child: Container(padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8), decoration: BoxDecoration(color: active ? _ink : const Color(0xFFEAEAEA), borderRadius: BorderRadius.circular(24)), child: Text(label, style: TextStyle(color: active ? Colors.white : _muted, fontSize: 10, fontWeight: FontWeight.w600))));
  }

  Widget _productCard(_WishlistProduct product) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 6, offset: Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(10), child: Stack(fit: StackFit.expand, children: [
        Image.asset(product.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _imageFallback(product.icon)),
        Positioned(top: 7, right: 7, child: Material(color: Colors.white.withOpacity(.93), shape: const CircleBorder(), child: InkWell(customBorder: const CircleBorder(), onTap: () => setState(() => _removed.add(product.id)), child: const Padding(padding: EdgeInsets.all(7), child: Icon(Icons.favorite, size: 17, color: _orange))))),
        Positioned(left: 7, bottom: 7, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: product.reserved ? const Color(0xFFEAEAEA) : _ink.withOpacity(.85), borderRadius: BorderRadius.circular(20)), child: Text(product.reserved ? 'Reserved' : 'Available', style: TextStyle(color: product.reserved ? _ink : Colors.white, fontSize: 9, fontWeight: FontWeight.w600)))),
      ]))),
      const SizedBox(height: 8),
      Text(product.category.toUpperCase(), style: const TextStyle(color: _muted, fontSize: 9, letterSpacing: .7, fontWeight: FontWeight.w600)),
      const SizedBox(height: 3),
      Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _ink, fontSize: 12, fontWeight: FontWeight.w600)),
      const SizedBox(height: 4),
      Row(children: [const Icon(Icons.star, color: _orange, size: 14), const SizedBox(width: 3), Text(product.rating, style: const TextStyle(color: _ink, fontSize: 10, fontWeight: FontWeight.w700)), const SizedBox(width: 4), Text('(${product.reviews})', style: const TextStyle(color: _muted, fontSize: 10))]),
      const SizedBox(height: 7),
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(child: Text(product.price, maxLines: 1, style: const TextStyle(color: _ink, fontSize: 14, fontWeight: FontWeight.w800))), const Text('/day', style: TextStyle(color: _muted, fontSize: 10))]),
      const SizedBox(height: 7),
      SizedBox(width: double.infinity, height: 34, child: FilledButton(onPressed: product.reserved ? null : () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${product.name} siap disewa.'))), style: FilledButton.styleFrom(backgroundColor: product.reserved ? const Color(0xFFEAEAEA) : _orange, foregroundColor: product.reserved ? _ink : Colors.white, disabledBackgroundColor: const Color(0xFFEAEAEA), disabledForegroundColor: _ink, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), child: Text(product.reserved ? 'Waitlist' : 'Rent Now', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)))),
    ]),
  );

  Widget _imageFallback(IconData icon) => Container(color: const Color(0xFFEAEAEA), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 48, color: const Color(0xFF887364)), const SizedBox(height: 6), const Text('GEARUP', style: TextStyle(color: _muted, fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w700))])));

  Widget _emptyState() => Center(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 104, height: 104, decoration: BoxDecoration(color: const Color(0xFFEAEAEA), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 8)), child: const Icon(Icons.favorite_border, size: 42, color: _orange)),
    const SizedBox(height: 20),
    const Text('Your Wishlist is Empty', style: TextStyle(color: _ink, fontSize: 20, fontWeight: FontWeight.w700)),
    const SizedBox(height: 8),
    const Text('Save your favorite equipment here to easily rent them later for your next backcountry trek.', textAlign: TextAlign.center, style: TextStyle(color: _muted, height: 1.5)),
    const SizedBox(height: 20),
    FilledButton.icon(onPressed: () => setState(() { _forceEmpty = false; _removed.clear(); _filter = 'all'; }), icon: const Icon(Icons.arrow_forward, size: 18), label: const Text('Explore Equipment'), style: FilledButton.styleFrom(backgroundColor: _orange, foregroundColor: Colors.white)),
  ])));
}

class _WishlistProduct {
  const _WishlistProduct(this.id, this.name, this.category, this.rating, this.reviews, this.price, this.icon, this.image, {this.reserved = false});
  final String id, name, category, rating, reviews, price, image;
  final IconData icon;
  final bool reserved;
}
