import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../../domain/entities/employee_entity.dart';

/// Employee Details Screen displaying comprehensive profile data.
class EmployeeDetailsPage extends StatelessWidget {
  final EmployeeEntity employee;

  const EmployeeDetailsPage({super.key, required this.employee});

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

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Employee Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.padding(context, 16.0),
              vertical: AppResponsive.verticalSpacing(context, 16.0),
            ),
            child: AppCardContainer(
              maxWidth: AppResponsive.maxContentWidth(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: AppResponsive.scale(context, 12.0)),

                  // Large Profile Avatar
                  Container(
                    width: AppResponsive.scale(context, 96.0),
                    height: AppResponsive.scale(context, 96.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(
                        AppResponsive.scale(context, 28.0),
                      ),
                      border: Border.all(
                        color: const Color(0xFFC7D2FE),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4F46E5).withValues(alpha: 0.15),
                          blurRadius: AppResponsive.scale(context, 16.0),
                          offset: Offset(0, AppResponsive.scale(context, 6.0)),
                        ),
                      ],
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
                                  fontWeight: FontWeight.w800,
                                  fontSize: AppResponsive.fontSize(context, 32.0),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                color: const Color(0xFF4F46E5),
                                fontWeight: FontWeight.w800,
                                fontSize: AppResponsive.fontSize(context, 32.0),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: AppResponsive.scale(context, 16.0)),

                  // Full Name
                  Text(
                    employee.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppResponsive.fontSize(context, 22.0),
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                    ),
                  ),
                  SizedBox(height: AppResponsive.scale(context, 6.0)),

                  // Employee ID Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.scale(context, 10.0),
                      vertical: AppResponsive.scale(context, 4.0),
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'ID: #${employee.id}',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 12.0),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.verticalSpacing(context, 24.0)),

                  // Details List
                  _buildDetailTile(
                    context,
                    icon: Icons.mail_outline_rounded,
                    label: 'Email Address',
                    value: employee.email.isNotEmpty ? employee.email : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.phone_outlined,
                    label: 'Mobile Number',
                    value: employee.mobile.isNotEmpty ? employee.mobile : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.public_outlined,
                    label: 'Country',
                    value: employee.country.isNotEmpty ? employee.country : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.map_outlined,
                    label: 'State / Region',
                    value: employee.state.isNotEmpty ? employee.state : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.location_city_outlined,
                    label: 'District / City',
                    value: employee.district.isNotEmpty ? employee.district : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: 'Created Date',
                    value: employee.createdAt.isNotEmpty
                        ? employee.createdAt.split('T').first
                        : 'N/A',
                    isDark: isDark,
                  ),
                  SizedBox(height: AppResponsive.verticalSpacing(context, 16.0)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: AppResponsive.verticalSpacing(context, 10.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppResponsive.scale(context, 14.0),
        vertical: AppResponsive.scale(context, 12.0),
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppResponsive.scale(context, 12.0)),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppResponsive.scale(context, 8.0)),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(
              icon,
              size: AppResponsive.scale(context, 18.0),
              color: const Color(0xFF4F46E5),
            ),
          ),
          SizedBox(width: AppResponsive.scale(context, 14.0)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 11.0),
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: AppResponsive.scale(context, 2.0)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 14.0),
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : const Color(0xFF0F172A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
