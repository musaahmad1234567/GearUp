import 'package:flutter/material.dart';
import 'account_store.dart';
import 'explore_page.dart';
import 'wishlist_page.dart';
import 'my_rental_page.dart';
import 'profile_page.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key, required this.account});
  final LocalAccount account;
  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeaderContent(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _searchBar(),
                    const SizedBox(height: 20),
                    _heroBanner(),
                    const SizedBox(height: 24),
                    _categories(),
                    const SizedBox(height: 24),
                    _popularEquipment(),
                    const SizedBox(height: 24),
                    _recommendedForYou(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GEARUP', style: TextStyle(fontSize: 9, letterSpacing: 1.2, fontWeight: FontWeight.w700, color: Color(0xFF454545))),
              const SizedBox(height: 4),
              Text('Ready for your next adventure?', style: TextStyle(fontSize: 15, height: 1.2, fontWeight: FontWeight.w500, color: Color(0xFF1B1C1C))),
            ],
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => _toast('You have 2 rental pickup reminders!'),
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1B1C1C)),
          ),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFF28C28),
            child: Text(widget.account.name.isEmpty ? '?' : widget.account.name[0].toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF454545), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(hintText: 'Search outdoor equipment...', border: InputBorder.none, focusedBorder: InputBorder.none, errorBorder: InputBorder.none, disabledBorder: InputBorder.none, contentPadding: EdgeInsets.zero),
                style: const TextStyle(color: Color(0xFF1B1C1C)),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Color(0xFFFBF9F9), borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12))),
              child: IconButton(tooltip: 'Filter', onPressed: () => _toast('Opening Expedition Filter...'), icon: const Icon(Icons.tune, color: Color(0xFF454545), size: 20)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B1C1C),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFF28C28), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('Premium Rentals', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFF28C28))),
                    ]),
                    const SizedBox(height: 12),
                    const Text('Gear Up. Explore More.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFFFFFFF), height: 1.2)),
                    const SizedBox(height: 8),
                    const Text('Find the right gear for your adventure.', style: TextStyle(fontSize: 14, color: Color(0xFF454545))),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF28C28),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ExplorePage(account: LocalAccount(name: 'Guest', email: 'guest@example.com', phone: '08123456789', password: 'password')),
                            ),
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Explore Now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                            SizedBox(width: 6),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F9),
                borderRadius: const BorderRadius.only(topRight: Radius.circular(16), bottomRight: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(4, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                child: Image.asset(
                  'assets/images/helmet.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    width: 120,
                    height: 120,
                    color: const Color(0xFFFBF9F9),
                    child: const Center(child: Icon(Icons.terrain, size: 40, color: Color(0xFF454545))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categories() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Categories', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
        Text('6 Categories', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: const Color(0xFFF28C28))),
      ]),
      const SizedBox(height: 8),
      GridView.count(crossAxisCount: 3, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 8, mainAxisSpacing: 8, children: [
        _categoryChip('Backpacks', Icons.shopping_bag),
        _categoryChip('Jackets', Icons.layers),
        _categoryChip('Footwear', Icons.directions_run),
        _categoryChip('Tents', Icons.ac_unit),
        _categoryChip('Sleep Bags', Icons.bed),
        _categoryChip('Accessories', Icons.explore),
      ]),
    ]));
  }

  Widget _categoryChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => _toast('Showing $label products...'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9F9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F9),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Icon(icon, color: const Color(0xFF454545), size: 22),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
          ],
        ),
      ),
    );
  }

  Widget _popularEquipment() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Popular Equipment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
        TextButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ExplorePage(account: widget.account)),
          );
        }, child: const Text('See All', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFF28C28)))),
      ]),
      const SizedBox(height: 8),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 8, mainAxisSpacing: 8, children: [
        _gearCard('Hiking Backpack', Icons.shopping_bag, 'Rp25.000', 'Expedition', 4.9, '128', 'assets/images/backpack.jpg'),
        _gearCard('Outdoor Jacket', Icons.layers, 'Rp35.000', 'Waterproof', 4.9, '94', 'assets/images/helmet.jpg'),
        _gearCard('Hiking Shoes', Icons.directions_run, 'Rp30.000', 'Vibram Sole', 4.8, '86', 'assets/images/boots.jpg'),
        _gearCard('Camping Tent', Icons.ac_unit, 'Rp50.000', '3-Season', 5.0, '112', 'assets/images/tent.jpg'),
      ]),
    ]));
  }

  Widget _gearCard(
    String name,
    IconData icon,
    String price,
    String badge,
    double rating,
    String reviews,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFFFBF9F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.outdoor_grill, size: 48, color: Color(0xFF454545)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFBF9F9),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () => _toast('Added to Wishlist!'),
                      icon: const Icon(
                        Icons.favorite,
                        color: Color(0xFF454545),
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1B1C1C),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFF28C28),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, color: Color(0xFFF28C28), size: 14),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1B1C1C),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($reviews)',
                style: const TextStyle(
                  fontSize: 9,
                  color: Color(0xFF454545),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFF28C28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recommendedForYou() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Recommended for You', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
        const Text('Alpine Verified', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF454545))),
      ]),
      const SizedBox(height: 8),
      ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: 2, separatorBuilder: (context, index) => const SizedBox(height: 8), itemBuilder: (context, index) {
        if (index == 0) {
          return _recommendedItem('Ultralight Alpine Sleeping Bag', '850 Fill Down \u2022 -10\u00b0C Rated', 'Rp28.000', 'Ultralight', Icons.bed, 4.9, 'https://lh3.googleusercontent.com/aida-public/AB6AXuDqL7qrO3Xfuc5Q9qL3r_BYR0Lhpv6TaoGQQOYfwbd4Anyd-0ta73nrYuxw_n3ezZ3n6j9h5kuiFTMQ5SWl102b6FzClBeaZ5OBEKlcAgxHYdZejnOHbm4nLrpck1UIMpl3hSVh6MwV-SMnfNlLgEwWzPOOocoT6lj6paNz6lC2blFsw9uzriGztT4wFuW5pjuM8d9Unp6Or1QkCbZrXaxVMIeJJZrt6aakXEIrWEY');
        } else {
          return _recommendedItem('Titanium Camp Cookware & Stove', 'Ultralight Titanium \u2022 Gas Stove', 'Rp18.000', 'Kit', Icons.local_fire_department, 4.8, 'https://lh3.googleusercontent.com/aida/ALJJyrDEEwVV03Ck566eLXTZUh0_F6l0iuo6olqVl4GQz-Ru5ieqv0gFKzxp5W_ez15t_goWcqSgMZsR04ojKTaUYAjAwstjEKq0U8a0vcdiTWFGeLUmF9hHxEikdxR9L0VdNLfn1AXLAbSKVeoDuJcPrgsIJ3CbA5MkZCud6xGwLeksowRB3ULQ-KKcMhR2EwCt18PNNso-nLneci8VMuL9hLY25EWDohsKxHWLi40KwQs');
        }
      }),
    ]));
  }

  Widget _recommendedItem(String name, String subtitle, String price, String badge, IconData icon, double rating, String imageUrl) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Row(children: [
      Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.network(imageUrl, width: 40, height: 40, fit: BoxFit.cover, errorBuilder: (context, error, stack) => Container(width: 40, height: 40, decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.outdoor_grill, size: 20, color: Color(0xFF454545)))),
        const SizedBox(height: 4),
        Text(rating.toString(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFF28C28))),
      ])),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
          Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: const BoxDecoration(color: Color(0xFFFBF9F9), borderRadius: BorderRadius.all(Radius.circular(4))), child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFF28C28)))),
        ]),
        Text(subtitle, style: const TextStyle(fontSize: 9, color: Color(0xFF454545))),
      ])),
      Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(price, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFF28C28))),
        const SizedBox(height: 4),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B1C1C), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: () => _toast('Gear reserved! Added to rental bag.'), child: const Text('Rent', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
      ]),
    ]));
  }

  Widget _bottomNav() {
    const items = <(String, IconData)>[
      ('Home', Icons.cottage_outlined),
      ('Explore', Icons.explore_outlined),
      ('Wishlist', Icons.favorite_border),
      ('My Rental', Icons.backpack_outlined),
      ('Profile', Icons.account_circle_outlined),
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.97),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (i) {
            final selected = i == 0;
            return Expanded(
              child: InkWell(
                onTap: () {
                  if (i == 0) {
                    // Home - stay on home page
                  }
                  if (i == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ExplorePage(account: widget.account)),
                    );
                  }
                  if (i == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => WishlistPage()),
                    );
                  }
                  if (i == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MyRentalPage()),
                    );
                  }
                  if (i == 4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProfilePage(account: widget.account)),
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[i].$2,
                      size: 21,
                      color: selected ? const Color(0xFFF28C28) : const Color(0xFF454545),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$1,
                      style: TextStyle(
                        color: selected ? const Color(0xFFF28C28) : const Color(0xFF454545),
                        fontSize: 9,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (selected)
                      Container(
                        width: 5,
                        height: 5,
                        margin: const EdgeInsets.only(top: 2),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF28C28),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.info, color: Color(0xFFF28C28)), const SizedBox(width: 8), Text(message)]), duration: const Duration(seconds: 3), backgroundColor: const Color(0xFFFBF9F9), behavior: SnackBarBehavior.floating));
  }
}
