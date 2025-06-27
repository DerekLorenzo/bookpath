import 'package:flutter/material.dart';

class BookReadingStatusSelector extends StatelessWidget {
  final int statusIndex;
  final List<Map<String, Object>> statuses;
  final ValueChanged<int> onStatusChanged;

  const BookReadingStatusSelector({
    super.key,
    required this.statusIndex,
    required this.statuses,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity != null) {
          if (details.primaryVelocity! < 0) {
            // Swiped Left
            onStatusChanged((statusIndex + 1) % statuses.length);
          } else if (details.primaryVelocity! > 0) {
            // Swiped Right
            onStatusChanged(
              (statusIndex - 1 + statuses.length) % statuses.length,
            );
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(12),
          color: Colors.blueGrey.withOpacity(0.1),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => onStatusChanged(
                (statusIndex - 1 + statuses.length) % statuses.length,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.blueGrey,
                size: 24,
                semanticLabel: 'Previous status',
              ),
            ),
            Text(
              statuses[statusIndex]["status"] as String,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: statuses[statusIndex]["color"] as Color,
              ),
            ),
            InkWell(
              onTap: () => onStatusChanged((statusIndex + 1) % statuses.length),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.blueGrey,
                size: 24,
                semanticLabel: 'Next status',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
