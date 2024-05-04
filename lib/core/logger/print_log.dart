import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';

void printLog(dynamic output, {bool isError = false}) {
  if (kDebugMode) {
    final color = isError ? '31m' : '32m';
    try {
      log('\x1B[$color${jsonEncode(output)}\x1B[0m');
    } catch (_) {
      final value = output.toString();
      const int maxLogSize = 1000;
      for (int i = 0; i <= value.length / maxLogSize; i++) {
        final int start = i * maxLogSize;
        int end = (i + 1) * maxLogSize;
        end = end > value.length ? value.length : end;
        print('\x1B[33m${value.substring(start, end)}\x1B[0m');
      }
    }
  }
}
