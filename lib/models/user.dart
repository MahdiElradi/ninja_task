// models/user.dart

class User {
  final String name;
  final int age;
  final String email;

  User({required this.name, required this.age, required this.email});

  // Convert User object to JSON format
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
    };
  }

  // Create User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
      email: json['email'],
    );
  }
}
