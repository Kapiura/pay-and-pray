import 'package:flutter/material.dart';

int balance = 1000; // Przykładowa wartość balance
int amount = 0;

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Tło AppBar przezroczyste
        elevation: 0, // Brak cienia
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Kolor ikony
          onPressed: () {
            Navigator.pop(context); // Powrót do poprzedniego ekranu
          },
          padding: EdgeInsets.all(0), // Brak paddingu wokół ikony
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
                    Image.asset(
                      "assets/logo.png",
                      width: 150, // Szerokość
                      height: 150, // Wysokość
                    ),
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
