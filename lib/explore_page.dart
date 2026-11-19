import 'package:flutter/material.dart';

import 'account_store.dart';
import 'category_products_page.dart';
import 'filter_sort_page.dart';
import 'search_results_page.dart';
import 'my_rental_page.dart';
import 'profile_page.dart';
import 'rental_date_page.dart';
import 'product_details_page.dart';

const _exploreInk = Color(0xFF252525);
const _exploreMuted = Color(0xFF454545);
const _exploreOrange = Color(0xFFF28C28);
const _exploreBg = Color(0xFFF7F7F7);

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key, required this.account});

  final LocalAccount account;

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();
  final Set<String> _wishlist = {};
  String _query = '';
  String _category = 'All';
  FilterSettings _settings = const FilterSettings();
  bool _hasAppliedFilters = false;

  static const _categories = [
    'All',
    'Backpacks',
    'Jackets',
    'Shoes',
    'Tents',
    'Camping',
    'Accessories',
  ];

  static const _products = <_ExploreProduct>[
    _ExploreProduct(
      'Hiking Backpack',
      'Backpacks',
      '4.9',
      128,
      'Rp25.000',
      Icons.backpack_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBCb7vMGtronr-Cyw6aHuGvIfRRNlu0b1XVxchxMolL4X4Zz5vwhkeEviUD1_PqHcmbw_t0ohGh6_UdHyfNIvrUchwKiotvYHEQEx3u1gxwrBs9S2fKDTFffWOK_1Z-YHJXRy0KjStMZgHgFoGm3QLB2WZDEfbTzPRUAq1yzzqtKqJxt0cP5k0IWPrquPgrtQSaK8OknBA6zQFm6NxbxYR-eZytVj984IBen_8X87o',
    ),
    _ExploreProduct(
      'Outdoor Jacket',
      'Apparel',
      '4.9',
      94,
      'Rp35.000',
      Icons.checkroom_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDhRtb-LyAXoAPCwg3UGSsw_tvNgxSVM2bOJZL5AQoCinGV43z0Uu80RlHcNE4Nykt5GIklKvKjXUaw7cuF6mDUTSzeSjGjWkESPXuNbD9RCFTkTppR2I-NOIF0skO3VcKQSd1BJEt6huiCmGNYtoWhJlljnzWg1pYp37t_GzjCRMVyZP7rX_Vj2ZyMRHLzgTqf49puTfC5dvEBgsvgkGtv1RiP3Dpzm4sLL_KR0JA',
    ),
    _ExploreProduct(
      'Hiking Shoes',
      'Footwear',
      '4.8',
      86,
      'Rp30.000',
      Icons.hiking_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBODdp8uBT1WY4rVCaJL0C3opwR2cwHU-8oxL9PALWVG7eaDbd1CCPszdb3WlcNsnlGzUY2eaw0fwvkgY3HsHBcP3hFATm_oJ9VlsPj2gVGcfXW7H3Ly53nBTghmzduggi-5rgcbZbB_6a6jxXscgSMsa_OwCkLDVRd-RvlnVsO_YhVKgspbBnSQaqK9fIDDkF5KoNiVf82bjj3cnba7OAYQDdt-UbaLp8oT5QqeAY',
    ),
    _ExploreProduct(
      'Camping Tent',
      'Shelter',
      '5.0',
      112,
      'Rp50.000',
      Icons.park_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBW4BWJgEdxG4DB83-lyIzRCpfW2czEGUMcld45jiFfaplvQUtIYSKD_RXDl7ouNUqRK3WIECMeM81eDSi_r6pCZpQFCAG0YTvHe1dvHe8EkVOQaLnN_-X2WVEKMVvqQay-dpRi6oCF68FwqdrrbQyUztRrqJdQsrukWkzyu079DkKMDXORrjJpCP7ZydZfReqpk9VVaFUHQTFYfBu0xQWo7CEGpxs4_EeVXAqYaLg',
    ),
    _ExploreProduct(
      'Hydration Pack',
      'Backpacks',
      '4.7',
      42,
      'Rp15.000',
      Icons.water_drop_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAh_rdHgwCi_Qtn-ethjQ9HLuS9VkTsQj-nNNnMIHdzWEBXf0tDdIxEiiEbDy8eYWQOiJJgcflK75MjpBt4KsyRTAfogEhYo2RmzFS-1z0iHw5YzjoctzsuDXw3bqPSPWXNIP2OabMk0sWjx3DkvEY02AlROm7G2Rz2pFFou1fH9u9c10ANOqpEpyzUZvyxzXLnSfuKDfPY73zvvT_iY1pAhB_b5Ir-YxfiPlwd3yc',
    ),
    _ExploreProduct(
      'Hiking Pants',
      'Apparel',
      '4.8',
      65,
      'Rp20.000',
      Icons.dry_cleaning_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDdrusyuSW4OOjzSKfdxwZHbgEXb24VpnWl_Tw3LYf2TAB1daRjJ2xeg1glNuz3gFFeV5MT2CEyDvS45YLls1VlA0tZALfhwvI2HoIBVkyw1lll2XGxQ08jtnPhl3EDgm8IunAq9S17831jip7r1aEKlWAZMbOxDUNEiHdESPpUO0wQePRfiycubgd2X4sQtN7zSeEoTb5LMDF31rh9t6Js_03wMJOAJ3uA5ozvlY8',
    ),
    _ExploreProduct(
      'Outdoor Gloves',
      'Accessories',
      '4.6',
      39,
      'Rp10.000',
      Icons.back_hand_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAWgnqwKuplndKIQ1fR0ckt-Txo1btisU3bg3zzG7wDPQGyocV7oBRemBox7MNfbD3klzMS80FsZZWNz0TzPENpKcfGz_b6I7_PQE5miEeZqNO40055HooLVWhabAgjVQxRoYCv41d22qmZdOjGxczUOyqISfIyRaTrw3h5HS1tHjTZJPdnafXwTRqwPqX57CkQO8B2Ui-b2XFdZ4Wx1ZwraGqU0wwhp9tEFkqEgSc',
    ),
    _ExploreProduct(
      'Hiking Hat',
      'Headwear',
      '4.7',
      51,
      'Rp8.000',
      Icons.umbrella_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDj8SdPZGLZGSCXAkvuDbEXKAePV5jTF9XiqyBr3IEqfak1mqdhaY2lk1C7D-1uztwXwCol8_8irsc_EccaXZWFWg1GkshSmgtF_5ljAPhbTtph3dfaosmmhbzRBA7qFQByQ8xqabflckUvWcO_qx-3SJgVmTlSP9p5-KF23WyJjSp4pMstdeNZPyFLNk5fILTe7eY-Ms7-ulh9OUS-KBZKNnxipTFcroIRsLgadY8',
    ),
    _ExploreProduct(
      'Alpine Sunglasses',
      'Eyewear',
      '4.9',
      73,
      'Rp12.000',
      Icons.visibility_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAjzaCPBu6a1-xdX1R9pajR2iKV9hAoC8qZCYyXJ_50egSYUdvAfHxzXryGm0_R1FWcRJX_9Icz9gN8EDl0cZ-Q-eSnu-ochzvyxCdwwtRsmVpsjjtu9o6DHoAvPwtrbyExCQBbeR1egdisVkFgWhQCtQ9zpLFLp4oPIYEoRp1t8vI02ECIUS7b34bA82mXejocpbbwG3QGQd1WYWCnqjcumEtFnL74XrE3vvbr_1g',
    ),
    _ExploreProduct(
      'Camping Stove',
      'Cookware',
      '4.8',
      88,
      'Rp18.000',
      Icons.outdoor_grill_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA9Fkd0tSYy2ZUFMZGPu9C6l1ZCo2BnPzzoeXLhuqFy0kmCFwtTnYZdbn5ykqqzoevQbCUiXvjGJZqZyXX8YdtUShVPlPO51tK7nuO2N0Tu-c5G_QY0NYMPf3ga4JDpQqjHIHhoRTr1lquY1YNfHNn3l_aK312_NbcNbgBHQLrPu-Q-Xicmx4MdLy2Ea8F37ZRz8GTo2Fa6tUWsFwjpVANS2qC3EsxnRZTpQSyTEAE',
    ),
    _ExploreProduct(
      'Sleeping Bag',
      'Sleep System',
      '4.9',
      104,
      'Rp28.000',
      Icons.bed_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuD8FDFJ12t5_nLAdNyLRxS5USIb3Ymd-VYS8XnQ6fTRczWua_wzlzytPZzM95qS-bbD3Yt4R6isNJdHpiYq7MZInWRekGjzm1O63KT2tCN8WM1E3U1YXLKFX_1XCLXUndZ9ujDBqQ3uOCzPs_hwNePd1g1b0E5_GcdcmaJTClRW7mLJdsY2LkQT8Kpr6e7ls0jwMJYSNQ67RwiJGDe_BrPHanXa0YUBHSpwBb1Llos',
    ),
    _ExploreProduct(
      'Trekking Poles',
      'Accessories',
      '4.8',
      92,
      'Rp14.000',
      Icons.hiking_outlined,
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBeTZnwwvHRQrcNCm2hzpzQCgWpIuMyBlSou26TWAce8vyCI0HSJQRaLa80ywr9QhZNsv85x9ETC65wHNhx4HEo-k6JTUs2jHEfMopEicyYAS_HUd2uZr_v61BLLXC6btD4iA3APSve8gorSty2pbL_eDYH2g4OzY_9Z8Ri59M0vhIxZueSFGUI8DI4U88cp-k8dG5JV6kfMfAUwJP5OvwoElsau2nuwbS3dbZmtcY',
    ),
  ];

  List<_ExploreProduct> get _filteredProducts {
    final filtered = _products.where((item) {
      final queryMatch =
          _query.isEmpty ||
          '${item.name} ${item.category}'.toLowerCase().contains(
            _query.toLowerCase(),
          );
      final categoryMatch = switch (_category) {
        'All' => true,
        'Shoes' => item.category == 'Footwear',
        'Tents' => item.category == 'Shelter',
        'Camping' => [
          'Cookware',
          'Sleep System',
          'Shelter',
        ].contains(item.category),
        _ => item.category == _category,
      };
      final normalizedCategory = switch (item.category) {
        'Footwear' => 'Shoes',
        'Shelter' => 'Tents',
        'Cookware' => 'Camping Equipment',
        'Sleep System' => 'Camping Equipment',
        'Apparel' => 'Jackets',
        'Eyewear' => 'Accessories',
        'Headwear' => 'Accessories',
        _ => item.category,
      };
      final settingsCategoryMatch =
          !_hasAppliedFilters ||
          _settings.categories.isEmpty ||
          _settings.categories.contains(normalizedCategory);
      final priceMatch =
          !_hasAppliedFilters ||
          (item.priceValue >= _settings.minPrice &&
              item.priceValue <= _settings.maxPrice);
      return queryMatch && categoryMatch && settingsCategoryMatch && priceMatch;
    }).toList();
    switch (_settings.sort) {
      case 'Lowest Price':
        filtered.sort((a, b) => a.priceValue.compareTo(b.priceValue));
        break;
      case 'Highest Price':
        filtered.sort((a, b) => b.priceValue.compareTo(a.priceValue));
        break;
      case 'Highest Rating':
        filtered.sort(
          (a, b) => double.parse(b.rating).compareTo(double.parse(a.rating)),
        );
        break;
      case 'Most Popular':
        filtered.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }
    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _toast(String message, {IconData icon = Icons.info_outline}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          content: Row(
            children: [
              Icon(icon, color: _exploreOrange, size: 18),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _exploreBg,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          _topBar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _intro()),
                SliverToBoxAdapter(child: _categoryScroller()),
                SliverToBoxAdapter(child: _sectionBar()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  sliver: SliverLayoutBuilder(
                    builder: (context, constraints) {
                      final columns = constraints.crossAxisExtent > 560 ? 3 : 2;
                      final products = _filteredProducts;
                      if (products.isEmpty)
                        return const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(
                              child: Text(
                                'No equipment found.',
                                style: TextStyle(color: _exploreMuted),
                              ),
                            ),
                          ),
                        );
                      return SliverGrid.builder(
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: columns == 2 ? .66 : .72,
                        ),
                        itemBuilder: (context, index) =>
                            _productCard(products[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: _bottomNav(),
  );

  Widget _topBar() => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.94),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
    ),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _exploreInk,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.terrain, color: _exploreOrange, size: 22),
        ),
        const SizedBox(width: 8),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GEARUP',
              style: TextStyle(
                color: _exploreMuted,
                fontSize: 9,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Explore',
              style: TextStyle(
                color: _exploreInk,
                fontSize: 16,
                height: 1.1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Search',
          onPressed: _openSearchResults,
          icon: const Icon(Icons.search, color: _exploreInk),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => _toast(
            'You have 2 rental pickup reminders.',
            icon: Icons.notifications,
          ),
          icon: const Icon(Icons.notifications_none, color: _exploreInk),
        ),
      ],
    ),
  );

  Widget _intro() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      color: _exploreInk,
                      fontSize: 27,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Find the right gear for your adventure.',
                    style: TextStyle(color: _exploreMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                IconButton.filledTonal(
                  onPressed: () => _toast(
                    'You have 2 rental pickup reminders.',
                    icon: Icons.notifications,
                  ),
                  icon: const Icon(Icons.notifications_none),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _exploreInk,
                  ),
                ),
                const Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: _exploreOrange,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(13),
                  boxShadow: const [
                    BoxShadow(color: Color(0x08000000), blurRadius: 6),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: _exploreMuted, size: 21),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocus,
                        style: const TextStyle(
                          color: _exploreInk,
                          fontSize: 14,
                        ),
                        onChanged: (value) =>
                            setState(() => _query = value.trim()),
                        onSubmitted: (_) => _openSearchResults(),
                        decoration: const InputDecoration(
                          hintText: 'Search outdoor equipment...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                onPressed: _openFilterSort,
                icon: const Icon(Icons.tune),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _exploreInk,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _categoryScroller() => SizedBox(
    height: 48,
    child: ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (context, index) {
        final name = _categories[index];
        final active = name == _category;
        return ChoiceChip(
          label: Text(name),
          selected: active,
          onSelected: (_) {
            if (name != 'All') {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CategoryProductsPage(category: name),
                ),
              );
            } else {
              setState(() => _category = name);
            }
          },
          showCheckmark: false,
          labelStyle: TextStyle(
            color: active ? Colors.white : _exploreMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: Colors.white,
          selectedColor: _exploreInk,
          side: BorderSide.none,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        );
      },
    ),
  );

  Widget _sectionBar() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
    child: Row(
      children: [
        const Text(
          'All Equipment',
          style: TextStyle(
            color: _exploreInk,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '(${_filteredProducts.length} items)',
          style: const TextStyle(
            color: _exploreMuted,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _openFilterSort,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.swap_vert, color: _exploreMuted, size: 16),
                const SizedBox(width: 4),
                Text(
                  _settings.sort,
                  style: const TextStyle(color: _exploreMuted, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> _openFilterSort() async {
    final settings = await Navigator.of(context).push<FilterSettings>(
      MaterialPageRoute<FilterSettings>(
        builder: (_) => FilterSortPage(initial: _settings),
      ),
    );
    if (settings != null && mounted) {
      setState(() {
        _settings = settings;
        _hasAppliedFilters = true;
      });
    }
  }

  void _openSearchResults() => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => SearchResultsPage(query: _query)),
  );

  void _rentProduct(_ExploreProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RentalDatePage(
          name: product.name,
          category: product.category,
          price: product.price,
          rating: product.rating,
          image: product.image,
          icon: product.icon,
        ),
      ),
    );
  }

  void _openProduct(_ExploreProduct product) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => ProductDetailsPage(
        name: product.name,
        category: product.category,
        price: product.price,
        rating: product.rating,
        reviews: '${product.reviews}',
        image: product.image,
        icon: product.icon,
      ),
    ));
  }

  Widget _productCard(_ExploreProduct product) => GestureDetector(
    onTap: () => _openProduct(product),
    child: Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 7)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFEAEAEA),
                    child: Center(
                      child: Icon(product.icon, color: _exploreMuted, size: 38),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 7,
                right: 7,
                child: Material(
                  color: Colors.white.withOpacity(.94),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      setState(
                        () => _wishlist.contains(product.name)
                            ? _wishlist.remove(product.name)
                            : _wishlist.add(product.name),
                      );
                      _toast(
                        _wishlist.contains(product.name)
                            ? 'Gear added to Wishlist'
                            : 'Removed from Wishlist',
                        icon: Icons.favorite,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        _wishlist.contains(product.name)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _wishlist.contains(product.name)
                            ? _exploreOrange
                            : _exploreInk,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 7,
                left: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _exploreInk,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'AVAILABLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.category,
          style: const TextStyle(color: _exploreMuted, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: _exploreInk,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, color: _exploreOrange, size: 14),
            const SizedBox(width: 3),
            Text(
              product.rating,
              style: const TextStyle(
                color: _exploreInk,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${product.reviews})',
              style: const TextStyle(color: _exploreMuted, fontSize: 10),
            ),
          ],
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: _exploreOrange,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
            children: [
              TextSpan(text: product.price),
              const TextSpan(
                text: '/day',
                style: TextStyle(
                  color: _exploreMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 34,
          child: FilledButton(
            onPressed: () => _rentProduct(product),
            style: FilledButton.styleFrom(
              backgroundColor: _exploreOrange,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
            ),
            child: const Text('Rent Now', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    ),
  ));

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
          color: Colors.white.withOpacity(.97),
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
            final selected = i == 1;
            return Expanded(
              child: InkWell(
                onTap: () {
                  if (i == 0) Navigator.of(context).maybePop();
                  if (i == 3) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(builder: (_) => const MyRentalPage()),
                    );
                  }
                  if (i == 4) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProfilePage(account: widget.account),
                      ),
                    );
                  }
                  if (i == 2) {
                    _toast(
                      '${items[i].$1} section selected.',
                      icon: items[i].$2,
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[i].$2,
                      size: 21,
                      color: selected ? _exploreOrange : _exploreMuted,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i].$1,
                      style: TextStyle(
                        color: selected ? _exploreOrange : _exploreMuted,
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
                          color: _exploreOrange,
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
}

class _ExploreProduct {
  const _ExploreProduct(
    this.name,
    this.category,
    this.rating,
    this.reviews,
    this.price,
    this.icon,
    this.image,
  );
  final String name;
  final String category;
  final String rating;
  final int reviews;
  final String price;
  final IconData icon;
  final String image;

  int get priceValue => int.parse(price.replaceAll(RegExp(r'[^0-9]'), ''));
}
