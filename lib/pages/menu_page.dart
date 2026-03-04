import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/router.dart';
import 'package:shakey/services/cart_service.dart';
import 'package:shakey/services/menu_service.dart';
import 'package:shakey/services/auth_service.dart';
import 'package:shakey/services/language_service.dart';

import 'package:shakey/services/user_service.dart';
import 'package:shakey/models/user.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _menuService = MenuService.instance;
  final CartService _cartService = CartService.instance;
  final _lang = LanguageService.instance;

  // List States
  List<Address> _addresses = [];
  List<Branch> _branches = [];

  final UserService _userService = UserService.instance;

  // Filters State
  String selectedCategory = 'For You';

  static const List<String> _categoryKeys = [
    'Today\'s Offer',
    'For You',
    'Favorites',
    'Vegetarian',
    'Popular',
    'Milk Tea',
    'Fruit Tea',
  ];

  String _getCategoryLangKey(String cat) {
    if (cat == 'For You') return 'cat_for_you';
    if (cat == 'Today\'s Offer') return 'cat_today_offer';
    return 'cat_${cat.toLowerCase().replaceAll(' ', '_').replaceAll('\'', '')}';
  }

  bool isVegetarian = false;
  bool isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // Data & Search & Cart State
  List<Menu> _allMenus = [];
  bool _isLoading = true;
  String searchQuery = '';
  Set<String> favorites = {};

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartChanged);
    _menuService.addListener(_onMenuServiceChanged);
    _lang.addListener(_onLanguageChanged);
    selectedCategory = 'For You';
    _fetchMenus();
  }

  void _onLanguageChanged() {
    if (mounted) setState(() {});
  }

  void _onMenuServiceChanged() {
    if (mounted) {
      setState(() {
        favorites = _menuService.favoriteIds;
      });
    }
  }

  Future<void> _fetchMenus() async {
    final fetched = await _menuService.getMenus();
    final favIds = await _menuService.getFavoriteIds();
    final addr = await _userService.getAddresses();
    final br = await _menuService.getBranches();

    if (mounted) {
      setState(() {
        _allMenus = fetched;
        _isLoading = false;
        favorites = favIds.toSet();
        _addresses = addr;
        _branches = br;

        // Initial defaults if nothing is selected yet
        if (_cartService.selectedAddress == null && _addresses.isNotEmpty) {
          _cartService.setSelectedAddress(_addresses.first);
        }
        if (_cartService.selectedBranch == null && _branches.isNotEmpty) {
          _cartService.setSelectedBranch(_branches.first);
        }
      });
    }
  }

  Future<void> _refreshAddresses() async {
    final addr = await _userService.getAddresses();
    if (mounted) {
      setState(() {
        _addresses = addr;
        // Keep selection if it still exists, otherwise reset
        if (_cartService.selectedAddress != null &&
            !_addresses.any((a) => a.id == _cartService.selectedAddress!.id)) {
          _cartService.setSelectedAddress(
            _addresses.isNotEmpty ? _addresses.first : null,
          );
        } else if (_cartService.selectedAddress == null &&
            _addresses.isNotEmpty) {
          _cartService.setSelectedAddress(_addresses.first);
        }
      });
    }
  }

  List<Menu> get _filteredMenus {
    List<Menu> menus = _allMenus;

    // Filter by Vegetarian
    if (isVegetarian) {
      menus = menus.where((m) => m.categories.contains('Vegetarian')).toList();
    }

    if (searchQuery.isNotEmpty) {
      menus = menus
          .where(
            (m) => m.name.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Filter by category logic (For You is default)
    if (selectedCategory == 'Favorites') {
      menus = menus.where((m) => favorites.contains(m.id)).toList();
    } else if (selectedCategory != 'For You') {
      menus = menus
          .where((m) => m.categories.contains(selectedCategory))
          .toList();
    }
    return menus;
  }

  @override
  void dispose() {
    _lang.removeListener(_onLanguageChanged);
    _cartService.removeListener(_onCartChanged);
    _menuService.removeListener(_onMenuServiceChanged);
    _searchController.dispose();
    super.dispose();
  }

  int get cartCount => _cartService.itemCount;

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  bool _isFavorite(Menu menu) => _menuService.favoriteIds.contains(menu.id);

  Future<void> _toggleFavorite(Menu menu) async {
    if (!AuthService.instance.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.get('login_fav_error')),
          backgroundColor: AppColor.primaryRed,
        ),
      );
      return;
    }

    final result = await _menuService.toggleFavorite(
      menu.id,
      _isFavorite(menu),
    );

    if (mounted) {
      if (result['success'] == true) {
        // UI will update via listener
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${result['message'] ?? 'Unknown error'}'),
            backgroundColor: AppColor.primaryRed,
          ),
        );
      }
    }
  }

  void _openCartPage() {
    Navigator.pushNamed(context, AppRoutes.cartPage);
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: AppColor.cream,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    if (selectedCategory == 'Today\'s Offer' ||
                        (selectedCategory == 'For You' && searchQuery.isEmpty))
                      _buildTodayOfferSection(),
                    _isLoading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColor.primaryRed,
                              ),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (searchQuery.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    8,
                                    16,
                                    16,
                                  ),
                                  child: Text(
                                    _lang.get(
                                      _getCategoryLangKey(selectedCategory),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              _buildMenuGrid(),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
          if (cartCount > 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: padding.bottom + 24,
              child: Center(child: _buildCartPill()),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 310,
      child: Stack(
        children: [
          // Background Red Area with Curve
          ClipPath(
            clipper: _MenuHeaderClipper(),
            child: Container(height: 260, color: AppColor.primaryRed),
          ),
          // Header Content
          Padding(
            padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _lang.get('order'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _lang.get(
                            _cartService.isDelivery ? 'deliver_now' : 'pick_up',
                          ),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        PopupMenuButton<dynamic>(
                          padding: EdgeInsets.zero,
                          offset: const Offset(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onSelected: (value) {
                            if (value == 'add_new') {
                              _showAddressForm(null);
                            } else if (value is Address) {
                              _cartService.setSelectedAddress(value);
                            } else if (value is Branch) {
                              _cartService.setSelectedBranch(value);
                            }
                          },
                          itemBuilder: (context) {
                            if (_cartService.isDelivery) {
                              return [
                                ..._addresses.map(
                                  (addr) => PopupMenuItem<Address>(
                                    value: addr,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 18,
                                          color:
                                              _cartService
                                                      .selectedAddress
                                                      ?.id ==
                                                  addr.id
                                              ? AppColor.primaryRed
                                              : Colors.grey,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            addr.name,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontWeight:
                                                  _cartService
                                                          .selectedAddress
                                                          ?.id ==
                                                      addr.id
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit_outlined,
                                            size: 18,
                                            color: Colors.blueGrey,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _showAddressForm(addr);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_addresses.isNotEmpty)
                                  const PopupMenuDivider(),
                                PopupMenuItem<String>(
                                  value: 'add_new',
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: AppColor.primaryRed.withValues(
                                            alpha: 0.1,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          size: 16,
                                          color: AppColor.primaryRed,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        _lang.get('add_new_address'),
                                        style: const TextStyle(
                                          color: AppColor.primaryRed,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ];
                            } else {
                              return _branches
                                  .map(
                                    (br) => PopupMenuItem<Branch>(
                                      value: br,
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.storefront,
                                            size: 18,
                                            color:
                                                _cartService
                                                        .selectedBranch
                                                        ?.id ==
                                                    br.id
                                                ? AppColor.primaryRed
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              br.detail,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight:
                                                    _cartService
                                                            .selectedBranch
                                                            ?.id ==
                                                        br.id
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            margin: const EdgeInsets.only(top: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    _cartService.isDelivery
                                        ? (_cartService.selectedAddress?.name ??
                                              _lang.get('select_address'))
                                        : (_cartService
                                                  .selectedBranch
                                                  ?.detail ??
                                              _lang.get('select_branch')),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      _cartService.isDelivery
                          ? Icons.directions_car
                          : Icons.storefront,
                      color: Colors.white.withValues(alpha: 0.3),
                      size: 80,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Overlapping Filter Box / Search Bar
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isSearching
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(width: 16),
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: Center(
                                child: Icon(
                                  Icons.search,
                                  color: AppColor.primaryRed,
                                  size: 22,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (val) =>
                                    setState(() => searchQuery = val),
                                decoration: InputDecoration(
                                  hintText: _lang.get('search_hint'),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                splashRadius: 20,
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () {
                                  setState(() {
                                    isSearching = false;
                                    searchQuery = '';
                                    _searchController.clear();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        )
                      : Row(
                          children: [
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => setState(() => isSearching = true),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            // For You Dropdown
                            Expanded(
                              child: PopupMenuButton<String>(
                                onSelected: (String cat) {
                                  setState(() => selectedCategory = cat);
                                },
                                itemBuilder: (BuildContext context) {
                                  return _categoryKeys.map((String cat) {
                                    return PopupMenuItem<String>(
                                      value: cat,
                                      child: Text(
                                        _lang.get(_getCategoryLangKey(cat)),
                                      ),
                                    );
                                  }).toList();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _lang.get(
                                            _getCategoryLangKey(
                                              selectedCategory,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            color: AppColor.primaryRed,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppColor.primaryRed,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            // Vegetarian Toggle
                            GestureDetector(
                              onTap: () =>
                                  setState(() => isVegetarian = !isVegetarian),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.eco_outlined,
                                      color: isVegetarian
                                          ? AppColor.primaryRed
                                          : Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      _lang.get('vegetarian'),
                                      style: TextStyle(
                                        color: isVegetarian
                                            ? AppColor.primaryRed
                                            : Colors.grey,
                                        fontWeight: isVegetarian
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 12),
                // Delivery Mode Togglepill
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildModeToggleButton(
                      _lang.get('deliver_now'),
                      Icons.directions_car,
                      _cartService.isDelivery,
                      () => _cartService.setDeliveryMode(true),
                    ),
                    const SizedBox(width: 16),
                    _buildModeToggleButton(
                      _lang.get('pick_up'),
                      Icons.storefront,
                      !_cartService.isDelivery,
                      () => _cartService.setDeliveryMode(false),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeToggleButton(
    String label,
    IconData icon,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive ? AppColor.primaryRed : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColor.primaryRed : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColor.primaryRed : Colors.grey,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dropdown menus are now handled by PopupMenuButton inline in the header

  void _showAddressForm(Address? existing) {
    final nameController = TextEditingController(text: existing?.name);
    final detailController = TextEditingController(text: existing?.detail);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          existing == null
              ? _lang.get('add_address_title')
              : _lang.get('edit_address_title'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: _lang.get('address_name')),
            ),
            TextField(
              controller: detailController,
              decoration: InputDecoration(
                labelText: _lang.get('detail_address'),
              ),
            ),
          ],
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () async {
                final success = await _userService.deleteAddress(existing.id);
                if (success) {
                  await _refreshAddresses();
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.pop(context); // Also close sheet
                  }
                }
              },
              child: Text(
                _lang.get('delete'),
                style: const TextStyle(color: Colors.red),
              ),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty || detailController.text.isEmpty)
                return;

              bool success;
              if (existing == null) {
                success = await _userService.addAddress(
                  nameController.text,
                  detailController.text,
                );
              } else {
                success = await _userService.updateAddress(
                  existing.id,
                  nameController.text,
                  detailController.text,
                );
              }

              if (success) {
                await _refreshAddresses();
                if (context.mounted) {
                  Navigator.pop(context);
                  if (existing != null)
                    Navigator.pop(context); // Close sheet if editing
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayOfferSection() {
    final offers = _allMenus
        .where((m) => m.categories.contains('Today\'s Offer'))
        .toList();
    if (offers.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Offer",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => selectedCategory = 'Today\'s Offer'),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: AppColor.primaryRed,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: offers.length,
            itemBuilder: (context, index) => _buildOfferCard(offers[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildOfferCard(Menu menu) {
    bool isFav = _isFavorite(menu);

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: menu.imagePath.startsWith('http')
                      ? Image.network(
                          menu.imagePath,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) =>
                              const Icon(Icons.broken_image, size: 40),
                        )
                      : Image.asset(
                          menu.imagePath,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        menu.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        menu.description,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '\$${menu.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (menu.oldPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\$${menu.oldPrice!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFCFCFCF),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColor.primaryRed.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.sell_outlined,
                                    size: 10,
                                    color: AppColor.primaryRed,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '-${menu.discountPercentage?.toStringAsFixed(0)}%',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColor.primaryRed,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const Spacer(),
                          GestureDetector(
                            onTap: () => _cartService.addMenu(menu),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColor.primaryRed,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _toggleFavorite(menu),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppColor.primaryRed : Colors.grey.shade400,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    final menus = _filteredMenus;

    if (menus.isEmpty && searchQuery.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Text(
            _lang.t(
              'No items found in this category.',
              'ไม่พบรายการในหมวดหมู่นี้',
            ),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 16,
        mainAxisSpacing: 24,
      ),
      itemCount: menus.length,
      itemBuilder: (context, index) => _buildMenuCard(menus[index]),
    );
  }

  Widget _buildMenuCard(Menu menu) {
    bool isFav = _isFavorite(menu);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.menuDetailPage,
                    arguments: menu,
                  ).then((_) => _fetchMenus());
                },
                borderRadius: BorderRadius.circular(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColor.cream,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: menu.imagePath.startsWith('http')
                                  ? Image.network(
                                      menu.imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                    )
                                  : Image.asset(
                                      menu.imagePath,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          // Badge
                          if (menu.badge != null)
                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryRed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  menu.badge!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          // Add button (RESTORED to image stack)
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _cartService.addMenu(menu),
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: const BoxDecoration(
                                    color: AppColor.primaryRed,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Text Section
                    Text(
                      menu.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${menu.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: AppColor.primaryRed,
                              ),
                            ),
                            if (menu.oldPrice != null)
                              Row(
                                children: [
                                  Text(
                                    '\$${menu.oldPrice!.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFCFCFCF),
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // Discount Badge (RESTORED)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColor.primaryRed.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '-${menu.discountPercentage?.toStringAsFixed(0)}%',
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        // Rating (RESTORED)
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFFFB200),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              menu.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Favorite button (SIBLING for hit test priority)
          Positioned(
            top: 14,
            right: 14,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _toggleFavorite(menu),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? AppColor.primaryRed : Colors.grey.shade400,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartPill() {
    if (cartCount == 0) return const SizedBox.shrink();
    return GestureDetector(
      onTap: _openCartPage,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppColor.primaryRed,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              '$cartCount order',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Move up the starting point on the left side
    path.lineTo(0, size.height - 50);

    // Arch upwards in the middle
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 90,
      size.width,
      size.height - 45,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
