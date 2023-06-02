class UserModel {
  String? username;
  String? password;
  UserModel({this.username, this.password});
}

final users = [
  UserModel(username: 'admin@gmail.com', password: 'admin'),
  UserModel(username: 'user@gmail.com', password: 'user'),
];
