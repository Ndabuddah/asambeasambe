import 'package:flutter_test/flutter_test.dart';
import 'package:rideapp/services/network_service.dart';

void main() {
  group('NetworkService Tests', () {
    test('should check internet connection', () async {
      final hasInternet = await NetworkService.hasInternetConnection();
      expect(hasInternet, isA<bool>());
    });

    test('should get connectivity type', () async {
      final connectivityType = await NetworkService.getConnectivityType();
      expect(connectivityType, isNotNull);
    });

    test('should check WiFi connection', () async {
      final isWifi = await NetworkService.isConnectedToWifi();
      expect(isWifi, isA<bool>());
    });

    test('should check mobile connection', () async {
      final isMobile = await NetworkService.isConnectedToMobile();
      expect(isMobile, isA<bool>());
    });

    test('should get connectivity info', () async {
      final info = await NetworkService.getConnectivityInfo();
      expect(info, isA<Map<String, dynamic>>());
      expect(info.containsKey('connectivityType'), isTrue);
      expect(info.containsKey('hasInternet'), isTrue);
      expect(info.containsKey('isWifi'), isTrue);
      expect(info.containsKey('isMobile'), isTrue);
      expect(info.containsKey('isNone'), isTrue);
    });
  });
} 