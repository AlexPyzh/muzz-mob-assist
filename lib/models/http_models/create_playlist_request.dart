class CreatePlaylistRequest {
  CreatePlaylistRequest({
    required this.name,
    required this.description,
    required this.userId,
    required this.public,
    required this.created,
  });

  final String? name;
  final String? description;
  final int? userId;
  final bool? public;
  final String? created;

  factory CreatePlaylistRequest.fromJson(Map<String, dynamic> json) {
    return CreatePlaylistRequest(
      name: json["name"],
      description: json["description"],
      userId: json["userId"],
      public: json["public"],
      created: json["created"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "userId": userId,
        "public": public,
        "created": created,
      };
}
