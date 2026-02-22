class MenuSize {
  final String name;
  final double price;

  const MenuSize({required this.name, required this.price});
}

class Menu {
  final String id;
  final String name;
  final String description;
  final double rating;
  final String imagePath;
  final List<MenuSize> sizes;

  const Menu({
    required this.id,
    required this.name,
    this.description =
        'Delicious premium drink made with high quality ingredients.',
    this.rating = 4.5,
    required this.imagePath,
    this.sizes = const [
      MenuSize(name: 'S', price: 45.0),
      MenuSize(name: 'M', price: 55.0),
      MenuSize(name: 'L', price: 65.0),
    ],
  });

  static List<Menu> get allMenus => const [
    Menu(
      id: '1',
      name: 'Chocolate',
      description:
          'Rich and creamy chocolate delight mixed with premium cocoa.',
      rating: 4.8,
      imagePath: 'assets/images/Chocolate.png',
    ),
    Menu(
      id: '2',
      name: 'Cookies & Cream',
      description: 'Sweet vanilla base loaded with chocolate cookie chunks.',
      rating: 4.9,
      imagePath: 'assets/images/Cookies_n_cream.png',
    ),
    Menu(
      id: '3',
      name: 'Matcha',
      description:
          'Authentic japanese matcha green tea balanced with sweet milk.',
      rating: 4.7,
      imagePath: 'assets/images/Matcha.png',
    ),
    Menu(
      id: '4',
      name: 'Strawberry',
      description:
          'Fresh strawberry blend perfectly mixed for a sweet and sour taste.',
      rating: 4.6,
      imagePath: 'assets/images/Strawberry.png',
    ),
    Menu(
      id: '5',
      name: 'Vanilla',
      description:
          'Classic smooth vanilla bean drink full of aromatic flavors.',
      rating: 4.5,
      imagePath: 'assets/images/Vanilla.png',
    ),
  ];
}
