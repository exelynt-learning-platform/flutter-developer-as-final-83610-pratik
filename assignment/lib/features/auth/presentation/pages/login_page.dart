import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/social_auth_button.dart';

/// PeopleFlow Sign-In page matching the modern SaaS reference interface.
/// Fully dynamic & responsive across phone, tablet, and desktop viewports.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequestedEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _onGoogleSignInPressed() {
    context.read<AuthBloc>().add(const GoogleSignInRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: AppCardContainer(
                  maxWidth: AppResponsive.maxContentWidth(context),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: AppResponsive.scale(context, 12.0)),

                        // Brand Icon & Title
                        const Center(child: AppBrandHeader()),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 32.0),
                        ),

                        // Email Field with External Label & Mail Icon
                        AppTextField(
                          controller: _emailController,
                          label: 'Email',
                          hint: 'alex.turner@company.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: InputValidators.validateEmail,
                          enabled: !isLoading,
                        ),
                        SizedBox(height: AppResponsive.scale(context, 16.0)),

                        // Password Field with Lock Icon & Visibility Toggle
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: '••••••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: InputValidators.validatePassword,
                          onFieldSubmitted: (_) => _onLoginPressed(),
                          enabled: !isLoading,
                        ),
                        SizedBox(height: AppResponsive.scale(context, 8.0)),

                        // Forgot Password Link (Right-aligned)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () => context.push(RouteNames.forgotPassword),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 4,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                fontSize: AppResponsive.fontSize(context, 13.0),
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 20.0),
                        ),

                        // Primary Sign In Button
                        AppButton(
                          label: 'Sign In',
                          onPressed: _onLoginPressed,
                          isLoading: isLoading,
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 20.0),
                        ),

                        // OR Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? AppColors.borderDark
                                    : const Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppResponsive.scale(context, 12.0),
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 11.0),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? AppColors.borderDark
                                    : const Color(0xFFE2E8F0),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 20.0),
                        ),

                        // Continue with Google Button
                        SocialAuthButton(
                          onPressed: isLoading ? null : _onGoogleSignInPressed,
                          isLoading: isLoading,
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 32.0),
                        ),

                        // Create Account Link (Teal Accent)
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 13.5),
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              GestureDetector(
                                onTap: isLoading
                                    ? null
                                    : () => context.push(RouteNames.register),
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize:
                                        AppResponsive.fontSize(context, 13.5),
                                    color: const Color(0xFF0D9488),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppResponsive.scale(context, 20.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
