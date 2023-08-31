class User {
  String userId;
  String username;
  String email;
  String avatar;
  String password;
  String birthdate;
  String registeredAt;
  User(this.userId, this.username, this.email, this.avatar, this.password, this.birthdate, this.registeredAt);

  User.fromMap(Map<String, dynamic> map)
    : userId = map['userId'],
    username = map['username'],
    email = map['email'],
    avatar = map['avatar'],
    password = map['password'],
    birthdate = map['birthdate'],
    registeredAt = map['registeredAt'];
}
