import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
          padding: EdgeInsets.all(0),
        ),
      ),
      backgroundColor: Color.fromRGBO(102, 0, 51, 0.5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/logo.png", width: 500, height: 500),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game');
              },
              child: const Text('Play'),
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
                Navigator.pushNamed(context, '/balance');
              },
              child: const Text('Bank'),
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
                SystemNavigator.pop();
              },
              child: const Text('Quit'),
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
}
