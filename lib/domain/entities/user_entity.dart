class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String tier;
  final bool isVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.tier = 'Standard',
    this.isVerified = false,
    required this.createdAt,
  });

  UserEntity copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    String? tier,
    bool? isVerified,
  }) {
    return UserEntity(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tier: tier ?? this.tier,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt,
    );
  }
}
