import 'package:flutter/material.dart';

class BalanceScreen extends StatefulWidget {
  const BalanceScreen({super.key});

  @override
  _BalanceScreenState createState() => _BalanceScreenState();
}

class _BalanceScreenState extends State<BalanceScreen> {
  final TextEditingController _controller = TextEditingController();
  String _inputValue = ''; // Zmienna do przechowywania wprowadzonej liczby
  int balance = 1000; // Przykładowa wartość balance
  int amount = 0; // Przykładowa wartość amount

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
          children: [
            Image.asset("assets/logo.png", width: 500, height: 500),
            // Wyświetlanie balance i amount
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
                    SizedBox(height: 10),
                    Text(
                      'Amount: \$${amount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // TextField do wprowadzania liczby
            Container(
              width: 200, // Ustalamy szerokość TextField, tak samo jak przycisk
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number, // Tylko liczby
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white), // Kolor etykiety
                  border: OutlineInputBorder(),
                  fillColor: Colors.white, // Tło pola tekstowego
                  filled: true, // Użycie tła
                ),
                style: TextStyle(color: Colors.black), // Kolor tekstu wewnątrz
                onChanged: (value) {
                  setState(() {
                    _inputValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _inputValue =
                      _controller.text; // Przypisanie wartości z TextField
                });

                if (_validateInput() == null) {
                  // Działanie, jeśli liczba jest poprawna
                  setState(() {
                    // Zaktualizowanie balance i amount na podstawie wprowadzonej liczby
                    amount += int.parse(_inputValue);
                    balance -= int.parse(_inputValue);
                  });
                  Navigator.pushNamed(context, '/');
                } else {
                  // Pokazanie komunikatu o błędzie, jeśli liczba jest niepoprawna
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number')),
                  );
                }
              },
              child: const Text('Add'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Color.fromRGBO(102, 153, 153, 1),
                foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Powrót do poprzedniego ekranu
              },
              child: const Text('Back'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 60),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Color.fromRGBO(102, 153, 153, 1),
                foregroundColor: Color.fromRGBO(255, 255, 255, 1),
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Funkcja walidująca wprowadzone dane
  String? _validateInput() {
    final number = int.tryParse(
      _inputValue,
    ); // Próbujemy przekonwertować tekst na liczbę
    if (number == null) {
      return 'Please enter a valid number';
    } else if (number <= 0) {
      return 'Please enter a number greater than 0'; // Walidacja większa niż 0
    }
    return null;
  }
}
