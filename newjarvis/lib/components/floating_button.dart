import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final double dragOffset;
  final Function(double) onDragUpdate;
  final Function onTap;

  const FloatingButton({
    super.key,
    required this.dragOffset,
    required this.onDragUpdate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: dragOffset,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          onDragUpdate(details.delta.dy);
        },
        onTap: () => onTap(),
        child: Container(
          width: 55,
          height: 44,
          decoration: const BoxDecoration(
            color: Color.fromARGB(240, 213, 238, 248),
            borderRadius: BorderRadius.horizontal(left: Radius.circular(40)),
          ),
          child: Center(
            child: Image.asset("assets/icons/icon.png", width: 25, height: 25),
          ),
        ),
      ),
    );
  }
}
