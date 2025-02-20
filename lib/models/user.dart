class User {
  final String userId;
  final String? patientId;
  final String? doctorId;
  final String? adminId;
  final String firstName;
  final String lastName;
  final String email;
  final String userType;
  final String? sickleCellType;
  final String contactNumber;
  final String? secConNumber;
  final int? age;
  final String? gender;
  final String? doctorLicenseNumber;
  final bool? isDeleted;

  User({
    required this.userId,
    this.patientId,
    this.doctorId,
    this.adminId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.userType,
    this.sickleCellType,
    required this.contactNumber,
    this.secConNumber,
    this.age,
    this.gender,
    this.doctorLicenseNumber,
    this.isDeleted,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json["userId"],
      patientId: json["patientId"],
      doctorId: json["doctorId"],
      adminId: json["adminId"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      userType: json["userType"],
      sickleCellType: json["sickleCellType"],
      contactNumber: json["contactNumber"],
      secConNumber: json["secConNumber"],
      age: json["age"] != null ? json["age"] as int : null,
      gender: json["gender"],
      doctorLicenseNumber: json["doctorLicenseNumber"],
      isDeleted: json["isDeleted"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "patientId": patientId,
      "doctorId": doctorId,
      "adminId": adminId,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "userType": userType,
      "sickleCellType": sickleCellType,
      "contactNumber": contactNumber,
      "secConNumber": secConNumber,
      "age": age,
      "gender": gender,
      "doctorLicenseNumber": doctorLicenseNumber,
      "isDeleted": isDeleted,
    };
  }
}

class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email.trim(),
      'password': password.trim(),
    };

    return map;
  }
}

class LoginResponseModel {
  final User? user;
  final String? error;

  LoginResponseModel({this.user, this.error});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("error")) {
      return LoginResponseModel(error: json["error"]);
    } else {
      return LoginResponseModel(user: User.fromJson(json));
    }
  }
}

class SignUpRequestModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? userType;
  final String? sickleCellType;
  final String contactNumber;
  final String? secConNumber;
  final int? age;
  final String? gender;
  final String? password;

  SignUpRequestModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.userType,
    required this.sickleCellType,
    required this.contactNumber,
    this.secConNumber,
    required this.age,
    required this.gender,
    this.password,
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) {
    return SignUpRequestModel(
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      userType: json["userType"],
      sickleCellType: json["sickleCellType"],
      contactNumber: json["contactNumber"],
      secConNumber: json["secConNumber"],
      age: json["age"] != null ? json["age"] as int : null,
      gender: json["gender"],
      password: json["password"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "userType": userType,
      "sickleCellType": sickleCellType,
      "contactNumber": contactNumber,
      "secConNumber": secConNumber,
      "age": age,
      "gender": gender,
      "password": password,
    };
  }
}

class SignUpResponseModel {
  final User? user;
  final String? error;

  SignUpResponseModel({this.user, this.error});

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("error")) {
      return SignUpResponseModel(error: json["error"]);
    } else {
      return SignUpResponseModel(user: User.fromJson(json));
    }
  }
}
