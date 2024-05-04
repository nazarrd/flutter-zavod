import 'package:flutter/material.dart';

import '../../../core/components/image/image_profile.dart';
import '../../../core/components/input/textfield_default.dart';
import '../../../core/extensions/context.dart';

class TopMenuWidget extends StatelessWidget {
  const TopMenuWidget({
    super.key,
    required this.searchController,
    required this.onTap,
    required this.onSubmitted,
  });

  final TextEditingController searchController;
  final void Function()? onTap;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StatefulBuilder(builder: (context, setInnerState) {
        return TextFieldDefault(
          hintText: 'Search',
          controller: searchController,
          style: context.textTheme.bodyLarge,
          hintStyle: context.textTheme.bodyLarge?.copyWith(color: Colors.grey),
          fillColor: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(100),
          onChanged: (value) => setInnerState(() {}),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 12, right: 6),
            child: Icon(Icons.search_rounded, size: 20, color: Colors.grey),
          ),
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: Builder(builder: (context) {
            if (searchController.text.isNotEmpty) {
              return InkWell(
                onTap: onTap,
                child: const Icon(Icons.clear, size: 20),
              );
            }

            return InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const ImageProfile(
                radius: 10,
                iconSize: 24,
                padding: EdgeInsets.all(8),
              ),
            );
          }),
          textInputAction: TextInputAction.search,
          onSubmitted: onSubmitted,
        );
      }),
    );
  }
}
