class UserData {
  final int id;
  final String name;
  final String password;
  final int egg;

  UserData(
      {required this.id,
      required this.name,
      required this.password,
      required this.egg});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'password': password};
  }
}
