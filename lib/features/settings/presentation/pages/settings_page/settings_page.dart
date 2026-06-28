import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/padding/horizontal_padding.dart';
import 'widgets/legal_section.dart';
import 'widgets/port_setting_field.dart';

/// Settings screen, reused on both platforms.
///
/// On the macOS server the sharing port is configurable; both platforms show
/// links to the privacy policy and terms of use.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: HorizontalPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (Platform.isMacOS) ...[
                const PortSettingField(),
                const SizedBox(height: 24.0),
              ],
              const LegalSection(),
            ],
          ),
        ),
      ),
    );
  }
}
