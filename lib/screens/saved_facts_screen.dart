import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadSavedFacts();
  }

  Future<void> _loadSavedFacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedFacts = prefs.getStringList('saved_facts') ?? [];
    });
  }

  Future<void> _clearFacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_facts');
    setState(() {
      _savedFacts.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        title: const Text('Сохранённые факты'),
        backgroundColor: Colors.blue[900]!,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: _savedFacts.isEmpty
          ? const Center(child: Text('Нет сохранённых фактов'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _savedFacts.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.blue[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: ListTile(
                    title: Text(
                      _savedFacts[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clearFacts,
        child: const Icon(Icons.delete),
      ),
    );
  }
}