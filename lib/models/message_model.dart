class MessageModel {
  final String id;
  final String classId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.classId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromMap(String id, Map<String, dynamic> map) {
    final timestampValue = map['timestamp'];
    DateTime timestamp;
    if (timestampValue is DateTime) {
      timestamp = timestampValue;
    } else if (timestampValue is Map && timestampValue['_seconds'] != null) {
      timestamp = DateTime.fromMillisecondsSinceEpoch((timestampValue['_seconds'] as int) * 1000);
    } else {
      timestamp = DateTime.now();
    }
    return MessageModel(
      id: id,
      classId: map['classId'] ?? '',
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      text: map['text'] ?? '',
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'classId': classId,
      'senderId': senderId,
      'senderName': senderName,
      'text': text,
      'timestamp': timestamp,
    };
  }
}
