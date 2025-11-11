class UserReaction {
  UserReaction({
    this.id,
    this.trackId,
    this.userId,
  });

  int? id;
  int? trackId;
  int? userId;

  UserReaction.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    trackId = json['trackId'] ?? 0;
    userId = json['userId'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['trackId'] = this.trackId;
    data['userId'] = this.userId;
    return data;
  }
}
