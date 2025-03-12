// class User {
//   int? id;
//   String fullName;
//   String phoneNumber;
//   String email;
//   String address;
//   String password;
//   String userStatus;
//   String role;

//   User({
//     this.id,
//     required this.fullName,
//     required this.phoneNumber,
//     required this.email,
//     required this.address,
//     required this.password,
//     this.userStatus = 'NON AUTORISE',
//     required this.role,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       role: json['role'],
//       id: json['id'],
//       fullName: json['full_name'],
//       phoneNumber: json['phone_number'],
//       email: json['email'],
//       address: json['address'],
//       password: json['password'],
//       userStatus: json['user_status'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'full_name': fullName,
//       'phone_number': phoneNumber,
//       'email': email,
//       'address': address,
//       'password': password,
//       'user_status': userStatus,
//       'role': role,
//     };
//   }
// }

class User {
  int? id;
  String fullName;
  String phoneNumber;
  String email;
  String address;
  String? password;
  String userStatus;
  String role;

  User({
    this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    this.password,
    required this.userStatus,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      role: json['role'],
      id: json['id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      address: json['address'],
      password: json['password'],
      userStatus: json['userStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'password': password,
      'userStatus': userStatus,
      'role': role,
    };
  }
}
