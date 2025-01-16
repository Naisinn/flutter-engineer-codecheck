import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/repository_provider.dart';
import 'screens/search_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RepositoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GitHub Repository Search',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const SearchScreen(),
      // 他のルート設定を必要に応じて追加
    );
  }
}
