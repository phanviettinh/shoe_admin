import 'package:flutter/material.dart';
import 'package:shoe_admin/common/widgets/layouts/grid_layout.dart';
import 'package:shoe_admin/common/widgets/shimmer/shimmer.dart';

class TBrandShimmer extends StatelessWidget {
  const TBrandShimmer({super.key, this.itemCount = 4});

  final int itemCount;
  @override
  Widget build(BuildContext context) {
    return TGridLayout(
        itemCount: itemCount,
        mainAxisExtent: 80,
        itemBuilder: (_, __) => const TShimmerEffect(width: 300, height: 80));
  }
}
