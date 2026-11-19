/// My Address page (Edit / Add delivery drop-off addresses).
///
/// Mirrors the HTML reference (`My Address` screen): dispatch banner,
/// horizontal tab bar, address cards with edit/delete actions, a floating
/// "Add New Address" button and a slide-up drawer with a full address form.
///
/// Uses the same design tokens as [ProfilePage] (surface #FBF9F9, blaze-orange
/// #F28C28, primary #914D00, charcoal #303031, red #BA1A1A).
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Design tokens (mirrors the HTML theme)
// ---------------------------------------------------------------------------
const _surface = Color(0xFFFBF9F9);
const _onSurface = Color(0xFF1B1C1C);
const _onSurfaceVariant = Color(0xFF554336);
const _secondary = Color(0xFF5F5E5E);
const _primaryContainer = Color(0xFFF28C28);
const _inverseSurface = Color(0xFF303031);
const _error = Color(0xFFBA1A1A);
const _surfaceVariant = Color(0xFFE3E2E2);
const _surfaceContainerLowest = Color(0xFFFFFFFF);
const _surfaceContainerLow = Color(0xFFF5F3F3);

/// One address card in the list.
class AddressEntry {
  final String type;
  final String label;
  final String name;
  final String phone;
  final String address;
  final String? note;
  final bool isDefault;

  const AddressEntry({
    required this.type,
    required this.label,
    required this.name,
    required this.phone,
    required this.address,
    this.note,
    this.isDefault = false,
  });
}

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------
class MyAddressPage extends StatelessWidget {
  static const String routeName = '/my-address';

  const MyAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: MyAddressPageView(),
    );
  }
}

class MyAddressPageView extends StatefulWidget {
  const MyAddressPageView({super.key});

  @override
  State<MyAddressPageView> createState() => _MyAddressPageViewState();
}

class _MyAddressPageViewState extends State<MyAddressPageView>
    with TickerProviderStateMixin {
  int _tabIndex = 0; // 0 = All, 1 = Home & Office, 2 = Trailhead Lockers
  final _labelCtrl = TextEditingController(text: 'Home');
  final _nameCtrl = TextEditingController(text: 'Alex Morgan');
  final _phoneCtrl = TextEditingController(text: '812 3456 7890');
  final _addressCtrl = TextEditingController();
  bool _isDefault = true;
  bool _isDrawerOpen = false;
  bool _isEdit = false;
  String _selectedType = 'Home';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _anim;
  late Animation<Offset> _slide;
  late Animation<double> _fade;

  final List<AddressEntry> _addresses = const [
    AddressEntry(
      type: 'Home',
      isDefault: true,
      label: 'Home',
      name: 'Alex Morgan',
      phone: '+62 812 3456 7890',
      address: 'Jl. Senopati No. 42, Kebayoran Baru, Jakarta Selatan, DKI Jakarta 12190',
      note: 'Drop off at lobby concierge if not available',
    ),
    AddressEntry(
      type: 'Office / Basecamp Hub',
      label: 'Office / Basecamp Hub',
      name: 'Alex Morgan (Work)',
      phone: '+62 812 3456 7890',
      address: 'Sudirman Central Business District (SCBD), Treasury Tower Lt. 18, Jakarta Selatan 12190',
    ),
    AddressEntry(
      type: 'Mountain Basecamp Locker',
      label: 'Mountain Basecamp Locker',
      name: 'Alex Morgan // Self Pickup',
      phone: '+62 812 3456 7890',
      address: 'Basecamp Locker #14, GEARUP Batu Alpine Hub, Jl. Puncak Giri No. 12, Jawa Timur',
      note: 'PIN issued upon reservation confirmation',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  void _openModal({AddressEntry? entry}) {
    if (entry != null) {
      _labelCtrl.text = entry.label;
      _nameCtrl.text = entry.name;
      _phoneCtrl.text = entry.phone.replaceFirst('+62 ', '');
      _addressCtrl.text = entry.address;
      _isDefault = entry.isDefault;
    } else {
      _labelCtrl.text = 'Basecamp Hub';
      _nameCtrl.text = 'Alex Morgan';
      _phoneCtrl.text = '812 3456 7890';
      _addressCtrl.text = '';
      _isDefault = false;
    }
    _isEdit = entry != null;
    _selectedType = entry?.type ?? 'Home';
    _slide = Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.reset();
    _anim.forward();
    setState(() => _isDrawerOpen = true);
  }

  void _closeModal() {
    _anim.reverse().then((_) {
      if (mounted) setState(() => _isDrawerOpen = false);
    });
  }

  void _saveAddress() {
    _anim.reverse().then((_) {
      if (!mounted) return;
      setState(() => _isDrawerOpen = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(child: Text('Address saved to trail gear profile')),
            ],
          ),
          backgroundColor: _primaryContainer,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  void _deleteAddress(int index) {
    setState(() => _addresses.removeAt(index));
  }

  void _selectTab(int index) {
    setState(() => _tabIndex = index);
  }

  Widget _buildDrawer() {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Stack(
          children: [
            GestureDetector(
              onTap: _closeModal,
              child: Container(color: Colors.black12),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: _buildDrawerPanel(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 24, color: _onSurface),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDispatchBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: _primaryContainer,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mail, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Expedition Drop Points',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _onSurface),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Manage addresses for gear delivery and basecamp locker drop-offs.',
                  style: TextStyle(fontSize: 13, color: _secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final tabs = const ['All (3)', 'Home & Office', 'Trailhead Lockers'];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final active = _tabIndex == i;
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: active ? _primaryContainer : _surfaceContainerLowest,
            ),
            child: TextButton(
              onPressed: () => _selectTab(i),
              style: TextButton.styleFrom(
                foregroundColor: active ? Colors.white : _secondary,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(tabs[i], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : _secondary)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(AddressEntry a, int index) {
    final isDefault = a.isDefault;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header + badges
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _Chip(a.type, _inverseSurface),
                          if (isDefault)
                            _Chip('Default', _primaryContainer),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        a.name,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _onSurface),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        a.phone,
                        style: TextStyle(fontSize: 12, color: _secondary),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _deleteAddress(index),
                  icon: const Icon(Icons.delete, size: 20, color: _error),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: _surfaceVariant),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
            child: Text(a.address, style: TextStyle(fontSize: 12, color: _onSurface)),
          ),
          if (a.note != null)
            Container(
              margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: _surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.info_outline, size: 16, color: _primaryContainer),
                  const SizedBox(width: 8),
                  Text(a.note!, style: TextStyle(fontSize: 12, color: _onSurfaceVariant)),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _onSurface,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Edit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () => _deleteAddress(index),
                  style: TextButton.styleFrom(
                    foregroundColor: _error,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Delete', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return SliverList.separated(
      itemCount: _addresses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _buildAddressCard(_addresses[index], index),
    );
  }

  Widget _buildDrawerPanel() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      height: MediaQuery.of(context).size.height * 0.88,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 80,
      ),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 24, offset: const Offset(0, -8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // pull handle
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(child: CircleAvatar(radius: 5, backgroundColor: _surfaceVariant)),
          ),
          // header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Text(
                  _isEdit ? 'Edit Address' : 'Add New Address',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: _onSurface),
                ),
                const Spacer(),
                IconButton(
                  onPressed: _closeModal,
                  icon: const Icon(Icons.close, size: 22, color: _secondary),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  iconSize: 22,
                ),
              ],
            ),
          ),
          // form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // address type pills
                    _TypePills(
                      selected: _selectedType,
                      onSelect: (t) {
                        _selectedType = t;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    // label
                    _Field(
                      label: 'Label Name',
                      hint: 'e.g. Home, Basecamp SCBD',
                      controller: _labelCtrl,
                      prefixIcon: Icons.label,
                    ),
                    const SizedBox(height: 12),
                    // recipient
                    _Field(
                      label: 'Recipient Name',
                      hint: 'Full legal name',
                      controller: _nameCtrl,
                      prefixIcon: Icons.person,
                    ),
                    const SizedBox(height: 12),
                    // phone
                    _Field(
                      label: 'Phone Number',
                      hint: '+62 000 0000 0000',
                      controller: _phoneCtrl,
                      prefixIcon: Icons.call,
                    ),
                    const SizedBox(height: 12),
                    // street address
                    _Field(
                      label: 'Full Street Address & Unit',
                      hint: 'Street, Building name, floor number, postal code...',
                      controller: _addressCtrl,
                      prefixIcon: Icons.pin_drop,
                      maxLines: 3,
                      isTextArea: true,
                    ),
                    const SizedBox(height: 16),
                    // default checkbox
                    _DefaultCheckbox(
                      isDefault: _isDefault,
                      onChanged: (v) {
                        _isDefault = v;
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          // footer CTAs (pinned)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _closeModal,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _onSurface,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel',
                        style:
                            TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: _saveAddress,
                    style: FilledButton.styleFrom(
                      backgroundColor: _primaryContainer,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save Address',
                        style:
                            TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _Chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 72,
                toolbarHeight: 52,
                backgroundColor: _surface,
                elevation: 0,
                shadowColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: _buildHeader(),
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDispatchBanner(),
                    _buildTabBar(),
                  ],
                ),
              ),
              _buildAddressList(),
            ],
          ),
          if (_isDrawerOpen) _buildDrawer(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: BoxDecoration(
            color: _surface.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _openModal,
              style: FilledButton.styleFrom(
                backgroundColor: _primaryContainer,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Add New Address',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Type pill selector at the top of the drawer form.
class _TypePills extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;

  const _TypePills({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final tabs = const ['Home', 'Office', 'Locker'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Address Type', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _secondary, letterSpacing: 0.5)),
        const SizedBox(height: 8),
        Row(
          children: tabs.map((t) {
            final active = selected == t;
            return GestureDetector(
              onTap: () => onSelect(t),
              child: Container(
                width: 76,
                height: 34,
                decoration: BoxDecoration(
                  color: active ? _inverseSurface : _surfaceContainerLow,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    t,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? Colors.white : _secondary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Single form field with a label, prefix icon, and controller.
class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData prefixIcon;
  final int maxLines;
  final bool isTextArea;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.maxLines = 1,
    this.isTextArea = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _secondary,
                    letterSpacing: 0.5),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hint,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 11, color: _onSurfaceVariant),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12, color: _onSurfaceVariant),
            prefixIcon: Icon(prefixIcon, size: 20, color: _secondary),
            filled: true,
            fillColor: _surfaceContainerLow,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _surfaceVariant, width: 1)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _primaryContainer, width: 2)),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

/// Checkbox + "Set as primary address" row.
class _DefaultCheckbox extends StatelessWidget {
  final bool isDefault;
  final ValueChanged<bool> onChanged;

  const _DefaultCheckbox({required this.isDefault, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isDefault),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set as primary address',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _onSurface),
            ),
            const Spacer(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isDefault ? _inverseSurface : _surfaceContainerLow,
                shape: BoxShape.circle,
              ),
              child: isDefault
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
