import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer when an item is tapped
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sylvestre Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sylvestre Project'),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            CalculatorScreen(),
            SignupScreen(),
            LoginScreen(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text('Calculator'),
                selected: _selectedIndex == 0,
                selectedTileColor: Colors.red,
                onTap: () => _onItemTapped(0),
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Signup'),
                selected: _selectedIndex == 1,
                selectedTileColor: Colors.red,
                onTap: () => _onItemTapped(1),
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text('Login'),
                selected: _selectedIndex == 2,
                selectedTileColor: Colors.red,
                onTap: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String displayText = "0";
  String expression = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    displayText,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromARGB(0, 255, 0, 85)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onButtonTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onButtonTap(String value) {
    setState(() {
      if (value == Btn.clr) {
        displayText = "0";
        expression = "";
      } else if (value == Btn.del) {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
          displayText = expression.isNotEmpty ? expression : "0";
        }
      } else if (value == Btn.calculate) {
        try {
          displayText = calculateExpression(expression);
          expression = displayText;
        } catch (e) {
          displayText = "Error";
        }
      } else {
        if (displayText == "0" && value != Btn.dot) {
          displayText = value;
        } else {
          displayText += value;
        }
        expression += value;
      }
    });
  }

  String calculateExpression(String expr) {
    try {
      expr = expr.replaceAll('×', '*');
      expr = expr.replaceAll('÷', '/');

      final evaluator = const ExpressionEvaluator();
      final exp = Expression.parse(expr);
      final result = evaluator.eval(exp, {});

      return result.toString();
    } catch (e) {
      return "Error";
    }
  }

  Color getBtnColor(String value) {
    if ([Btn.del, Btn.clr].contains(value)) {
      return Colors.blueGrey;
    } else {
      return [
        Btn.per,
        Btn.multiply,
        Btn.add,
        Btn.substract,
        Btn.divided,
        Btn.calculate,
      ].contains(value)
          ? Colors.orange
          : Color.fromRGBO(19, 110, 23, 0.867);
    }
  }
}

class Btn {
  static const String del = 'D';
  static const String clr = 'C';
  static const String per = '%';
  static const String multiply = 'x';
  static const String divided = '/';
  static const String add = '+';
  static const String substract = '-';
  static const String calculate = '=';
  static const String dot = '.';

  static const String n0 = '0';
  static const String n1 = '1';
  static const String n2 = '2';
  static const String n3 = '3';
  static const String n4 = '4';
  static const String n5 = '5';
  static const String n6 = '6';
  static const String n7 = '7';
  static const String n8 = '8';
  static const String n9 = '9';

  static const List<String> buttonValues = [
    n7,
    n8,
    n9,
    divided,
    n4,
    n5,
    n6,
    multiply,
    n1,
    n2,
    n3,
    substract,
    dot,
    n0,
    add,
    per,
    clr,
    del,
    calculate
  ];
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _numberController,
                decoration: InputDecoration(labelText: 'Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data
                  }
                },
                child: Text('Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Process data
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
