import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/resources/colors/app_colors.dart';
import '../../../../../../core/resources/text/app_text_style.dart';
import '../../../bloc/browser_bloc/browser_bloc.dart';

/// Shows the current folder path with an "up" control.
class PathBar extends StatelessWidget {
  const PathBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrowserBloc, BrowserState>(
      builder: (context, state) {
        return Container(
          color: AppColors.surface.value,
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 4.0,
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: state.isAtRoot
                    ? null
                    : () =>
                        context.read<BrowserBloc>().add(const BrowserEvent.goUp()),
              ),
              Expanded(
                child: Text(
                  state.isAtRoot ? '/' : '/${state.path}',
                  style: AppTextStyle.medium14.value.copyWith(
                    color: AppColors.textPrimary.value,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context
                    .read<BrowserBloc>()
                    .add(const BrowserEvent.loadFiles()),
              ),
            ],
          ),
        );
      },
    );
  }
}
