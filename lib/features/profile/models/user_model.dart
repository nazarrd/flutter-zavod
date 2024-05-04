class UserModel {
  String? photo;
  String? fullName;
  String? email;
  bool? saveHistory;

  UserModel({
    this.photo,
    this.fullName,
    this.email,
    this.saveHistory,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    photo = json['photo'];
    fullName = json['fullName'];
    email = json['email'];
    saveHistory = json['saveHistory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['photo'] = photo;
    data['fullName'] = fullName;
    data['email'] = email;
    data['saveHistory'] = saveHistory;
    return data;
  }
}
