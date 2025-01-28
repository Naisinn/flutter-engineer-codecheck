//main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/repository_provider.dart';
import 'screens/search_screen.dart';

// 生成されるローカライズクラス
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  const MyApp({super.key}); // 変更: super.key を使用

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリのタイトルはローカライズ不要ならハードコードでも可
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,

      // ローカライズデリゲートの設定
      localizationsDelegates: const [
        AppLocalizations.delegate, // 生成されたローカライズクラス
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // 英語
        Locale('ja', ''), // 日本語
      ],

      // テーマ設定
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      home: const SearchScreen(),
    );
  }
}
