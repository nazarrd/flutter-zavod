import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../extensions/context.dart';

class TextFieldDefault extends StatelessWidget {
  const TextFieldDefault({
    super.key,
    this.obscureText = false,
    this.enableSuggestions = false,
    this.autocorrect = false,
    this.isDense = true,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.controller,
    this.textInputAction,
    this.keyboardType,
    this.title,
    this.hintText,
    this.labelText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.onEditingComplete,
    this.onSubmitted,
    this.onChanged,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.minLines = 1,
    this.helperMaxLines = 4,
    this.maxLength,
    this.onTap,
    this.hintStyle,
    this.fillColor,
    this.contentPadding = const EdgeInsets.fromLTRB(16, 12, 16, 12),
    this.prefixStyle,
    this.focusNode,
    this.decoration,
    this.floatingLabelBehavior,
    this.inputFormatters,
    this.margin = EdgeInsets.zero,
    this.labelStyle,
    this.validator,
    this.initialValue,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.showCounter = true,
    this.style,
    this.prefixIconConstraints,
    this.borderRadius,
  });

  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool isDense;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final String? title;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final String? prefixText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? helperMaxLines;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final dynamic Function()? onTap;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final TextStyle? prefixStyle;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry margin;
  final TextStyle? labelStyle;
  final String? Function(String?)? validator;
  final String? initialValue;
  final AutovalidateMode autovalidateMode;
  final bool showCounter;
  final TextStyle? style;
  final BoxConstraints? prefixIconConstraints;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (title != null) Text(title!),
        if (title != null) const SizedBox(height: 10),
        TextFormField(
          autovalidateMode: autovalidateMode,
          initialValue: controller == null ? initialValue : null,
          onTap: onTap,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
          obscureText: obscureText,
          enableSuggestions: enableSuggestions,
          autocorrect: autocorrect,
          enabled: enabled,
          readOnly: readOnly || onTap != null,
          autofocus: autofocus,
          controller: controller,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          validator: validator,
          cursorWidth: 1,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onSubmitted,
          onChanged: onChanged,
          textCapitalization: textCapitalization,
          minLines: minLines,
          maxLines: maxLines,
          focusNode: focusNode,
          maxLength: maxLength,
          style: context.textTheme.bodyMedium,
          decoration: decoration ?? buildInputDecoration(context),
          inputFormatters: inputFormatters,
        ),
      ]),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      isDense: isDense,
      hintText: hintText,
      labelText: labelText,
      helperText: helperText,
      errorText: errorText,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      counterText: showCounter == true ? null : '',
      contentPadding: contentPadding,
      helperMaxLines: helperMaxLines,
      fillColor: readOnly ? Colors.grey.shade200 : fillColor,
      filled: readOnly || fillColor != null,
      floatingLabelBehavior: floatingLabelBehavior,
      border: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.black54, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        borderSide: BorderSide(
          color: fillColor ?? Colors.black54,
          width: 0.5,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        borderSide: BorderSide(
          color: fillColor ?? Colors.black54,
          width: 0.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: context.textTheme.bodySmall?.copyWith(color: Colors.red),
      helperStyle: context.textTheme.bodySmall,
      labelStyle: labelStyle ??
          context.textTheme.bodyMedium?.copyWith(color: Colors.black54),
      hintStyle: hintStyle ??
          context.textTheme.bodyMedium?.copyWith(color: Colors.black54),
      prefixStyle: prefixStyle ?? context.textTheme.bodyMedium,
      prefixIconConstraints: prefixIconConstraints,
    );
  }
}
