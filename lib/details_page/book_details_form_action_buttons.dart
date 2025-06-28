import 'package:flutter/material.dart';

class BookDetailsFormActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final Future<void> Function() onDelete;
  final Color? saveColor;
  final Color? saveTextColor;
  final Color? deleteColor;
  final Color? deleteTextColor;

  const BookDetailsFormActionButtons({
    super.key,
    required this.onSave,
    required this.onDelete,
    this.saveColor,
    this.saveTextColor,
    this.deleteColor,
    this.deleteTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Tooltip(
              message: 'Save changes',
              child: Semantics(
                button: true,
                label: 'Save Book Details',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        saveColor ?? Theme.of(context).colorScheme.primary,
                    foregroundColor:
                        saveTextColor ??
                        Theme.of(context).colorScheme.onPrimary,
                  ),
                  onPressed: onSave,
                  child: const Text('Save'),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Tooltip(
              message: 'Delete book',
              child: Semantics(
                button: true,
                label: 'Delete Book',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deleteColor ?? Colors.redAccent,
                    foregroundColor: deleteTextColor ?? Colors.white,
                  ),
                  onPressed: onDelete,
                  child: const Text('Delete'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
