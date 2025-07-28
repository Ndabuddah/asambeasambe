import 'package:flutter_test/flutter_test.dart';
import 'package:rideapp/models/user_model.dart';
import 'package:rideapp/models/driver_model.dart';

void main() {
  group('Driver Login Tests', () {
    test('UserModel copyWith should work without bio parameter', () {
      final user = UserModel(
        uid: 'test-uid',
        email: 'test@example.com',
        name: 'John',
        surname: 'Doe',
        isDriver: true,
      );

      final updatedUser = user.copyWith(
        name: 'Jane',
        isOnline: true,
      );

      expect(updatedUser.name, 'Jane');
      expect(updatedUser.isOnline, true);
      expect(updatedUser.email, 'test@example.com'); // Should remain unchanged
    });

    test('DriverModel should handle missing fields gracefully', () {
      final driverData = {
        'userId': 'test-driver-id',
        'idNumber': '123456789',
        'name': 'John Driver',
        'phoneNumber': '+1234567890',
        'email': 'driver@example.com',
        'status': 0, // offline
        'isApproved': false,
      };

      final driver = DriverModel.fromMap(driverData);

      expect(driver.userId, 'test-driver-id');
      expect(driver.name, 'John Driver');
      expect(driver.status, DriverStatus.offline);
      expect(driver.isApproved, false);
      expect(driver.towns, isEmpty);
      expect(driver.documents, isEmpty);
    });

    test('UserModel should handle missing fields gracefully', () {
      final userData = {
        'uid': 'test-user-id',
        'email': 'user@example.com',
        'name': 'John User',
        'isDriver': true,
      };

      final user = UserModel.fromMap(userData);

      expect(user.uid, 'test-user-id');
      expect(user.email, 'user@example.com');
      expect(user.name, 'John User');
      expect(user.isDriver, true);
      expect(user.surname, ''); // Should default to empty string
      expect(user.isApproved, false); // Should default to false
      expect(user.savedAddresses, isEmpty);
      expect(user.recentRides, isEmpty);
    });
  });
} 