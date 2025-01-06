import 'package:flutter/material.dart';

class ScrollToBottomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isVisible;

  const ScrollToBottomFAB({
    super.key,
    required this.onPressed,
    this.isVisible = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isVisible ? 1.0 : 0.0,
      child: Visibility(
        visible: isVisible,
        child: FloatingActionButton.small(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          onPressed: onPressed,
          backgroundColor: Colors.blueAccent,
          elevation: 2.0,
          tooltip: "Scroll to bottom",
          child: const Icon(
            Icons.arrow_downward,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
