import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../domain/entities/employee_entity.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../widgets/add_edit_employee_dialog.dart';
import '../widgets/delete_employee_dialog.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_shimmer_loading.dart';

/// Visually stunning, professional SaaS Employee Dashboard.
/// Complete with full CRUD capabilities (Add, Edit, Delete with confirmation),
/// search by ID/Name/Email/Mobile/Country, multi-field filtering, sorting,
/// pull-to-refresh, smooth feedback notifications, and light/dark theme excellence.
class EmployeeDashboardPage extends StatefulWidget {
  final UserEntity user;

  const EmployeeDashboardPage({super.key, required this.user});

  @override
  State<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCountryFilter = 'All';
  String _activeSearchField = 'All'; // 'All', 'ID', 'Name', 'Email', 'Mobile', 'Country'
  String _sortBy = 'Name'; // 'Name', 'ID', 'Date'

  @override
  void initState() {
    super.initState();
    context.read<EmployeeBloc>().add(const LoadEmployeesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getUserInitials(UserEntity user) {
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      final parts = user.displayName!.trim().split(' ');
      if (parts.length >= 2) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }
    if (user.email.isNotEmpty) {
      return user.email.substring(0, 2).toUpperCase();
    }
    return 'AU';
  }

  String _getUserDisplayName(UserEntity user) {
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    if (user.email.isNotEmpty) {
      final namePart = user.email.split('@').first;
      if (namePart.isNotEmpty) {
        return namePart[0].toUpperCase() + namePart.substring(1);
      }
    }
    return 'User';
  }

  void _onLogoutPressed() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppResponsive.scale(context, 16.0)),
          ),
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          title: Text(
            'Sign Out',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 18.0),
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            'Are you sure you want to sign out of PeopleFlow?',
            style: TextStyle(
              fontSize: AppResponsive.fontSize(context, 14.0),
              color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.scale(context, 16.0),
                  vertical: AppResponsive.scale(context, 8.0),
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthBloc>().add(const LogoutRequestedEvent());
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }

  void _showProfileBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(AppResponsive.scale(context, 24.0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: AppResponsive.scale(context, 16.0)),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF4F46E5),
                  child: Text(
                    _getUserInitials(widget.user),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: AppResponsive.scale(context, 12.0)),
                Text(
                  widget.user.displayName ?? 'PeopleFlow Admin',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                ),
                SizedBox(height: AppResponsive.scale(context, 20.0)),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.red),
                  title: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _onLogoutPressed();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddEmployeeDialog() {
    AddEditEmployeeDialog.show(
      context,
      onSave: (newEmployee) {
        context.read<EmployeeBloc>().add(CreateEmployeeEvent(newEmployee));
      },
    );
  }

  void _openEditEmployeeDialog(EmployeeEntity employee) {
    AddEditEmployeeDialog.show(
      context,
      employee: employee,
      onSave: (updatedEmployee) {
        context.read<EmployeeBloc>().add(
              UpdateEmployeeEvent(id: employee.id, employee: updatedEmployee),
            );
      },
    );
  }

  void _openDeleteEmployeeDialog(EmployeeEntity employee) {
    DeleteEmployeeDialog.show(
      context,
      employee: employee,
      onConfirmDelete: () {
        context.read<EmployeeBloc>().add(DeleteEmployeeEvent(employee.id));
      },
    );
  }

  List<EmployeeEntity> _filterAndSort(List<EmployeeEntity> rawList) {
    final query = _searchController.text.trim().toLowerCase();
    var list = rawList.where((emp) {
      // 1. Search Query with Field Specificity or Global Search
      if (query.isNotEmpty) {
        if (_activeSearchField == 'ID') {
          final idMatch = emp.id.toLowerCase() == query ||
              emp.id.toLowerCase().contains(query) ||
              'emp-${emp.id}'.toLowerCase().contains(query) ||
              '#${emp.id}'.toLowerCase().contains(query);
          if (!idMatch) return false;
        } else if (_activeSearchField == 'Name') {
          if (!emp.name.toLowerCase().contains(query)) return false;
        } else if (_activeSearchField == 'Email') {
          if (!emp.email.toLowerCase().contains(query)) return false;
        } else if (_activeSearchField == 'Mobile') {
          if (!emp.mobile.toLowerCase().contains(query)) return false;
        } else if (_activeSearchField == 'Country') {
          if (!emp.country.toLowerCase().contains(query)) return false;
        } else {
          // Global Search
          final nameMatch = emp.name.toLowerCase().contains(query);
          final idMatch = emp.id.toLowerCase().contains(query) ||
              'emp-${emp.id}'.toLowerCase().contains(query) ||
              '#${emp.id}'.toLowerCase().contains(query);
          final emailMatch = emp.email.toLowerCase().contains(query);
          final mobileMatch = emp.mobile.toLowerCase().contains(query);
          final countryMatch = emp.country.toLowerCase().contains(query);
          final stateMatch = emp.state.toLowerCase().contains(query);
          final districtMatch = emp.district.toLowerCase().contains(query);

          if (!nameMatch &&
              !idMatch &&
              !emailMatch &&
              !mobileMatch &&
              !countryMatch &&
              !stateMatch &&
              !districtMatch) {
            return false;
          }
        }
      }

      // 2. Country Filter
      if (_selectedCountryFilter != 'All') {
        if (!emp.country.toLowerCase().contains(_selectedCountryFilter.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();

    // 3. Sorting
    if (_sortBy == 'Name') {
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_sortBy == 'ID') {
      list.sort((a, b) {
        final aInt = int.tryParse(a.id) ?? 0;
        final bInt = int.tryParse(b.id) ?? 0;
        return aInt.compareTo(bInt);
      });
    } else if (_sortBy == 'Date') {
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return list;
  }

  void _openFilterBottomSheet(BuildContext context, List<EmployeeEntity> employees) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppColors.surfaceDark : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    final uniqueCountries = <String>{'All'};
    for (final emp in employees) {
      if (emp.country.trim().isNotEmpty) {
        uniqueCountries.add(emp.country.trim());
      }
    }
    if (uniqueCountries.length == 1) {
      uniqueCountries.addAll(['India', 'United States', 'United Kingdom', 'Canada', 'Germany', 'Australia']);
    }

    String tempField = _activeSearchField;
    String tempCountry = _selectedCountryFilter;
    String tempSort = _sortBy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: surfaceColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppResponsive.scale(context, 20.0),
                  AppResponsive.scale(context, 12.0),
                  AppResponsive.scale(context, 20.0),
                  AppResponsive.scale(context, 20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: AppResponsive.scale(context, 16.0)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF2FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.tune_rounded,
                                color: Color(0xFF4F46E5),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Filter & Sort',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 18.0),
                                fontWeight: FontWeight.w700,
                                color: primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            setSheetState(() {
                              tempField = 'All';
                              tempCountry = 'All';
                              tempSort = 'Name';
                            });
                          },
                          child: const Text(
                            'Reset All',
                            style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    Text(
                      'FILTER BY FIELD',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 11.5),
                        fontWeight: FontWeight.w700,
                        color: secondaryTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: AppResponsive.scale(context, 8.0)),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: ['All', 'Name', 'Email', 'Mobile', 'Country', 'ID'].map((field) {
                        final isSelected = tempField == field;
                        return ChoiceChip(
                          label: Text(field == 'All' ? 'All Fields' : field),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setSheetState(() => tempField = field);
                          },
                          selectedColor: const Color(0xFF4F46E5),
                          backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : primaryTextColor,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            fontSize: AppResponsive.fontSize(context, 12.5),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              color: isSelected ? const Color(0xFF4F46E5) : borderColor,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: AppResponsive.scale(context, 16.0)),

                    Text(
                      'FILTER BY COUNTRY',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 11.5),
                        fontWeight: FontWeight.w700,
                        color: secondaryTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: AppResponsive.scale(context, 8.0)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: uniqueCountries.map((country) {
                          final isSelected = tempCountry.toLowerCase() == country.toLowerCase();
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ChoiceChip(
                              label: Text(country),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val) setSheetState(() => tempCountry = country);
                              },
                              selectedColor: const Color(0xFF4F46E5),
                              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : primaryTextColor,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                fontSize: AppResponsive.fontSize(context, 12.5),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(
                                  color: isSelected ? const Color(0xFF4F46E5) : borderColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: AppResponsive.scale(context, 16.0)),

                    Text(
                      'SORT BY',
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 11.5),
                        fontWeight: FontWeight.w700,
                        color: secondaryTextColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: AppResponsive.scale(context, 8.0)),
                    Row(
                      children: [
                        _buildSortRadio(
                          label: 'Name (A-Z)',
                          value: 'Name',
                          groupValue: tempSort,
                          onChanged: (val) => setSheetState(() => tempSort = val!),
                          isDark: isDark,
                          primaryTextColor: primaryTextColor,
                        ),
                        const SizedBox(width: 8),
                        _buildSortRadio(
                          label: 'ID',
                          value: 'ID',
                          groupValue: tempSort,
                          onChanged: (val) => setSheetState(() => tempSort = val!),
                          isDark: isDark,
                          primaryTextColor: primaryTextColor,
                        ),
                        const SizedBox(width: 8),
                        _buildSortRadio(
                          label: 'Date',
                          value: 'Date',
                          groupValue: tempSort,
                          onChanged: (val) => setSheetState(() => tempSort = val!),
                          isDark: isDark,
                          primaryTextColor: primaryTextColor,
                        ),
                      ],
                    ),
                    SizedBox(height: AppResponsive.scale(context, 24.0)),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _activeSearchField = tempField;
                            _selectedCountryFilter = tempCountry;
                            _sortBy = tempSort;
                          });
                          Navigator.of(sheetContext).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: AppResponsive.scale(context, 14.0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Apply Filters',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 14.0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortRadio({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
    required bool isDark,
    required Color primaryTextColor,
  }) {
    final isSelected = value == groupValue;
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(value),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEEF2FF)
                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1),
              width: 1.0,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF4F46E5) : primaryTextColor,
              ),
            ),
          ),
        ),
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

    return BlocConsumer<EmployeeBloc, EmployeeState>(
      listener: (context, state) {
        if (state is EmployeeLoadedState) {
          if (state.successMessage != null && state.successMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.successMessage!)),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Expanded(child: Text(state.errorMessage!)),
                  ],
                ),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final rawEmployees =
            state is EmployeeLoadedState ? state.employees : <EmployeeEntity>[];
        final filteredList = _filterAndSort(rawEmployees);

        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
          // --- APP BAR ---
          appBar: AppBar(
            elevation: 0,
            backgroundColor: surfaceColor,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            titleSpacing: AppResponsive.scale(context, 16.0),
            title: Row(
              children: [
                // App squircle icon badge
                Container(
                  width: AppResponsive.scale(context, 38.0),
                  height: AppResponsive.scale(context, 38.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppResponsive.scale(context, 10.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withValues(alpha: 0.25),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.badge_outlined,
                      size: AppResponsive.scale(context, 20.0),
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: AppResponsive.scale(context, 12.0)),

                // User Name + Employees & Count Pill
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getUserDisplayName(widget.user),
                      style: TextStyle(
                        fontSize: AppResponsive.fontSize(context, 17.5),
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: primaryTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppResponsive.scale(context, 2.0)),
                    Row(
                      children: [
                        Text(
                          'Employees',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 12.0),
                            fontWeight: FontWeight.w600,
                            color: secondaryTextColor,
                          ),
                        ),
                        SizedBox(width: AppResponsive.scale(context, 6.0)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.scale(context, 6.0),
                            vertical: AppResponsive.scale(context, 1.5),
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            rawEmployees.isNotEmpty ? '${rawEmployees.length}' : '0',
                            style: TextStyle(
                              fontSize: AppResponsive.fontSize(context, 11.0),
                              fontWeight: FontWeight.w700,
                              color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_outlined,
                  color: isDark ? const Color(0xFFFCD34D) : secondaryTextColor,
                ),
                tooltip: isDark ? 'Switch to Light Theme' : 'Switch to Dark Theme',
                iconSize: AppResponsive.scale(context, 22.0),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              GestureDetector(
                onTap: _showProfileBottomSheet,
                child: Container(
                  margin: EdgeInsets.only(
                    left: AppResponsive.scale(context, 4.0),
                    right: AppResponsive.scale(context, 16.0),
                  ),
                  width: AppResponsive.scale(context, 34.0),
                  height: AppResponsive.scale(context, 34.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4F46E5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getUserInitials(widget.user),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: AppResponsive.fontSize(context, 12.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // --- BODY ---
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: AppResponsive.maxContentWidth(context) + 160.0,
                ),
                child: RefreshIndicator(
                  color: const Color(0xFF4F46E5),
                  onRefresh: () async {
                    context.read<EmployeeBloc>().add(const RefreshEmployeesEvent());
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // 1. Search Bar + Small Filter Icon Beside It
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppResponsive.scale(context, 16.0),
                          AppResponsive.scale(context, 16.0),
                          AppResponsive.scale(context, 16.0),
                          AppResponsive.scale(context, 8.0),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: AppResponsive.scale(context, 46.0),
                                  decoration: BoxDecoration(
                                    color: surfaceColor,
                                    borderRadius: BorderRadius.circular(
                                      AppResponsive.scale(context, 12.0),
                                    ),
                                    border: Border.all(color: borderColor, width: 1.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: TextField(
                                    controller: _searchController,
                                    onChanged: (_) => setState(() {}),
                                    style: TextStyle(
                                      fontSize: AppResponsive.fontSize(context, 13.5),
                                      color: primaryTextColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: _activeSearchField == 'All'
                                          ? 'Search employees by ID, name...'
                                          : 'Search by $_activeSearchField...',
                                      hintStyle: TextStyle(
                                        color: const Color(0xFF94A3B8),
                                        fontSize: AppResponsive.fontSize(context, 13.0),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.search_rounded,
                                        color: const Color(0xFF94A3B8),
                                        size: AppResponsive.scale(context, 20.0),
                                      ),
                                      suffixIcon: _searchController.text.isNotEmpty
                                          ? IconButton(
                                              icon: const Icon(Icons.close_rounded, size: 18),
                                              color: const Color(0xFF94A3B8),
                                              onPressed: () {
                                                _searchController.clear();
                                                setState(() {});
                                              },
                                            )
                                          : null,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: AppResponsive.scale(context, 12.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: AppResponsive.scale(context, 10.0)),
                              // Small Filter Icon Beside Search Bar
                              Material(
                                color: (_activeSearchField != 'All' || _selectedCountryFilter != 'All')
                                    ? const Color(0xFF4F46E5)
                                    : surfaceColor,
                                borderRadius: BorderRadius.circular(
                                  AppResponsive.scale(context, 12.0),
                                ),
                                child: InkWell(
                                  onTap: () => _openFilterBottomSheet(context, rawEmployees),
                                  borderRadius: BorderRadius.circular(
                                    AppResponsive.scale(context, 12.0),
                                  ),
                                  child: Container(
                                    width: AppResponsive.scale(context, 46.0),
                                    height: AppResponsive.scale(context, 46.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        AppResponsive.scale(context, 12.0),
                                      ),
                                      border: Border.all(
                                        color: (_activeSearchField != 'All' || _selectedCountryFilter != 'All')
                                            ? const Color(0xFF4F46E5)
                                            : borderColor,
                                        width: 1.0,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.tune_rounded,
                                          size: AppResponsive.scale(context, 20.0),
                                          color: (_activeSearchField != 'All' || _selectedCountryFilter != 'All')
                                              ? Colors.white
                                              : (isDark ? Colors.white : const Color(0xFF0F172A)),
                                        ),
                                        if (_activeSearchField != 'All' || _selectedCountryFilter != 'All')
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: Container(
                                              width: 7,
                                              height: 7,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFF10B981),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 3. Meta Row: Showing Count & Sorting
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppResponsive.scale(context, 16.0),
                          AppResponsive.scale(context, 12.0),
                          AppResponsive.scale(context, 16.0),
                          AppResponsive.scale(context, 8.0),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Showing ${filteredList.length} employees',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 12.0),
                                  color: secondaryTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              PopupMenuButton<String>(
                                initialValue: _sortBy,
                                onSelected: (val) => setState(() => _sortBy = val),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: borderColor),
                                ),
                                color: surfaceColor,
                                elevation: 2,
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'Name',
                                    child: Text('Sorted by Name'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'ID',
                                    child: Text('Sorted by ID'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Date',
                                    child: Text('Sorted by Date'),
                                  ),
                                ],
                                child: Row(
                                  children: [
                                    Text(
                                      'Sorted by $_sortBy',
                                      style: TextStyle(
                                        fontSize: AppResponsive.fontSize(context, 12.0),
                                        fontWeight: FontWeight.w600,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: secondaryTextColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 4. Main Content: Skeleton, Error, Empty, or Cards List
                      if (state is EmployeeLoadingState && !state.isRefreshing)
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.scale(context, 16.0),
                          ),
                          sliver: const SliverToBoxAdapter(
                            child: EmployeeShimmerLoading(itemCount: 6),
                          ),
                        )
                      else if (state is EmployeeErrorState)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildErrorView(context, state.errorMessage),
                        )
                      else if (state is EmployeeEmptyState ||
                          (state is EmployeeLoadedState && filteredList.isEmpty))
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyView(context),
                        )
                      else if (state is EmployeeLoadedState)
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            AppResponsive.scale(context, 16.0),
                            0,
                            AppResponsive.scale(context, 16.0),
                            AppResponsive.scale(context, 88.0), // Padding for FAB
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final employee = filteredList[index];
                                return EmployeeCard(
                                  employee: employee,
                                  onTap: () {
                                    context.push(
                                      RouteNames.employeeDetails,
                                      extra: employee,
                                    );
                                  },
                                  onEdit: () => _openEditEmployeeDialog(employee),
                                  onDelete: () => _openDeleteEmployeeDialog(employee),
                                );
                              },
                              childCount: filteredList.length,
                            ),
                          ),
                        )
                      else
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // --- SMALL FLOATING ACTION BUTTON AT BOTTOM RIGHT ---
          floatingActionButton: FloatingActionButton.small(
            onPressed: _openAddEmployeeDialog,
            backgroundColor: const Color(0xFF4F46E5),
            foregroundColor: Colors.white,
            elevation: 4,
            tooltip: 'Add Employee',
            child: const Icon(Icons.add_rounded, size: 24),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppResponsive.padding(context, 24.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.scale(context, 20.0)),
              decoration: const BoxDecoration(
                color: Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.people_outline_rounded,
                size: AppResponsive.scale(context, 48.0),
                color: const Color(0xFF4F46E5),
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 16.0)),
            Text(
              'No Employees Found',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 18.0),
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 6.0)),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No results matching "${_searchController.text}". Try another query.'
                  : 'Get started by creating your company\'s first employee record.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13.0),
                color: secondaryTextColor,
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 18.0)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.scale(context, 18.0),
                  vertical: AppResponsive.scale(context, 11.0),
                ),
              ),
              onPressed: _openAddEmployeeDialog,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A);
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppResponsive.padding(context, 24.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.scale(context, 20.0)),
              decoration: const BoxDecoration(
                color: Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: AppResponsive.scale(context, 48.0),
                color: AppColors.error,
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 16.0)),
            Text(
              'Unable to Load Employees',
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 18.0),
                fontWeight: FontWeight.w700,
                color: primaryTextColor,
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 6.0)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13.0),
                color: secondaryTextColor,
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 20.0)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.scale(context, 20.0),
                  vertical: AppResponsive.scale(context, 12.0),
                ),
              ),
              onPressed: () {
                context.read<EmployeeBloc>().add(const LoadEmployeesEvent());
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry Connection'),
            ),
          ],
        ),
      ),
    );
  }
}
