part of '../views/dashboard.dart';

class _IndexStackWithFadeAnimation extends StatefulWidget {
  const _IndexStackWithFadeAnimation({
    Key? key,
    required this.index,
    required this.children,
  }) : super(key: key);

  final int index;
  final List<Widget> children;

  @override
  State<_IndexStackWithFadeAnimation> createState() =>
      _IndexStackWithFadeAnimationState();
}

class _IndexStackWithFadeAnimationState
    extends State<_IndexStackWithFadeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void didUpdateWidget(_IndexStackWithFadeAnimation oldWidget) {
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        index: widget.index,
        children: widget.children,
      ),
    );
  }
}
