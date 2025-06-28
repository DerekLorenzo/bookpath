# BookPath

BookPath is a cross-platform Flutter application for journaling your reading journey. It allows you to track, review, and manage your books with a beautiful, modern interface. The app is designed for personal use and supports Android, iOS, web, and desktop platforms.

## Features

- **Book Journal:** Add, update, and remove books from your personal reading list.
- **Book Details:** View and edit details for each book, including cover images, reading status, and notes.
- **Home Page:** Enjoy a visually engaging home page with parallax scrolling for your book list.
- **Search:** Quickly find and add books using the integrated search bar.
- **Persistent Storage:** Your book list is saved locally using `shared_preferences`.
- **Cover Image Download:** Book cover images are downloaded and cached for offline use.
- **Accessibility:** Designed with accessibility and responsive layouts in mind.

## Project Structure

- `lib/core/` — App state, main app, and landing page
- `lib/home_page/` — Home page, parallax widgets, and search bar
- `lib/details_page/` — Book details and editing
- `lib/info_page/` — About, Terms, and Privacy Policy (HTML rendering)
- `lib/models/` — Data models for books, journals, and audits
- `assets/images/` — App logos and default images
- `test/` — Unit and widget tests

## Dependencies
- [Flutter](https://flutter.dev/)
- [provider](https://pub.dev/packages/provider)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [path_provider](https://pub.dev/packages/path_provider)
- [http](https://pub.dev/packages/http)
- [flutter_html](https://pub.dev/packages/flutter_html)

## Development Notes
- The app uses Material 3 theming.
- InfoPage uses ExpansionTiles for About, Terms, and Privacy Policy, with adaptive scrolling and HTML rendering.
- The app is responsive and supports both portrait and landscape orientations.
---

For questions or support, contact: enzo.labs.help@gmail.com
