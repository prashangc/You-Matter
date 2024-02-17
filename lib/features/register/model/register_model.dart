class RegisterModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? therapistCategory;
  String? passwordConfirmation;

  RegisterModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.therapistCategory,
    this.passwordConfirmation,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    therapistCategory = json['therapistCategory'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['therapistCategory'] = therapistCategory;
    data['password_confirmation'] = passwordConfirmation;
    return data;
  }
}
