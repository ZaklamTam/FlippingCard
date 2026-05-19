import 'dart:math';

import 'package:flutter/material.dart';

class FlippableCard extends StatefulWidget {
  final int display;
  final bool faceUp;
  final bool enabled;
  final VoidCallback onTap;

  const FlippableCard({
    super.key,
    required this.display,
    required this.faceUp,
    this.enabled = true,
    required this.onTap
  });

  @override
  State<FlippableCard> createState() => _FlippableCardState();
}

class _FlippableCardState extends State<FlippableCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInBack,
        reverseCurve: Curves.easeInBack.flipped
    );

    if (widget.faceUp) {
      _controller.value = 1.0;  // turn the face up directly
    }
  }

  // when does it change? when the status of old widget is outdated
  @override
  void didUpdateWidget(covariant FlippableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.faceUp != widget.faceUp) {
      if (widget.faceUp) {  // flip
        _controller.forward();
      } else {  // cover back
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // _animation.value is in [0, 1]
            final angle = _animation.value * pi;
            final tilt = ((_animation.value - 0.5).abs() - 0.5) * 0.003;

            return Transform(
              transform: Matrix4.rotationY(angle)..setEntry(3, 0, tilt),
              alignment: Alignment.center,
              child: _animation.value < 0.5
                  ? _buildCard(Theme.of(context).colorScheme.inversePrimary, "HAHAHA")
                  : Transform.scale(
                      scaleX: -1,
                      scaleY: 1,
                      child: _buildCard(Theme.of(context).colorScheme.onPrimary, "${widget.display}",)
                    ),
            );
          },
        ),
      ),
    );
  }
  Widget _buildCard(Color color, String textBody) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          textBody,
          style: Theme.of(context).textTheme.headlineMedium,
        )
    );
  }
}