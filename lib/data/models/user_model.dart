import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.tier,
    super.isVerified,
    required super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      tier: json['tier'] as String? ?? 'Standard',
      isVerified: json['isVerified'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'tier': tier,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static UserModel get mockUser => UserModel(
        id: '1',
        name: 'Pine Developer',
        email: 'pine.dev@trapai.io',
        tier: 'PRO',
        isVerified: true,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      );
}
