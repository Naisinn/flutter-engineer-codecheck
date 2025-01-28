// test/appium.dart

import 'package:integration_test/integration_test.dart';
import 'package:flutter_engineer_codecheck/main.dart' as app;

void main() {
  // Flutter Driver Extension の代わりに IntegrationTestWidgetsFlutterBinding を初期化
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  app.main(); // 本番アプリの main.dart を呼び出す
}
