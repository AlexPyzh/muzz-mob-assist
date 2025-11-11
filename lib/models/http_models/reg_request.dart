class RegRequest {
  const RegRequest({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.name,
    required this.role,
  });

  final String email;
  final String password;
  final String confirmPassword;
  final String role;
  final String name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['name'] = this.name;
    data['role'] = this.role;
    return data;
  }
}
