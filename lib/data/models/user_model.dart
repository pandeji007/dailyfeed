import 'package:dailyfeed/domain/entities/user.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.accessToken,
    required this.image,
  });

  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String accessToken;
  final String image;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as int? ?? 0,
    username: json['username'] as String? ?? '',
    email: json['email'] as String? ?? '',
    firstName: json['firstName'] as String? ?? '',
    lastName: json['lastName'] as String? ?? '',
    accessToken: json['accessToken'] as String? ?? '',
    image: json['image'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'accessToken': accessToken,
    'image': image,
  };

  User toEntity() => User(
    id: id,
    username: username,
    email: email,
    firstName: firstName,
    lastName: lastName,
    accessToken: accessToken,
    image: image,
  );
}
