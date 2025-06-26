import 'package:flutter/material.dart';

class SavedFactsScreen extends StatefulWidget {
  const SavedFactsScreen({super.key});

  @override
  State<SavedFactsScreen> createState() => _SavedFactsScreenState();
}

class _SavedFactsScreenState extends State<SavedFactsScreen> {
  List<String> _savedFacts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сохранённые факты')),
      body: _savedFacts.isEmpty
          ? const Center(child: Text('Нет сохранённых фактов'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _savedFacts.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_savedFacts[index]),
                  ),
                );
              },
            ),
    );
  }
}