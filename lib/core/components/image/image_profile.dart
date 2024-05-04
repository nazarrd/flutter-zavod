import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../features/profile/models/user_model.dart';
import '../../utils/value_notifier.dart';

class ImageProfile extends StatelessWidget {
  const ImageProfile({
    super.key,
    this.radius = 40,
    this.iconSize = 45,
    this.padding,
  });

  final double radius;
  final double iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
      valueListenable: userDataNotifier,
      builder: (context, value, child) {
        return Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Builder(builder: (context) {
            if ((value?.photo) == null) {
              return CircleAvatar(
                radius: radius,
                child: Icon(Icons.person, size: iconSize),
              );
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.memory(
                base64Decode('${value?.photo}'),
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
              ),
            );
          }),
        );
      },
    );
  }
}
