import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/employee_entity.dart';

/// Visually stunning, modern SaaS Employee Card.
/// Displays only authentic entity fields (Name, ID, Email, Mobile, Location)
/// with elegant typography, soft ambient shadows, harmonious gradient avatar,
/// and direct action triggers (View, Edit, Delete).
class EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) {
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0].toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  List<Color> _getAvatarGradient(String name) {
    final gradients = [
      [const Color(0xFF4F46E5), const Color(0xFF7C3AED)], // Indigo to Purple
      [const Color(0xFF2563EB), const Color(0xFF06B6D4)], // Blue to Cyan
      [const Color(0xFF059669), const Color(0xFF10B981)], // Emerald
      [const Color(0xFFD97706), const Color(0xFFF59E0B)], // Amber
      [const Color(0xFFE11D48), const Color(0xFFFB7185)], // Rose
      [const Color(0xFF0F766E), const Color(0xFF14B8A6)], // Teal
    ];
    final hash = name.hashCode.abs();
    return gradients[hash % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _getInitials(employee.name);
    final avatarColors = _getAvatarGradient(employee.name);

    // Format real location: District, State, Country
    final locationParts = [
      if (employee.district.trim().isNotEmpty) employee.district.trim(),
      if (employee.state.trim().isNotEmpty) employee.state.trim(),
      if (employee.country.trim().isNotEmpty) employee.country.trim(),
    ];
    final locationText = locationParts.isNotEmpty
        ? locationParts.join(', ')
        : '—';

    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? AppColors.surfaceDark : Colors.white;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return Container(
      margin: EdgeInsets.only(
        bottom: AppResponsive.verticalSpacing(context, 12.0),
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppResponsive.scale(context, 14.0)),
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: AppResponsive.scale(context, 10.0),
            offset: Offset(0, AppResponsive.scale(context, 3.0)),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppResponsive.scale(context, 14.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppResponsive.scale(context, 14.0)),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.scale(context, 16.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Avatar + Name & ID + Action Menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Gradient Avatar with Initials or Network Image
                    Container(
                      width: AppResponsive.scale(context, 46.0),
                      height: AppResponsive.scale(context, 46.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: avatarColors,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: avatarColors[0].withValues(alpha: 0.25),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: AppResponsive.fontSize(context, 15.0),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: AppResponsive.fontSize(context, 15.0),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(width: AppResponsive.scale(context, 12.0)),

                    // Name + ID Badge + Country Tag
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  employee.name,
                                  style: TextStyle(
                                    fontSize: AppResponsive.fontSize(context, 15.5),
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.2,
                                    color: primaryTextColor,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: AppResponsive.scale(context, 8.0)),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppResponsive.scale(context, 7.0),
                                  vertical: AppResponsive.scale(context, 2.0),
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF2FF),
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Text(
                                  '#${employee.id}',
                                  style: TextStyle(
                                    fontSize: AppResponsive.fontSize(context, 11.0),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                    color: const Color(0xFF4F46E5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (employee.country.trim().isNotEmpty) ...[
                            SizedBox(height: AppResponsive.scale(context, 3.0)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.scale(context, 6.0),
                                vertical: AppResponsive.scale(context, 1.5),
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Text(
                                employee.country.toUpperCase(),
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 10.0),
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    // Quick Actions: Edit, Delete, or Menu
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          iconSize: AppResponsive.scale(context, 18.0),
                          color: secondaryTextColor,
                          tooltip: 'Edit Employee',
                          onPressed: onEdit,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          iconSize: AppResponsive.scale(context, 18.0),
                          color: Colors.red.shade400,
                          tooltip: 'Delete Employee',
                          onPressed: onDelete,
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: AppResponsive.scale(context, 12.0)),

                // Subtle Divider
                Container(
                  height: 1.0,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                ),

                SizedBox(height: AppResponsive.scale(context, 10.0)),

                // Info Rows: Email, Mobile, Location (Real Data Only)
                Row(
                  children: [
                    // Email
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          Icon(
                            Icons.mail_outline_rounded,
                            size: AppResponsive.scale(context, 13.5),
                            color: const Color(0xFF94A3B8),
                          ),
                          SizedBox(width: AppResponsive.scale(context, 6.0)),
                          Expanded(
                            child: Text(
                              employee.email.isNotEmpty ? employee.email : '—',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 12.5),
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppResponsive.scale(context, 10.0)),

                    // Phone / Mobile
                    Expanded(
                      flex: 4,
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: AppResponsive.scale(context, 13.5),
                            color: const Color(0xFF94A3B8),
                          ),
                          SizedBox(width: AppResponsive.scale(context, 6.0)),
                          Expanded(
                            child: Text(
                              employee.mobile.trim().isNotEmpty
                                  ? employee.mobile.trim()
                                  : '—',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 12.5),
                                color: secondaryTextColor,
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
                ),

                SizedBox(height: AppResponsive.scale(context, 8.0)),

                // Location row: District, State, Country
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: AppResponsive.scale(context, 13.5),
                      color: const Color(0xFF94A3B8),
                    ),
                    SizedBox(width: AppResponsive.scale(context, 6.0)),
                    Expanded(
                      child: Text(
                        locationText,
                        style: TextStyle(
                          fontSize: AppResponsive.fontSize(context, 12.5),
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: AppResponsive.scale(context, 11.0),
                      color: const Color(0xFFCBD5E1),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
