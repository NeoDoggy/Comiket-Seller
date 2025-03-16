// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:comiket_seller/AppStates/StateFuncs.dart';
import 'package:comiket_seller/AppStates/Validators.dart';
import 'package:comiket_seller/globals.dart' as globals;
import 'package:comiket_seller/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:url_strategy/url_strategy.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  testWidgets('Add Item Button Smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();
    setPathUrlStrategy();
    if (kIsWeb) {
      globals.isInApp = false;
    } else if (Platform.isWindows) {
      globals.isInApp = true;
    }
    await tester.pumpWidget(const MyApp());

    expect(find.text('單品列表'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(find.text('儲存'), findsOneWidget);

    // Unit Test for Validators

  });

  group('Validators', () {

    group('validateProductName', () {
      test('null input returns error', () {
        expect(Validators.validateProductName(null), "請輸入正確的商品名稱");
      });
      test('empty input returns error', () {
        expect(Validators.validateProductName(""), "請輸入正確的商品名稱");
      });
      test('input containing {} returns error', () {
        expect(Validators.validateProductName("abc{def}"), "請輸入正確的商品名稱");
        expect(Validators.validateProductName("abc}def{"), "請輸入正確的商品名稱");
        expect(Validators.validateProductName("{abcdef"), "請輸入正確的商品名稱");
      });
      // need duplicate testing
      test('valid product name returns null', () {
        expect(Validators.validateProductName("ValidProduct"), null);
      });
    });

    group('validateSetName', () {
      test('null input returns error', () {
        expect(Validators.validateSetName(null), "請輸入正確的套組名稱");
      });
      test('empty input returns error', () {
        expect(Validators.validateSetName(""), "請輸入正確的套組名稱");
      });
      test('input containing {} returns error', () {
        expect(Validators.validateSetName("套組{錯誤}"), "請輸入正確的套組名稱");
      });
      // need duplicate testing
      test('valid set name returns null', () {
        expect(Validators.validateSetName("ValidSet"), null);
      });
    });

    group('validateProductNameAndSetName', () {
      test('null input returns error', () {
        expect(Validators.validateProductNameAndSetName(null, null, false),
            "請輸入正確的商品名稱");
      });
      test('empty input returns error', () {
        expect(Validators.validateProductNameAndSetName("", "", false),
            "請輸入正確的商品名稱");
      });
      test('input containing {} returns error', () {
        expect(Validators.validateProductNameAndSetName("abc{def}", "abc{def}", false),
            "請輸入正確的商品名稱");
      });
      // need duplicate testing
      // need duplicate testing
      test('valid input returns null', () {
        // 當 duplicate 檢查皆未觸發
        expect(Validators.validateProductNameAndSetName("Valid", "Last", false), null);
        expect(Validators.validateProductNameAndSetName("Valid", "Last", true), null);
      });
    });

    group('validatePrice', () {
      test('null input returns error', () {
        expect(Validators.validatePrice(null), "請輸入正確的價格");
      });
      test('empty input returns error', () {
        expect(Validators.validatePrice(""), "請輸入正確的價格");
      });
      test('non-numeric input returns error', () {
        expect(Validators.validatePrice("abc"), "請輸入正確的價格");
      });
      test('negative value returns error (boundary test)', () {
        expect(Validators.validatePrice("-1"), "請輸入正確的價格");
      });
      test('zero returns valid (boundary test)', () {
        expect(Validators.validatePrice("0"), null);
      });
      test('positive number returns valid', () {
        expect(Validators.validatePrice("100"), null);
      });
    });

    group('validateQuantity', () {
      test('null input returns error', () {
        expect(Validators.validateQuantity(null), "請輸入正確的數量");
      });
      test('empty input returns error', () {
        expect(Validators.validateQuantity(""), "請輸入正確的數量");
      });
      test('non-numeric input returns error', () {
        expect(Validators.validateQuantity("abc"), "請輸入正確的數量");
      });
      test('negative value returns error (boundary test)', () {
        expect(Validators.validateQuantity("-1"), "請輸入正確的數量");
      });
      test('zero returns valid (boundary test)', () {
        expect(Validators.validateQuantity("0"), null);
      });
      test('positive number returns valid', () {
        expect(Validators.validateQuantity("10"), null);
      });
    });

    group('validateURL', () {
      test('empty string returns null', () {
        expect(Validators.validateURL(""), null);
      });
      test('valid URL returns null', () {
        expect(Validators.validateURL("https://example.com"), null);
      });
      test('invalid URL returns error', () {
        expect(Validators.validateURL("invalid_url"), "請輸入正確圖片URL");
      });
    });
  });
}
