import 'package:flutter/material.dart';

/// With this component, create an dialog will be much easier. We can focus on the child view and don't worry about wasting time to configure the dialog. Less code, less time, better.
///
/// Example usage:
/// ```dart
/// baseDialog(
///   context,
///   child: Text('this is a simple dialog'),
/// );
/// ```
/// The [child] is Widget type and can be anything around Flutter widget.
/// The [barrierDismissible] is used to define the dialog can be dismissed by outside tap or not.
void baseDialog(BuildContext context,
    {Widget? child, bool barrierDismissible = true}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => Dialog(
      surfaceTintColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height -
              MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: child,
      ),
    ),
  );
}
