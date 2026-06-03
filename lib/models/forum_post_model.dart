class ForumPostModel {
  final String id;
  final String classId;
  final String authorId;
  final String authorName;
  final String title;
  final String content;
  final int likes;
  final int replies;
  final bool pinned;
  final DateTime createdAt;

  ForumPostModel({
    required this.id,
    required this.classId,
    required this.authorId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.likes,
    required this.replies,
    required this.pinned,
    required this.createdAt,
  });

  factory ForumPostModel.fromMap(String id, Map<String, dynamic> map) {
    final createdAtValue = map['createdAt'];
    DateTime createdAt;
    if (createdAtValue is DateTime) {
      createdAt = createdAtValue;
    } else if (createdAtValue is Map && createdAtValue['_seconds'] != null) {
      createdAt = DateTime.fromMillisecondsSinceEpoch((createdAtValue['_seconds'] as int) * 1000);
    } else {
      createdAt = DateTime.now();
    }
    return ForumPostModel(
      id: id,
      classId: map['classId'] ?? '',
      authorId: map['authorId'] ?? '',
      authorName: map['authorName'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      likes: map['likes'] ?? 0,
      replies: map['replies'] ?? 0,
      pinned: map['pinned'] ?? false,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'authorId': authorId,
      'authorName': authorName,
      'title': title,
      'content': content,
      'likes': likes,
      'replies': replies,
      'pinned': pinned,
      'createdAt': createdAt,
    };
  }
}
