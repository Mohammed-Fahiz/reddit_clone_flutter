class UserModel {
  final String name;
  final String profilePic;
  final String banner;
  final bool isGuest;
  final List<String> awards;
  final int karma;
  final String uid;

  const UserModel({
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.isGuest,
    required this.awards,
    required this.karma,
    required this.uid,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    bool? isGuest,
    List<String>? awards,
    int? karma,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      isGuest: isGuest ?? this.isGuest,
      awards: awards ?? this.awards,
      karma: karma ?? this.karma,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'isGuest': isGuest,
      'awards': awards,
      'karma': karma,
      'uid': uid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      banner: map['banner'] as String,
      isGuest: map['isGuest'] as bool,
      awards: List<String>.from(map["awards"]),
      karma: map['karma'] as int,
      uid: map['uid'] as String,
    );
  }
}
