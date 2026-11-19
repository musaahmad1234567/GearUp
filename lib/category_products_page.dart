import 'package:flutter/material.dart';

import 'filter_sort_page.dart';
import 'search_results_page.dart';
import 'account_store.dart';
import 'my_rental_page.dart';
import 'profile_page.dart';
import 'rental_date_page.dart';

const _categoryInk = Color(0xFF252525);
const _categoryMuted = Color(0xFF454545);
const _categoryOrange = Color(0xFFF28C28);
const _categoryBg = Color(0xFFF7F7F7);

class CategoryProductsPage extends StatefulWidget {
  const CategoryProductsPage({super.key, this.category = 'Backpacks'});

  final String category;

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  static const _products = <_BackpackProduct>[
    _BackpackProduct(
      brand: "Arc'teryx",
      name: "Arc'teryx Bora 65L",
      spec: '65 Liters • 2.2 kg',
      rating: 4.9,
      reviews: 112,
      price: 35000,
      badge: 'Expedition',
      liters: 65,
      waterproof: true,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBCb7vMGtronr-Cyw6aHuGvIfRRNlu0b1XVxchxMolL4X4Zz5vwhkeEviUD1_PqHcmbw_t0ohGh6_UdHyfNIvrUchwKiotvYHEQEx3u1gxwrBs9S2fKDTFffWOK_1Z-YHJXRy0KjStMZgHgFoGm3QLB2WZDEfbTzPRUAq1yzzqtKqJxt0cP5k0IWPrquPgrtQSaK8OknBA6zQFm6NxbxYR-eZytVj984IBen_8X87o',
    ),
    _BackpackProduct(
      brand: 'Osprey',
      name: 'Osprey Atmos AG 50L',
      spec: '50 Liters • 1.9 kg',
      rating: 4.9,
      reviews: 148,
      price: 25000,
      badge: 'Top Choice',
      liters: 50,
      waterproof: false,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCuRt416I05o7NWzVnqSe194-ICNFEniZ-IVJbDLBhc8sEXimvSR-QqeENVplqVebM0Gk8OwG8UW4HEIac8QGaqZsloSp4lH7V4HfS2huEpgsaZW51F3WziCajD0HTOpXnlMe95XaJUJKzueddsvsh2lWff-4vudQ0C1bFlaIih6COPphe7hhbFqjoe2Gn1a7bcRLhM6zT5H4hU4oybcD2gqJwvSHBeLK26IDWKGao',
    ),
    _BackpackProduct(
      brand: 'Hyperlite',
      name: 'HMG 3400 Windrider',
      spec: '55 Liters • 910g',
      rating: 5.0,
      reviews: 64,
      price: 38000,
      badge: 'Ultralight',
      liters: 55,
      waterproof: true,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBrqagJvt255DPanEyh-hnZsCeVKsyV6xhzkxqXEBvPj3rrATi6GZy8ECGYdInRurhijjzPG9ehuoxdQe0yNriUzDrSJFdmYX3O5WrFua7yDnYxFWglLHk4NZ-0XU1vTHE_Ca-tCuoWX3cPxR8kwgB-RA7slZL4RmLqTFkmFNhIkU9mflS5BFidmYGi0uH_26VJ1H9oEINZWHKvuxEXwkhCnw3-xfDwpebCO3HpyV8',
    ),
    _BackpackProduct(
      brand: 'Deuter',
      name: 'Deuter Aircontact Pro',
      spec: '85 Liters • 3.1 kg',
      rating: 4.8,
      reviews: 89,
      price: 28000,
      badge: 'Heavy Load',
      liters: 85,
      waterproof: true,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuANpGmPZbftGZyuFHYUF0y-pGGr9ZiQArz-OWFHnjvJEdNS-bad-ypZ7GZoHIxcAya7QuIe9Z3zpWr4062Hewy7MLs2EjlgvbwLqF5AwOYz14CYiu1a2QqSPSyyizClELRb3QTpbVLo3B4TpRjWHEyVaWW6LBpR0Q4J_A3WIKyaePRCtPg-PH69qQD_SxdnHBLpT30Y9h7rYni1_fV6TGPMdlcS17G4h0Mh-NeNLRE',
    ),
    _BackpackProduct(
      brand: 'Black Diamond',
      name: 'BD Speed 40 Alpine',
      spec: '40 Liters • 1.2 kg',
      rating: 4.7,
      reviews: 52,
      price: 22000,
      badge: 'Alpine Stripped',
      liters: 40,
      waterproof: false,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuARiFvhgq8FLbvySoZKED_x7qnXr2XCVuRBCLG0FT2SMQXYzfs8fqJWimTm_vXWtcAx5BAncmPP98JEMQQJpy1qDIL7yJNRer1SCedeAltzdLbKq0OtZEF89nxw7oeB0dtZxo5JATzhBeeGVMiGcKvUIKkrViMs7b5rAGJdlFUQV_Gxm6HcfZ-HiY6ezmR-oITmzOLvLtb0H16nNRUu8Bvv4Kt_dZa1qLQnbgBDtx4',
    ),
    _BackpackProduct(
      brand: 'Patagonia',
      name: 'Patagonia Ascensionist',
      spec: '35 Liters • 890g',
      rating: 4.8,
      reviews: 76,
      price: 24000,
      badge: 'Climbing Ready',
      liters: 35,
      waterproof: false,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD-GUEOvEMz9DAbUcpp78K4Sk3W0R8kAUSgQKwVfxe2w3qLZhwnq1CtqpYQvLwAL1G4L126HZK_UiQdkPH4zv7nEv7GG4aKWZJlSOqEmXvUaPxzCItKoagCWZhcxOaXLhvN8iKkFuzXkT7NL-DDsvY1euG6-gawf0tnC5j6R2zWjA2MmKvKYMS3t79a0e7NxBORtiMrGuMAyDK1kTKzgxAfyCh7mBYaM1jefOqrjLY',
    ),
  ];

  static const _otherProducts = <_BackpackProduct>[
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Outdoor Jacket',
      spec: 'Waterproof shell • 680g',
      rating: 4.9,
      reviews: 94,
      price: 35000,
      badge: 'Waterproof',
      liters: 0,
      waterproof: true,
      category: 'Jackets',
      filters: ['Shell', 'Waterproof'],
      icon: Icons.checkroom_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDhRtb-LyAXoAPCwg3UGSsw_tvNgxSVM2bOJZL5AQoCinGV43z0Uu80RlHcNE4Nykt5GIklKvKjXUaw7cuF6mDUTSzeSjGjWkESPXuNbD9RCFTkTppR2I-NOIF0skO3VcKQSd1BJEt6huiCmGNYtoWhJlljnzWg1pYp37t_GzjCRMVyZP7rX_Vj2ZyMRHLzgTqf49puTfC5dvEBgsvgkGtv1RiP3Dpzm4sLL_KR0JA',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Hiking Pants',
      spec: 'Stretch ripstop • 420g',
      rating: 4.8,
      reviews: 65,
      price: 20000,
      badge: 'Trail Shell',
      liters: 0,
      waterproof: false,
      category: 'Jackets',
      filters: ['Shell'],
      icon: Icons.dry_cleaning_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDdrusyuSW4OOjzSKfdxwZHbgEXb24VpnWl_Tw3LYf2TAB1daRjJ2xeg1glNuz3gFFeV5MT2CEyDvS45YLls1VlA0tZALfhwvI2HoIBVkyw1lll2XGxQ08jtnPhl3EDgm8IunAq9S17831jip7r1aEKlWAZMbOxDUNEiHdESPpUO0wQePRfiycubgd2X4sQtN7zSeEoTb5LMDF31rh9t6Js_03wMJOAJ3uA5ozvlY8',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Hiking Shoes',
      spec: 'Vibram sole • 820g',
      rating: 4.8,
      reviews: 86,
      price: 30000,
      badge: 'Trail Ready',
      liters: 0,
      waterproof: true,
      category: 'Shoes',
      filters: ['Trail', 'Waterproof'],
      icon: Icons.hiking_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBODdp8uBT1WY4rVCaJL0C3opwR2cwHU-8oxL9PALWVG7eaDbd1CCPszdb3WlcNsnlGzUY2eaw0fwvkgY3HsHBcP3hFATm_oJ9VlsPj2gVGcfXW7H3Ly53nBTghmzduggi-5rgcbZbB_6a6jxXscgSMsa_OwCkLDVRd-RvlnVsO_YhVKgspbBnSQaqK9fIDDkF5KoNiVf82bjj3cnba7OAYQDdt-UbaLp8oT5QqeAY',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Camping Tent',
      spec: '3-Season • 2 person',
      rating: 5.0,
      reviews: 112,
      price: 50000,
      badge: '3-Season',
      liters: 0,
      waterproof: true,
      category: 'Tents',
      filters: ['3-Season', 'Shelter'],
      icon: Icons.park_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBW4BWJgEdxG4DB83-lyIzRCpfW2czEGUMcld45jiFfaplvQUtIYSKD_RXDl7ouNUqRK3WIECMeM81eDSi_r6pCZpQFCAG0YTvHe1dvHe8EkVOQaLnN_-X2WVEKMVvqQay-dpRi6oCF68FwqdrrbQyUztRrqJdQsrukWkzyu079DkKMDXORrjJpCP7ZydZfReqpk9VVaFUHQTFYfBu0xQWo7CEGpxs4_EeVXAqYaLg',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Ultralight Sleeping Bag',
      spec: '850 Fill Down • -10°C',
      rating: 4.9,
      reviews: 104,
      price: 28000,
      badge: 'Ultralight',
      liters: 0,
      waterproof: false,
      category: 'Sleep Bags',
      filters: ['Sleep System', 'Ultralight'],
      icon: Icons.bed_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD8FDFJ12t5_nLAdNyLRxS5USIb3Ymd-VYS8XnQ6fTRczWua_wzlzytPZzM95qS-bbD3Yt4R6isNJdHpiYq7MZInWRekGjzm1O63KT2tCN8WM1E3U1YXLKFX_1XCLXUndZ9ujDBqQ3uOCzPs_hwNePd1g1b0E5_GcdcmaJTClRW7mLJdsY2LkQT8Kpr6e7ls0jwMJYSNQ67RwiJGDe_BrPHanXa0YUBHSpwBb1Llos',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Titanium Camp Stove',
      spec: 'Titanium cookware kit',
      rating: 4.8,
      reviews: 88,
      price: 18000,
      badge: 'Cookware',
      liters: 0,
      waterproof: false,
      category: 'Camping Equipment',
      filters: ['Cookware'],
      icon: Icons.outdoor_grill_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA9Fkd0tSYy2ZUFMZGPu9C6l1ZCo2BnPzzoeXLhuqFy0kmCFwtTnYZdbn5ykqqzoevQbCUiXvjGJZqZyXX8YdtUShVPlPO51tK7nuO2N0Tu-c5G_QY0NYMPf3ga4JDpQqjHIHhoRTr1lquY1YNfHNn3l_aK312_NbcNbgBHQLrPu-Q-Xicmx4MdLy2Ea8F37ZRz8GTo2Fa6tUWsFwjpVANS2qC3EsxnRZTpQSyTEAE',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Hydration Pack',
      spec: '2L reservoir • 340g',
      rating: 4.7,
      reviews: 42,
      price: 15000,
      badge: 'Hydration',
      liters: 0,
      waterproof: false,
      category: 'Accessories',
      filters: ['Hydration'],
      icon: Icons.water_drop_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAh_rdHgwCi_Qtn-ethjQ9HLuS9VkTsQj-nNNnMIHdzWEBXf0tDdIxEiiEbDy8eYWQOiJJgcflK75MjpBt4KsyRTAfogEhYo2RmzFS-1z0iHw5YzjoctzsuDXw3bqPSPWXNIP2OabMk0sWjx3DkvEY02AlROm7G2Rz2pFFou1fH9u9c10ANOqpEpyzUZvyxzXLnSfuKDfPY73zvvT_iY1pAhB_b5Ir-YxfiPlwd3yc',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Outdoor Gloves',
      spec: 'Waterproof shell • 210g',
      rating: 4.6,
      reviews: 39,
      price: 10000,
      badge: 'Accessories',
      liters: 0,
      waterproof: true,
      category: 'Accessories',
      filters: ['Waterproof', 'Tools'],
      icon: Icons.back_hand_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAWgnqwKuplndKIQ1fR0ckt-Txo1btisU3bg3zzG7wDPQGyocV7oBRemBox7MNfbD3klzMS80FsZZWNz0TzPENpKcfGz_b6I7_PQE5miEeZqNO40055HooLVWhabAgjVQxRoYCv41d22qmZdOjGxczUOyqISfIyRaTrw3h5HS1tHjTZJPdnafXwTRqwPqX57CkQO8B2Ui-b2XFdZ4Wx1ZwraGqU0wwhp9tEFkqEgSc',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Hiking Hat',
      spec: 'UPF sun protection • 160g',
      rating: 4.7,
      reviews: 51,
      price: 8000,
      badge: 'Headwear',
      liters: 0,
      waterproof: false,
      category: 'Accessories',
      filters: ['Headwear'],
      icon: Icons.umbrella_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDj8SdPZGLZGSCXAkvuDbEXKAePV5jTF9XiqyBr3IEqfak1mqdhaY2lk1C7D-1uztwXwCol8_8irsc_EccaXZWFWg1GkshSmgtF_5ljAPhbTtph3dfaosmmhbzRBA7qFQByQ8xqabflckUvWcO_qx-3SJgVmTlSP9p5-KF23WyJjSp4pMstdeNZPyFLNk5fILTe7eY-Ms7-ulh9OUS-KBZKNnxipTFcroIRsLgadY8',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Alpine Sunglasses',
      spec: 'Polarized glacier lens',
      rating: 4.9,
      reviews: 73,
      price: 12000,
      badge: 'Eyewear',
      liters: 0,
      waterproof: false,
      category: 'Accessories',
      filters: ['Eyewear'],
      icon: Icons.visibility_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAjzaCPBu6a1-xdX1R9pajR2iKV9hAoC8qZCYyXJ_50egSYUdvAfHxzXryGm0_R1FWcRJX_9Icz9gN8EDl0cZ-Q-eSnu-ochzvyxCdwwtRsmVpsjjtu9o6DHoAvPwtrbyExCQBbeR1egdisVkFgWhQCtQ9zpLFLp4oPIYEoRp1t8vI02ECIUS7b34bA82mXejocpbbwG3QGQd1WYWCnqjcumEtFnL74XrE3vvbr_1g',
    ),
    _BackpackProduct(
      brand: 'GEARUP',
      name: 'Trekking Poles',
      spec: 'Carbon fiber • Pair',
      rating: 4.8,
      reviews: 92,
      price: 14000,
      badge: 'Trail Tools',
      liters: 0,
      waterproof: false,
      category: 'Accessories',
      filters: ['Tools'],
      icon: Icons.hiking_outlined,
      image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBeTZnwwvHRQrcNCm2hzpzQCgWpIuMyBlSou26TWAce8vyCI0HSJQRaLa80ywr9QhZNsv85x9ETC65wHNhx4HEo-k6JTUs2jHEfMopEicyYAS_HUd2uZr_v61BLLXC6btD4iA3APSve8gorSty2pbL_eDYH2g4OzY_9Z8Ri59M0vhIxZueSFGUI8DI4U88cp-k8dG5JV6kfMfAUwJP5OvwoElsau2nuwbS3dbZmtcY',
    ),
  ];

  static const _allProducts = <_BackpackProduct>[
    ..._products,
    ..._otherProducts,
  ];

  final Set<String> _wishlist = {};
  String _pill = 'All';
  String _sort = 'Recommended';
  late FilterSettings _filterSettings;
  bool _hasAppliedFilters = false;
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    _filterSettings = FilterSettings(
      categories: _categoryKey == 'Backpacks'
          ? const ['Backpacks', 'Jackets']
          : [_categoryKey == 'Sleep Bags' ? 'Camping Equipment' : _categoryKey],
    );
  }

  String get _categoryKey => switch (widget.category) {
    'Footwear' || 'Shoes' => 'Shoes',
    'Camping' || 'Camping Equipment' => 'Camping Equipment',
    'Sleep Bags' => 'Sleep Bags',
    _ => widget.category,
  };

  String get _categorySubtitle => switch (_categoryKey) {
    'Backpacks' => 'Alpine & Trail Packs',
    'Jackets' => 'Technical Jackets & Apparel',
    'Shoes' => 'Trail Footwear',
    'Tents' => 'Shelter & Expedition Tents',
    'Sleep Bags' => 'Sleeping Systems',
    'Camping Equipment' => 'Camp Kitchen & Essentials',
    _ => 'Outdoor Equipment',
  };

  String get _heroTitle => switch (_categoryKey) {
    'Backpacks' => 'Backpacks & Trail Packs',
    'Jackets' => 'Technical Jackets & Apparel',
    'Shoes' => 'Trail Shoes & Footwear',
    'Tents' => 'Tents & Trail Shelters',
    'Sleep Bags' => 'Sleeping Bags',
    'Camping Equipment' => 'Camping Equipment',
    _ => 'Outdoor Accessories',
  };

  String get _heroDescription => switch (_categoryKey) {
    'Backpacks' => 'Ergonomic, technical backpacks engineered for day hikes, alpine ridge treks, and multi-day backcountry expeditions.',
    'Jackets' => 'Weather-ready technical layers built to protect you from wind, rain, and changing alpine conditions.',
    'Shoes' => 'Trail-tested footwear with reliable grip, protection, and comfort for long days outside.',
    'Tents' => 'Reliable shelters designed for changing weather, trail camps, and multi-day expeditions.',
    'Sleep Bags' => 'Warm, packable sleep systems for comfortable nights at camp and in the backcountry.',
    'Camping Equipment' => 'Lightweight camp kitchen gear and practical essentials for your next trip.',
    _ =>
      'Field-tested outdoor essentials selected for your next trail adventure.',
  };

  IconData get _categoryIcon => switch (_categoryKey) {
    'Backpacks' => Icons.backpack_outlined,
    'Jackets' => Icons.checkroom_outlined,
    'Shoes' => Icons.hiking_outlined,
    'Tents' => Icons.park_outlined,
    'Sleep Bags' => Icons.bed_outlined,
    'Camping Equipment' => Icons.outdoor_grill_outlined,
    _ => Icons.explore_outlined,
  };

  List<String> get _pillOptions => switch (_categoryKey) {
    'Backpacks' => [
      'All',
      'Daypacks (20-35L)',
      'Multi-Day (40-60L)',
      'Expedition (65L+)',
      'Waterproof',
    ],
    'Jackets' => ['All', 'Shell', 'Waterproof'],
    'Shoes' => ['All', 'Trail', 'Waterproof'],
    'Tents' => ['All', '3-Season', 'Waterproof'],
    'Sleep Bags' => ['All', 'Ultralight', 'Sleep System'],
    'Camping Equipment' => ['All', 'Cookware', 'Shelter', 'Sleep System'],
    _ => ['All', 'Hydration', 'Headwear', 'Eyewear', 'Tools'],
  };

  int get _displayCount => _categoryKey == 'Backpacks'
      ? 24
      : _allProducts.where((item) => item.category == _categoryKey).length;

  List<_BackpackProduct> get _visibleProducts {
    final result = _allProducts.where((item) {
      final pillMatch = switch (_pill) {
        'Daypacks (20-35L)' => item.liters >= 20 && item.liters <= 35,
        'Multi-Day (40-60L)' => item.liters >= 40 && item.liters <= 60,
        'Expedition (65L+)' => item.liters >= 65,
        'Waterproof' => item.waterproof,
        'All' => true,
        _ => item.filters.contains(_pill),
      };
      final priceMatch =
          item.price >= _filterSettings.minPrice &&
          item.price <= _filterSettings.maxPrice;
      final categoryMatch = item.category == _categoryKey;
      final appliedCategoryMatch =
          !_hasAppliedFilters ||
          _filterSettings.categories.isEmpty ||
          _filterSettings.categories.contains(_categoryKey) ||
          (_categoryKey == 'Sleep Bags' &&
              _filterSettings.categories.contains('Camping Equipment'));
      return pillMatch && priceMatch && categoryMatch && appliedCategoryMatch;
    }).toList();
    switch (_sort) {
      case 'Lowest Price':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Highest Price':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Highest Rating':
        result.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Most Popular':
        result.sort((a, b) => b.reviews.compareTo(a.reviews));
        break;
    }
    return result;
  }

  Future<void> _openFilters() async {
    final settings = await Navigator.of(context).push<FilterSettings>(
      MaterialPageRoute<FilterSettings>(
        builder: (_) => FilterSortPage(initial: _filterSettings),
      ),
    );
    if (settings != null && mounted) {
      setState(() {
        _filterSettings = settings;
        _sort = settings.sort;
        _hasAppliedFilters = true;
      });
    }
  }

  void _showSort() => showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(18),
            child: Text(
              'Sort $_categoryKey',
              style: TextStyle(
                color: _categoryInk,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final option in [
            'Recommended',
            'Lowest Price',
            'Highest Price',
            'Highest Rating',
            'Most Popular',
          ])
            ListTile(
              title: Text(option),
              trailing: _sort == option
                  ? const Icon(Icons.check, color: _categoryOrange)
                  : null,
              onTap: () {
                setState(() => _sort = option);
                Navigator.of(sheetContext).pop();
              },
            ),
        ],
      ),
    ),
  );

  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _categoryBg,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          _appBar(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _categoryHeader()),
                SliverToBoxAdapter(child: _heroCard()),
                SliverToBoxAdapter(child: _sortAndFilter()),
                SliverToBoxAdapter(child: _pills()),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  sliver: _visibleProducts.isEmpty
                      ? const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Center(
                              child: Text(
                                'No backpacks match these filters.',
                                style: TextStyle(color: _categoryMuted),
                              ),
                            ),
                          ),
                        )
                      : SliverGrid.builder(
                          itemCount: _visibleProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: .56,
                              ),
                          itemBuilder: (context, index) =>
                              _productCard(_visibleProducts[index]),
                        ),
                ),
                SliverToBoxAdapter(child: _assuranceBanner()),
                const SliverToBoxAdapter(child: SizedBox(height: 22)),
              ],
            ),
          ),
        ],
      ),
    ),
    bottomNavigationBar: _bottomNav(),
  );

  Widget _appBar() => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.96),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 8)],
    ),
    child: Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: _categoryInk,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.terrain, color: _categoryOrange, size: 21),
        ),
        const SizedBox(width: 8),
        const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GEARUP',
              style: TextStyle(
                color: _categoryMuted,
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Category Products',
              style: TextStyle(
                color: _categoryInk,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          tooltip: 'Search',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const SearchResultsPage(query: 'Hiking Backpack'),
            ),
          ),
          icon: const Icon(Icons.search, color: _categoryInk),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => _message('You have 2 rental pickup reminders.'),
          icon: const Icon(Icons.notifications_none, color: _categoryInk),
        ),
      ],
    ),
  );

  Widget _categoryHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
    child: Row(
      children: [
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).maybePop(),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEFEFEF),
            foregroundColor: _categoryInk,
          ),
          icon: const Icon(Icons.arrow_back, size: 20),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _categoryKey,
                style: const TextStyle(
                  color: _categoryInk,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                _categorySubtitle,
                style: const TextStyle(color: _categoryMuted, fontSize: 10),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const SearchResultsPage(query: 'Hiking Backpack'),
            ),
          ),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEFEFEF),
            foregroundColor: _categoryInk,
          ),
          icon: const Icon(Icons.search, size: 20),
        ),
        IconButton.filledTonal(
          onPressed: () => setState(() => _bookmarked = !_bookmarked),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFEFEFEF),
            foregroundColor: _bookmarked ? _categoryOrange : _categoryInk,
          ),
          icon: Icon(
            _bookmarked ? Icons.bookmark : Icons.bookmark_border,
            size: 20,
          ),
        ),
      ],
    ),
  );

  Widget _heroCard() => Container(
    margin: const EdgeInsets.fromLTRB(16, 10, 16, 16),
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: const Color(0xFFEAEAEA),
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 7)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.hiking, color: _categoryOrange, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'TECHNICAL GEAR',
                        style: TextStyle(
                          color: _categoryOrange,
                          fontSize: 9,
                          letterSpacing: .8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _heroTitle,
                    style: const TextStyle(
                      color: _categoryInk,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _heroDescription,
                    style: const TextStyle(
                      color: _categoryMuted,
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(_categoryIcon, color: _categoryInk),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _specChip(
              _categoryKey == 'Backpacks'
                  ? '$_displayCount Packs Available'
                  : '$_displayCount Items Available',
              Icons.circle,
            ),
            _specChip(
              _categoryKey == 'Backpacks'
                  ? 'Capacity: 20L - 85L'
                  : 'Trail-Tested Gear',
              Icons.tune,
            ),
            _specChip('Alpine-Inspected', Icons.verified_outlined),
          ],
        ),
      ],
    ),
  );

  Widget _specChip(String text, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon == Icons.circle)
          const Icon(Icons.circle, color: _categoryOrange, size: 6)
        else
          Icon(icon, color: _categoryMuted, size: 12),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: _categoryInk,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _sortAndFilter() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
    child: Row(
      children: [
        OutlinedButton.icon(
          onPressed: _showSort,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: _categoryInk,
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.expand_more, color: _categoryMuted, size: 18),
          label: Text('Sort: $_sort', style: const TextStyle(fontSize: 11)),
        ),
        const Spacer(),
        FilledButton.icon(
          onPressed: _openFilters,
          style: FilledButton.styleFrom(
            backgroundColor: _categoryInk,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(11),
            ),
          ),
          icon: const Icon(Icons.tune, size: 17),
          label: Text(
            'Filter  ${_filterSettings.categories.length}',
            style: const TextStyle(fontSize: 11),
          ),
        ),
      ],
    ),
  );

  Widget _pills() {
    final pills = _pillOptions;
    return SizedBox(
      height: 43,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        scrollDirection: Axis.horizontal,
        itemCount: pills.length,
        separatorBuilder: (_, __) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final pill = pills[index];
          final active = pill == _pill;
          return ChoiceChip(
            label: Text(pill == 'All' ? 'All ($_displayCount)' : pill),
            selected: active,
            onSelected: (_) => setState(() => _pill = pill),
            showCheckmark: false,
            labelStyle: TextStyle(
              color: active ? Colors.white : _categoryInk,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: _categoryInk,
            backgroundColor: Colors.white,
            side: BorderSide.none,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 7),
          );
        },
      ),
    );
  }

  Widget _productCard(_BackpackProduct product) => Container(
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
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFEAEAEA),
                  child: Center(
                    child: Icon(product.icon, color: _categoryMuted, size: 40),
                  ),
                ),
              ),
              Positioned(
                top: 7,
                left: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _categoryInk.withOpacity(.86),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.badge,
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
                  color: Colors.white.withOpacity(.92),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() {
                      if (!_wishlist.add(product.name))
                        _wishlist.remove(product.name);
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        _wishlist.contains(product.name)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _wishlist.contains(product.name)
                            ? _categoryOrange
                            : _categoryInk,
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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.spec,
                style: const TextStyle(color: _categoryMuted, fontSize: 9),
              ),
              const SizedBox(height: 3),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: _categoryInk,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.star, color: _categoryOrange, size: 14),
                  const SizedBox(width: 3),
                  Text(
                    product.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      color: _categoryInk,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${product.reviews})',
                    style: const TextStyle(color: _categoryMuted, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: _categoryInk,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                  children: [
                    TextSpan(text: 'Rp${_formatPrice(product.price)}'),
                    const TextSpan(
                      text: '/day',
                      style: TextStyle(
                        color: _categoryMuted,
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
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => RentalDatePage(
                        name: product.name,
                        category: product.category,
                        price: 'Rp${_formatPrice(product.price)}',
                        rating: product.rating.toString(),
                        image: product.image,
                        icon: product.icon,
                      ),
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: _categoryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Rent Now',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
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
    final result = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      if (i > 0 && (value.length - i) % 3 == 0) result.write('.');
      result.write(value[i]);
    }
    return result.toString();
  }

  Widget _assuranceBanner() => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFEFEFEF),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0x1AF28C28),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sanitizer_outlined,
              color: _categoryOrange,
              size: 20,
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Field-Tested & Sanitized',
                style: const TextStyle(
                  color: _categoryInk,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Every item is inspected, cleaned, and weather-tested between rentals.',
                style: const TextStyle(
                  color: _categoryMuted,
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _bottomNav() => SafeArea(
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
        children: [
          _navItem(
            'Home',
            Icons.cottage_outlined,
            false,
            () => Navigator.of(context).maybePop(),
          ),
          _navItem(
            'Explore',
            Icons.explore_outlined,
            true,
            () => Navigator.of(context).maybePop(),
          ),
          _navItem(
            'Wishlist',
            Icons.favorite_border,
            false,
            () => _message('Wishlist has ${_wishlist.length} saved items.'),
          ),
          _navItem(
            'My Rental',
            Icons.backpack_outlined,
            false,
            () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const MyRentalPage(),
              ),
            ),
          ),
          _navItem(
            'Profile',
            Icons.account_circle_outlined,
            false,
            () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ProfilePage(
                  account: LocalAccount(
                    name: 'Alex Morgan',
                    email: 'alexmorgan@email.com',
                    phone: '+62 812 3456 7890',
                    password: '',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _navItem(
    String title,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 21,
            color: selected ? _categoryOrange : _categoryMuted,
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              color: selected ? _categoryOrange : _categoryMuted,
              fontSize: 9,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          if (selected)
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(
                color: _categoryOrange,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    ),
  );
}

class _BackpackProduct {
  const _BackpackProduct({
    required this.brand,
    required this.name,
    required this.spec,
    required this.rating,
    required this.reviews,
    required this.price,
    required this.badge,
    required this.liters,
    required this.waterproof,
    required this.image,
    this.category = 'Backpacks',
    this.filters = const [],
    this.icon = Icons.backpack_outlined,
  });
  final String brand;
  final String name;
  final String spec;
  final double rating;
  final int reviews;
  final int price;
  final String badge;
  final int liters;
  final bool waterproof;
  final String image;
  final String category;
  final List<String> filters;
  final IconData icon;
}
