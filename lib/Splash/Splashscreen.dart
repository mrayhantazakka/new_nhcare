import 'package:flutter/material.dart';
import 'LoadingPage.dart'; // Import LoadingPage untuk navigasi

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isWhiteLogo = true;
  bool _isAnimationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();
    _controller.addListener(() {
      setState(() {
        if (_controller.status == AnimationStatus.completed) {
          _isAnimationComplete = true;
          _isWhiteLogo = false;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _isWhiteLogo = false;
            });
          });
        }
      });
    });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingPage(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/img/loading_page.png', 
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Image.asset(
                        _isWhiteLogo ? 'assets/img/logo_putih.png' : 'assets/img/logo.jpg',
                        width: 1200,
                        height: 100,
                      ),
                    );
                  },
                ),
                if (!_isAnimationComplete) SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

