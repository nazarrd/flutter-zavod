import 'package:flutter/material.dart';

class IntrinsicHeightScrollView extends StatelessWidget {
  /// A scrollable view that enforces an intrinsic height based on its content.
  ///
  /// The `IntrinsicHeightScrollView` widget is used to create a scrollable
  /// view that adjusts its height to fit its content. It ensures that the
  /// child widget inside it does not overflow vertically.
  ///
  /// Example usage:
  /// ```dart
  /// IntrinsicHeightScrollView(
  ///   child: MapView(),
  /// );
  /// ```
  ///
  /// In this example, the `IntrinsicHeightScrollView` will adjust its height
  /// to accommodate the `LoginForm` widget without causing vertical overflow.
  /// Creates an `IntrinsicHeightScrollView` with the specified [child].
  ///
  /// The [child] is the widget that will be displayed within the scroll view.
  const IntrinsicHeightScrollView({required this.child, super.key});

  /// The child widget to be displayed within the scroll view.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height,
        ),
        child: child,
      ),
    );
  }
}
