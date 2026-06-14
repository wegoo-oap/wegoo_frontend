import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

class WegooApp extends ConsumerWidget {
  const WegooApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'WeGoo',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}
