import 'package:flutter/material.dart';
import '../services/essay_store.dart';
import '../models/essay.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Essays', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListenableBuilder(
        listenable: essayStore,
        builder: (context, _) {
          final essays = essayStore.essays;
          
          if (essays.isEmpty) {
            return const Center(
              child: Text(
                'No essays yet.\nTap + to start writing.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              // Responsive grid
              int crossAxisCount = 1;
              if (constraints.maxWidth > 800) {
                crossAxisCount = 3;
              } else if (constraints.maxWidth > 500) {
                crossAxisCount = 2;
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.85,
                ),
                itemCount: essays.length,
                itemBuilder: (context, index) {
                  final essay = essays[index];
                  return _EssayCard(essay: essay);
                },
              );
            }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newEssay = Essay(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: '',
            content: '',
            lastModified: DateTime.now(),
          );
          essayStore.addEssay(newEssay);
          Navigator.pushNamed(context, '/editor', arguments: newEssay);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EssayCard extends StatelessWidget {
  final Essay essay;

  const _EssayCard({required this.essay});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/editor', arguments: essay);
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                essay.title.isEmpty ? 'Untitled Essay' : essay.title,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  essay.content.isEmpty ? 'Start writing...' : essay.content,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${essay.wordCount} words',
                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () {
                      essayStore.deleteEssay(essay.id);
                    },
                    color: theme.colorScheme.error,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
