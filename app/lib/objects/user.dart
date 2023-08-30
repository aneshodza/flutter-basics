class User {
  String username;
  String email;
  String avatar;
  String password;
  String birthdate;
  String registeredAt;
  User(this.username, this.email, this.avatar, this.password, this.birthdate, this.registeredAt);

  User.fromMap(Map<String, dynamic> map)
    : username = map['username'],
    email = map['email'],
    avatar = map['avatar'],
    password = map['password'],
    birthdate = map['birthdate'],
    registeredAt = map['registeredAt'];
}
