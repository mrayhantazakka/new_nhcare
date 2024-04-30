import 'package:flutter/material.dart';
import 'package:nhcoree/Auth/Login.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
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
        // Navigate to loading page when animation completes
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoadingPage(), // Navigate to LoadingPage
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
          AnimatedContainer(
            duration: Duration(seconds: 1),
            color: _isAnimationComplete ? Colors.white : Color(0xFFA4C751),
            curve: Curves.easeInOut,
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
                        _isWhiteLogo
                            ? 'assets/img/logo_putih.png'
                            : 'assets/img/logo.jpg',
                        width: 1200,
                        height: 100,
                      ),
                    );
                  },
                ),
                if (!_isAnimationComplete) SizedBox(height: 16),
                if (!_isAnimationComplete)
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State {
  @override
  void initState() {
    super.initState();
    // Add any initialization logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFFA4C751)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo_putih.png',
                  height: 203,
                  width: 168,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Selamat Datang di Aplikasi NH Care',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFA4C751),
                              minimumSize: Size(180, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/register');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFFA4C751)),
                              minimumSize: Size(180, 60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFFA4C751),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
