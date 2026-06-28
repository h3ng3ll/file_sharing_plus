import 'package:flutter/material.dart';

import '../../widgets/markdown_document_view.dart';

/// Displays the bundled terms of use markdown.
class TermsOfUsePage extends StatelessWidget {
  const TermsOfUsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MarkdownDocumentView(
      assetPath: 'assets/data/terms_of_use.md',
      title: 'Terms of Use',
    );
  }
}
