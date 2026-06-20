class UserModel {
  const UserModel({
    required this.userId,
    required this.displayName,
    required this.photoUrl,
    required this.phone,
    required this.nationality,
    required this.age,
    required this.languages,
    required this.interests,
    required this.travelStyle,
    required this.budgetLevel,
    required this.bio,
    required this.rating,
    required this.ratingCount,
    required this.isVerified,
    required this.blockedUsers,
    required this.createdAt,
    required this.lastActive,
  });

  final String userId;
  final String displayName;
  final String photoUrl;
  final String phone;
  final String nationality;
  final int age;
  final List<String> languages;
  final List<String> interests;
  final String travelStyle; // "CHILL" | "MODERATE" | "ADVENTURE"
  final String budgetLevel; // "BUDGET" | "MODERATE" | "LUXURY"
  final String bio;
  final double rating;
  final int ratingCount;
  final bool isVerified;
  final List<String> blockedUsers;
  final DateTime? createdAt;
  final DateTime? lastActive;

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      userId: data['userId'] ?? data['_id'] ?? '',
      displayName: data['displayName'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      phone: data['phone'] ?? '',
      nationality: data['nationality'] ?? '',
      age: (data['age'] ?? 0).toInt(),
      languages: List<String>.from(data['languages'] ?? []),
      interests: List<String>.from(data['interests'] ?? []),
      travelStyle: data['travelStyle'] ?? 'MODERATE',
      budgetLevel: data['budgetLevel'] ?? 'MODERATE',
      bio: data['bio'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      ratingCount: (data['ratingCount'] ?? 0).toInt(),
      isVerified: data['isVerified'] ?? false,
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
      createdAt: data['createdAt'] != null ? DateTime.tryParse(data['createdAt'].toString()) : null,
      lastActive: data['lastActive'] != null ? DateTime.tryParse(data['lastActive'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phone': phone,
      'nationality': nationality,
      'age': age,
      'languages': languages,
      'interests': interests,
      'travelStyle': travelStyle,
      'budgetLevel': budgetLevel,
      'bio': bio,
      'rating': rating,
      'ratingCount': ratingCount,
      'isVerified': isVerified,
      'blockedUsers': blockedUsers,
      'createdAt': createdAt?.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    String? nationality,
    int? age,
    List<String>? languages,
    List<String>? interests,
    String? travelStyle,
    String? budgetLevel,
    String? bio,
    double? rating,
    int? ratingCount,
    bool? isVerified,
    List<String>? blockedUsers,
  }) {
    return UserModel(
      userId: userId,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phone: phone,
      nationality: nationality ?? this.nationality,
      age: age ?? this.age,
      languages: languages ?? this.languages,
      interests: interests ?? this.interests,
      travelStyle: travelStyle ?? this.travelStyle,
      budgetLevel: budgetLevel ?? this.budgetLevel,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isVerified: isVerified ?? this.isVerified,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      createdAt: createdAt,
      lastActive: lastActive,
    );
  }
}
