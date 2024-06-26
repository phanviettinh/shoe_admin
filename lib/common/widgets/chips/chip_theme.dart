import 'package:flutter/material.dart';
import 'package:shoe_admin/utils/constants/colors.dart';

class TChipTheme {
  TChipTheme._();
  static ChipThemeData lightChipTheme = ChipThemeData(
      disabledColor: TColors.grey.withOpacity(0.4),
      labelStyle: const TextStyle(color: TColors.black),
      selectedColor: TColors.primaryColor,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: TColors.white);

  static ChipThemeData darkChipTheme = const ChipThemeData(
      disabledColor: TColors.darkerGrey,
      labelStyle: TextStyle(color: TColors.white),
      selectedColor: TColors.primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: TColors.white);
}
