class UserModel {
  int id;
  String name;
  String email;
  String password;
  String apiToken;
  String isAdmin;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.apiToken,
      this.isAdmin});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    apiToken = json['api_token'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['api_token'] = this.apiToken;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}
