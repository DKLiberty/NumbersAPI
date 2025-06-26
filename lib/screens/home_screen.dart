import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'saved_facts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedType = 'trivia';
  String _numberInput = '';
  bool _isRandom = true;
  String _result = '';
  bool _isLoading = false;
  bool _hasInternet = true;

  final List<String> _types = ['trivia', 'math', 'date'];

  Future<void> _fetchTrivia() async {
    if (!_hasInternet) {
      setState(() {
        _result = 'Нет соединения с интернетом';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      String url;
      if (_isRandom) {
        url = 'http://numbersapi.com/random/$_selectedType';
      } else {
        if (_numberInput.isEmpty || int.tryParse(_numberInput) == null) {
          setState(() {
            _result = 'Число должно быть в виде цифры';
            _isLoading = false;
          });
          return;
        }
        url = 'http://numbersapi.com/$_numberInput/$_selectedType';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _result = response.body;
          _isLoading = false;
        });
      } else {
        setState(() {
          _result = 'Произошла ошибка, попробуйте снова';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Нет соединения с интернетом';
        _isLoading = false;
      });
    }
  }

  void _saveFact() async {
    if (_result.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedFacts = prefs.getStringList('saved_facts') ?? [];
      savedFacts.add('$_numberInput ($_selectedType): $_result');
      await prefs.setStringList('saved_facts', savedFacts);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Факт сохранён!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Number Trivia')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<String>(
              value: _selectedType,
              items: _types.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: _isRandom,
                  onChanged: (bool? value) {
                    setState(() {
                      _isRandom = value!;
                      _numberInput = '';
                    });
                  },
                ),
                const Text('Случайное число'),
                Radio<bool>(
                  value: false,
                  groupValue: _isRandom,
                  onChanged: (bool? value) {
                    setState(() {
                      _isRandom = value!;
                    });
                  },
                ),
                const Text('Конкретное число'),
              ],
            ),
            if (!_isRandom)
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Введите число'),
                onChanged: (value) => _numberInput = value,
              ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _fetchTrivia,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Получить информацию'),
            ),
            const SizedBox(height: 10),
            if (_result.isNotEmpty)
              ElevatedButton(
                onPressed: _saveFact,
                child: const Text('Сохранить'),
              ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/saved');
              },
              child: const Text('Сохранённые факты'),
            ),
          ],
        ),
      ),
    );
  }
}