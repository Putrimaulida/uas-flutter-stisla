import 'dart:convert';

class LoginError {
  String? message;
  Errors? errors;

  LoginError({this.message, this.errors});

  LoginError.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    errors =
        json['errors'] != null ? new Errors.fromJson(json['errors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.errors != null) {
      data['errors'] = this.errors!.toJson();
    }
    return data;
  }
}

class Errors {
  List<String>? email;
  List<String>? password;
  List<String>? deviceName;

  Errors({this.email, this.password, this.deviceName});

  Errors.fromJson(Map<String, dynamic> json) {
    if (json['email'] != null) {
      email = List.from(json['email']);
    }
    if (json['password'] != null) {
      password = List.from(json['password']);
    }
    if (json['device_name'] != null) {
      deviceName = List.from(json['device_name']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['device_name'] = this.deviceName;
    return data;
  }
}
