import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendwise/services/sharedPreferencesService.dart';

void main() {
  late SharedPreferencesService service;

  setUp(() {
    service = SharedPreferencesService();
    SharedPreferences.setMockInitialValues({});
  });

  group('SharedPreferencesService', () {
    test('saveStringValue stores string', () async {
      await service.saveStringValue('key', 'value');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('key'), 'value');
    });

    test('saveIntValue stores int', () async {
      await service.saveIntValue('intKey', 42);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('intKey'), 42);
    });

    test('saveBoolValue stores bool', () async {
      await service.saveBoolValue('boolKey', true);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('boolKey'), true);
    });

    test('getStringValue retrieves string', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('strKey', 'abc');
      final result = await service.getStringValue('strKey');
      expect(result, 'abc');
    });

    test('getIntValue retrieves int', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('intKey', 123);
      final result = await service.getIntValue('intKey');
      expect(result, 123);
    });

    test('getBoolValue retrieves bool', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('boolKey', false);
      final result = await service.getBoolValue('boolKey');
      expect(result, false);
    });

    test('clearPreferences clears all values', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('a', 'b');
      await prefs.setInt('c', 1);
      await prefs.setBool('d', true);

      await service.clearPreferences();

      expect(prefs.getString('a'), null);
      expect(prefs.getInt('c'), null);
      expect(prefs.getBool('d'), null);
    });
  });
}