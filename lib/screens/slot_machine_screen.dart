import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pay_and_pray/providers/balance_provider.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final List<String> _symbols = [
    'assets/cherry.png',
    'assets/lemon.png',
    'assets/seven.png',
    'assets/bar.png',
    'assets/watermelon.png',
  ];

  List<int> _currentIndices = [0, 0, 0];
  bool _isSpinning = false;
  int _betAmount = 10;
  String _resultMessage = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.decelerate);

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkResult();
        setState(() {
          _isSpinning = false;
        });
      }
    });
  }

  void _spin() {
    final balanceProvider = Provider.of<BalanceProvider>(
      context,
      listen: false,
    );

    if (_isSpinning || balanceProvider.balance < _betAmount) return;

    setState(() {
      _isSpinning = true;
      balanceProvider.updateBalance(-_betAmount);
      _resultMessage = '';
      _currentIndices = [
        Random().nextInt(_symbols.length),
        Random().nextInt(_symbols.length),
        Random().nextInt(_symbols.length),
      ];
    });

    _controller.reset();
    _controller.forward();
  }

  void _checkResult() {
    final balanceProvider = Provider.of<BalanceProvider>(
      context,
      listen: false,
    );

    if (_currentIndices[0] == _currentIndices[1] &&
        _currentIndices[1] == _currentIndices[2]) {
      int winAmount = _betAmount * 10;
      balanceProvider.updateBalance(winAmount);
      setState(() {
        _resultMessage = 'You won \$$winAmount!';
      });
    } else if (_currentIndices[0] == _currentIndices[1] ||
        _currentIndices[1] == _currentIndices[2] ||
        _currentIndices[0] == _currentIndices[2]) {
      int winAmount = _betAmount * 2;
      balanceProvider.updateBalance(winAmount);
      setState(() {
        _resultMessage = 'Double! \$$winAmount';
      });
    }
  }

  void _changeBet(int amount) {
    if (_isSpinning) return;
    setState(() {
      _betAmount += amount;
      if (_betAmount < 10) _betAmount = 10;
      if (_betAmount > 100) _betAmount = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final balanceProvider = Provider.of<BalanceProvider>(context);

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
            Column(
              children: [
                Text(
                  'Balance: \$${balanceProvider.balance}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset("assets/logo.png", width: 150, height: 150),
              ],
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      double value = _animation.value;
                      int displayIndex =
                          (_currentIndices[index] + (value * 20).toInt()) %
                          _symbols.length;
                      return Image.asset(_symbols[displayIndex]);
                    },
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            Text(
              _resultMessage,
              style: TextStyle(
                color: Colors.yellow,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () => _changeBet(-10),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.purple[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Zakład: \$$_betAmount',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => _changeBet(10),
                ),
              ],
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _spin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'SPIN',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
