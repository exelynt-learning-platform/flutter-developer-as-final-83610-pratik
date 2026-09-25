import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/employee_entity.dart';

/// Clean, responsive card displaying employee summary in the dashboard list.
class EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback? onTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onTap,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _getInitials(employee.name);

    final locationParts = [
      if (employee.district.isNotEmpty) employee.district,
      if (employee.state.isNotEmpty) employee.state,
      if (employee.country.isNotEmpty) employee.country,
    ];
    final locationText = locationParts.join(', ');

    return Container(
      margin: EdgeInsets.only(
        bottom: AppResponsive.verticalSpacing(context, 12.0),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(AppResponsive.scale(context, 16.0)),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: AppResponsive.scale(context, 10.0),
            offset: Offset(0, AppResponsive.scale(context, 4.0)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppResponsive.scale(context, 16.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppResponsive.scale(context, 16.0)),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.scale(context, 16.0)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar with network image or initials fallback
                Container(
                  width: AppResponsive.scale(context, 50.0),
                  height: AppResponsive.scale(context, 50.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(
                      AppResponsive.scale(context, 14.0),
                    ),
                    border: Border.all(
                      color: const Color(0xFFC7D2FE),
                      width: 1.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: employee.avatar.isNotEmpty
                      ? Image.network(
                          employee.avatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: const Color(0xFF4F46E5),
                                fontWeight: FontWeight.w700,
                                fontSize: AppResponsive.fontSize(context, 18.0),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              color: const Color(0xFF4F46E5),
                              fontWeight: FontWeight.w700,
                              fontSize: AppResponsive.fontSize(context, 18.0),
                            ),
                          ),
                        ),
                ),
                SizedBox(width: AppResponsive.scale(context, 14.0)),

                // Info details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Employee Name
                      Text(
                        employee.name,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 16.0),
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppResponsive.scale(context, 4.0)),

                      // Email
                      if (employee.email.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.mail_outline_rounded,
                              size: AppResponsive.scale(context, 13.0),
                              color: const Color(0xFF64748B),
                            ),
                            SizedBox(width: AppResponsive.scale(context, 5.0)),
                            Expanded(
                              child: Text(
                                employee.email,
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 13.0),
                                  color: const Color(0xFF64748B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      // Location pill
                      if (locationText.isNotEmpty) ...[
                        SizedBox(height: AppResponsive.scale(context, 6.0)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.scale(context, 8.0),
                            vertical: AppResponsive.scale(context, 3.0),
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: AppResponsive.scale(context, 11.0),
                                color: const Color(0xFF64748B),
                              ),
                              SizedBox(width: AppResponsive.scale(context, 4.0)),
                              Flexible(
                                child: Text(
                                  locationText,
                                  style: TextStyle(
                                    fontSize:
                                        AppResponsive.fontSize(context, 11.0),
                                    color: const Color(0xFF475569),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Right arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: const Color(0xFF94A3B8),
                  size: AppResponsive.scale(context, 22.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
