import 'package:flutter/material.dart';

import '../../../../../core/resources/colors/app_colors.dart';
import '../../../../../core/resources/text/app_text_style.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import '../../../../../core/widgets/section_card.dart';

/// Static screen describing the app and how to use it.
class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'How to Use'),
      body: const SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: HorizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionCard(
                title: 'About',
                child: _Paragraph(
                  'File Sharing transfers files between your Mac and iPhone '
                  'over the local Wi-Fi network. Nothing leaves your network — '
                  'there is no internet or cloud involved. The Mac runs the '
                  'server and shares a folder; the iPhone connects to it to '
                  'browse, download and upload files.',
                ),
              ),
              SizedBox(height: 16.0),
              SectionCard(
                title: 'Getting started',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StepTile(
                      number: 1,
                      text: 'On the Mac, open the app and tap "Start Server", '
                          'then choose a folder to share.',
                    ),
                    _StepTile(
                      number: 2,
                      text: 'On the iPhone, the Mac appears automatically in '
                          'the device list. If it does not, tap + and enter '
                          'the Mac\'s IP address and port manually.',
                    ),
                    _StepTile(
                      number: 3,
                      text: 'Tap a device to open its shared folder and browse '
                          'files.',
                    ),
                    _StepTile(
                      number: 4,
                      text: 'Tap the download icon next to a file to save it to '
                          'your iPhone, or tap "Upload" to send a file from the '
                          'Files app to the Mac.',
                    ),
                    _StepTile(
                      number: 5,
                      text: 'Watch the progress bar during a transfer and review '
                          'finished transfers in the history list.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              SectionCard(
                title: 'Tips',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BulletTile('Keep both devices on the same Wi-Fi network.'),
                    _BulletTile('Large files are supported — transfers stream '
                        'rather than loading everything into memory.'),
                    _BulletTile('All data stays on your local network.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A plain body paragraph.
class _Paragraph extends StatelessWidget {
  final String text;

  const _Paragraph(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyle.regular14.value.copyWith(
        color: AppColors.textSecondary.value,
        height: 1.4,
      ),
    );
  }
}

/// A numbered step in the "Getting started" section.
class _StepTile extends StatelessWidget {
  final int number;
  final String text;

  const _StepTile({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.0,
            height: 24.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.value,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: AppTextStyle.regular12.value.copyWith(
                color: AppColors.onPrimary.value,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.regular14.value.copyWith(
                color: AppColors.textPrimary.value,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A bullet point in the "Tips" section.
class _BulletTile extends StatelessWidget {
  final String text;

  const _BulletTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 10.0),
            child: Container(
              width: 6.0,
              height: 6.0,
              decoration: BoxDecoration(
                color: AppColors.accent.value,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.regular14.value.copyWith(
                color: AppColors.textPrimary.value,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
