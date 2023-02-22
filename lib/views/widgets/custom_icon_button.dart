import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;
  final double? height;
  final double? width;

  const CustomIconButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.color,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      width: width ?? 22.0,
      height: height ?? 22.0,
      child: Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 2,
        child: IconButton(
            onPressed: onPressed,
            padding: const EdgeInsets.all(0),
            iconSize: 16,
            color: color?.withOpacity(0.8) ?? Colors.grey,
            icon: Icon(icon)),
      ),
    );
  }
}
