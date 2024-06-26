import 'package:flutter/material.dart';
import 'package:shoe_admin/utils/constants/colors.dart';
import 'package:shoe_admin/utils/device/device_utility.dart';
import 'package:shoe_admin/utils/helpers/helper_funtions.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TTabBar({
    super.key, required this.tabs,
  });

  final List<Widget> tabs;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? TColors.black : TColors.white,
      child: SingleChildScrollView(
        child: TabBar(
              isScrollable: true,
              padding: EdgeInsets.only(right: 60),
              indicatorColor: TColors.primaryColor,
              unselectedLabelColor: TColors.darkGrey,
              // indicatorPadding: EdgeInsets.only(left: 40),
              labelColor: dark ? TColors.white : TColors.primaryColor,
              tabs: tabs),
        )

    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
