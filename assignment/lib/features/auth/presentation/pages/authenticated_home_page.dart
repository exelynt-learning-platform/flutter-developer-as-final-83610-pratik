import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class AuthenticatedHomePage extends StatelessWidget {
  final UserEntity user;

  const AuthenticatedHomePage({super.key, required this.user});

  void _onLogoutPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size(90, 40),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Sign Out',
            onPressed: () => _onLogoutPressed(context),
          ),
          const SizedBox(width: AppDimensions.space8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.space24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.space24),
                      child: Row(
                        children: [
                          _UserAvatar(user: user),
                          const SizedBox(width: AppDimensions.space20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.displayName?.isNotEmpty == true
                                      ? user.displayName!
                                      : 'Authenticated User',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppDimensions.space4),
                                Text(
                                  user.email,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: AppDimensions.space8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppDimensions.space8,
                                    vertical: AppDimensions.space2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusSmall,
                                    ),
                                  ),
                                  child: const Text(
                                    'Active Session',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.space24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppSectionHeader(
                            icon: Icons.verified_user_rounded,
                            title: 'Authentication Complete (Phase 2)',
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          Text(
                            'You have successfully authenticated via Firebase Authentication. Protected routes, session persistence, and user profile integration are now active.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.textSecondaryDark
                                  : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.space16),
                          const Divider(),
                          const SizedBox(height: AppDimensions.space12),
                          _DetailRow(label: 'User ID', value: user.id),
                          const SizedBox(height: AppDimensions.space8),
                          _DetailRow(
                            label: 'Device Viewport',
                            value: AppResponsive.isTablet(context)
                                ? 'Tablet / Desktop'
                                : 'Mobile',
                          ),
                          const SizedBox(height: AppDimensions.space8),
                          const _DetailRow(
                            label: 'Next Milestone',
                            value: 'Phase 3 — REST API Data Layer',
                          ),
                          const SizedBox(height: AppDimensions.space24),
                          OutlinedButton.icon(
                            onPressed: () => _onLogoutPressed(context),
                            icon: const Icon(Icons.logout_rounded, size: 18),
                            label: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  final UserEntity user;

  const _UserAvatar({required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 32,
        backgroundImage: NetworkImage(user.photoUrl!),
        onBackgroundImageError: (_, _) {},
        child: _fallbackInitials(),
      );
    }
    return CircleAvatar(
      radius: 32,
      backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      child: _fallbackInitials(),
    );
  }

  Widget _fallbackInitials() {
    final initials = user.displayName?.isNotEmpty == true
        ? user.displayName![0].toUpperCase()
        : user.email.isNotEmpty
        ? user.email[0].toUpperCase()
        : '?';

    return Text(
      initials,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
