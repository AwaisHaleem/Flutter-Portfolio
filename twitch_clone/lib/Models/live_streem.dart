class LiveStreem {
  final String title;
  final String image;
  final String uid;
  final String username;
  final startedAt;
  final int viewers;
  final String channelId;

  LiveStreem({
    required this.title,
    required this.image,
    required this.uid,
    required this.username,
    required this.startedAt,
    required this.viewers,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
      'uid': uid,
      'username': username,
      'startedAt': startedAt,
      'viewers': viewers,
      'channelId': channelId,
    };
  }

  factory LiveStreem.fromMap(Map<String, dynamic> map) {
    return LiveStreem(
        title: map['title'] ?? "",
        image: map['image'] ?? "",
        uid: map['uid'] ?? "",
        username: map['username'] ?? "",
        startedAt: map['startedAt'] ?? "",
        viewers: map['viewers']?.toInt() ?? 0,
        channelId: map['channelId'] ?? "");
  }
}
