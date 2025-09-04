import 'package:flutter/material.dart';
class AnimatedButton extends StatefulWidget {
  final Color? color;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;
  final Widget child;
  final bool enabled;
  final double? width;
  final int duration;
  final double height;
  final Color disabledColor;
  final double borderRadius;
  final VoidCallback onPressed;
  final ShadowDegree shadowDegree;
  final bool hasBorder;

  const AnimatedButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.height = 40,
    this.width,
    this.duration = 70,
    this.enabled = true,
    this.borderRadius = 12,
    this.color,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.disabledColor = Colors.grey,
    this.shadowDegree = ShadowDegree.light,
    this.hasBorder = false,
  })  : assert(
          color != null || gradientColors != null,
          'Either color or gradientColors must be provided',
        ),
        super(key: key);

  @override
  _AnimatedButtonState createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  static const Curve _curve = Curves.easeIn;
  static const double _shadowHeight = 4;
  final GlobalKey _buttonKey = GlobalKey();

  double _position = 4;

  @override
  Widget build(BuildContext context) {
    final double _height = widget.height - _shadowHeight;
    final bool isWidthInfinite = widget.width == double.infinity;
    final bool useGradient = widget.gradientColors != null;

    // Get colors for gradient or solid
    final List<Color> buttonColors = useGradient
        ? widget.gradientColors!
        : [widget.color ?? Colors.blue, widget.color ?? Colors.blue];

    // Create shadow colors (darker versions)
    final List<Color> shadowColors = buttonColors
        .map((color) => darken(color, widget.shadowDegree))
        .toList();

    // Disabled colors
    final List<Color> disabledColors = [
      widget.disabledColor,
      widget.disabledColor
    ];
    final List<Color> disabledShadowColors = [
      darken(widget.disabledColor, widget.shadowDegree),
      darken(widget.disabledColor, widget.shadowDegree)
    ];

    return GestureDetector(
      key: _buttonKey,
      onTapDown: widget.enabled ? _pressed : null,
      onTapUp: widget.enabled ? _onTapUp : null,
      onPanUpdate: widget.enabled ? _onPanUpdate : null,
      onPanEnd: widget.enabled ? _onPanEnd : null,
      child: SizedBox(
        width: widget.width,
        height: _height + _shadowHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              bottom: 0,
              left: isWidthInfinite ? 0 : null,
              right: isWidthInfinite ? 0 : null,
              child: Container(
                height: _height,
                width: widget.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors:
                        widget.enabled ? shadowColors : disabledShadowColors,
                    begin: widget.gradientBegin ?? Alignment.centerLeft,
                    end: widget.gradientEnd ?? Alignment.centerRight,
                  ),
                  borderRadius: _getBorderRadius(),
                ),
                child: widget.width == null
                    ? Opacity(opacity: 0, child: widget.child)
                    : null,
              ),
            ),
            AnimatedPositioned(
              curve: _curve,
              duration: Duration(milliseconds: widget.duration),
              bottom: _position,
              left: isWidthInfinite ? 0 : null,
              right: isWidthInfinite ? 0 : null,
              child: Container(
                height: _height,
                width: widget.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.enabled ? buttonColors : disabledColors,
                    begin: widget.gradientBegin ?? Alignment.centerLeft,
                    end: widget.gradientEnd ?? Alignment.centerRight,
                  ),
                  borderRadius: _getBorderRadius(),
                  border: widget.hasBorder
                      ? Border.all(
                          color: widget.enabled
                              ? shadowColors.last
                              : disabledShadowColors.last,
                          width: 1,
                        )
                      : null,
                ),
                child: Center(child: widget.child),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pressed(_) {
    setState(() {
      _position = 0;
    });
  }

  void _onTapUp(_) => _onPressed();

  void _onPressed() {
    setState(() {
      _position = 4;
    });
    widget.onPressed();
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      final buttonRect =
          Rect.fromLTWH(0, 0, renderBox.size.width, renderBox.size.height);

      if (!buttonRect.contains(localPosition)) {
        setState(() {
          _position = 4;
        });
      } else {
        setState(() {
          _position = 0;
        });
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    final RenderBox? renderBox =
        _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final localPosition = renderBox.globalToLocal(details.globalPosition);
      final buttonRect =
          Rect.fromLTWH(0, 0, renderBox.size.width, renderBox.size.height);

      if (buttonRect.contains(localPosition)) {
        _onPressed();
      }
    }
  }

  BorderRadius? _getBorderRadius() {
    return BorderRadius.circular(widget.borderRadius);
  }
}

Color darken(Color color, ShadowDegree degree) {
  double amount = degree == ShadowDegree.dark ? 0.3 : 0.12;
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

enum ShadowDegree { light, dark }
