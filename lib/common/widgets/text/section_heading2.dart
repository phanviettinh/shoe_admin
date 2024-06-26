import 'package:flutter/material.dart';
import 'package:shoe_admin/utils/constants/colors.dart';

class TSectionHeading2 extends StatelessWidget {
  const TSectionHeading2({
    super.key,
    this.textColor,
    this.title,
    this.fonSize,
  });

  final Color? textColor;
  final String? title;
  final double?  fonSize;

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Popular Categories',
          style:  TextStyle(color: TColors.white,fontSize: 18),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
