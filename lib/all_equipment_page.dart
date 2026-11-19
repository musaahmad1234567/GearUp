import 'package:flutter/material.dart';
import 'product_details_page.dart';

class AllEquipmentPage extends StatelessWidget {
  const AllEquipmentPage({super.key, required this.account});

  final dynamic account;

  static const _products = <_AllProduct>[
    _AllProduct('Hiking Backpack', 'Backpacks', 'Rp25.000', 4.9, 128, 'assets/images/backpack.jpg'),
    _AllProduct('Outdoor Jacket', 'Apparel', 'Rp35.000', 4.9, 94, 'assets/images/helmet.jpg'),
    _AllProduct('Hiking Shoes', 'Footwear', 'Rp30.000', 4.8, 86, 'assets/images/boots.jpg'),
    _AllProduct('Camping Tent', 'Shelter', 'Rp50.000', 5.0, 112, 'assets/images/tent.jpg'),
    _AllProduct('Sleeping Bag', 'Sleeping', 'Rp28.000', 4.9, 78, 'assets/images/sleepingbag.jpg'),
    _AllProduct('Camping Cookware', 'Camping', 'Rp18.000', 4.8, 65, 'assets/images/cookware.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBF9F9),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C1C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'All Equipment',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C)),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFFBF9F9),
      body: _buildProductGrid(context),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return _allGearCard(context, product);
        },
      ),
    );
  }

  Widget _allGearCard(BuildContext context, _AllProduct p) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(
              name: p.name,
              category: p.category,
              price: p.price,
              rating: p.rating.toString(),
              reviews: p.reviews.toString(),
              image: p.imagePath,
              icon: Icons.outdoor_grill,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFBF9F9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF9F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  p.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF9F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.outdoor_grill, size: 40, color: Color(0xFF454545)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFF28C28), size: 14),
                const SizedBox(width: 4),
                Text(
                  p.rating.toString(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1B1C1C),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${p.reviews})',
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF454545),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              p.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1B1C1C),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              p.price,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFFF28C28),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B1C1C),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(
                        name: p.name,
                        category: p.category,
                        price: p.price,
                        rating: p.rating.toString(),
                        reviews: p.reviews.toString(),
                        image: p.imagePath,
                        icon: Icons.outdoor_grill,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Rent',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AllProduct {
  final String name;
  final String category;
  final String price;
  final double rating;
  final int reviews;
  final String imagePath;

  const _AllProduct(this.name, this.category, this.price, this.rating, this.reviews, this.imagePath);
}
