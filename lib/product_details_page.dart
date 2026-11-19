import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.name, required this.category, required this.price, required this.rating, required this.reviews, required this.image, required this.icon});

  final String name, category, price, rating, reviews, image;
  final IconData icon;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFFBF9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFFBF9F9),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1B1C1C)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              const Icon(Icons.landscape, color: Color(0xFFF28C28), size: 23),
              const SizedBox(width: 7),
              const Text('GEARUP', style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 14, fontWeight: FontWeight.w800)),
              const Spacer(),
              const Text('Product Details', style: TextStyle(color: Color(0xFF1B1C1C), fontSize: 14, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stack) => Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFBF9F9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.outdoor_grill, size: 60, color: Color(0xFF454545)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFF28C28), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    widget.rating,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C)),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '(${widget.reviews} reviews)',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF454545)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF1B1C1C)),
              ),
              const SizedBox(height: 8),
              Text(
                widget.category,
                style: const TextStyle(fontSize: 14, color: Color(0xFF454545)),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1C1C),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      widget.price,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Per day',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.access_time, color: Color(0xFF454545), size: 18),
                  const SizedBox(width: 8),
                  const Text(
                    '24-hour pickup available at Basecamp Station',
                    style: TextStyle(fontSize: 14, color: Color(0xFF454545)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF28C28),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check, color: Color(0xFFF28C28)),
                          SizedBox(width: 8),
                          Text('Gear reserved! Added to rental bag.'),
                        ],
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Rent Now',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      );
}
