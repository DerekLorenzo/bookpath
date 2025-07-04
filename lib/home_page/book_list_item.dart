import 'package:book_path/models/book_journal.dart';
import 'package:flutter/material.dart';
import 'package:book_path/home_page/parallax_flow_delegate.dart';
import 'dart:io';

@immutable
class BookListItem extends StatelessWidget {
  BookListItem({
    super.key,
    required this.title,
    required this.author,
    this.rating,
    required this.bookReadingStatus,
    this.coverImageAsset,
  });

  final String title;
  final String author;
  final double? rating;
  final BookReadingStatus bookReadingStatus;
  final String? coverImageAsset;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          '$title by $author'
          '${rating != null && rating != 0 ? ', rated $rating stars' : ''}'
          ', status: ${bookReadingStatus.name.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase()}',
      child: Semantics(
        label:
            '$title by $author'
            '${rating != null && rating != 0 ? ', rated $rating stars' : ''}'
            ', status: ${bookReadingStatus.name.replaceAll(RegExp(r'([A-Z])'), ' \$1').toLowerCase()}',
        button: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  _buildParallaxBackground(context),
                  _buildGradient(),
                  _buildTitleAndSubtitle(context),
                  _buildStatusIndicator(),
                  _buildRatingIndicator(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(BookReadingStatus status) {
    switch (status) {
      case BookReadingStatus.notStarted:
        return Colors.blueAccent;
      case BookReadingStatus.inProgress:
        return Colors.teal;
      case BookReadingStatus.completed:
        return Colors.brown.shade300;
    }
  }

  Widget _buildParallaxBackground(BuildContext context) {
    Widget backgroundImage;

    if (coverImageAsset != null && coverImageAsset?.isNotEmpty == true) {
      final file = File(coverImageAsset!);
      if (file.existsSync()) {
        backgroundImage = Image.file(
          File(coverImageAsset!),
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        );
      } else {
        backgroundImage = Image.asset(
          'assets/images/no_cover_found.png',
          key: _backgroundImageKey,
          fit: BoxFit.cover,
        );
      }
    } else {
      backgroundImage = Image.asset(
        'assets/images/no_cover_found.png',
        key: _backgroundImageKey,
        fit: BoxFit.cover,
      );
    }

    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [backgroundImage],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.3, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 24 * 2 - 120,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              author,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: _statusColor(bookReadingStatus),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildRatingIndicator() {
    if (rating == null || rating == 0) return const SizedBox.shrink();
    return Positioned(
      bottom: 20,
      right: 12,
      child: Row(
        children: [
          ...List.generate(5, (index) {
            final starValue = index + 1;
            IconData icon;
            if (rating! >= starValue) {
              icon = Icons.star;
            } else if (rating! >= starValue - 0.5) {
              icon = Icons.star_half;
            } else {
              icon = Icons.star_border;
            }
            return Icon(icon, size: 18, color: Colors.amber);
          }),
        ],
      ),
    );
  }
}
