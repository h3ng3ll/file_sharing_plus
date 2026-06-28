import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../../../../core/routes/init_router/init_router.dart';
import '../../../../../../core/widgets/section_card.dart';

/// Links to the Privacy Policy and Terms of Use documents.
class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  void _openPrivacy(BuildContext context) {
    context.push(AppRoutes.privacyPolicy);
  }

  void _openTerms(BuildContext context) {
    context.push(AppRoutes.termsOfUse);
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Legal',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: AppColors.primary.value,
            ),
            title: Text(
              'Privacy Policy',
              style: AppTextStyle.regular14.value,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openPrivacy(context),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.description_outlined,
              color: AppColors.primary.value,
            ),
            title: Text(
              'Terms of Use',
              style: AppTextStyle.regular14.value,
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openTerms(context),
          ),
        ],
      ),
    );
  }
}
