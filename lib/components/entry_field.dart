import 'package:flutter/material.dart';

class EntryField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final Widget? prefix;
  final String? initialValue;
  final TextInputType? textInputType;
  final String? Function(String? value)? validator;
  final bool? obscureText;
  EntryField(
      {this.controller,
      this.hint,
      this.prefix,
      this.initialValue,
      this.validator,
      this.obscureText,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    print(obscureText);
    final theme = Theme.of(context);
    return TextFormField(
      keyboardType: textInputType,
      obscureText: obscureText ?? false,
      controller: controller,
      initialValue: initialValue,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        prefix: prefix,
        hintStyle: theme.textTheme.bodyText2!
            .copyWith(color: theme.hintColor, fontSize: 15),
      ),
    );
  }
}
