import 'package:flutter/material.dart';

class BaseContainerDefaultComponent extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;

  /// Cor de de fundo do container.
  /// Caso não seja informado, será utilizado a cor padrão.
  /// Ao passar o backgroundColor, o container terá uma borda com a mesma cor. (se necessário criar uma nova variavel para passar a cor especifica da borda)
  final Color? backgroundColor;

  const BaseContainerDefaultComponent({required this.child, super.key, this.backgroundColor, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: child,
        )
      ),
    );
  }
}