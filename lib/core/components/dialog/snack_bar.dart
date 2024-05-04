import 'package:flutter/material.dart';

import '../../extensions/context.dart';
import '../../services/navigation_service.dart';

enum SnackBarType { error, success, general, warning }

/// A custom snackbar for return feedback to user with some custom flag.
///
/// Example usage:
/// ```dart
/// showSnackBar(
///   text: 'This is an error mesage',
///   type: SnackBarType.error,
/// );
/// ```
/// The [text] is required for main content feedback.
/// The [type] is set default to general which is has black color. Error is red, success is blue and warning is yellow.
/// The [duration] used to timeout before snackbar was closed.
void showSnackBar({
  required String text,
  SnackBarType type = SnackBarType.general,
  Duration? duration,
}) {
  if (!globalContext.mounted) return;
  Color contentColor;
  IconData icon;
  if (type == SnackBarType.error) {
    contentColor = Colors.red;
    icon = Icons.error;
  } else if (type == SnackBarType.success) {
    contentColor = Colors.green;
    icon = Icons.check_circle_rounded;
  } else if (type == SnackBarType.general) {
    contentColor = Colors.black;
    icon = Icons.info;
  } else if (type == SnackBarType.warning) {
    contentColor = Colors.amber;
    icon = Icons.warning;
  } else {
    contentColor = Colors.black;
    icon = Icons.info;
  }

  ScaffoldMessenger.of(globalContext).removeCurrentSnackBar();
  ScaffoldMessenger.of(globalContext).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    elevation: 4,
    duration: duration ?? const Duration(milliseconds: 4000),
    padding: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(color: Colors.grey.withOpacity(0.05)),
    ),
    behavior: SnackBarBehavior.floating,
    content: Row(children: [
      Icon(icon, color: contentColor),
      const SizedBox(width: 12),
      Expanded(child: Text(text, style: globalContext.textTheme.bodyMedium))
    ]),
  ));
}
