import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../domain/entities/employee_entity.dart';

/// Modal dialog for confirming deletion of an employee.
class DeleteEmployeeDialog extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onConfirmDelete;

  const DeleteEmployeeDialog({
    super.key,
    required this.employee,
    required this.onConfirmDelete,
  });

  static Future<bool?> show(
    BuildContext context, {
    required EmployeeEntity employee,
    required VoidCallback onConfirmDelete,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteEmployeeDialog(
        employee: employee,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return Dialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppResponsive.scale(context, 16.0)),
        side: BorderSide(color: borderColor),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppResponsive.scale(context, 20.0),
        vertical: AppResponsive.scale(context, 24.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppResponsive.scale(context, 420.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppResponsive.scale(context, 20.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Warning Icon Badge
              Container(
                width: AppResponsive.scale(context, 48.0),
                height: AppResponsive.scale(context, 48.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFECACA),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: AppResponsive.scale(context, 26.0),
                  ),
                ),
              ),

              SizedBox(height: AppResponsive.scale(context, 16.0)),

              // Title
              Text(
                'Delete Employee?',
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 18.0),
                  fontWeight: FontWeight.w700,
                  color: primaryTextColor,
                ),
              ),

              SizedBox(height: AppResponsive.scale(context, 8.0)),

              // Employee Info Pill
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.scale(context, 10.0),
                  vertical: AppResponsive.scale(context, 4.0),
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  '${employee.name} (ID: #${employee.id})',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 12.5),
                    fontWeight: FontWeight.w600,
                    color: primaryTextColor,
                  ),
                ),
              ),

              SizedBox(height: AppResponsive.scale(context, 10.0)),

              // Confirmation message
              Text(
                'Are you sure you want to remove this employee? This action is permanent and cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppResponsive.fontSize(context, 13.0),
                  color: secondaryTextColor,
                  height: 1.4,
                ),
              ),

              SizedBox(height: AppResponsive.scale(context, 20.0)),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondaryTextColor,
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: AppResponsive.scale(context, 11.0),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: AppResponsive.scale(context, 12.0)),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: AppResponsive.scale(context, 11.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                        onConfirmDelete();
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
