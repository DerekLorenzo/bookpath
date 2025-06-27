import 'package:flutter/material.dart';

class StarRatingSelector extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final double starSize;
  final Color? color;

  const StarRatingSelector({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.starSize = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalWidth = starSize * 5;

    void handleUpdate(Offset localPosition) {
      double percent = localPosition.dx.clamp(0, totalWidth) / totalWidth;
      double newRating = (percent * 5).clamp(0, 5);
      newRating = (newRating * 2).round() / 2.0;
      onRatingChanged(newRating);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanDown: (details) => handleUpdate(details.localPosition),
      onPanUpdate: (details) => handleUpdate(details.localPosition),
      onTapDown: (details) => handleUpdate(details.localPosition),
      child: SizedBox(
        width: totalWidth,
        height: starSize,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            double starValue = index + 1;
            IconData icon;
            if (rating >= starValue) {
              icon = Icons.star;
            } else if (rating >= starValue - 0.5) {
              icon = Icons.star_half;
            } else {
              icon = Icons.star_border;
            }
            return Icon(
              icon,
              size: starSize,
              color: color ?? theme.colorScheme.primary,
              semanticLabel:
                  'Rating: $starValue star${starValue > 1 ? 's' : ''}',
            );
          }),
        ),
      ),
    );
  }
}
