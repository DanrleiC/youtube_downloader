import 'package:flutter/material.dart';
import 'package:youtube_downloader/app/utils/responsive_size.utils.dart';

/// Wrapper para cálculo dinâmico de tamanhos e animação.
class ResponsiveAnimatedBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveSizesUtils sizes) builder;
  final Duration duration;
  final Curve curve;

  const ResponsiveAnimatedBuilder({
    super.key,
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        final safeWidth = constraints.hasBoundedWidth && constraints.maxWidth < double.infinity ? constraints.maxWidth : mediaQuerySize.width;

        final safeHeight = constraints.hasBoundedHeight && constraints.maxHeight < double.infinity ? constraints.maxHeight : mediaQuerySize.height;

        final sizes = ResponsiveSizesUtils(
          width: safeWidth,
          height: safeHeight,
        );

        return _ResponsiveAnimatedChild(
          sizes: sizes,
          duration: duration,
          curve: curve,
          builder: builder,
        );
      },
    );
  }
}

/// Classe interna para gerenciar animação com AnimatedContainer.
class _ResponsiveAnimatedChild extends StatefulWidget {
  final ResponsiveSizesUtils sizes;
  final Widget Function(BuildContext, ResponsiveSizesUtils) builder;
  final Duration duration;
  final Curve curve;

  const _ResponsiveAnimatedChild({
    required this.sizes,
    required this.builder,
    required this.duration,
    required this.curve,
  });

  @override
  State<_ResponsiveAnimatedChild> createState() => _ResponsiveAnimatedChildState();
}

class _ResponsiveAnimatedChildState extends State<_ResponsiveAnimatedChild> {
  late ResponsiveSizesUtils _sizes;

  @override
  void initState() {
    super.initState();
    _sizes = widget.sizes;
  }

  @override
  void didUpdateWidget(covariant _ResponsiveAnimatedChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sizes != widget.sizes) {
      setState(() {
        _sizes = widget.sizes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      child: widget.builder(context, _sizes),
    );
  }
}

