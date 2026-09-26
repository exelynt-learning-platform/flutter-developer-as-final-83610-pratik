import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';

/// Clean modern skeleton shimmer matching the flat SaaS EmployeeCard layout.
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
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.35, end: 0.75).animate(
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
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE5E7EB);
    final baseShimmer = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

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
                bottom: AppResponsive.verticalSpacing(context, 10.0),
              ),
              padding: EdgeInsets.all(AppResponsive.scale(context, 16.0)),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius:
                    BorderRadius.circular(AppResponsive.scale(context, 12.0)),
                border: Border.all(
                  color: borderColor,
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar skeleton
                      Container(
                        width: AppResponsive.scale(context, 44.0),
                        height: AppResponsive.scale(context, 44.0),
                        decoration: BoxDecoration(
                          color: baseShimmer.withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(
                            AppResponsive.scale(context, 10.0),
                          ),
                        ),
                      ),
                      SizedBox(width: AppResponsive.scale(context, 12.0)),

                      // Name + Email lines skeleton
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: AppResponsive.scale(context, 120.0),
                                  height: AppResponsive.scale(context, 14.0),
                                  decoration: BoxDecoration(
                                    color: baseShimmer.withValues(
                                      alpha: _animation.value,
                                    ),
                                    borderRadius: BorderRadius.circular(3.0),
                                  ),
                                ),
                                SizedBox(width: AppResponsive.scale(context, 8.0)),
                                Container(
                                  width: AppResponsive.scale(context, 38.0),
                                  height: AppResponsive.scale(context, 14.0),
                                  decoration: BoxDecoration(
                                    color: baseShimmer.withValues(
                                      alpha: _animation.value * 0.7,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppResponsive.scale(context, 6.0)),
                            Container(
                              width: AppResponsive.scale(context, 180.0),
                              height: AppResponsive.scale(context, 11.0),
                              decoration: BoxDecoration(
                                color: baseShimmer.withValues(
                                  alpha: _animation.value * 0.6,
                                ),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppResponsive.scale(context, 12.0)),

                  // Divider
                  Container(
                    height: 1.0,
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  ),

                  SizedBox(height: AppResponsive.scale(context, 10.0)),

                  // Bottom info row skeleton (phone + location)
                  Row(
                    children: [
                      Container(
                        width: AppResponsive.scale(context, 90.0),
                        height: AppResponsive.scale(context, 10.0),
                        decoration: BoxDecoration(
                          color: baseShimmer.withValues(
                            alpha: _animation.value * 0.5,
                          ),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: AppResponsive.scale(context, 110.0),
                        height: AppResponsive.scale(context, 10.0),
                        decoration: BoxDecoration(
                          color: baseShimmer.withValues(
                            alpha: _animation.value * 0.5,
                          ),
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                    ],
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
