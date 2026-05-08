import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import Pages
import 'features/posts/presentation/pages/posts_list_page.dart';
import 'features/posts/presentation/pages/shopping_page.dart';

// Import Providers
import 'features/posts/presentation/providers/theme_provider.dart';

void main() {
  runApp(

    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Clean Riverpod App',
      debugShowCheckedModeBanner: false,

      // Theme settings
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blue,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blue,
      ),


      home: const PostsListPage(),
    );
  }
}