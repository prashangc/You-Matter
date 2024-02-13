class RegisterModel {
  String? name;
  String? email;
  String? password;
  String? phone;
  String? passwordConfirmation;

  RegisterModel({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.passwordConfirmation,
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
    passwordConfirmation = json['password_confirmation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['password_confirmation'] = passwordConfirmation;
    return data;
  }
}
