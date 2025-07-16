import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../variables.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with TickerProviderStateMixin {
  final String text = "BookFlix";
  final Color bgColor = mainColor;
  final Color textColor = secondaryColor;

  late final List<AnimationController> _letterControllers;
  late final List<Animation<double>> _letterAnimations;

  late final AnimationController _zoomController;
  late final Animation<double> _zoomAnimation;

  late final AnimationController _lightController;
  late final Animation<double> _lightAnimation;

  @override
  void initState() {
    super.initState();

    _letterControllers = List.generate(
      text.length,
          (i) => AnimationController(
        duration: const Duration(milliseconds: 1000),
        vsync: this,
      ),
    );

    _letterAnimations = _letterControllers.map((controller) {
      return Tween<double>(begin: -200, end: 0)
          .chain(CurveTween(curve: Curves.easeOutBack))
          .animate(controller);
    }).toList();

    /// 🕒 Add pre-animation delay here
    Future.delayed(const Duration(milliseconds: 800), () {
      for (int i = 0; i < _letterControllers.length; i++) {
        Future.delayed(Duration(milliseconds: 250 * i), () {
          _letterControllers[i].forward();
        });
      }

      // Zoom and light effect after letters drop
      Future.delayed(Duration(milliseconds: 250 * text.length + 300), () {
        _zoomController.forward();
        _lightController.forward();
      });

      // Navigate after full animation
      Future.delayed(Duration(milliseconds: 250 * text.length + 4300), () {
        Get.offNamed("/onBoarding");
      });
    });

    // Setup zoom and light animations
    _zoomController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _zoomAnimation = Tween<double>(begin: 1.0, end: 1.15)
        .chain(CurveTween(curve: Curves.easeOutExpo))
        .animate(_zoomController);

    _lightController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _lightAnimation = Tween<double>(begin: -1.0, end: 2.0)
        .animate(CurvedAnimation(parent: _lightController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    for (var controller in _letterControllers) {
      controller.dispose();
    }
    _zoomController.dispose();
    _lightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_zoomController, _lightController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _zoomAnimation.value,
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    begin: Alignment(_lightAnimation.value, 0.0),
                    end: Alignment(_lightAnimation.value + 0.3, 0.0),
                    colors: [
                      Colors.white.withOpacity(0.0),
                      Colors.white.withOpacity(0.4),
                      Colors.white.withOpacity(0.0),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(text.length, (i) {
                    return AnimatedBuilder(
                      animation: _letterAnimations[i],
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _letterAnimations[i].value),
                          child: Text(
                            text[i],
                            style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              fontFamily: "GentiumBookPlus",
                              color: textColor,
                              shadows: [
                                Shadow(
                                  blurRadius: 16,
                                  color: textColor.withOpacity(0.5),
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
