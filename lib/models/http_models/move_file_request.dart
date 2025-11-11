class MoveFileRequest {
  MoveFileRequest({
    required this.oldPath,
    required this.newPath,
  });

  String oldPath;
  String newPath;

  Map<String, dynamic> toJson() => {
        "oldPath": oldPath,
        "newPath": newPath,
      };
}
