import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// PeopleFlow forgot password page with dynamic responsive sizing.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onResetPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        ForgotPasswordRequestedEvent(email: _emailController.text.trim()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: AppResponsive.scale(context, 18.0),
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          onPressed: () => context.pop(),
        ),
      ),
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
          } else if (state is PasswordResetSentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Password reset email sent to ${state.email}. Check your inbox.',
                ),
                backgroundColor: AppColors.success,
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
          final isSuccess = state is PasswordResetSentState;

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
                        // Header
                        const Center(child: AppBrandHeader()),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 32.0),
                        ),

                        Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: AppResponsive.fontSize(context, 24.0),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: AppResponsive.scale(context, 6.0)),
                        Text(
                          'Enter your verified email address and we will send you secure recovery instructions.',
                          style: AppTypography.subtitle(
                            context,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 24.0),
                        ),

                        // Email Input Field
                        AppTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'alex.turner@company.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: InputValidators.validateEmail,
                          enabled: !isLoading && !isSuccess,
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 24.0),
                        ),

                        // Action Button
                        AppButton(
                          label: isSuccess ? 'Email Sent' : 'Send Reset Link',
                          onPressed: isSuccess ? null : _onResetPressed,
                          isLoading: isLoading,
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 24.0),
                        ),

                        // Back to Sign In Link
                        Center(
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: AppResponsive.scale(context, 16.0),
                                  color: const Color(0xFF4F46E5),
                                ),
                                SizedBox(
                                  width: AppResponsive.scale(context, 6.0),
                                ),
                                Text(
                                  'Back to Sign In',
                                  style: TextStyle(
                                    fontSize:
                                        AppResponsive.fontSize(context, 14.0),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF4F46E5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: AppResponsive.scale(context, 16.0)),
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
