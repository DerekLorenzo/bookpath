import 'package:flutter/material.dart';

class CharacterDialog extends StatelessWidget {
  CharacterDialog({super.key, required this.controller, this.initial});

  final TextEditingController controller;
  final String? initial;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(initial == null ? 'Add Character' : 'Edit Character'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: TextField(
          controller: controller,
          minLines: 1,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Character'),
          autofocus: true,
        ),
      ),
      actions: [
        if (initial != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context, {'action': 'delete'});
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final text = controller.text.trim();
            if (text.isNotEmpty) {
              Navigator.pop(context, {'action': 'save', 'value': text});
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
