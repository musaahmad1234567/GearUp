import 'package:flutter/material.dart';

const _filterInk = Color(0xFF252525);
const _filterMuted = Color(0xFF454545);
const _filterOrange = Color(0xFFF28C28);
const _filterBg = Color(0xFFF7F7F7);

class FilterSettings {
  const FilterSettings({
    this.sort = 'Recommended',
    this.minPrice = 10000,
    this.maxPrice = 75000,
    this.categories = const ['Backpacks', 'Jackets'],
    this.availableImmediately = true,
    this.alpineCertified = true,
    this.superhostGear = false,
  });

  final String sort;
  final double minPrice;
  final double maxPrice;
  final List<String> categories;
  final bool availableImmediately;
  final bool alpineCertified;
  final bool superhostGear;

  int get estimatedCount {
    if (categories.isEmpty) return 24;
    var count = categories.length * 9;
    if (maxPrice <= 25000) count = (count * .55).round();
    if (!availableImmediately) count += 3;
    if (superhostGear) count = (count * .65).round();
    return count.clamp(0, 54).toInt();
  }
}

class FilterSortPage extends StatefulWidget {
  const FilterSortPage({super.key, this.initial = const FilterSettings()});

  final FilterSettings initial;

  @override
  State<FilterSortPage> createState() => _FilterSortPageState();
}

class _FilterSortPageState extends State<FilterSortPage> {
  static const _sortOptions = [
    'Recommended',
    'Lowest Price',
    'Highest Price',
    'Highest Rating',
    'Most Popular',
  ];
  static const _categories = [
    'Backpacks',
    'Jackets',
    'Shoes',
    'Tents',
    'Camping Equipment',
    'Accessories',
  ];

  late String _sort;
  late RangeValues _priceRange;
  late Set<String> _selectedCategories;
  late bool _availableImmediately;
  late bool _alpineCertified;
  late bool _superhostGear;
  String? _selectedPricePill = 'Rp25.000 - Rp50.000';

  @override
  void initState() {
    super.initState();
    final value = widget.initial;
    _sort = value.sort;
    _priceRange = RangeValues(value.minPrice, value.maxPrice);
    _selectedCategories = value.categories.toSet();
    _availableImmediately = value.availableImmediately;
    _alpineCertified = value.alpineCertified;
    _superhostGear = value.superhostGear;
  }

  FilterSettings get _settings => FilterSettings(
    sort: _sort,
    minPrice: _priceRange.start,
    maxPrice: _priceRange.end,
    categories: _categories.where(_selectedCategories.contains).toList(),
    availableImmediately: _availableImmediately,
    alpineCertified: _alpineCertified,
    superhostGear: _superhostGear,
  );

  void _reset() => setState(() {
    _sort = 'Recommended';
    _priceRange = const RangeValues(10000, 75000);
    _selectedCategories = {'Backpacks', 'Jackets'};
    _availableImmediately = true;
    _alpineCertified = true;
    _superhostGear = false;
    _selectedPricePill = 'Rp25.000 - Rp50.000';
  });

  void _setQuickPrice(String value) {
    setState(() {
      _selectedPricePill = value;
      switch (value) {
        case '< Rp25.000':
          _priceRange = const RangeValues(0, 25000);
          break;
        case 'Rp25.000 - Rp50.000':
          _priceRange = const RangeValues(25000, 50000);
          break;
        case '> Rp50.000':
          _priceRange = const RangeValues(50000, 100000);
          break;
      }
    });
  }

  String _formatPrice(double value) {
    final number = value.round().toString();
    final output = StringBuffer();
    for (var i = 0; i < number.length; i++) {
      if (i > 0 && (number.length - i) % 3 == 0) output.write('.');
      output.write(number[i]);
    }
    return 'Rp $output';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _filterBg,
    body: SafeArea(
      child: Column(
        children: [
          _topHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3E2E2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 12),
                    child: Row(
                      children: [
                        IconButton.filledTonal(
                          tooltip: 'Close Filter',
                          onPressed: () => Navigator.of(context).maybePop(),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFEFEFEF),
                            foregroundColor: _filterInk,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          icon: const Icon(Icons.close, size: 19),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Filter & Sort',
                              style: TextStyle(
                                color: _filterInk,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: _reset,
                          child: const Text(
                            'Reset All',
                            style: TextStyle(color: _filterMuted, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _sortSection(),
                  const SizedBox(height: 23),
                  _priceSection(),
                  const SizedBox(height: 23),
                  _categorySection(),
                  const SizedBox(height: 23),
                  _standardsSection(),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEDED),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.sanitizer_outlined,
                          color: _filterOrange,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'All rented gear sanitized & weather-tested prior to release.',
                            style: TextStyle(color: _filterInk, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _reset,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFEFEDED),
                    foregroundColor: _filterInk,
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(_settings),
                  style: FilledButton.styleFrom(
                    backgroundColor: _filterOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: Text(
                    'Apply Filters (${_settings.estimatedCount} Items)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _topHeader() => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.95),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Go back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: _filterInk),
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GEARUP',
                style: TextStyle(
                  color: _filterMuted,
                  fontSize: 9,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Filter & Sort',
                style: TextStyle(
                  color: _filterInk,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: _reset,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEFEDED),
            foregroundColor: _filterInk,
          ),
          icon: const Icon(Icons.tune, size: 19),
        ),
      ],
    ),
  );

  Widget _sectionTitle(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: _filterInk,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 2),
      Text(subtitle, style: const TextStyle(color: _filterMuted, fontSize: 11)),
    ],
  );

  Widget _sortSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Sort By', 'Choose how to view gear'),
      const SizedBox(height: 10),
      ..._sortOptions.map((option) {
        final selected = _sort == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => setState(() => _sort = option),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        color: selected ? _filterInk : _filterMuted,
                        fontSize: 14,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: selected ? _filterOrange : const Color(0xFFE3E2E2),
                      shape: BoxShape.circle,
                    ),
                    child: selected
                        ? const Center(
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    ],
  );

  Widget _priceSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: _sectionTitle(
              'Price Range (Per Day)',
              'Indonesian Rupiah (IDR)',
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE5D0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'IDR / 24h',
              style: TextStyle(
                color: _filterOrange,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _priceBox('Min Price', _formatPrice(_priceRange.start)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _priceBox('Max Price', _formatPrice(_priceRange.end)),
          ),
        ],
      ),
      RangeSlider(
        values: _priceRange,
        min: 0,
        max: 100000,
        divisions: 20,
        activeColor: _filterOrange,
        inactiveColor: const Color(0xFFE3E2E2),
        labels: RangeLabels(
          _formatPrice(_priceRange.start),
          _formatPrice(_priceRange.end),
        ),
        onChanged: (value) => setState(() {
          _priceRange = value;
          _selectedPricePill = null;
        }),
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (final pill in [
              '< Rp25.000',
              'Rp25.000 - Rp50.000',
              '> Rp50.000',
            ])
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: ChoiceChip(
                  label: Text(pill),
                  selected: _selectedPricePill == pill,
                  onSelected: (_) => _setQuickPrice(pill),
                  showCheckmark: false,
                  labelStyle: TextStyle(
                    color: _selectedPricePill == pill
                        ? Colors.white
                        : _filterInk,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  backgroundColor: const Color(0xFFEFEFEF),
                  selectedColor: _filterOrange,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
              ),
          ],
        ),
      ),
    ],
  );

  Widget _priceBox(String label, String value) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: const Color(0xFFEFEFEF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _filterMuted, fontSize: 10)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: _filterInk,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );

  Widget _categorySection() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        children: [
          Expanded(
            child: _sectionTitle('Categories', 'Alpine & trail gear types'),
          ),
          Text(
            '${_selectedCategories.length} Selected',
            style: const TextStyle(
              color: _filterMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      const SizedBox(height: 11),
      Wrap(
        spacing: 7,
        runSpacing: 8,
        children: _categories.map((category) {
          final selected = _selectedCategories.contains(category);
          return FilterChip(
            label: Text(category),
            selected: selected,
            onSelected: (value) => setState(() {
              if (value) {
                _selectedCategories.add(category);
              } else {
                _selectedCategories.remove(category);
              }
            }),
            showCheckmark: selected,
            checkmarkColor: Colors.white,
            labelStyle: TextStyle(
              color: selected ? Colors.white : _filterInk,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            backgroundColor: const Color(0xFFEFEFEF),
            selectedColor: _filterInk,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          );
        }).toList(),
      ),
    ],
  );

  Widget _standardsSection() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _sectionTitle('Rental Standards', 'Backcountry readiness & fulfillment'),
      const SizedBox(height: 10),
      _standardToggle(
        'Available Immediately',
        'Instant trailhead pickup ready',
        Icons.bolt,
        _availableImmediately,
        (v) => setState(() => _availableImmediately = v),
        highlighted: true,
      ),
      const SizedBox(height: 7),
      _standardToggle(
        'Alpine Certified',
        'Inspected for sub-zero performance',
        Icons.verified_outlined,
        _alpineCertified,
        (v) => setState(() => _alpineCertified = v),
        highlighted: true,
      ),
      const SizedBox(height: 7),
      _standardToggle(
        'Superhost Gear',
        'Top-rated mountain outfitters',
        Icons.workspace_premium_outlined,
        _superhostGear,
        (v) => setState(() => _superhostGear = v),
      ),
    ],
  );

  Widget _standardToggle(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged, {
    bool highlighted = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFEFEFEF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            icon,
            color: highlighted ? _filterOrange : _filterMuted,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: _filterInk,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: _filterMuted, fontSize: 10),
              ),
            ],
          ),
        ),
        Switch(value: value, activeColor: _filterOrange, onChanged: onChanged),
      ],
    ),
  );
}
