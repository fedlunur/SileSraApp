import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_event.dart';
import 'package:silesra/features/Auth/presentation/block/user_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()..add(LoadUser()), // Initialize UserBloc
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 1));

    print("======> Splash screen checking");
    await context.read<UserBloc>().stream.firstWhere(
      (state) {
        print("======> Current state: $state");
        return state is UserLoaded || state is UserError;
      },
    );

    final userState = context.read<UserBloc>().state;
    print("======> User state: $userState");

    if (userState is UserLoaded) {
      context.go('/home');
    } else {
      context.go('/sign_in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF168AE3),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SvgPicture.asset(
                'assets/logo.svg',
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "ስለ ስራ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF8FCFF),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Version 1.0.0",
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFF8FCFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
