enum MemberLevel { Bronze, Silver, Gold }

class User {
  final String userId;
  final String email;
  final String? username;
  final String? firstname;
  final String? lastname;
  final String? phone;
  final DateTime? birthday;
  final int point;
  final int totalCupsPurchased;
  final MemberLevel member;

  const User({
    required this.userId,
    required this.email,
    this.username,
    this.firstname,
    this.lastname,
    this.phone,
    this.birthday,
    required this.point,
    required this.totalCupsPurchased,
    required this.member,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: (json['user_id'] as String?) ?? '',
      email: (json['email'] as String?) ?? '',
      username: json['username'] as String?,
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      phone: json['phone'] as String?,
      birthday: json['birthday'] != null
          ? DateTime.parse(json['birthday'] as String)
          : null,
      point: (json['point'] as int?) ?? 0,
      totalCupsPurchased: (json['total_cups_purchased'] as int?) ?? 0,
      member: _parseMemberLevel((json['member'] as String?) ?? 'Bronze'),
    );
  }

  static MemberLevel _parseMemberLevel(String level) {
    switch (level.toLowerCase()) {
      case 'bronze':
        return MemberLevel.Bronze;
      case 'silver':
        return MemberLevel.Silver;
      case 'gold':
        return MemberLevel.Gold;
      default:
        return MemberLevel.Bronze;
    }
  }
}

class Address {
  final String id;
  final String name;
  final String detail;

  const Address({required this.id, required this.name, required this.detail});

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['address_id'] ?? '',
      name: json['name'] ?? '',
      detail: json['detail'] ?? '',
    );
  }
}

class Branch {
  final String id;
  final String detail;

  const Branch({required this.id, required this.detail});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(id: json['branch_id'] ?? '', detail: json['detail'] ?? '');
  }
}
