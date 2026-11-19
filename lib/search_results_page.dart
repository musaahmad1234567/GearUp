import 'package:flutter/material.dart';

import 'filter_sort_page.dart';

const _searchInk = Color(0xFF252525);
const _searchMuted = Color(0xFF454545);
const _searchOrange = Color(0xFFF28C28);
const _searchBg = Color(0xFFF7F7F7);

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, this.query = ''});

  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  static const _filters = [
    'All Backpacks',
    '30L - 45L',
    '50L - 70L',
    'Ultralight',
    'Expedition Grade',
  ];

  static const _products = <_SearchGear>[
    _SearchGear(
      'Arc\'teryx',
      'Bora 65L Alpine',
      '4.9',
      84,
      32000,
      65,
      'Expedition',
      true,
      false,
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBCb7vMGtronr-Cyw6aHuGvIfRRNlu0b1XVxchxMolL4X4Zz5vwhkeEviUD1_PqHcmbw_t0ohGh6_UdHyfNIvrUchwKiotvYHEQEx3u1gxwrBs9S2fKDTFffWOK_1Z-YHJXRy0KjStMZgHgFoGm3QLB2WZDEfbTzPRUAq1yzzqtKqJxt0cP5k0IWPrquPgrtQSaK8OknBA6zQFm6NxbxYR-eZytVj984IBen_8X87o',
    ),
    _SearchGear(
      'Osprey',
      'Atmos AG 50L',
      '4.9',
      128,
      25000,
      50,
      'Popular',
      false,
      false,
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCuRt416I05o7NWzVnqSe194-ICNFEniZ-IVJbDLBhc8sEXimvSR-QqeENVplqVebM0Gk8OwG8UW4HEIac8QGaqZsloSp4lH7V4HfS2huEpgsaZW51F3WziCajD0HTOpXnlMe95XaJUJKzueddsvsh2lWff-4vudQ0C1bFlaIih6COPphe7hhbFqjoe2Gn1a7bcRLhM6zT5H4hU4oybcD2gqJwvSHBeLK26IDWKGao',
    ),
    _SearchGear(
      'Hyperlite',
      'Windrider 40L',
      '5.0',
      42,
      38000,
      40,
      'Ultralight',
      false,
      true,
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDizIDIFCPhD8ITLIiGn8tC2rx6iFeQjxhpBTa3wtAxlWCsVxX9TwRsC8KnLSFPfujdxgrT1clnP8fMU1YatGsXmJBFpLtBdpH6vDNliEUfWr9KAGyJ-6aoxbIn-8JwePg0IVAJIbDY7_sy0qM5DTsNhAYkPDKak1ZWY_NCAxzCBNG2cZf6XkKNpCbr2x7WmZ5tKeQle_I0my2RWFWVJ1vQNs3rGJgJgV8GFg7nHYA',
    ),
    _SearchGear(
      'Deuter',
      'Aircontact 60L',
      '4.8',
      56,
      26000,
      60,
      'Field Tested',
      true,
      false,
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCuRt416I05o7NWzVnqSe194-ICNFEniZ-IVJbDLBhc8sEXimvSR-QqeENVplqVebM0Gk8OwG8UW4HEIac8QGaqZsloSp4lH7V4HfS2huEpgsaZW51F3WziCajD0HTOpXnlMe95XaJUJKzueddsvsh2lWff-4vudQ0C1bFlaIih6COPphe7hhbFqjoe2Gn1a7bcRLhM6zT5H4hU4oybcD2gqJwvSHBeLK26IDWKGao',
    ),
    _SearchGear(
      'Black Diamond',
      'Creek 35L Alpine',
      '4.7',
      38,
      22000,
      35,
      'Weatherproof',
      false,
      false,
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDDjBcULhscIE5afLBv_aUe8pBUwav0UEN1q4dk7MBxcF_rMOz2a8pX8nyNUDLatpldo9ql4-7A3Px3Z1w2xrHGeuSPlcdoNQQMYXRtbu7ao7X95TA9TFDwdsvSpezFDx44noAaagw7bAU9Hoda5G_xGjrAhQE6ejYfguDED2eLx7diSSoSaMoOcxAElrb1VboXgJWIqqpq8QUXV4w0pVce32j5I-fyuQTOgyZcJJ8',
    ),
    _SearchGear(
      'Gregory',
      'Baltoro 75L Hauler',
      '4.8',
      61,
      35000,
      75,
      'Heavy Load',
      true,
      false,
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuC9UQkyAhYwoDn6VoALQNyvcdzU5i_DGCOcT6tMYd4BrbS_U0acUCsa8_lR2dFLQcNJV9Z9CoOngPYSafaF0rodTEmFpYuWjDL85SMLey5jqB4GPKSjO6xxxKfhutuCgytUxX4OA3UgYYfcPcMrB1xTiA6LGdcoI_Xq9bt_dbQ4RDhPGe5UGdrZOF3qMFKVN6UcbrVzYz4qBqOH8MCi7D2DL7-FFzjGYcJRINRHYoc',
    ),
  ];

  late final TextEditingController _controller;
  late String _query;
  final Set<String> _wishlist = {};
  String _filter = 'All Backpacks';
  FilterSettings _settings = const FilterSettings();
  bool _simulateEmpty = false;

  @override
  void initState() {
    super.initState();
    _query = widget.query.trim().isEmpty
        ? 'Hiking Backpack'
        : widget.query.trim();
    _controller = TextEditingController(text: _query);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_SearchGear> get _results {
    final q = _query.toLowerCase().trim();
    final backpackQuery =
        q.isEmpty || q.contains('backpack') || q.contains('hiking');
    final list = _products.where((item) {
      final queryMatch =
          backpackQuery ||
          '${item.brand} ${item.name} ${item.badge}'.toLowerCase().contains(q);
      final filterMatch = switch (_filter) {
        '30L - 45L' => item.liters >= 30 && item.liters <= 45,
        '50L - 70L' => item.liters >= 50 && item.liters <= 70,
        'Ultralight' => item.ultralight,
        'Expedition Grade' => item.expedition,
        _ => true,
      };
      final priceMatch =
          item.price >= _settings.minPrice && item.price <= _settings.maxPrice;
      final categoryMatch =
          _settings.categories.isEmpty ||
          _settings.categories.contains('Backpacks');
      return queryMatch && filterMatch && priceMatch && categoryMatch;
    }).toList();
    switch (_settings.sort) {
      case 'Lowest Price':
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Highest Price':
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Highest Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Most Popular':
        list.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }
    return list;
  }

  bool get _empty => _simulateEmpty || _results.isEmpty;

  void _setQuery(String value) {
    setState(() {
      _query = value.trim();
      _simulateEmpty = false;
    });
  }

  void _clearQuery() {
    _controller.clear();
    setState(() {
      _query = '';
      _simulateEmpty = true;
      _filter = 'All Backpacks';
    });
  }

  void _resetSearch() {
    const defaultQuery = 'Hiking Backpack';
    _controller.text = defaultQuery;
    setState(() {
      _query = defaultQuery;
      _filter = 'All Backpacks';
      _simulateEmpty = false;
    });
  }

  Future<void> _openFilterSort() async {
    final result = await Navigator.of(context).push<FilterSettings>(
      MaterialPageRoute<FilterSettings>(
        builder: (_) => FilterSortPage(initial: _settings),
      ),
    );
    if (result != null && mounted) setState(() => _settings = result);
  }

  void _toast(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _searchBg,
    body: SafeArea(
      child: Column(
        children: [
          _appBar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _searchContext()),
                if (!_empty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    sliver: SliverGrid.builder(
                      itemCount: _results.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: .66,
                          ),
                      itemBuilder: (context, index) =>
                          _productCard(_results[index]),
                    ),
                  )
                else
                  SliverToBoxAdapter(child: _emptyState()),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _appBar() => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.94),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Go back',
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: _searchInk),
        ),
        const SizedBox(width: 2),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GEARUP',
                style: TextStyle(
                  color: _searchMuted,
                  fontSize: 9,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Search Results',
                style: TextStyle(
                  color: _searchInk,
                  fontSize: 19,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'Filter & Sort',
          onPressed: _openFilterSort,
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEFEDED),
            foregroundColor: _searchInk,
          ),
          icon: const Icon(Icons.tune, size: 20),
        ),
      ],
    ),
  );

  Widget _searchContext() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: const [
              BoxShadow(color: Color(0x0A000000), blurRadius: 7),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: _searchMuted, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: _searchInk, fontSize: 14),
                  onChanged: _setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Search alpine packs, tents...',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Clear search query',
                onPressed: _clearQuery,
                icon: const Icon(Icons.close, size: 17),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFEFEDED),
                  minimumSize: const Size(25, 25),
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 13),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Found ${_empty ? 0 : _results.length} results',
                    style: const TextStyle(
                      color: _searchInk,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Matched with outdoor gear inventory',
                    style: TextStyle(color: _searchMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => setState(() => _simulateEmpty = !_simulateEmpty),
              icon: const Icon(Icons.tune, size: 15),
              label: Text(
                _simulateEmpty
                    ? 'Show Results (${_results.length})'
                    : 'Simulate Empty',
                style: const TextStyle(fontSize: 10),
              ),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEFEDED),
                foregroundColor: _searchInk,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 39,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            separatorBuilder: (_, __) => const SizedBox(width: 7),
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final selected = filter == _filter;
              return ChoiceChip(
                label: Text(filter),
                selected: selected,
                onSelected: (_) => setState(() {
                  _filter = filter;
                  _simulateEmpty = false;
                }),
                showCheckmark: false,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : _searchInk,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                backgroundColor: Colors.white,
                selectedColor: _searchInk,
                side: BorderSide.none,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              );
            },
          ),
        ),
        const SizedBox(height: 2),
      ],
    ),
  );

  Widget _productCard(_SearchGear item) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(13),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 7)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEAEAEA),
                  child: Center(
                    child: Icon(item.icon, color: _searchMuted, size: 42),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _searchInk.withOpacity(.86),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Material(
                  color: Colors.white.withOpacity(.93),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() {
                      if (!_wishlist.add(item.name))
                        _wishlist.remove(item.name);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        _wishlist.contains(item.name)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _wishlist.contains(item.name)
                            ? _searchOrange
                            : _searchInk,
                        size: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.brand.toUpperCase(),
                style: const TextStyle(
                  color: _searchMuted,
                  fontSize: 9,
                  letterSpacing: .8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _searchInk,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: _searchOrange, size: 15),
                  const SizedBox(width: 3),
                  Text(
                    item.rating,
                    style: const TextStyle(
                      color: _searchInk,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${item.reviews})',
                    style: const TextStyle(color: _searchMuted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: _searchInk,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(text: 'Rp${_formatPrice(item.price)}'),
                    const TextSpan(
                      text: '/day',
                      style: TextStyle(
                        color: _searchMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  String _formatPrice(int price) {
    final value = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      if (i != 0 && (value.length - i) % 3 == 0) buffer.write('.');
      buffer.write(value[i]);
    }
    return buffer.toString();
  }

  Widget _emptyState() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
    child: Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              color: Color(0xFFEFEDED),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.backpack_outlined,
              color: _searchMuted,
              size: 38,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No Gear Found',
            style: TextStyle(
              color: _searchInk,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            "We couldn't find any equipment matching your search. Try adjusting keywords or clearing active filters.",
            textAlign: TextAlign.center,
            style: TextStyle(color: _searchMuted, fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: FilledButton(
              onPressed: _resetSearch,
              style: FilledButton.styleFrom(
                backgroundColor: _searchOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: const Text('Clear Search & Reset'),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Try popular searches:',
            style: TextStyle(
              color: _searchMuted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 6,
            children: [
              _suggestion('Tents'),
              _suggestion('Sleeping Bags'),
              _suggestion('Alpine Boots'),
            ],
          ),
        ],
      ),
    ),
  );

  Widget _suggestion(String text) => ActionChip(
    label: Text(text),
    onPressed: () {
      _controller.text = text;
      _setQuery(text);
    },
  );
}

class _SearchGear {
  const _SearchGear(
    this.brand,
    this.name,
    this.rating,
    this.reviews,
    this.price,
    this.liters,
    this.badge,
    this.expedition,
    this.ultralight,
    this.icon,
    this.image,
  );
  final String brand;
  final String name;
  final String rating;
  final int reviews;
  final int price;
  final int liters;
  final String badge;
  final bool expedition;
  final bool ultralight;
  final IconData icon;
  final String image;
}
