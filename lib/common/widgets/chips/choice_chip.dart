import 'package:flutter/material.dart';
import 'package:shoe_admin/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TChoiceChip extends StatelessWidget {
  const TChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = THelperFunctions.getColor(text) != null ;
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
        child: ChoiceChip(
          label: isColor
              ? const SizedBox()
              :  Text(text),
          selected: selected,
          labelStyle: TextStyle(color: selected ? TColors.white : null),
          onSelected: onSelected,
          avatar: isColor
              ?  TCircularContainer(
            width: 50,
            height: 50,
            backgroundColor: THelperFunctions.getColor(text)!,
          )
              : null,
          shape: isColor ?  const CircleBorder() : null,
          labelPadding: isColor ?  const EdgeInsets.all(0) : null,
          padding: isColor ?  const EdgeInsets.all(0) : null,
          backgroundColor: isColor ?  THelperFunctions.getColor(text)! : null,
        )
    );
  }
}
