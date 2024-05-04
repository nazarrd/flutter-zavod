import 'package:flutter/material.dart';

import '../../constants/asset_path.dart';
import '../../extensions/context.dart';
import '../../services/navigation_service.dart';

class ErrorFeedback extends StatelessWidget {
  /// A reusable feedback component page to return feedback as a fullscreen.
  ///
  /// Example usage:
  /// ```dart
  /// ErrorFeedback(
  ///   title: 'Error Title',
  ///   subtitle: 'Error Description',
  /// ),
  /// ```
  /// The [icon] is expected as image file path from assets folder and it's optional. Will show error icon as default.
  ///
  /// The [title, subtitle] is free text.
  ///
  /// The [iconHeight] is optional with default value `50`.

  const ErrorFeedback({
    super.key,
    this.icon,
    this.title,
    required this.subtitle,
    this.iconHeight = 50,
  });

  final String? icon;
  final String? title;
  final String subtitle;
  final double iconHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(icon ?? AssetPath.errorGIF, height: iconHeight),
          if (title != null)
            Text(title!, style: globalContext.textTheme.headlineSmall),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: globalContext.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
