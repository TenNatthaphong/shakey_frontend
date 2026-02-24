import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/router.dart';
import 'package:shakey/services/cart_service.dart';
import 'package:shakey/services/menu_service.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _menuService = MenuService();
  final CartService _cartService = CartService.instance;

  // Option Flags
  bool isDelivery = true; // true = Deliver now, false = Pick up

  // Dropdown States
  String address = 'Condo';
  final List<String> addresses = ['Condo', 'Workplace', 'Add new address'];

  String branch = 'Nearest Branch';
  final List<String> branches = [
    'Nearest Branch',
    'Bangna Branch',
    'Siam Branch',
  ];

  // Filters State
  String selectedCategory = 'For You';
  final List<String> categories = [
    'Today\'s Offer',
    'For You',
    'Favorites',
    'Vegetarian',
    'Popular',
    'Milk Tea',
    'Fruit Tea',
  ];
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
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    final fetched = await _menuService.getMenus();
    if (mounted) {
      setState(() {
        _allMenus = fetched;
        _isLoading = false;
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
    _cartService.removeListener(_onCartChanged);
    _searchController.dispose();
    super.dispose();
  }

  int get cartCount => _cartService.itemCount;

  void _onCartChanged() {
    if (mounted) setState(() {});
  }

  bool _isFavorite(Menu menu) => favorites.contains(menu.id);

  void _toggleFavorite(Menu menu) {
    setState(() {
      if (!_isFavorite(menu)) {
        favorites.add(menu.id);
      } else {
        favorites.remove(menu.id);
      }
    });
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
                                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                                  child: Text(
                                    selectedCategory == 'For You'
                                        ? 'For You'
                                        : selectedCategory,
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
      height: 275,
      child: Stack(
        children: [
          // Background Red Area with Curve
          ClipPath(
            clipper: _MenuHeaderClipper(),
            child: Container(height: 220, color: AppColor.primaryRed),
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
                        const Text(
                          'Order',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isDelivery ? 'Deliver now' : 'Pick up',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text(
                              '[location]',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Icon(
                      isDelivery ? Icons.directions_car : Icons.storefront,
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
                                decoration: const InputDecoration(
                                  hintText: 'Search...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
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
                                  return categories.map((String cat) {
                                    return PopupMenuItem<String>(
                                      value: cat,
                                      child: Text(cat),
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
                                          selectedCategory,
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
                                      'Vegetarian',
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
                      'Deliver now',
                      Icons.directions_car,
                      isDelivery,
                      () => setState(() => isDelivery = true),
                    ),
                    const SizedBox(width: 16),
                    _buildModeToggleButton(
                      'Pick up',
                      Icons.storefront,
                      !isDelivery,
                      () => setState(() => isDelivery = false),
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
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
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
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '[price]',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (menu.oldPrice != null) ...[
                      const SizedBox(width: 6),
                      const Text(
                        '[price]',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFCFCFCF),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.sell_outlined,
                        size: 14,
                        color: Color(0xFFF37552),
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
    );
  }

  Widget _buildMenuGrid() {
    final menus = _filteredMenus;

    if (menus.isEmpty && searchQuery.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Text(
            'No items found in this category.',
            style: TextStyle(color: Colors.grey, fontSize: 16),
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
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.menuDetailPage, arguments: menu);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(menu.imagePath, fit: BoxFit.cover),
                  ),
                ),
                // Badge
                if (menu.badge != null)
                  Positioned(
                    top: 10,
                    left: 10,
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
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => _toggleFavorite(menu),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorite(menu)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _isFavorite(menu)
                            ? AppColor.primaryRed
                            : Colors.grey.shade500,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                // Add button
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Text Section
          Text(
            menu.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                '[price]',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (menu.oldPrice != null) ...[
                const SizedBox(width: 6),
                const Text(
                  '[price]',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFCFCFCF),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const Spacer(),
              const Icon(
                Icons.star_rounded,
                size: 16,
                color: Color(0xFFFFB200),
              ),
              const SizedBox(width: 3),
              Text(
                menu.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
            ],
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
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
