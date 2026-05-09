import 'package:flutter/material.dart';

import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      builder: (context, child) {
        return Container(
          color: Colors.grey.shade200,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 390,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
