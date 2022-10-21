import 'package:flutter/material.dart';
import 'package:task/src/core/presenter/theme/responsive_outlet.dart';

import '../../../../core/presenter/shared/common_spacing.dart';
import '../../../../core/presenter/shared/common_text.dart';
import '../../../../core/presenter/theme/color_outlet.dart';

class RowDueDate extends StatelessWidget {
  final String text;

  const RowDueDate({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.more_time_outlined,
          color: ColorOutlet.iconColor,
        ),
        CommonSpacing.width(),
        CommonText(
          fontSize: ResponsiveOutlet.textMedium(context),
          text: text,
        ),
      ],
    );
  }
}
