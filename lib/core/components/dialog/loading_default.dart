import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingDefault extends StatelessWidget {
  /// Simple loading dialog with cupertino style and custom scale. This widget is expected to use when load some data or waiting for other widget.
  ///
  /// Example usage:
  /// ```dart
  /// return LoadingDefault();
  /// ```
  /// The [color] used to control the color of loading dialog.
  const LoadingDefault({super.key, this.color = Colors.blue});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 1.35,
        child: CupertinoActivityIndicator(color: color),
      ),
    );
  }
}
