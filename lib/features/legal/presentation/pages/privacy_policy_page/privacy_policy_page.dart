import 'package:flutter/material.dart';

import '../../widgets/markdown_document_view.dart';

/// Displays the bundled privacy policy markdown.
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarkdownDocumentView(
      assetPath: 'assets/data/privacy_policy.md',
      title: 'Privacy Policy',
    );
  }
}
