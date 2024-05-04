import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get globalContext => navigatorKey.currentContext!;

Future<T?> nextScreen<T extends Object?>(Widget screen) async {
  return await navigatorKey.currentState!
      .push<T>(CupertinoPageRoute(builder: (context) => screen));
}

Future<void> nextReplace(Widget screen) async {
  await navigatorKey.currentState!
      .pushReplacement(MaterialPageRoute(builder: (context) => screen));
}

Future<void> nextRemoveUntil(Widget screen) async {
  await navigatorKey.currentState!.pushAndRemoveUntil(
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: const Duration(seconds: 1),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    ),
    (route) => false,
  );
}

void backScreen([dynamic result]) {
  navigatorKey.currentState!.pop(result);
}

void goBackUntil() {
  navigatorKey.currentState!.popUntil((route) => route.isFirst);
}
