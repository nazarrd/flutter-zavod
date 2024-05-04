import 'package:flutter/cupertino.dart';

import '../../extensions/context.dart';

class SwitchDefault extends StatelessWidget {
  const SwitchDefault({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: context.textTheme.bodyMedium),
      SizedBox(
        width: 42,
        child: Transform.scale(
          scale: 0.75,
          child: CupertinoSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ),
      ),
    ]);
  }
}
