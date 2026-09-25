import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';

/// Skeleton shimmer effect while loading the employee list.
class EmployeeShimmerLoading extends StatefulWidget {
  final int itemCount;

  const EmployeeShimmerLoading({super.key, this.itemCount = 6});

  @override
  State<EmployeeShimmerLoading> createState() => _EmployeeShimmerLoadingState();
}

class _EmployeeShimmerLoadingState extends State<EmployeeShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.itemCount,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                bottom: AppResponsive.verticalSpacing(context, 12.0),
              ),
              padding: EdgeInsets.all(AppResponsive.scale(context, 16.0)),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius:
                    BorderRadius.circular(AppResponsive.scale(context, 16.0)),
                border: Border.all(
                  color: baseColor.withValues(alpha: 0.4),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  // Avatar skeleton
                  Container(
                    width: AppResponsive.scale(context, 50.0),
                    height: AppResponsive.scale(context, 50.0),
                    decoration: BoxDecoration(
                      color: baseColor.withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(
                        AppResponsive.scale(context, 14.0),
                      ),
                    ),
                  ),
                  SizedBox(width: AppResponsive.scale(context, 14.0)),

                  // Text lines skeleton
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: AppResponsive.scale(context, 140.0),
                          height: AppResponsive.scale(context, 14.0),
                          decoration: BoxDecoration(
                            color: baseColor.withValues(alpha: _animation.value),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        SizedBox(height: AppResponsive.scale(context, 8.0)),
                        Container(
                          width: AppResponsive.scale(context, 200.0),
                          height: AppResponsive.scale(context, 11.0),
                          decoration: BoxDecoration(
                            color: baseColor.withValues(
                              alpha: _animation.value * 0.7,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        SizedBox(height: AppResponsive.scale(context, 8.0)),
                        Container(
                          width: AppResponsive.scale(context, 100.0),
                          height: AppResponsive.scale(context, 16.0),
                          decoration: BoxDecoration(
                            color: baseColor.withValues(
                              alpha: _animation.value * 0.5,
                            ),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
