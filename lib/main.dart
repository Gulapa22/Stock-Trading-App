import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'balance_model.dart'; // Import your BalanceModel class

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BalanceModel(), // Provide an instance of BalanceModel
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PasscodeScreen(),
      ),
    );
  }
}


class PasscodeScreen extends StatefulWidget {
  const PasscodeScreen({Key? key}) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String enteredPasscode = '';
  String correctPasscode = '0246';
  int wrongAttempts = 0;
  bool passcodeEnabled = true;

  void _handleKeyPress(String key) {
    if (!passcodeEnabled) return;

    setState(() {
      enteredPasscode += key;
    });

    if (enteredPasscode.length == 4) {
      if (enteredPasscode == correctPasscode) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          wrongAttempts++;
          enteredPasscode = '';
        });
        if (wrongAttempts == 5) {
          setState(() {
            passcodeEnabled = false;
            enteredPasscode = '';
          });
          Future.delayed(const Duration(seconds: 30), () {
            setState(() {
              passcodeEnabled = true;
            });
          });
        } else {
          // Display "Incorrect Password" for 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              wrongAttempts = 0;
            });
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.pink[100]!, Colors.red[100]!],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Passcode:',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                      (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: enteredPasscode.length > index
                          ? Text('*')
                          : Container(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (wrongAttempts > 0)
                Text(
                  'Incorrect Password',
                  style: TextStyle(color: Colors.red),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberButton('0'),
                  _buildNumberButton('1'),
                  _buildNumberButton('2'),
                  _buildNumberButton('3'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberButton('4'),
                  _buildNumberButton('5'),
                  _buildNumberButton('6'),
                  _buildNumberButton('7'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNumberButton('8'),
                  _buildNumberButton('9'),
                  _buildNumberButton('C', onPressed: () {
                    setState(() {
                      enteredPasscode = '';
                    });
                  }),
                ],
              ),
              if (!passcodeEnabled) SizedBox(height: 20),
              if (!passcodeEnabled)
                Text(
                  'Try again in 30 seconds',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number, {VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed ?? () => _handleKeyPress(number),
        child: Text(number),
      ),
    );
  }
}
