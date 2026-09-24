import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/input_validators.dart';
import '../../../../core/widgets/core_widgets.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// PeopleFlow registration page with dynamic responsive sizing and clean SaaS aesthetics.
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        RegisterRequestedEvent(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          displayName: _nameController.text.trim(),
        ),
      );
    }
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

                        // Brand Header
                        const Center(child: AppBrandHeader()),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 32.0),
                        ),

                        // Full Name
                        AppTextField(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Alex Turner',
                          prefixIcon: Icons.person_outline_rounded,
                          validator: InputValidators.validateName,
                          enabled: !isLoading,
                        ),
                        SizedBox(height: AppResponsive.scale(context, 16.0)),

                        // Email
                        AppTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'alex.turner@company.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          validator: InputValidators.validateEmail,
                          enabled: !isLoading,
                        ),
                        SizedBox(height: AppResponsive.scale(context, 16.0)),

                        // Password
                        AppTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hint: '••••••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          isPassword: true,
                          textInputAction: TextInputAction.done,
                          validator: InputValidators.validatePassword,
                          onFieldSubmitted: (_) => _onRegisterPressed(),
                          enabled: !isLoading,
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 24.0),
                        ),

                        // Submit Button
                        AppButton(
                          label: 'Create Account',
                          onPressed: _onRegisterPressed,
                          isLoading: isLoading,
                        ),
                        SizedBox(
                          height: AppResponsive.verticalSpacing(context, 24.0),
                        ),

                        // Back to Sign In Link
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: AppResponsive.fontSize(context, 13.5),
                                  color: isDark
                                      ? AppColors.textSecondaryDark
                                      : const Color(0xFF64748B),
                                ),
                              ),
                              GestureDetector(
                                onTap: isLoading ? null : () => context.pop(),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize:
                                        AppResponsive.fontSize(context, 13.5),
                                    color: const Color(0xFF4F46E5),
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
