class ReviseLog {
  int id;
  String subject;
  String date;

  ReviseLog({required this.id, required this.subject, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'date': date,
    };
  }

  static ReviseLog fromMap(Map<String, dynamic> map) {
    return ReviseLog(
      id: map['id'],
      subject: map['subject'],
      date: map['date'],
    );
  }
}