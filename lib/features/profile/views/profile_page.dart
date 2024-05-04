import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/components/button/button_default.dart';
import '../../../core/components/dialog/base_dialog.dart';
import '../../../core/components/dialog/snack_bar.dart';
import '../../../core/components/image/image_profile.dart';
import '../../../core/components/input/switch_default.dart';
import '../../../core/components/input/textfield_default.dart';
import '../../../core/components/sheet/bottom_sheet_default.dart';
import '../../../core/extensions/context.dart';
import '../../../core/extensions/string.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/utils/value_notifier.dart';
import '../../../main.dart';
import '../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  bool saveHistory = true;
  UserModel? userData;

  @override
  void initState() {
    final data = getIt<LocalStorageService>().getString('userData');
    if (data != null) {
      userData = UserModel.fromJson(jsonDecode(data));
      nameController.text = userData?.fullName ?? '';
      emailController.text = userData?.email ?? '';
      saveHistory = userData?.saveHistory ?? false;
    } else {
      userData = UserModel();
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profile',
          style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
      ),
      floatingActionButton: Visibility(
        visible: !keyboardVisible,
        child: SizedBox(
          height: 40,
          child: FloatingActionButton.extended(
            onPressed: () {
              _confirmDialog(
                context,
                actionText: 'Reset',
                description:
                    'Are you sure you want to reset all app data? This action can\'t be undone.',
                onTap: () {
                  nameController.clear();
                  emailController.clear();
                  getIt<LocalStorageService>().clear();
                  updateUserDataValue(null);
                  Navigator.pop(globalContext);
                  showSnackBar(
                    text: 'Reset data success',
                    type: SnackBarType.success,
                  );
                },
              );
            },
            backgroundColor: Colors.red.shade800,
            label: Text(
              'Reset Data',
              style: context.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(padding: const EdgeInsets.all(16), children: [
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _pickImgSource(context),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const ImageProfile(),
              const SizedBox(height: 5),
              Text(
                'change photo',
                textAlign: TextAlign.center,
                style:
                    context.textTheme.bodyMedium?.copyWith(color: Colors.blue),
              ),
            ]),
          ),
          const SizedBox(height: 40),
          TextFieldDefault(
            labelText: 'Full Name',
            controller: nameController,
            margin: const EdgeInsets.only(bottom: 12),
            validator: (value) {
              if (value?.isEmpty ?? false) {
                return 'full name cannot be empty';
              }
              return null;
            },
          ),
          TextFieldDefault(
            labelText: 'Email Address',
            controller: emailController,
            margin: const EdgeInsets.only(bottom: 5),
            validator: (value) {
              if (value?.isEmpty ?? false) {
                return 'email address cannot be empty';
              } else if (!'$value'.isValidEmail) {
                return 'email address not valid';
              }
              return null;
            },
          ),
          SwitchDefault(
            label: 'Save History',
            value: saveHistory,
            onChanged: (value) => setState(() => saveHistory = value),
          ),
          const SizedBox(height: 24),
          ButtonDefault(
            'Save Data',
            width: 150,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (formKey.currentState!.validate()) {
                final data = UserModel(
                  fullName: nameController.text,
                  email: emailController.text,
                  photo: userData?.photo,
                  saveHistory: saveHistory,
                );
                getIt<LocalStorageService>()
                    .setString('userData', jsonEncode(data));
                updateUserDataValue(data);
                showSnackBar(
                  text: 'Data saved succesfully',
                  type: SnackBarType.success,
                );
              }
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _pickImgSource(BuildContext context) {
    return bottomSheetDefault(
      context,
      title: 'Pick Image Source',
      widget: Column(
        children: [
          (icon: Icons.camera_alt, value: 'Camera'),
          (icon: Icons.image, value: 'Gallery'),
          if (userData?.photo != null)
            (icon: Icons.delete, value: 'Delete Photo'),
        ].map((e) {
          final delete = e.icon == Icons.delete;
          return InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              Navigator.pop(context);
              if (delete) {
                _confirmDialog(
                  context,
                  actionText: 'Delete',
                  description:
                      'Are you sure you want to delete your profile photo? This action can\'t be undone.',
                  onTap: () {
                    getIt<LocalStorageService>().remove('userImg');
                    updateUserDataValue(null);
                    Navigator.pop(context);
                  },
                );
              } else {
                final camera = await Permission.camera.status;
                if (camera.isGranted) {
                  final pickedImage = await ImagePicker().pickImage(
                    source: e.icon == Icons.camera_alt
                        ? ImageSource.camera
                        : ImageSource.gallery,
                    imageQuality: 50,
                  );
                  if (pickedImage != null) {
                    final path = File(pickedImage.path);
                    final base64Img = base64Encode(path.readAsBytesSync());
                    getIt<LocalStorageService>()
                        .setString('userImg', base64Img);
                    userData?.photo = base64Img;
                    updateUserDataValue(userData);
                  }
                } else if (camera.isDenied || camera.isPermanentlyDenied) {
                  await Permission.camera.request();
                } else {
                  await Permission.camera.request();
                }
              }
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: delete ? Colors.red : Colors.grey,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      e.icon,
                      color: delete ? Colors.red : null,
                    ),
                  ),
                  Text(
                    e.value,
                    style: context.textTheme.bodyMedium
                        ?.copyWith(color: delete ? Colors.red : null),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _confirmDialog(
    BuildContext context, {
    required String description,
    required String actionText,
    required void Function()? onTap,
  }) {
    return baseDialog(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Text(
                  actionText,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () => Navigator.pop(context),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Text(
                  'Cancel',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
