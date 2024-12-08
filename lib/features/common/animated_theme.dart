import 'package:flutter/material.dart';
import '../../../../../../config/theme/colors.dart';

class AnimatedMoonSunIcon extends StatefulWidget {
  final bool isDarkMode;

  const AnimatedMoonSunIcon({super.key, required this.isDarkMode});

  @override
  State<AnimatedMoonSunIcon> createState() => _AnimatedMoonSunIconState();
}

class _AnimatedMoonSunIconState extends State<AnimatedMoonSunIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Set initial state based on the current theme
    if (widget.isDarkMode) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedMoonSunIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDarkMode != oldWidget.isDarkMode) {
      widget.isDarkMode ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FadeTransition(
          opacity: _animation,
          child: const Icon(
            Icons.brightness_high,
            color: AppColors.primaryBackground,
          ),
        ),
        FadeTransition(
          opacity: ReverseAnimation(_animation),
          child: const Icon(
            Icons.nightlight_round,
            color: AppColors.primaryText,
          ),
        ),
      ],
    );
  }
}
