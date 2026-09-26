import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../../domain/entities/employee_entity.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../widgets/add_edit_employee_dialog.dart';
import '../widgets/delete_employee_dialog.dart';

/// Visually stunning, executive Employee Details Screen.
/// Displays comprehensive profile information with quick Edit & Delete actions.
class EmployeeDetailsPage extends StatefulWidget {
  final EmployeeEntity employee;

  const EmployeeDetailsPage({super.key, required this.employee});

  @override
  State<EmployeeDetailsPage> createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  late EmployeeEntity _currentEmployee;

  @override
  void initState() {
    super.initState();
    _currentEmployee = widget.employee;
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  List<Color> _getAvatarGradient(String name) {
    final gradients = [
      [const Color(0xFF4F46E5), const Color(0xFF7C3AED)],
      [const Color(0xFF2563EB), const Color(0xFF06B6D4)],
      [const Color(0xFF059669), const Color(0xFF10B981)],
      [const Color(0xFFD97706), const Color(0xFFF59E0B)],
      [const Color(0xFFE11D48), const Color(0xFFFB7185)],
      [const Color(0xFF0F766E), const Color(0xFF14B8A6)],
    ];
    final hash = name.hashCode.abs();
    return gradients[hash % gradients.length];
  }

  void _onEditPressed() {
    AddEditEmployeeDialog.show(
      context,
      employee: _currentEmployee,
      onSave: (updated) {
        setState(() => _currentEmployee = updated);
        context.read<EmployeeBloc>().add(
              UpdateEmployeeEvent(id: updated.id, employee: updated),
            );
      },
    );
  }

  void _onDeletePressed() {
    DeleteEmployeeDialog.show(
      context,
      employee: _currentEmployee,
      onConfirmDelete: () {
        context.read<EmployeeBloc>().add(DeleteEmployeeEvent(_currentEmployee.id));
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initials = _getInitials(_currentEmployee.name);
    final avatarColors = _getAvatarGradient(_currentEmployee.name);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Employee Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: _onEditPressed,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            color: Colors.red.shade400,
            tooltip: 'Delete Employee',
            onPressed: _onDeletePressed,
          ),
          const SizedBox(width: 8),
        ],
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

                  // Large Gradient Avatar
                  Container(
                    width: AppResponsive.scale(context, 96.0),
                    height: AppResponsive.scale(context, 96.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: avatarColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: avatarColors[0].withValues(alpha: 0.25),
                          blurRadius: AppResponsive.scale(context, 16.0),
                          offset: Offset(0, AppResponsive.scale(context, 6.0)),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _currentEmployee.avatar.isNotEmpty
                        ? Image.network(
                            _currentEmployee.avatar,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(
                              child: Text(
                                initials,
                                style: TextStyle(
                                  color: Colors.white,
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
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: AppResponsive.fontSize(context, 32.0),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(height: AppResponsive.scale(context, 16.0)),

                  // Full Name
                  Text(
                    _currentEmployee.name,
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
                      'ID: #${_currentEmployee.id}',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 12.0),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                  SizedBox(height: AppResponsive.verticalSpacing(context, 24.0)),

                  // Details List (Real fields only)
                  _buildDetailTile(
                    context,
                    icon: Icons.mail_outline_rounded,
                    label: 'Email Address',
                    value: _currentEmployee.email.isNotEmpty ? _currentEmployee.email : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.phone_outlined,
                    label: 'Mobile Number',
                    value: _currentEmployee.mobile.isNotEmpty ? _currentEmployee.mobile : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.public_outlined,
                    label: 'Country',
                    value: _currentEmployee.country.isNotEmpty ? _currentEmployee.country : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.map_outlined,
                    label: 'State / Region',
                    value: _currentEmployee.state.isNotEmpty ? _currentEmployee.state : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.location_city_outlined,
                    label: 'District / City',
                    value: _currentEmployee.district.isNotEmpty ? _currentEmployee.district : 'N/A',
                    isDark: isDark,
                  ),
                  _buildDetailTile(
                    context,
                    icon: Icons.calendar_today_outlined,
                    label: 'Created Date',
                    value: _currentEmployee.createdAt.isNotEmpty
                        ? _currentEmployee.createdAt.split('T').first
                        : 'N/A',
                    isDark: isDark,
                  ),
                  SizedBox(height: AppResponsive.verticalSpacing(context, 16.0)),

                  // Action Buttons Row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: AppResponsive.scale(context, 12.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _onEditPressed,
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          label: const Text('Edit Details'),
                        ),
                      ),
                      SizedBox(width: AppResponsive.scale(context, 12.0)),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                              vertical: AppResponsive.scale(context, 12.0),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: _onDeletePressed,
                          icon: const Icon(Icons.delete_outline_rounded, size: 18),
                          label: const Text('Delete'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppResponsive.verticalSpacing(context, 8.0)),
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
