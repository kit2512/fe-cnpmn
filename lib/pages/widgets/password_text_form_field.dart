import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PasswordTextFormField extends StatefulWidget {
  const PasswordTextFormField({
    Key? key,
    this.errorText,
    this.textInputAction,
    required this.onChanged,
    this.hint,
    this.labelText,
    this.validator,
    this.enabled,
  }) : super(key: key);
  final String? errorText;
  final TextInputAction? textInputAction;
  final void Function(String) onChanged;
  final String? Function(String?)? validator;
  final String? hint;
  final String? labelText;
  final bool? enabled;

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: _obscureText,
        validator: widget.validator,
        key: const Key('emailInputKey'),
        keyboardType: TextInputType.emailAddress,
        enabled: widget.enabled,
        decoration: InputDecoration(
          labelText: widget.labelText ?? 'Password',
          errorText: widget.errorText,
          hintText: widget.hint,
          suffixIcon: IconButton(
            icon: SvgPicture.asset(_obscureText ? 'assets/svg/eye-off.svg' : 'assets/svg/eye.svg'),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
        textInputAction: widget.textInputAction,
        onChanged: widget.onChanged,
      );
}
