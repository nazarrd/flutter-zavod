import 'package:flutter/material.dart';

import '../../features/profile/models/user_model.dart';

// listen userData value change
final userDataNotifier = ValueNotifier<UserModel?>(null);
void updateUserDataValue(UserModel? value) => userDataNotifier.value = value;
