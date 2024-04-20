class UserModel {
  String? name;
  String? mobileNumber;
  String? address;
  String? gender;
  int? age;

  UserModel({
    this.name,
    this.mobileNumber,
    this.address,
    this.gender,
    this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      mobileNumber: json['mobileNumber'],
      address: json['address'],
      gender: json['gender'],
      age: json['age'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobileNumber'] = this.mobileNumber;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['age'] = this.age;
    return data;
  }
}
