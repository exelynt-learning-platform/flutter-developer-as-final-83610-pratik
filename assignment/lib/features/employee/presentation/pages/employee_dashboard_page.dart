import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/app_responsive.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';
import '../widgets/employee_card.dart';
import '../widgets/employee_shimmer_loading.dart';

/// PeopleFlow Employee Dashboard screen.
/// Displays user info in app bar, pull-to-refresh employee directory,
/// skeleton loading, error states, and empty states.
class EmployeeDashboardPage extends StatefulWidget {
  final UserEntity user;

  const EmployeeDashboardPage({super.key, required this.user});

  @override
  State<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Trigger initial fetch of employees
    context.read<EmployeeBloc>().add(const LoadEmployeesEvent());
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            // Mini Brand Squircle
            Container(
              width: AppResponsive.scale(context, 34.0),
              height: AppResponsive.scale(context, 34.0),
              decoration: BoxDecoration(
                color: const Color(0xFF4F46E5),
                borderRadius: BorderRadius.circular(
                  AppResponsive.scale(context, 10.0),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.people_outline_rounded,
                  size: AppResponsive.scale(context, 18.0),
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: AppResponsive.scale(context, 10.0)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PeopleFlow',
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 16.0),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  widget.user.email,
                  style: TextStyle(
                    fontSize: AppResponsive.fontSize(context, 11.0),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            color: const Color(0xFF64748B),
            onPressed: _onLogoutPressed,
          ),
          SizedBox(width: AppResponsive.scale(context, 6.0)),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppResponsive.maxContentWidth(context),
            ),
            child: RefreshIndicator(
              color: const Color(0xFF4F46E5),
              onRefresh: () async {
                context.read<EmployeeBloc>().add(const RefreshEmployeesEvent());
              },
              child: BlocBuilder<EmployeeBloc, EmployeeState>(
                builder: (context, state) {
                  return CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    slivers: [
                      // Section Header with count badge
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          AppResponsive.padding(context, 16.0),
                          AppResponsive.verticalSpacing(context, 16.0),
                          AppResponsive.padding(context, 16.0),
                          AppResponsive.verticalSpacing(context, 12.0),
                        ),
                        sliver: SliverToBoxAdapter(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Employees',
                                      style: TextStyle(
                                        fontSize: AppResponsive.fontSize(context, 20.0),
                                        fontWeight: FontWeight.w800,
                                        color: isDark
                                            ? AppColors.textPrimaryDark
                                            : const Color(0xFF0F172A),
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                    SizedBox(height: AppResponsive.scale(context, 2.0)),
                                    Text(
                                      'Manage workforce directory',
                                      style: TextStyle(
                                        fontSize: AppResponsive.fontSize(context, 12.0),
                                        color: const Color(0xFF64748B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: AppResponsive.scale(context, 12.0)),
                              if (state is EmployeeLoadedState)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppResponsive.scale(context, 10.0),
                                    vertical: AppResponsive.scale(context, 4.0),
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEEF2FF),
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                      color: const Color(0xFFC7D2FE),
                                    ),
                                  ),
                                  child: Text(
                                    '${state.employees.length} Members',
                                    style: TextStyle(
                                      fontSize: AppResponsive.fontSize(context, 12.0),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF4F46E5),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      // Content Body based on state
                      if (state is EmployeeLoadingState && !state.isRefreshing)
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.padding(context, 16.0),
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
                      else if (state is EmployeeEmptyState)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyView(context),
                        )
                      else if (state is EmployeeLoadedState)
                        SliverPadding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppResponsive.padding(context, 16.0),
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final employee = state.employees[index];
                                return EmployeeCard(
                                  employee: employee,
                                  onTap: () {
                                    context.push(
                                      RouteNames.employeeDetails,
                                      extra: employee,
                                    );
                                  },
                                );
                              },
                              childCount: state.employees.length,
                            ),
                          ),
                        )
                      else
                        const SliverToBoxAdapter(child: SizedBox.shrink()),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppResponsive.padding(context, 24.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.scale(context, 20.0)),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
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
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 6.0)),
            Text(
              'Pull down to refresh or check back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13.0),
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppResponsive.padding(context, 24.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(AppResponsive.scale(context, 20.0)),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
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
              ),
            ),
            SizedBox(height: AppResponsive.verticalSpacing(context, 6.0)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppResponsive.fontSize(context, 13.0),
                color: const Color(0xFF64748B),
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
