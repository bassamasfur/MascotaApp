import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _textAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
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
          // Fondo animado de burbujas
          Positioned.fill(child: AnimatedBubbles()),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoAnimation,
                  child: const Text('🐾', style: TextStyle(fontSize: 100)),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _textAnimation,
                  child: Column(
                    children: const [
                      Text(
                        '¡Bienvenido a Pet App!',
                        style: TextStyle(
                          fontSize: 30,
                          color: Color(0xFF0D47A1),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          fontFamily: 'ComicNeue',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Cuida, registra y disfruta de tus mascotas',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.5,
                          fontFamily: 'ComicNeue',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                FadeTransition(
                  opacity: _textAnimation,
                  child: const CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBubbles extends StatefulWidget {
  @override
  State<AnimatedBubbles> createState() => _AnimatedBubblesState();
}

class _AnimatedBubblesState extends State<AnimatedBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Bubble> _bubbles = [];
  final int _bubbleCount = 18;
  final List<Color> _colors = [
    Color(0xFFB2EBF2),
    Color(0xFF81D4FA),
    Color(0xFFB3E5FC),
    Color(0xFF80DEEA),
    Color(0xFF4FC3F7),
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    for (int i = 0; i < _bubbleCount; i++) {
      _bubbles.add(
        _Bubble(
          left: random.nextDouble(),
          size: 40.0 + random.nextDouble() * 40,
          color: _colors[random.nextInt(_colors.length)],
          speed: 0.5 + random.nextDouble() * 1.2,
          offset: random.nextDouble(),
        ),
      );
    }
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _BubblePainter(_bubbles, _controller.value),
        );
      },
    );
  }
}

class _Bubble {
  final double left;
  final double size;
  final Color color;
  final double speed;
  final double offset;
  _Bubble({
    required this.left,
    required this.size,
    required this.color,
    required this.speed,
    required this.offset,
  });
}

class _BubblePainter extends CustomPainter {
  final List<_Bubble> bubbles;
  final double progress;
  _BubblePainter(this.bubbles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (final bubble in bubbles) {
      final paint = Paint()..color = bubble.color.withOpacity(0.18);
      final dy =
          size.height -
          ((progress + bubble.offset) % 1.0) * size.height * bubble.speed;
      final dx = bubble.left * size.width;
      canvas.drawCircle(Offset(dx, dy), bubble.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
