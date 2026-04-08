class User {
    String email;
    int id;
    String name;
    String role;
    String? password; // Optional password field (not stored in JSON)

    User({
        required this.email,
        required this.id,
        required this.name,
        required this.role,
        this.password,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        email: json["email"],
        id: json["id"],
        name: json["name"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
        "role": role,
    };
}
