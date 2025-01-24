// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/repository_provider.dart';
import 'screens/search_screen.dart';

void main() {
  // Providerを利用してRepositoryProviderをグローバルに提供
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RepositoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

/// アプリのルートウィジェット
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repository Search',
      theme: ThemeData.light(),   // ライトテーマ
      darkTheme: ThemeData.dark(), // ダークテーマ
      home: const SearchScreen(),  // 最初の画面をSearchScreenに設定
      // 必要に応じて他のルートを設定
    );
  }
}
