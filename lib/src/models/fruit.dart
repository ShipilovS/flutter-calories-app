class UserFruit {
  final int id;
  final String name;
  final String size_gram;
  final String kilocalories;

  const UserFruit({
    required this.id,
    required this.name,
    required this.size_gram,
    required this.kilocalories
  });

  factory UserFruit.fromJson(Map<String, dynamic> json) {
    return UserFruit(
      id:           json['id'],
      name:         json['name']           == null ? "" : json['name'],
      size_gram:    json['size_gram']      == null ? "" : json['size_gram'],
      kilocalories: json['kilocalories']   == null ? "" : json['kilocalories'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'size_gram': size_gram,
      'kilocalories': kilocalories,
    };
  }

}