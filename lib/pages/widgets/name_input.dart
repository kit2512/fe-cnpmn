import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
    this.errorText,
    this.textInputAction,
    required this.onChanged,
    this.validator,
    this.labelText,
    this.enabled,
    this.initialValue,
  }) : super(key: key);
  final String? errorText;
  final TextInputAction? textInputAction;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final String? labelText;
  final bool? enabled;
  final String? initialValue;

  @override
  Widget build(BuildContext context) => TextFormField(
        key: const Key('nameInputKey'),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: labelText ?? 'Name',
          errorText: errorText,
        ),
        enabled: enabled,
        textInputAction: textInputAction,
        onChanged: onChanged,
        initialValue: initialValue,
      );
}
