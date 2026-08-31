class Essay {
  final String id;
  String title;
  String content;
  DateTime lastModified;

  Essay({
    required this.id,
    required this.title,
    required this.content,
    required this.lastModified,
  });

  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }
}
