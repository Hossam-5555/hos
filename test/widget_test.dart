import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:hos/main.dart';
import 'package:hos/core/serveces/myservisec.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Initialize GetX services (Myservisec with SharedPreferences)
    await initialservisec();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets(
    'App renders successfully with correct initial theme configuration',
    (WidgetTester tester) async {
      // Pump the main application widget
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verify the app renders without dependency errors
      expect(find.byType(GetMaterialApp), findsOneWidget);

      // Verify the initial theme configuration is loaded correctly
      final app = tester.widget<GetMaterialApp>(find.byType(GetMaterialApp));
      expect(app.themeMode, ThemeMode.system);
      expect(app.theme, isNotNull);
    },
  );
}
