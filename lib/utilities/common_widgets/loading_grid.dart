import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingGrid extends StatelessWidget {
  const LoadingGrid({
    super.key,
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GridView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 18, mainAxisSpacing: 20, childAspectRatio: 2 / 2.2),
        itemCount: 12,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[200]!,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: height * 0.4,
              width: height * 0.3,
              decoration: BoxDecoration(
                color: Colors.grey[300]!,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 0.4,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
