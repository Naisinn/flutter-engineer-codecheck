// test/appium.dart

import 'package:appium_flutter_server/appium_flutter_server.dart';
import 'package:flutter_engineer_codecheck/main.dart' as app;

void main() {
  initializeTest(app: const app.MyApp());
}
