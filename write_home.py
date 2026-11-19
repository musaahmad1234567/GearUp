import os
path = 'D:/RPLX/materi.dart/tugas/flutter_application_4/lib/home_page.dart'

content = """import 'package:flutter/material.dart';
import 'account_store.dart';
import 'explore_page.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key, required this.account});
  final LocalAccount account;
  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F9),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 100,
            pinned: true,
            backgroundColor: const Color(0xFFFBF9F9),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeaderContent(),
            ),
          ),
        ],
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 8, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderContent(),
              _searchBar(),
              _promoBanner(),
              _categories(),
              _popularEquipment(),
              _recommendedForYou(),
            ],
          ),
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
              Text('Home', style: TextStyle(fontSize: 16, height: 1.1, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
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

  Widget _promoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: DecoratedBox(
        decoration: const BoxDecoration(color: Color(0xFF1B1C1C), borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFF28C28), shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      const Text('Premium Rentals', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFF28C28))),
                    ]),
                    const Text('Ready for Your Next Adventure?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFFFFFFF))),
                    const Text('Find the right gear for your journey.', style: TextStyle(fontSize: 12, color: Color(0xFF454545))),
                    const SizedBox(height: 12),
                    SizedBox(width: double.infinity, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF28C28), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: () => _toast('Opening Season Expedition collection...'), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text('Explore Gear', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)), SizedBox(width: 4), Icon(Icons.arrow_forward, size: 16)]))),
                  ],
                ),
              ),
            ),
            Container(width: 72, height: 80, decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.network('https://lh3.googleusercontent.com/aida/ALJJyrDUka0ybV-q0JSi8GkLFXQPuw3Mgx8NNpmfielU0FpfhV48vdzrq5YZK94lutHbZtQX0zXQ2ljf3ZbI_nkWluXphCtqOYHqBpcaLIg6QfzDopogrWC4r4WJIx0R9SjmsuEosP6cjAqyAXth6jHW7l1T-SMfSBG4ezHG9i3lL8SKzU3rH5xxOyiSc_HVr8lF8d42vJOKwiqZa9XOqaCVcnpIlETA6KJaVkTLbT_o73ec', width: 48, height: 48, fit: BoxFit.cover),
            ])),
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
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Column(children: [
      Container(width: 40, height: 40, decoration: const BoxDecoration(color: Color(0xFFFBF9F9), borderRadius: BorderRadius.all(Radius.circular(12))), child: Icon(icon, color: const Color(0xFF454545), size: 22)),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
    ]));
  }

  Widget _popularEquipment() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Popular Equipment', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
        TextButton(onPressed: () => _toast('Loading full equipment inventory...'), child: const Text('See All', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFF28C28)))),
      ]),
      const SizedBox(height: 8),
      GridView.count(crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 8, mainAxisSpacing: 8, children: [
        _gearCard('Hiking Backpack', Icons.shopping_bag, 'Rp25.000', 'Expedition', 4.9, '128'),
        _gearCard('Outdoor Jacket', Icons.layers, 'Rp35.000', 'Waterproof', 4.9, '94'),
        _gearCard('Hiking Shoes', Icons.directions_run, 'Rp30.000', 'Vibram Sole', 4.8, '86'),
        _gearCard('Camping Tent', Icons.ac_unit, 'Rp50.000', '3-Season', 5.0, '112'),
      ]),
    ]));
  }

  Widget _gearCard(String name, IconData icon, String price, String badge, double rating, String reviews) {
    return Container(decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(height: 120, decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Stack(children: [
        Image.network('https://lh3.googleusercontent.com/aida/ALJJyrDUka0ybV-q0JSi8GkLFXQPuw3Mgx8NNpmfielU0FpfhV48vdzrq5YZK94lutHbZtQX0zXQ2ljf3ZbI_nkWluXphCtqOYHqBpcaLIg6QfzDopogrWC4r4WJIx0R9SjmsuEosP6cjAqyAXth6jHW7l1T-SMfSBG4ezHG9i3lL8SKzU3rH5xxOyiSc_HVr8lF8d42vJOKwiqZa9XOqaCVcnpIlETA6KJaVkTLbT_o73ec', width: double.infinity, height: 120, fit: BoxFit.cover),
        Positioned(top: 8, right: 8, child: Container(width: 36, height: 36, decoration: const BoxDecoration(color: Color(0xFFFBF9F9), shape: BoxShape.circle), child: IconButton(onPressed: () => _toast('Added to Wishlist!'), icon: const Icon(Icons.favorite, color: Color(0xFF454545), size: 18)))),
        Positioned(bottom: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: const BoxDecoration(color: Color(0xFF1B1C1C), borderRadius: BorderRadius.all(Radius.circular(4))), child: Text(badge, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFFF28C28))))),
      ])),
      const SizedBox(height: 6),
      Row(children: [
        const Icon(Icons.star, color: Color(0xFFF28C28), size: 14),
        const SizedBox(width: 4),
        Text(rating.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C))),
        const SizedBox(width: 4),
        Text('($reviews)', style: const TextStyle(fontSize: 9, color: Color(0xFF454545))),
      ]),
      const SizedBox(height: 4),
      Text(price, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFF28C28))),
    ]));
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
          return _recommendedItem('Ultralight Alpine Sleeping Bag', '850 Fill Down \u2022 -10\u00b0C Rated', 'Rp28.000', 'Ultralight', Icons.bed);
        } else {
          return _recommendedItem('Titanium Camp Cookware & Stove', 'Ultralight Titanium \u2022 Gas Stove', 'Rp18.000', 'Kit', Icons.local_fire_department);
        }
      }),
    ]));
  }

  Widget _recommendedItem(String name, String subtitle, String price, String badge, IconData icon) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Row(children: [
      Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFFFBF9F9), borderRadius: BorderRadius.circular(12)), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: const Color(0xFFF28C28), size: 24),
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
    return BottomNavigationBar(currentIndex: _selectedTab, onTap: (index) { setState(() => _selectedTab = index); }, items: const [
      BottomNavigationBarItem(icon: Icon(Icons.cottage_outlined), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Wishlist'),
      BottomNavigationBarItem(icon: Icon(Icons.room_service_outlined), label: 'My Rental'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
    ], type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFFF28C28), unselectedItemColor: const Color(0xFF454545), backgroundColor: const Color(0xFFFBF9F9), elevation: 8, iconSize: 24);
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [const Icon(Icons.info, color: Color(0xFFF28C28)), const SizedBox(width: 8), Text(message)]), duration: const Duration(seconds: 3), backgroundColor: const Color(0xFFFBF9F9), behavior: SnackBarBehavior.floating));
  }
}
"""

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print('File written successfully')
