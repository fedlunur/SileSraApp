import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:silesra/core/config/router.dart';
import 'package:silesra/core/di/injector.dart';
import 'package:silesra/core/theme/theme.dart';
import 'package:silesra/features/Auth/presentation/block/user_bloc.dart';
import 'package:silesra/features/Auth/presentation/block/user_event.dart';
import 'package:silesra/features/POST/ListingProvider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await HiveService.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  setupDependencies();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ListingProvider()),
        BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc()..add(LoadUser()), // Dispatch LoadUser event
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      color: Colors.white,
      title: 'Silesra App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      routerConfig: router,
      debugShowCheckedModeBanner: false,

      // : const AuthPage(),
    );
  }
}
