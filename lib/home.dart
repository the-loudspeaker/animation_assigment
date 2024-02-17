import 'package:flutter/material.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with TickerProviderStateMixin {
  late AnimationController _fadeInController;
  late AnimationController _textGrowController;
  late AnimationController _boxGrowController;
  PageState currentState = PageState.RESET;

  @override
  void initState() {
    _fadeInController =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener(statusListener);
    _textGrowController =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addStatusListener(statusListener);
    _boxGrowController =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..addStatusListener(statusListener);
    super.initState();
  }

  void statusListener(AnimationStatus status) {
    //Start textGrow and boxGrow subsequently.
    if (_fadeInController.isCompleted &&
        _textGrowController.isDismissed &&
        _boxGrowController.isDismissed) {
      _textGrowController.forward();
    }
    if (_fadeInController.isCompleted &&
        _textGrowController.isCompleted &&
        _boxGrowController.isDismissed) {
      _boxGrowController.forward();
    }
    // ANIMATING if any one is animating.
    if (status == AnimationStatus.forward ||
        status == AnimationStatus.reverse) {
      setState(() {
        currentState = PageState.ANIMATING;
      });
    }
    // COMPLETED when all complete.
    if (_fadeInController.isCompleted &&
        _textGrowController.isCompleted &&
        _boxGrowController.isCompleted) {
      setState(() {
        currentState = PageState.COMPLETE;
      });
    }
    // RESET when all dismissed.
    if (_fadeInController.isDismissed &&
        _textGrowController.isDismissed &&
        _boxGrowController.isDismissed) {
      setState(() {
        currentState = PageState.RESET;
      });
    }
  }

  @override
  void dispose() {
    _fadeInController.dispose();
    _textGrowController.dispose();
    _boxGrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 1.25).animate(
            CurvedAnimation(
              parent: _boxGrowController,
              curve: Curves.easeInOut,
            ),
          ),
          child: SizedBox(
            height: 375,
            width: 300,
            child: Stack(
              children: [
                FadeTransition(
                  opacity: _fadeInController,
                  child: Image.asset(
                    "assets/balloons.jpg",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _textGrowController,
                        curve: Curves.bounceInOut,
                      ),
                    ),
                    child: const Text(
                      "Animated text",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          switch (currentState) {
            case PageState.ANIMATING:
              break;
            case PageState.RESET:
              _fadeInController.forward();
              break;
            case PageState.COMPLETE:
              _fadeInController.reset();
              _textGrowController.reset();
              _boxGrowController.reset();
              break;
          }
        },
        child: currentState == PageState.RESET
            ? const Icon(Icons.play_arrow)
            : currentState == PageState.ANIMATING
            ? const Icon(Icons.pause)
            : const Icon(Icons.restart_alt),
      ),
    );
  }
}

enum PageState { ANIMATING, COMPLETE, RESET }
