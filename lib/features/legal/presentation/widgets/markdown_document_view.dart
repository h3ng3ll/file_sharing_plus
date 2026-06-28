import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

import '../../../../core/resources/colors/app_colors.dart';
import '../../../../core/resources/text/app_text_style.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/padding/horizontal_padding.dart';

/// Renders a bundled markdown asset as a scrollable, read-only document page.
///
/// Loads [assetPath] once and displays it under a [CustomAppBar] titled
/// [title]; the back button is provided automatically by the router.
class MarkdownDocumentView extends StatefulWidget {
  final String assetPath;
  final String title;

  const MarkdownDocumentView({
    super.key,
    required this.assetPath,
    required this.title,
  });

  @override
  State<MarkdownDocumentView> createState() => _MarkdownDocumentViewState();
}

class _MarkdownDocumentViewState extends State<MarkdownDocumentView> {
  late final Future<String> _markdownFuture;

  @override
  void initState() {
    super.initState();
    _markdownFuture = rootBundle.loadString(widget.assetPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: widget.title),
      body: FutureBuilder<String>(
        future: _markdownFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: HorizontalPadding(
              child: DefaultTextStyle.merge(
                style: AppTextStyle.regular14.value.copyWith(
                  color: AppColors.textPrimary.value,
                  height: 1.4,
                ),
                child: GptMarkdown(snapshot.data!),
              ),
            ),
          );
        },
      ),
    );
  }
}
