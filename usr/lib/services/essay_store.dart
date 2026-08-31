import 'package:flutter/foundation.dart';
import '../models/essay.dart';

class EssayStore extends ChangeNotifier {
  final List<Essay> _essays = [
    Essay(
      id: '1',
      title: 'The Future of Artificial Intelligence',
      content: 'Artificial intelligence is rapidly evolving. As we look towards the next decade, the integration of AI into our daily lives will become increasingly seamless. We must consider both the ethical implications and the vast potential for positive transformation.',
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Essay(
      id: '2',
      title: 'A Reflection on Modern Architecture',
      content: 'Modern architecture emphasizes function over form, but in doing so, has it lost its soul? The brutalist structures of the mid-20th century stand in stark contrast to the organic shapes pioneered by earlier visionaries.',
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  List<Essay> get essays => List.unmodifiable(_essays..sort((a, b) => b.lastModified.compareTo(a.lastModified)));

  void addEssay(Essay essay) {
    _essays.add(essay);
    notifyListeners();
  }

  void updateEssay(String id, String newTitle, String newContent) {
    final index = _essays.indexWhere((e) => e.id == id);
    if (index != -1) {
      _essays[index].title = newTitle;
      _essays[index].content = newContent;
      _essays[index].lastModified = DateTime.now();
      notifyListeners();
    }
  }

  void deleteEssay(String id) {
    _essays.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}

// Global singleton for demo simplicity
final essayStore = EssayStore();
