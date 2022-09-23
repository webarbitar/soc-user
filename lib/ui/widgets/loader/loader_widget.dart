import 'package:flutter/material.dart';
import 'dart:math' as math show sin, pi;

import '../../../core/constance/style.dart';

class LoaderWidget extends StatefulWidget {
  const LoaderWidget({
    Key? key,
    this.color = primaryColor,
    this.size = 20.0,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 2400),
    this.controller,
  }) : super(key: key);

  final Color color;
  final double size;
  final IndexedWidgetBuilder? itemBuilder;
  final Duration duration;
  final AnimationController? controller;

  @override
  State<LoaderWidget> createState() => _LoaderWidgetState();
}

class _LoaderWidgetState extends State<LoaderWidget> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ?? AnimationController(vsync: this, duration: widget.duration))
      ..repeat();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.fromSize(
        size: Size.square(widget.size),
        child: Center(
          child: Transform.rotate(
            angle: -45.0 * 0.0174533,
            child: Stack(
              children: List.generate(4, (i) {
                final size = widget.size * 0.5, position = widget.size * .5;
                return Positioned.fill(
                  top: position,
                  left: position,
                  child: Transform.scale(
                    scale: 1.1,
                    origin: Offset(-size * .5, -size * .5),
                    child: Transform(
                      transform: Matrix4.rotationZ(90.0 * i * 0.0174533),
                      child: Align(
                        alignment: Alignment.center,
                        child: FadeTransition(
                          opacity: DelayTween(begin: 0.0, end: 1.0, delay: 0.3 * i)
                              .animate(_controller!),
                          child:
                              SizedBox.fromSize(size: Size.square(size), child: _itemBuilder(i)),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) => widget.itemBuilder != null
      ? widget.itemBuilder!(context, index)
      : DecoratedBox(decoration: BoxDecoration(color: widget.color));
}

class DelayTween extends Tween<double> {
  DelayTween({required double begin, required double end, required this.delay})
      : super(begin: begin, end: end);

  final double delay;

  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
