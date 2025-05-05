import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_and_pray/providers/audio_handler.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AudioHandler.playBackground();
    final screenSize = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
          padding: EdgeInsets.zero,
        ),

      ),
      backgroundColor: const Color.fromRGBO(102, 0, 51, 0.5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenSize.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width:
                        isPortrait
                            ? screenSize.width * 0.8
                            : screenSize.width * 0.5,
                    height:
                        isPortrait
                            ? screenSize.height * 0.4
                            : screenSize.height * 0.6,
                    child: Image.asset("assets/logo.png", fit: BoxFit.contain),
                  ),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(
                        context: context,
                        text: 'Play',
                        onPressed: () => Navigator.pushNamed(context, '/game'),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildActionButton(
                        context: context,
                        text: 'Bank',
                        onPressed:
                            () => Navigator.pushNamed(context, '/balance'),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      _buildActionButton(
                        context: context,
                        text: 'Quit',
                        onPressed: () => SystemNavigator.pop(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String text,
    required VoidCallback onPressed,
  }) {
    final screenSize = MediaQuery.of(context).size;

    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: screenSize.width * 0.045,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(screenSize.width * 0.6, screenSize.height * 0.07),
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.05,
          vertical: screenSize.height * 0.015,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: const Color.fromRGBO(102, 153, 153, 1),
        foregroundColor: Colors.white,
      ),
    );
  }
}
