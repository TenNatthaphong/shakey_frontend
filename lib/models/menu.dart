class MenuSize {
  final String variantId;
  final String name;
  final double price;

  const MenuSize({
    required this.variantId,
    required this.name,
    required this.price,
  });

  factory MenuSize.fromJson(Map<String, dynamic> json) {
    return MenuSize(
      variantId: (json['variant_id'] ?? '') as String,
      name: (json['size'] ?? '') as String,
      price: (json['price_upsize'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Topping {
  final String id;
  final String name;
  final int price;

  const Topping({required this.id, required this.name, required this.price});

  factory Topping.fromJson(Map<String, dynamic> json) {
    return Topping(
      id: (json['topping_id'] as String?) ?? '',
      name: (json['name'] as String?) ?? '',
      price: (json['price'] as int?) ?? 0,
    );
  }
}

class UserReward {
  final String id;
  final String userId;
  final String rewardId;
  final String status; // ACTIVE, USED, EXPIRED
  final DateTime? createdAt;
  final DateTime? usedAt;
  final MenuReward? reward;

  const UserReward({
    required this.id,
    required this.userId,
    required this.rewardId,
    required this.status,
    this.createdAt,
    this.usedAt,
    this.reward,
  });

  factory UserReward.fromJson(Map<String, dynamic> json) {
    try {
      return UserReward(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        rewardId: json['reward_id']?.toString() ?? '',
        status: json['reward_status']?.toString() ?? 'ACTIVE',
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        usedAt: json['used_at'] != null
            ? DateTime.tryParse(json['used_at'].toString())
            : null,
        reward: json['reward'] != null
            ? MenuReward.fromJson(json['reward'] as Map<String, dynamic>)
            : null,
      );
    } catch (e) {
      print('Error parsing UserReward: $e');
      print('JSON data: $json');
      rethrow;
    }
  }
}

class MenuReward {
  final String id;
  final String name;
  final String? image;
  final int points;
  final String? description;
  final String? expDate;

  const MenuReward({
    required this.id,
    required this.name,
    this.image,
    required this.points,
    this.description,
    this.expDate,
  });

  factory MenuReward.fromJson(Map<String, dynamic> json) {
    return MenuReward(
      id: (json['reward_id'] ?? json['id'])?.toString() ?? '',
      name: json['name']?.toString() ?? 'Untitled',
      image: json['image']?.toString(),
      points: int.tryParse(json['require_point']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      expDate: json['exp_date']?.toString(),
    );
  }
}

class Menu {
  final String id;
  final String name;
  final String description;
  final double rating;
  final String imagePath;
  final double price; // Base price from schema
  final double? oldPrice; // Original price for discount display
  final double? discountPercentage; // Discount percentage
  final String? badge; // e.g., 'Most ordered', 'Most liked'
  final List<MenuSize> sizes;
  final List<String> categories;
  final bool favorite;

  const Menu({
    required this.id,
    required this.name,
    this.description =
        'Delicious premium drink made with high quality ingredients.',
    this.rating = 4.5,
    required this.imagePath,
    this.price = 0.0,
    this.oldPrice,
    this.discountPercentage,
    this.badge,
    this.sizes = const [],
    this.categories = const ['Milk Tea'],
    this.favorite = false,
  });

  Menu copyWith({
    String? id,
    String? name,
    String? description,
    double? rating,
    String? imagePath,
    double? price,
    double? oldPrice,
    double? discountPercentage,
    String? badge,
    List<MenuSize>? sizes,
    List<String>? categories,
    bool? favorite,
  }) {
    return Menu(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      imagePath: imagePath ?? this.imagePath,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      badge: badge ?? this.badge,
      sizes: sizes ?? this.sizes,
      categories: categories ?? this.categories,
      favorite: favorite ?? this.favorite,
    );
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    final double basePrice = (json['base_price'] as num?)?.toDouble() ?? 0.0;
    final double discount = (json['discount'] as num?)?.toDouble() ?? 0.0;

    double currentPrice = basePrice;
    double? previousPrice;
    double? calculatedPercentage;

    if (discount > 0 && basePrice > 0) {
      currentPrice = basePrice - (basePrice * (discount / 100));
      previousPrice = basePrice;
      calculatedPercentage = discount;
    }

    return Menu(
      id: json['menu_id'] as String? ?? '',
      name: json['flavor'] as String? ?? 'Untitled',
      description: json['flavor'] as String? ?? 'Delicious drink',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      imagePath: json['image'] as String? ?? '',
      price: currentPrice,
      oldPrice: previousPrice,
      discountPercentage: calculatedPercentage,
      badge: json['badge'] as String?,
      favorite: json['favorite'] as bool? ?? false,
      sizes: const [], // Variants fetched separately or via Service
      categories:
          (json['categories'] as List?)?.map((e) => e.toString()).toList() ??
          ['Milk Tea'],
    );
  }

  static List<Menu> get allMenus => const [
    Menu(
      id: '11',
      name: '[name]',
      description: 'Placeholder description',
      rating: 5.0,
      imagePath: 'assets/images/Chocolate.png',
      price: 0.0,
      oldPrice: 0.0,
      categories: ['Today\'s Offer', 'Popular'],
    ),
    Menu(
      id: '1',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.8,
      imagePath: 'assets/images/Chocolate.png',
      price: 0.0,
      badge: 'Most ordered',
      categories: ['Popular', 'Fruit Tea', 'For You'],
    ),
    Menu(
      id: '2',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.9,
      imagePath: 'assets/images/Cookies_n_cream.png',
      price: 0.0,
      badge: 'Most ordered',
      categories: ['Popular', 'For You'],
    ),
    Menu(
      id: '3',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.7,
      imagePath: 'assets/images/Matcha.png',
      price: 0.0,
      badge: 'Most liked',
      categories: ['Vegetarian', 'Milk Tea', 'For You'],
    ),
    Menu(
      id: '4',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.6,
      imagePath: 'assets/images/Strawberry.png',
      price: 0.0,
      badge: 'Most ordered',
      categories: ['For You', 'Milk Tea'],
    ),
    Menu(
      id: '5',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.5,
      imagePath: 'assets/images/Vanilla.png',
      price: 0.0,
      categories: ['Fruit Tea', 'Popular'],
    ),
    Menu(
      id: '6',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.9,
      imagePath: 'assets/images/Chocolate.png',
      price: 0.0,
      categories: ['Fruit Tea'],
    ),
    Menu(
      id: '7',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.8,
      imagePath: 'assets/images/Chocolate.png',
      price: 0.0,
      categories: ['Fruit Tea'],
    ),
    Menu(
      id: '8',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.7,
      imagePath: 'assets/images/Strawberry.png',
      price: 0.0,
      badge: 'Most ordered',
      categories: ['Fruit Tea', 'Popular'],
    ),
    Menu(
      id: '9',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.6,
      imagePath: 'assets/images/Strawberry.png',
      price: 0.0,
      categories: ['Fruit Tea'],
    ),
    Menu(
      id: '10',
      name: '[name]',
      description: 'Placeholder description',
      rating: 4.5,
      imagePath: 'assets/images/Chocolate.png',
      price: 0.0,
      categories: ['Fruit Tea'],
    ),
  ];
}

class OrderDetail {
  final String id;
  final Menu menu;
  final MenuSize? variant;
  final int quantity;
  final String sweetness;
  final int price;
  final String? note;
  final List<Topping> selectedToppings;

  const OrderDetail({
    required this.id,
    required this.menu,
    this.variant,
    required this.quantity,
    required this.sweetness,
    required this.price,
    this.note,
    this.selectedToppings = const [],
  });

  // Helper to calculate total price
  int get totalPrice {
    int toppingsSum = selectedToppings.fold(0, (sum, t) => sum + t.price);
    return (price + toppingsSum) * quantity;
  }

  Map<String, dynamic> toJson() {
    // Map '100% Sweet' to 'Sweet_100' for Prisma enum
    String mappedSweetness = 'Sweet_100';
    if (sweetness.contains('0%'))
      mappedSweetness = 'Sweet_0';
    else if (sweetness.contains('25%'))
      mappedSweetness = 'Sweet_25';
    else if (sweetness.contains('50%'))
      mappedSweetness = 'Sweet_50';
    else if (sweetness.contains('75%'))
      mappedSweetness = 'Sweet_75';

    return {
      'variant_id': variant?.variantId,
      'quantity': quantity,
      'sweetness': mappedSweetness,
      'price': price,
      'note': note,
      'topping_ids': selectedToppings.map((t) => t.id).toList(),
    };
  }

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      id: json['order_detail_id'] ?? '',
      menu: json['variant']?['menu'] != null
          ? Menu.fromJson(json['variant']['menu'])
          : Menu(id: '', name: 'Deleted Item', imagePath: ''),
      variant: json['variant'] != null
          ? MenuSize.fromJson(json['variant'])
          : null,
      quantity: json['quantity'] ?? 1,
      sweetness: json['sweetness'] != null
          ? '${json['sweetness'].toString().replaceAll('Sweet_', '')}%'
          : '100%',
      price: json['price'] ?? 0,
      note: json['note'],
    );
  }
}

class Order {
  final String id;
  final bool delivery;
  final int totalPrice;
  final List<OrderDetail> items;
  final DateTime? createdAt;

  const Order({
    required this.id,
    required this.delivery,
    required this.items,
    this.totalPrice = 0,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['order_id'] ?? '',
      delivery: json['delivery'] ?? false,
      totalPrice: json['total_price'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      items:
          (json['order_details'] as List?)
              ?.map((e) => OrderDetail.fromJson(e))
              .toList() ??
          [],
    );
  }
}
