import 'package:flutter/material.dart';

class CustomTextfield extends StatefulWidget {
  final String hintText;
  final bool initialObscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;

  const CustomTextfield({
    super.key,
    required this.hintText,
    required this.initialObscureText,
    required this.controller,
    this.validator,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  late bool _obscureText = widget.initialObscureText;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        autofocus: false,

        obscureText: _obscureText, // Use local state
        controller: widget.controller,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.blue,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          fillColor: Theme.of(context).colorScheme.tertiary,
          filled: true,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: widget.initialObscureText
              ? Container(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: _toggleVisibility,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
