import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pay_and_pray/providers/balance_provider.dart';
import 'dart:math';
import 'package:pay_and_pray/providers/audio_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _spinController;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  final List<Map<String, dynamic>> _symbols = [
    {'asset': 'assets/cherry.png', 'multiplier': 5},
    {'asset': 'assets/lemon.png', 'multiplier': 10},
    {'asset': 'assets/watermelon.png', 'multiplier': 15},
    {'asset': 'assets/bar.png', 'multiplier': 20},
    {'asset': 'assets/seven.png', 'multiplier': 50},
  ];

  List<int> _currentIndices = [0, 0, 0];
  bool _isSpinning = false;
  int _betAmount = 10;
  String _resultMessage = '';
  bool _showWin = false;
  bool _showWinAnimation = false;
  final Random _random = Random();
  final int _extraSpins = 20;
  bool _resetControllers = false;

  final AudioPlayer _spinSoundPlayer = AudioPlayer();
  final AudioPlayer _winSoundPlayer = AudioPlayer();
  final AudioPlayer _jackpotSoundPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    AudioHandler.playBackground();

    _spinController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _spinController.reset();
      }
    });

    _initSounds();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resetReelPositions();
    });
  }

  Future<void> _initSounds() async {
    await _spinSoundPlayer.setSource(AssetSource('audio/spin.mp3'));
    await _winSoundPlayer.setSource(AssetSource('audio/win.mp3'));
    await _jackpotSoundPlayer.setSource(AssetSource('audio/jackpot.mp3'));

    await _spinSoundPlayer.setVolume(0.7);
    await _winSoundPlayer.setVolume(0.7);
    await _jackpotSoundPlayer.setVolume(0.7);
  }

  void _resetReelPositions() {
    for (int i = 0; i < 3; i++) {
      _scrollControllers[i].jumpTo(_currentIndices[i] * 100.0);
    }
  }

  void _spin() async {
    final balance = Provider.of<BalanceProvider>(context, listen: false);

    if (_isSpinning || balance.balance < _betAmount) return;

    await _spinSoundPlayer.seek(Duration.zero);
    await _spinSoundPlayer.resume();

    setState(() {
      _isSpinning = true;
      _showWin = false;
      _showWinAnimation = false;
      _resultMessage = '';
      balance.updateBalance(-_betAmount);
    });

    final newIndices = List.generate(
      3,
      (_) => _random.nextInt(_symbols.length),
    );
    print('Nowe indeksy: $newIndices');

    if (_resetControllers) {
      for (int i = 0; i < 3; i++) {
        _scrollControllers[i].jumpTo(0);
      }
    }

    for (int i = 0; i < 3; i++) {
      final double startOffset = _scrollControllers[i].offset;
      final double targetOffset =
          startOffset +
          (_extraSpins * _symbols.length * 100) +
          (newIndices[i] * 100.0);

      final duration = Duration(milliseconds: 2500 + (i * 300));

      _scrollControllers[i]
          .animateTo(
            targetOffset,
            duration: duration,
            curve: Curves.easeOutQuint,
          )
          .whenComplete(() {
            if (i == 2) {
              setState(() {
                _currentIndices = newIndices;
                _isSpinning = false;
                _resetControllers = true;
              });
              _checkResult();
            }
          });
    }
  }

  void _checkResult() async {
    final balance = Provider.of<BalanceProvider>(context, listen: false);
    int winAmount = 0;
    bool isJackpot = false;

    if (_currentIndices[0] == _currentIndices[1] &&
        _currentIndices[1] == _currentIndices[2]) {
      winAmount =
          _betAmount * (_symbols[_currentIndices[0]]['multiplier'] as int);
      _resultMessage = 'JACKPOT! \$$winAmount';
      _showWin = true;
      isJackpot = true;
    } else if ((_currentIndices[0] == _currentIndices[1] &&
            _currentIndices[1] != _currentIndices[2]) ||
        (_currentIndices[1] == _currentIndices[2] &&
            _currentIndices[0] != _currentIndices[1]) ||
        (_currentIndices[0] == _currentIndices[2] &&
            _currentIndices[1] != _currentIndices[0])) {
      winAmount = _betAmount * 2;
      _resultMessage = 'DOUBLE! \$$winAmount';
      _showWin = true;
    } else if (_currentIndices.any(
      (index) => _symbols[index]['asset'].endsWith('seven.png'),
    )) {
      winAmount = _betAmount;
      _resultMessage = 'LUCKY 7! \$$winAmount';
      _showWin = true;
    } else {
      _resultMessage = 'TRY AGAIN!';
      _showWin = false;
    }

    if (winAmount > 0) {
      if (isJackpot) {
        await _jackpotSoundPlayer.seek(Duration.zero);
        await _jackpotSoundPlayer.resume();
      } else {
        await _winSoundPlayer.seek(Duration.zero);
        await _winSoundPlayer.resume();
      }

      balance.updateBalance(winAmount);
      setState(() {
        _showWinAnimation = true;
      });

      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showWinAnimation = false;
          });
        }
      });
    }
  }

  void _changeBet(int amount) {
    if (_isSpinning) return;
    setState(() {
      _betAmount = (_betAmount + amount).clamp(10, 100);
    });
  }

  Widget _buildReel(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 100,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        controller: _scrollControllers[index],
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _symbols.length * 100,
        itemBuilder: (context, i) {
          final symbolIndex = i % _symbols.length;
          return SizedBox(
            height: 100,
            child: Image.asset(_symbols[symbolIndex]['asset']),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final balance = Provider.of<BalanceProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(102, 0, 51, 0.5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      'BALANCE: \$${balance.balance}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset("assets/logo.png", width: 150, height: 150),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) => _buildReel(i)),
                ),

                const SizedBox(height: 20),

                Text(
                  _resultMessage,
                  style: TextStyle(
                    color: _showWin ? Colors.yellow : Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.white),
                      onPressed: () => _changeBet(-10),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple[800],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'BET: \$$_betAmount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.white),
                      onPressed: () => _changeBet(10),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _spin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
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

          if (_showWinAnimation)
            AnimatedOpacity(
              opacity: _showWinAnimation ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.yellow.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'WINNER!',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _spinController.dispose();
    for (var controller in _scrollControllers) {
      controller.dispose();
    }
    _spinSoundPlayer.dispose();
    _winSoundPlayer.dispose();
    _jackpotSoundPlayer.dispose();
    AudioHandler.dispose();
    super.dispose();
  }
}
