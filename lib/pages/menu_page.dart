import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  // Option Flags
  bool isDelivery = true; // true = ส่งทันที, false = รับที่ร้าน

  // Dropdown States
  String address = 'คอนโด';
  final List<String> addresses = ['คอนโด', 'ที่ทำงาน', 'เพิ่มที่อยู่ใหม่'];

  String branch = 'สาขาใกล้ฉัน';
  final List<String> branches = ['สาขาใกล้ฉัน', 'สาขาบางนา', 'สาขาสยาม'];

  // Search State
  String searchQuery = '';

  // Order & Favorite State
  int cartCount = 0;
  Set<String> favorites = {};

  List<Menu> get _filteredMenus {
    if (searchQuery.isEmpty) return Menu.allMenus;
    return Menu.allMenus
        .where((m) => m.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.cream,
      body: Stack(
        children: [
          // Main Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              bottom: 180,
            ), // Prevent hiding behind navbar and cart
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),

                // Options Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildToggle(true, 'ส่งทันที', Icons.local_shipping),
                    const SizedBox(width: 20),
                    _buildToggle(false, 'รับที่ร้าน', Icons.storefront),
                  ],
                ),

                const SizedBox(height: 30),

                // แนะนำ Section (Recommended)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'แนะนำ',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'ดูทั้งหมด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(left: 20),
                    scrollDirection: Axis.horizontal,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _filteredMenus.length,
                    itemBuilder: (context, index) =>
                        _buildRecommendedCard(_filteredMenus[index]),
                  ),
                ),

                const SizedBox(height: 20),

                // ยอดนิยม Section (Popular)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ยอดนิยม',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'ดูทั้งหมด',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredMenus.length,
                  itemBuilder: (context, index) =>
                      _buildPopularCard(_filteredMenus[index]),
                ),
              ],
            ),
          ),

          // Floating Cart Pill
          if (cartCount > 0)
            Positioned(
              bottom: 120, // Ensures it's above the NavBar
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.cream,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: AppColor.primaryRed.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.shopping_cart,
                          color: AppColor.primaryRed,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$cartCount order',
                          style: const TextStyle(
                            color: AppColor.primaryRed,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Red Top Background
        Container(
          height: 190,
          decoration: const BoxDecoration(
            color: AppColor.primaryRed,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Address Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDelivery ? 'ส่งทันที' : 'รับที่ร้าน',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  DropdownButton<String>(
                    value: isDelivery ? address : branch,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    dropdownColor: AppColor.primaryRed,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    underline: const SizedBox(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          if (isDelivery) {
                            address = val;
                          } else {
                            branch = val;
                          }
                        });
                      }
                    },
                    items: (isDelivery ? addresses : branches).map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                  ),
                ],
              ),
              // Dynamic Icon
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isDelivery ? Icons.local_shipping : Icons.storefront,
                  key: ValueKey<bool>(isDelivery),
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 70,
                ),
              ),
            ],
          ),
        ),
        // Search Bar OVERLAP
        Positioned(
          bottom: -25, // Extends halfway out of the red section
          left: 20,
          right: 20,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColor.primaryRed,
                ),
                hintText: 'ค้นหา...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle(bool isDeliv, String text, IconData icon) {
    bool active = isDelivery == isDeliv;
    return GestureDetector(
      onTap: () => setState(() => isDelivery = isDeliv),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: active ? AppColor.primaryRed : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: active ? AppColor.primaryRed : Colors.grey),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: active ? AppColor.primaryRed : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCard(Menu menu) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16, bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: AppColor.primaryRed,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Image container
              Container(
                width: 90,
                padding: const EdgeInsets.all(8),
                child: Hero(
                  tag: 'rec_${menu.id}',
                  child: Image.asset(menu.imagePath, fit: BoxFit.contain),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12, top: 16, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              menu.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                menu.rating.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        menu.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 10,
                          height: 1.2,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCard(Menu menu) {
    bool isFav = favorites.contains(menu.id);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 120,
      decoration: BoxDecoration(
        color: AppColor.primaryRed,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              // Image
              Container(
                width: 100,
                padding: const EdgeInsets.all(12),
                child: Hero(
                  tag: 'pop_${menu.id}',
                  child: Image.asset(menu.imagePath, fit: BoxFit.contain),
                ),
              ),
              // Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                    right: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              menu.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  menu.rating.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        menu.description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                          height: 1.2,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Heart Top Right
          Positioned(
            top: 10,
            right: 12,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isFav) {
                    favorites.remove(menu.id);
                  } else {
                    favorites.add(menu.id);
                  }
                });
              },
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  key: ValueKey<bool>(isFav),
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
          // Add Order Bottom Right
          Positioned(
            bottom: 10,
            right: 12,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  cartCount++;
                });

                // Optional: show quick snackbar
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('เพิ่มเมนูใส่ตะกร้าเรียบร้อยแล้ว'),
                    duration: Duration(milliseconds: 1000),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Icon(
                Icons.add_circle_outline,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
