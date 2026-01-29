import 'package:flutter/material.dart';

class BaseContainerDefaultComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final void Function()? onTap;
  final Color? backgroundColor;

  const BaseContainerDefaultComponent({
    required this.child,
    super.key,
    this.backgroundColor,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        color: backgroundColor,
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.0),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: child,
          ),
        ),
      ),
    );
  }
}