import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'saved_facts_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedType = 'trivia';
  List<String> _numberInput = ['0', '0', '0', '0'];
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
      String fullNumber = _numberInput.join('');
      if (fullNumber.isEmpty || int.tryParse(fullNumber) == null) {
        setState(() {
          _result = 'Число должно быть в виде цифры';
          _isLoading = false;
        });
        return;
      }
      final url = 'http://numbersapi.com/$fullNumber/$_selectedType';

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
      String fullNumber = _numberInput.join('');
      savedFacts.add('$fullNumber ($_selectedType): $_result');
      await prefs.setStringList('saved_facts', savedFacts);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Факт сохранён!')),
      );
    }
  }

  void _incrementNumber() {
    String fullNumber = _numberInput.join('');
    int number = int.parse(fullNumber) + 1;
    if (number > 9999) number = 0;
    setState(() {
      _numberInput = number.toString().padLeft(4, '0').split('');
    });
  }

  void _decrementNumber() {
    String fullNumber = _numberInput.join('');
    int number = int.parse(fullNumber) - 1;
    if (number < 0) number = 9999;
    setState(() {
      _numberInput = number.toString().padLeft(4, '0').split('');
    });
  }

  void _setRandomNumber() {
    int randomNumber = Random().nextInt(10000);
    setState(() {
      _numberInput = randomNumber.toString().padLeft(4, '0').split('');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NumbersAPI'),
        backgroundColor: Colors.blue[900]!,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blue[900]!, width: 2.0)
                ),
                child: Center(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    items: _types.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type.toUpperCase(),
                          textAlign: TextAlign.center
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedType = newValue!;
                      });
                    },
                    dropdownColor: Colors.blue[900],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    iconEnabledColor: Colors.white,
                    underline: const SizedBox.shrink()
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _setRandomNumber,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                ),
                child: const Text('Случайное число')
              ),
              const SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up, color: Colors.blue[900]),
                        onPressed: _incrementNumber
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 4; i++)
                        Container(
                          width: 40,
                          height: 60,
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue[900]!, width: 2.0)
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue[900]!, width: 2.0)
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(color: Colors.blue[700]!, width: 2.0)
                              ),
                              filled: true,
                              fillColor: Colors.blue[800],
                              hintText: '0',
                              hintStyle: const TextStyle(color: Colors.white70)
                            ),
                            style: const TextStyle(color: Colors.white, fontSize: 20.0),
                            onChanged: (value) {
                              if (value.isNotEmpty && int.tryParse(value) != null) {
                                setState(() {
                                  _numberInput[i] = value;
                                });
                              } else if (value.isEmpty) {
                                setState(() {
                                  _numberInput[i] = '0';
                                });
                              }
                            },
                            controller: TextEditingController(text: _numberInput[i])
                          ),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down, color: Colors.blue[900]),
                        onPressed: _decrementNumber
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_result.isNotEmpty)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              color: Colors.blue[800],
                              padding: const EdgeInsets.all(10.0),
                              width: 300,
                              child: Text(
                                _result,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white
                                ),
                                textAlign: TextAlign.center
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                ),
                onPressed: _isLoading ? null : _fetchTrivia,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Получить информацию'),
              ),
              const SizedBox(height: 10),
              if (_result.isNotEmpty)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                  ),
                  onPressed: _saveFact,
                  child: const Text('Сохранить'),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/saved');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                ),
                child: const Text('Сохранённые факты')
              ),
            ],
          ),
        ),
      ),
    );
  }
}