import 'package:flutter/material.dart';

Future<void> bottomSheetDefault(
  BuildContext context, {
  String? title,
  required Widget widget,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16),
  Color backgroundColor = Colors.white,
  bool useSafeArea = true,
  ScrollPhysics? physics,
  bool enableDrag = true,
  bool isDismissible = true,
}) {
  FocusManager.instance.primaryFocus?.unfocus();
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: isDismissible,
    useSafeArea: useSafeArea,
    isScrollControlled: true,
    enableDrag: enableDrag,
    showDragHandle: useSafeArea,
    transitionAnimationController: null,
    backgroundColor: backgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        topRight: Radius.circular(15),
      ),
    ),
    builder: (context) => SingleChildScrollView(
      physics: physics,
      padding: const EdgeInsets.only(bottom: 24),
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .8,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: padding,
              child: widget,
            ),
          ],
        ),
      ),
    ),
  );
}
