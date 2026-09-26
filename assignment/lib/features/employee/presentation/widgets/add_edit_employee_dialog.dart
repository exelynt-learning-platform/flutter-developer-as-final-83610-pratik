import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/utils/input_validators.dart';
import '../../domain/entities/employee_entity.dart';

/// Reusable modal bottom sheet for creating and editing an employee.
/// Features input validation, clean modern SaaS form fields, pre-population,
/// and smooth submission feedback with keyboard-aware layout.
class AddEditEmployeeDialog extends StatefulWidget {
  final EmployeeEntity? employee;
  final Function(EmployeeEntity employee) onSave;

  const AddEditEmployeeDialog({
    super.key,
    this.employee,
    required this.onSave,
  });

  /// Opens the Add/Edit form as a sleek, keyboard-responsive modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    EmployeeEntity? employee,
    required Function(EmployeeEntity employee) onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.54),
      builder: (ctx) => AddEditEmployeeDialog(
        employee: employee,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddEditEmployeeDialog> createState() => _AddEditEmployeeDialogState();
}

class _AddEditEmployeeDialogState extends State<AddEditEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _mobileController;
  late final TextEditingController _countryController;
  late final TextEditingController _stateController;
  late final TextEditingController _districtController;
  late final TextEditingController _avatarController;

  bool _isSubmitting = false;

  bool get isEditing => widget.employee != null;

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;
    _nameController = TextEditingController(text: emp?.name ?? '');
    _emailController = TextEditingController(text: emp?.email ?? '');
    _mobileController = TextEditingController(text: emp?.mobile ?? '');
    _countryController = TextEditingController(text: emp?.country ?? 'India');
    _stateController = TextEditingController(text: emp?.state ?? 'Maharashtra');
    _districtController = TextEditingController(text: emp?.district ?? '');
    _avatarController = TextEditingController(text: emp?.avatar ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final newOrUpdatedEmployee = EmployeeEntity(
      id: widget.employee?.id ?? '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      country: _countryController.text.trim(),
      state: _stateController.text.trim(),
      district: _districtController.text.trim(),
      avatar: _avatarController.text.trim().isNotEmpty
          ? _avatarController.text.trim()
          : (widget.employee?.avatar ?? ''),
      createdAt: widget.employee?.createdAt ?? DateTime.now().toIso8601String(),
    );

    widget.onSave(newOrUpdatedEmployee);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 20.0,
            offset: Offset(0, -4),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12.0, bottom: 8.0),
                width: 44.0,
                height: 5.0,
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white30 : Colors.black26),
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
            ),

            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: AppResponsive.scale(context, 40.0),
                    height: AppResponsive.scale(context, 40.0),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Icon(
                      isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
                      color: AppColors.primary,
                      size: AppResponsive.scale(context, 20.0),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? 'Edit Employee' : 'Add New Employee',
                          style: TextStyle(
                            fontSize: AppResponsive.scale(context, 18.0),
                            fontWeight: FontWeight.w700,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          isEditing
                              ? 'Update details for #${widget.employee?.id ?? ''}'
                              : 'Fill in employee details to register',
                          style: TextStyle(
                            fontSize: AppResponsive.scale(context, 12.0),
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: secondaryTextColor),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Divider(height: 1.0, color: borderColor),

            // Scrollable Form Fields
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildFormField(
                        context: context,
                        controller: _nameController,
                        label: 'Full Name *',
                        hint: 'e.g. John Doe',
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter full name';
                          }
                          if (value.trim().length < 2) {
                            return 'Name must be at least 2 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14.0),

                      _buildFormField(
                        context: context,
                        controller: _emailController,
                        label: 'Email Address *',
                        hint: 'e.g. john.doe@example.com',
                        prefixIcon: Icons.mail_outline_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter email address';
                          }
                          final emailRegExp = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegExp.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14.0),

                      _buildFormField(
                        context: context,
                        controller: _mobileController,
                        label: 'Mobile Number * (10 digits)',
                        hint: 'e.g. 9876543210',
                        prefixIcon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: InputValidators.validatePhone,
                      ),
                      const SizedBox(height: 14.0),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildFormField(
                              context: context,
                              controller: _countryController,
                              label: 'Country *',
                              hint: 'e.g. India',
                              prefixIcon: Icons.public_rounded,
                              validator: (val) => val == null || val.trim().isEmpty
                                  ? 'Enter country'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: _buildFormField(
                              context: context,
                              controller: _stateController,
                              label: 'State *',
                              hint: 'e.g. Maharashtra',
                              prefixIcon: Icons.location_city_rounded,
                              validator: (val) => val == null || val.trim().isEmpty
                                  ? 'Enter state'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14.0),

                      _buildFormField(
                        context: context,
                        controller: _districtController,
                        label: 'District *',
                        hint: 'e.g. Solapur / Mumbai',
                        prefixIcon: Icons.map_outlined,
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Please enter district'
                            : null,
                      ),
                      const SizedBox(height: 14.0),

                      _buildFormField(
                        context: context,
                        controller: _avatarController,
                        label: 'Avatar URL (Optional)',
                        hint: 'https://...',
                        prefixIcon: Icons.image_outlined,
                        keyboardType: TextInputType.url,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Fixed Footer Action Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        side: BorderSide(color: borderColor),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: _isSubmitting ? null : _submit,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              isEditing ? 'Save Changes' : 'Add Employee',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final fieldBg = isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppResponsive.scale(context, 12.5),
            fontWeight: FontWeight.w600,
            color: primaryTextColor,
          ),
        ),
        const SizedBox(height: 6.0),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: TextStyle(
            fontSize: AppResponsive.scale(context, 14.0),
            color: primaryTextColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: AppResponsive.scale(context, 13.0),
              color: secondaryTextColor.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              prefixIcon,
              size: AppResponsive.scale(context, 18.0),
              color: secondaryTextColor,
            ),
            filled: true,
            fillColor: fieldBg,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppResponsive.scale(context, 14.0),
              vertical: AppResponsive.scale(context, 12.0),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
