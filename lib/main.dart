import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(AgeCalculatorApp());
}

class AgeCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AgeCalculatorHomePage(),
    );
  }
}

class AgeCalculatorHomePage extends StatefulWidget {
  @override
  _AgeCalculatorHomePageState createState() => _AgeCalculatorHomePageState();
}

class _AgeCalculatorHomePageState extends State<AgeCalculatorHomePage> {
  final TextEditingController _dateController = TextEditingController();
  String _age = '';
  IconData? _ageIcon;

  void _calculateAge(String input) {
    try {
      DateTime birthDate = DateFormat('dd-MM-yyyy').parseStrict(input);
      DateTime today = DateTime.now();
      int years = today.year - birthDate.year;
      int months = today.month - birthDate.month;
      int days = today.day - birthDate.day;

      if (days < 0) {
        months--;
        days += DateTime(today.year, today.month, 0).day; // Get the last day of the previous month
      }

      if (months < 0) {
        years--;
        months += 12;
      }

      String ageCategory = _getAgeCategory(years);

      setState(() {
        _age = 'You are:\n$years years\n$months months\n$days days old';
        _ageIcon = _getAgeIcon(ageCategory);
      });
    } catch (e) {
      setState(() {
        _age = 'Invalid date format';
        _ageIcon = null;
      });
    }
  }

  String _getAgeCategory(int years) {
    if (years < 13) {
      return 'child';
    } else if (years < 20) {
      return 'teen';
    } else if (years < 60) {
      return 'adult';
    } else {
      return 'senior';
    }
  }

  IconData _getAgeIcon(String category) {
    switch (category) {
      case 'child':
        return Icons.child_care;
      case 'teen':
        return Icons.school;
      case 'adult':
        return Icons.work;
      case 'senior':
        return Icons.elderly;
      default:
        return Icons.person;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Age Calculator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Enter your birth date (dd-MM-yyyy)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _calculateAge(_dateController.text);
                },
                child: Text('Calculate Age'),
              ),
              SizedBox(height: 20),
              if (_age.isNotEmpty)
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_ageIcon != null) Icon(_ageIcon, size: 100),
                          SizedBox(height: 20),
                          Text(
                            _age,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
