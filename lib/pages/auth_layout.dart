import 'package:fitnessbetav2/pages/sign_in.dart';
import 'package:fitnessbetav2/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'navbar.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({
    super.key,
    this.pageIfNotConnected,
  });

  final Widget? pageIfNotConnected;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: authService,
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            Widget widget;
            if (snapshot.connectionState == ConnectionState.waiting) {
              widget = const SplashScreen();
            }
            else if(snapshot.hasData){
              widget = const BottomnavState();
            }
            else {
              widget = pageIfNotConnected ?? const LoginPage();
            }
            return widget;
          },
        );
      },
    );
  }
}