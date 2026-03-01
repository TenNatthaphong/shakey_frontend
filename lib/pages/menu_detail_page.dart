import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/cart_service.dart';
import 'package:shakey/services/menu_service.dart';

class MenuDetailPage extends StatefulWidget {
  final Menu menu;

  const MenuDetailPage({super.key, required this.menu});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  final MenuService _menuService = MenuService();
  final CartService _cartService = CartService.instance;
  int quantity = 1;
  String selectedSweetness = '100% Sweet';

  List<MenuSize> _sizes = [];
  MenuSize? _selectedSize;
  bool _isLoadingSizes = true;

  List<Topping> _toppings = [];
  Set<Topping> _selectedToppings = {};
  bool _isLoadingToppings = true;

  final List<String> sweetnessLevels = [
    '100% Sweet',
    '75% Sweet',
    '50% Sweet',
    '25% Sweet',
    '0% Sweet',
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final variants = await _menuService.getMenuVariants(widget.menu.id);
      final toppings = await _menuService.getToppings();
      if (mounted) {
        setState(() {
          _sizes = variants;
          if (_sizes.isNotEmpty) {
            _selectedSize = _sizes.first;
          }
          _isLoadingSizes = false;

          _toppings = toppings;
          _isLoadingToppings = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingSizes = false;
          _isLoadingToppings = false;
        });
      }
    }
  }

  int get currentTotalPrice {
    // Use base price from menu or default to sizes.last.price if not available
    double basePrice = widget.menu.price > 0
        ? widget.menu.price
        : (widget.menu.sizes.isNotEmpty ? widget.menu.sizes.last.price : 0.0);

    double upsizePrice = _selectedSize?.price ?? 0.0;

    int toppingsTotal = _selectedToppings.fold(
      0,
      (sum, topping) => sum + topping.price,
    );

    return ((basePrice.toInt() + upsizePrice.toInt() + toppingsTotal) *
        quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildHeaderImage(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleSection(),
                      const Divider(height: 32),
                      if (_isLoadingSizes)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryRed,
                            ),
                          ),
                        )
                      else if (_sizes.isNotEmpty) ...[
                        _buildSectionHeader('Size', 'Pick 1'),
                        ..._sizes.map(
                          (s) => _buildRadioItem(
                            'Size ${s.name}' +
                                (s.price > 0
                                    ? ' (+ ${_price(s.price.toInt())})'
                                    : ''),
                            s.name,
                            _selectedSize?.name ?? '',
                            (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedSize = _sizes.firstWhere(
                                    (sz) => sz.name == val,
                                  );
                                });
                              }
                            },
                          ),
                        ),
                        const Divider(height: 32),
                      ] else ...[
                        _buildSectionHeader('Size', 'Pick 1'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'ยังไม่มีข้อมูล size',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                        const Divider(height: 32),
                      ],
                      _buildSectionHeader('Sweetness Level', 'Pick 1'),
                      ...sweetnessLevels.map(
                        (s) => _buildRadioItem(
                          s,
                          s,
                          selectedSweetness,
                          (val) => setState(() => selectedSweetness = val!),
                        ),
                      ),
                      if (_isLoadingToppings)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryRed,
                            ),
                          ),
                        )
                      else if (_toppings.isNotEmpty) ...[
                        const Divider(height: 32),
                        _buildSectionHeader('Add Toppings', 'Optional'),
                        ..._toppings.map((t) => _buildCheckboxItem(t)),
                      ] else ...[
                        const Divider(height: 32),
                        _buildSectionHeader('Add Toppings', 'Optional'),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'ยังไม่มี Topping ในตอนนี้',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      _buildNoteSection(),
                      const SizedBox(height: 120), // Space for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildTopButtons(context),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return SliverToBoxAdapter(
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(color: AppColor.cream),
        child: Hero(
          tag: 'pop_${widget.menu.id}',
          child: widget.menu.imagePath.startsWith('http')
              ? Image.network(
                  widget.menu.imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) =>
                      const Icon(Icons.broken_image, size: 100),
                )
              : Image.asset(widget.menu.imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildTopButtons(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleButton(Icons.close, () => Navigator.pop(context)),
            _buildCircleButton(Icons.share_outlined, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.menu.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${widget.menu.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (widget.menu.oldPrice != null)
                  Text(
                    '\$${widget.menu.oldPrice!.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFCFCFCF),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                const Text(
                  'Base price',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.menu.oldPrice != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColor.primaryRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sell_outlined,
                  size: 14,
                  color: AppColor.primaryRed,
                ),
                const SizedBox(width: 4),
                Text(
                  '-${widget.menu.discountPercentage?.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    color: AppColor.primaryRed,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioItem(
    String label,
    String value,
    String groupValue,
    ValueChanged<String?> onChanged,
  ) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(label, style: const TextStyle(fontSize: 15)),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColor.primaryRed,
    );
  }

  Widget _buildCheckboxItem(Topping topping) {
    return CheckboxListTile(
      value: _selectedToppings.contains(topping),
      onChanged: (bool? value) {
        setState(() {
          if (value == true) {
            _selectedToppings.add(topping);
          } else {
            _selectedToppings.remove(topping);
          }
        });
      },
      title: Text(topping.name, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        '+ ${_price(topping.price)}',
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColor.primaryRed,
    );
  }

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Note to restaurant',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Optional',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: 'Add your request (subject to restaurant\'s discretion)',
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildQuantityButton(Icons.remove, () {
                    if (quantity > 1) setState(() => quantity--);
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildQuantityButton(
                    Icons.add,
                    () => setState(() => quantity++),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final detail = OrderDetail(
                      id: DateTime.now().microsecondsSinceEpoch.toString(),
                      menu: widget.menu,
                      quantity: quantity,
                      sweetness: selectedSweetness,
                      price: currentTotalPrice ~/ quantity,
                      selectedToppings: _selectedToppings.toList(),
                    );
                    _cartService.addOrderDetail(detail);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: Text(
                    'Add to Basket - ${_price(currentTotalPrice)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColor.primaryRed.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColor.primaryRed),
      ),
    );
  }

  String _price(int value) {
    return '\$${value.toString()}';
  }
}
