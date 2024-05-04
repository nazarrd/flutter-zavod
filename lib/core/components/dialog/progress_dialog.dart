import 'package:flutter/material.dart';

import '../../services/navigation_service.dart';
import 'loading_default.dart';

/// This dialog used to cover full screen with a opacity dialog and loading indicator on top of it.
///
/// Example usage:
/// ```dart
/// progressDialog();
/// await Future.delayed(const Duration(seconds: 3));
/// progressDialog(close: true);
/// ```
/// The [close] is used to determine when to show/hide the dialog.
void progressDialog({bool close = false}) {
  if (close) return Navigator.pop(globalContext);
  showDialog(
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (context) => const LoadingDefault(color: Colors.white),
    context: globalContext,
    barrierDismissible: false,
  );
}
