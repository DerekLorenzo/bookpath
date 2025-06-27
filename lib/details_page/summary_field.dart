import 'package:flutter/material.dart';

class SummaryField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final FormFieldValidator<String>? validator;

  const SummaryField({
    super.key,
    required this.controller,
    required this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: AbsorbPointer(
          child: TextFormField(
            controller: controller,
            maxLines: 5,
            minLines: 1,
            decoration: const InputDecoration(
              labelText: 'Summary',
              border: OutlineInputBorder(),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }
}
