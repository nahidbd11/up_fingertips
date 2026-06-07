import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/ddlg_dashboard.dart';
import 'screens/uno_dashboard.dart';
import 'screens/engineer_dashboard.dart';
import 'screens/secretary_dashboard.dart';
import 'screens/chairman_dashboard.dart';
import 'screens/committee_dashboard.dart';
import 'screens/ward_member_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const UPFingertipsApp());
}

class UPFingertipsApp extends StatelessWidget {
  const UPFingertipsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        title: 'UP@Fingertips',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (_) => const LoginScreen(),
          '/ddlg': (_) => const DDLGDashboard(),
          '/uno': (_) => const UNODashboard(),
          '/engineer': (_) => const EngineerDashboard(),
          '/secretary': (_) => const SecretaryDashboard(),
          '/chairman': (_) => const ChairmanDashboard(),
          '/committee': (_) => const CommitteeDashboard(),
          '/ward_member': (_) => const WardMemberDashboard(),
        },
      ),
    );
  }
}
