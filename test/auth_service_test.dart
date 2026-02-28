import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diploma_gameteach/auth_service.dart';

void main() {
  group('AuthService', () {
    test('getUserInfo returns stored user data', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'userName': 'Bek',
        'userEmail': 'bek@test.com',
      });

      final authService = AuthService();

      // Act
      final result = await authService.getUserInfo();

      // Assert
      expect(result['name'], 'Bek');
      expect(result['email'], 'bek@test.com');
    });

    test('getUserInfo returns null when no data exists', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});

      final authService = AuthService();

      // Act
      final result = await authService.getUserInfo();

      // Assert
      expect(result['name'], isNull);
      expect(result['email'], isNull);
    });
  });
}
