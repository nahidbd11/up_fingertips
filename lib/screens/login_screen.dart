import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController(text: '01711-000001');
  final _passwordController = TextEditingController(text: '••••••••');

  final _roles = [
    _RoleOption('DDLG', 'ডিডিএলজি', Icons.account_balance_outlined, '/ddlg', 'District-level Monitoring'),
    _RoleOption('UNO', 'ইউএনও', Icons.supervisor_account_outlined, '/uno', 'Upazila Monitoring & Oversight'),
    _RoleOption('Upazila Engineer', 'উপজেলা প্রকৌশলী', Icons.engineering_outlined, '/engineer', 'Project Creation & Technical Review'),
    _RoleOption('UP Secretary', 'ইউপি সচিব', Icons.manage_accounts_outlined, '/secretary', 'Project Management & Reporting'),
    _RoleOption('UP Chairman', 'ইউপি চেয়ারম্যান', Icons.how_to_vote_outlined, '/chairman', 'Final Approval Authority'),
    _RoleOption('Committee Member', 'কমিটি সদস্য', Icons.group_outlined, '/committee', 'Site Monitoring & Photo Upload'),
    _RoleOption('Ward Member', 'ওয়ার্ড সদস্য', Icons.person_pin_circle_outlined, '/ward_member', 'Ward Project View & Photo Submission'),
  ];

  void _login(BuildContext context, String route) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushNamed(context, route);
      }
    });
  }

  void _showRoleSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RoleSelectorSheet(roles: _roles, onSelect: (route) {
        Navigator.pop(context);
        _login(context, route);
      }),
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // Header
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(40), blurRadius: 16.r, offset: const Offset(0, 4))],
                      ),
                      child: Icon(Icons.account_balance_rounded, size: 44.sp, color: AppColors.primary),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      'UP@Fingertips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'ডিজিটাল ইউনিয়ন পরিষদ ব্যবস্থাপনা',
                      style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13.sp, fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Digital Union Parishad Management System',
                      style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Login Form
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      Text(
                        'লগইন করুন',
                        style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                      ),
                      SizedBox(height: 24.h),

                      // User ID Field
                      const _FieldLabel('Mobile Number / User ID', 'মোবাইল নম্বর / ইউজার আইডি'),
                      SizedBox(height: 6.h),
                      TextFormField(
                        controller: _userIdController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: '01XXX-XXXXXX',
                          prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                          suffixIcon: Container(
                            margin: EdgeInsets.all(8.w),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(15),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text('Demo', style: TextStyle(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Password Field
                      const _FieldLabel('Password', 'পাসওয়ার্ড'),
                      SizedBox(height: 6.h),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: AppColors.textHint,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),

                      // Forgot password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password? • পাসওয়ার্ড ভুলে গেছেন?',
                              style: TextStyle(fontSize: 12.sp, color: AppColors.primary)),
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : () => _showRoleSelector(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 22.w,
                                  height: 22.h,
                                  child: CircularProgressIndicator(strokeWidth: 2.w, color: Colors.white),
                                )
                              : Text('Login • লগইন', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700)),
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Demo note
                      Container(
                        padding: EdgeInsets.all(14.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withAlpha(10),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.primary.withAlpha(40)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.primary, size: 18.sp),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                'Prototype Demo — tap Login to select your role and explore all dashboards.',
                                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),

                      // Footer
                      Center(
                        child: Text(
                          'Powered by LGED • Bangladesh Government',
                          style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  final String bangla;
  const _FieldLabel(this.label, this.bangla);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const Spacer(),
        Text(bangla, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
      ],
    );
  }
}

class _RoleOption {
  final String label;
  final String banglaLabel;
  final IconData icon;
  final String route;
  final String description;
  const _RoleOption(this.label, this.banglaLabel, this.icon, this.route, this.description);
}

class _RoleSelectorSheet extends StatelessWidget {
  final List<_RoleOption> roles;
  final void Function(String) onSelect;

  const _RoleSelectorSheet({required this.roles, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40.w, height: 4.h, decoration: BoxDecoration(color: AppColors.divider, borderRadius: BorderRadius.circular(2.r)))),
          SizedBox(height: 16.h),
          Text('Select Your Role', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text('আপনার ভূমিকা বেছে নিন — Prototype Demo', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
          SizedBox(height: 16.h),
          ...roles.map((r) => _RoleCard(role: r, onTap: () => onSelect(r.route))),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final _RoleOption role;
  final VoidCallback onTap;
  const _RoleCard({required this.role, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(15), borderRadius: BorderRadius.circular(10.r)),
              child: Icon(role.icon, color: AppColors.primary, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(role.label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  Text(role.banglaLabel, style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                  Text(role.description, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 14.sp, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
