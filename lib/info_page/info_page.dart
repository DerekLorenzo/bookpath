import 'package:book_path/info_page/privacy_notice.dart';
import 'package:book_path/info_page/terms_and_conditions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class InfoPage extends StatefulWidget {
  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      ExpansionTile(
        key: ValueKey('about'),
        title: Text('About', style: Theme.of(context).textTheme.headlineSmall),
        initiallyExpanded: expandedIndex == 0,
        onExpansionChanged: (expanded) {
          setState(() {
            expandedIndex = expanded ? 0 : null;
          });
        },
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Center(
                      child: Image.asset(
                        'assets/images/bookpath_banner_transparent.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'BookPath',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  'Version: 1.0.0',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Developer: EnzoLabs',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Contact: enzo.labs.help@gmail.com',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8),
                Text(
                  'Last updated: 2025-06-27',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 8),
                Text(
                  '© 2025 BookPath. All rights reserved.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
      ExpansionTile(
        key: ValueKey('terms'),
        title: Text(
          'Terms & Conditions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        initiallyExpanded: expandedIndex == 1,
        onExpansionChanged: (expanded) {
          setState(() {
            expandedIndex = expanded ? 1 : null;
          });
        },
        children: [
          LayoutBuilder(
            builder: (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.85,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: termsAndConditionsHtml,
                      style: {"p": Style(fontSize: FontSize(18))},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ExpansionTile(
        key: ValueKey('privacy'),
        title: Text(
          'Privacy Policy',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        initiallyExpanded: expandedIndex == 2,
        onExpansionChanged: (expanded) {
          setState(() {
            expandedIndex = expanded ? 2 : null;
          });
        },
        children: [
          LayoutBuilder(
            builder: (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight * 0.85,
              ),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Html(
                      data: privacyPolicyHtml,
                      style: {"p": Style(fontSize: FontSize(18))},
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('About & Terms'),
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: expandedIndex == null
                          ? tiles
                          : [tiles[expandedIndex!]],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
