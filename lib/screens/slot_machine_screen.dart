import 'package:flutter/material.dart';

int balance = 1000;
int amount = 0;

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          padding: EdgeInsets.all(0),
        ),
      ),
      backgroundColor: Color.fromRGBO(102, 0, 51, 0.5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Game', style: TextStyle(fontSize: 24)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'Balance: \$${balance}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset("assets/logo.png", width: 150, height: 150),
                    Row(),
                  ],
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
