class User {
  static User instance = User._internal();

  User._internal();

  String? userId;
  String? username;

  // const User({required this.userId, required this.username});

  static Map<String, dynamic> toMap(String userId, String username, String password, int isLoggedIn) {
    return {
      'user_id': userId,
      'username': username,
      'password': password,
      'is_logged_in': isLoggedIn,
    };
  }
}
