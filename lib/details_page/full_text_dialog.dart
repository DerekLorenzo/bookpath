import 'package:flutter/material.dart';

class FullTextDialog extends StatelessWidget {
  const FullTextDialog({
    super.key,
    required this.controller,
    required this.title,
    required this.onSave,
  });

  final TextEditingController controller;
  final String title;
  final ValueChanged<String> onSave;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.95,
        child: TextField(
          controller: controller,
          minLines: 5,
          maxLines: null,
          decoration: InputDecoration(border: OutlineInputBorder()),
          autofocus: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onSave(controller.text);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
