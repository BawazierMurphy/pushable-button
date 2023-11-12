library pushable_button;

import 'package:flutter/material.dart';

import 'animation_controller_state.dart';

/// A widget to show a "3D" pushable button
class PushableButton extends StatefulWidget {
  const PushableButton({
    Key? key,
    this.child,
    this.animationDuration,
    required this.color,
    required this.height,
    this.elevation = 8.0,
    this.borderRadius,
    this.onPressed,
  })  : assert(height > 0),
        super(key: key);

  /// child widget (normally a Text or Icon)
  final Widget? child;

  /// gesture Duration
  final Duration? animationDuration;

  /// Color of the top layer
  /// The color of the bottom layer is derived by decreasing the luminosity by 0.15
  final Color color;

  /// height of the top layer
  final double height;

  /// elevation or "gap" between the top and bottom layer
  final double elevation;

  /// An optional radius to make the button look better
  final double? borderRadius;

  /// button pressed callback
  final VoidCallback? onPressed;

  @override
  _PushableButtonState createState() =>
      _PushableButtonState(Duration(milliseconds: 100));
}

class _PushableButtonState extends AnimationControllerState<PushableButton> {
  _PushableButtonState(Duration duration) : super(duration);

  bool _isDragInProgress = false;
  Offset _gestureLocation = Offset.zero;

  void _handleTap() {
    animationController.forward();
    Future.delayed(widget.animationDuration ?? Duration(milliseconds: 100), () {
      if (!_isDragInProgress && mounted) {
        animationController.reverse();
      }
    });
  }

  void _handleTapDown(TapDownDetails details) {
    _gestureLocation = details.localPosition;
    animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    animationController.reverse();
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    Future.delayed(widget.animationDuration ?? Duration(milliseconds: 100), () {
      if (!_isDragInProgress && mounted) {
        animationController.reverse();
      }
    });
  }

  void _handleDragStart(DragStartDetails details) {
    _gestureLocation = details.localPosition;
    _isDragInProgress = true;
    animationController.forward();
  }

  void _handleDragEnd(Size buttonSize) {
    if (_isDragInProgress) {
      _isDragInProgress = false;
      animationController.reverse();
    }
    if (_gestureLocation.dx >= 0 &&
        _gestureLocation.dy < buttonSize.width &&
        _gestureLocation.dy >= 0 &&
        _gestureLocation.dy < buttonSize.height) {
      widget.onPressed?.call();
    }
  }

  void _handleDragCancel() {
    if (_isDragInProgress) {
      _isDragInProgress = false;
      animationController.reverse();
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _gestureLocation = details.localPosition;
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = widget.height + widget.elevation;
    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final buttonSize = Size(constraints.maxWidth, constraints.maxHeight);

          return GestureDetector(
            onTap: _handleTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            onHorizontalDragStart: _handleDragStart,
            onHorizontalDragEnd: (_) => _handleDragEnd(buttonSize),
            onHorizontalDragCancel: _handleDragCancel,
            onHorizontalDragUpdate: _handleDragUpdate,
            onVerticalDragStart: _handleDragStart,
            onVerticalDragEnd: (_) => _handleDragEnd(buttonSize),
            onVerticalDragCancel: _handleDragCancel,
            onVerticalDragUpdate: _handleDragUpdate,
            child: AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                final top = animationController.value * widget.elevation;
                final hslColor = HSLColor.fromColor(widget.color);
                final bottomHslColor =
                    hslColor.withLightness(hslColor.lightness - 0.15);
                return Stack(
                  children: [
                    // Draw bottom layer first
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: totalHeight - top,
                        decoration: BoxDecoration(
                          color: bottomHslColor.toColor(),
                          borderRadius: BorderRadius.circular(
                            widget.borderRadius ?? widget.height / 2,
                          ),
                        ),
                      ),
                    ),
                    // Then top (pushable) layer
                    Positioned(
                      left: 0,
                      right: 0,
                      top: top,
                      child: Container(
                        height: widget.height,
                        decoration: ShapeDecoration(
                          color: hslColor.toColor(),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              widget.borderRadius ?? widget.height / 2,
                            ),
                          ),
                        ),
                        child: Center(child: widget.child),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
