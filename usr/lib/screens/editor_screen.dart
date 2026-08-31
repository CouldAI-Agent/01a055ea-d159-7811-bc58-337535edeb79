import 'package:flutter/material.dart';
import '../models/essay.dart';
import '../services/essay_store.dart';

class EditorScreen extends StatefulWidget {
  final Essay essay;

  const EditorScreen({super.key, required this.essay});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.essay.title);
    _contentController = TextEditingController(text: widget.essay.content);
    _wordCount = widget.essay.wordCount;

    _contentController.addListener(_updateWordCount);
  }

  void _updateWordCount() {
    final text = _contentController.text.trim();
    setState(() {
      if (text.isEmpty) {
        _wordCount = 0;
      } else {
        _wordCount = text.split(RegExp(r'\s+')).length;
      }
    });
    _saveEssay();
  }

  void _saveEssay() {
    essayStore.updateEssay(
      widget.essay.id,
      _titleController.text,
      _contentController.text,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '$_wordCount words',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: TextField(
                    controller: _titleController,
                    onChanged: (_) => _saveEssay(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    decoration: const InputDecoration(
                      hintText: 'Essay Title',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null,
                      expands: true,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                            fontSize: 18,
                          ),
                      decoration: const InputDecoration(
                        hintText: 'Start writing your essay here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
