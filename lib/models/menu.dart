class MenuSize {
  final String name;
  final double price;

  const MenuSize({required this.name, required this.price});

  factory MenuSize.fromJson(Map<String, dynamic> json) {
    return MenuSize(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
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
    return UserReward(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      rewardId: json['reward_id'] as String,
      status: json['reward_status'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      usedAt: json['used_at'] != null
          ? DateTime.parse(json['used_at'] as String)
          : null,
      reward: json['reward'] != null
          ? MenuReward.fromJson(json['reward'] as Map<String, dynamic>)
          : null,
    );
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
      id: (json['reward_id'] as String?) ?? '',
      name: (json['name'] as String?) ?? 'Untitled',
      image: json['image'] as String?,
      points: (json['require_point'] as int?) ?? 0,
      description: json['description'] as String?,
      expDate: json['exp_date'] as String?,
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
    this.sizes = const [
      MenuSize(name: 'S', price: 45.0),
      MenuSize(name: 'M', price: 55.0),
      MenuSize(name: 'L', price: 65.0),
    ],
    this.categories = const ['Milk Tea'],
    this.favorite = false,
  });

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
  final int quantity;
  final String sweetness;
  final int price;
  final List<Topping> selectedToppings;

  const OrderDetail({
    required this.id,
    required this.menu,
    required this.quantity,
    required this.sweetness,
    required this.price,
    this.selectedToppings = const [],
  });

  // Helper to calculate total price
  int get totalPrice {
    int toppingsSum = selectedToppings.fold(0, (sum, t) => sum + t.price);
    return (price + toppingsSum) * quantity;
  }
}

class Order {
  final String id;
  final bool delivery;
  final List<OrderDetail> items;

  const Order({required this.id, required this.delivery, required this.items});
}
