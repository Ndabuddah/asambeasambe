import 'package:flutter_test/flutter_test.dart';
import 'package:rideapp/services/permission_service.dart';

void main() {
  group('PermissionService Tests', () {
    test('should check location service enabled', () async {
      final isEnabled = await PermissionService.isLocationServiceEnabled();
      expect(isEnabled, isA<bool>());
    });

    test('should check location permission granted', () async {
      final isGranted = await PermissionService.isLocationPermissionGranted();
      expect(isGranted, isA<bool>());
    });

    test('should check background location permission granted', () async {
      final isGranted = await PermissionService.isBackgroundLocationPermissionGranted();
      expect(isGranted, isA<bool>());
    });

    test('should get permission status', () async {
      final status = await PermissionService.getPermissionStatus();
      expect(status, isA<Map<String, bool>>());
      expect(status.containsKey('locationGranted'), isTrue);
      expect(status.containsKey('backgroundLocationGranted'), isTrue);
      expect(status.containsKey('locationServiceEnabled'), isTrue);
    });

    test('should check if all permissions are granted', () async {
      final allGranted = await PermissionService.areAllPermissionsGranted();
      expect(allGranted, isA<bool>());
    });
  });
} 