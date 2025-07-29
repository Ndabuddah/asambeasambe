import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionService {
  static const String _locationPermissionKey = 'location_permission_explained';
  static const String _backgroundLocationPermissionKey = 'background_location_permission_explained';
  static const String _dontAskAgainKey = 'location_permission_dont_ask_again';

  // Check if location permission is granted
  static Future<bool> isLocationPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }

  // Check if background location permission is granted
  static Future<bool> isBackgroundLocationPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always;
  }

  // Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Request location permission
  static Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.requestPermission();
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always;
  }

  // Request background location permission
  static Future<bool> requestBackgroundLocationPermission() async {
    // First ensure we have basic location permission
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    
    // For background location, we need to request again to get "always" permission
    if (permission == LocationPermission.whileInUse) {
      permission = await Geolocator.requestPermission();
    }
    
    return permission == LocationPermission.always;
  }

  // Check if we should show permission explanation
  static Future<bool> shouldShowLocationPermissionExplanation() async {
    final prefs = await SharedPreferences.getInstance();
    final dontAskAgain = prefs.getBool(_dontAskAgainKey) ?? false;
    if (dontAskAgain) return false;
    return !(prefs.getBool(_locationPermissionKey) ?? false);
  }

  // Check if we should show background location permission explanation
  static Future<bool> shouldShowBackgroundLocationPermissionExplanation() async {
    final prefs = await SharedPreferences.getInstance();
    final dontAskAgain = prefs.getBool(_dontAskAgainKey) ?? false;
    if (dontAskAgain) return false;
    return !(prefs.getBool(_backgroundLocationPermissionKey) ?? false);
  }

  // Mark location permission as explained
  static Future<void> markLocationPermissionExplained() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_locationPermissionKey, true);
  }

  // Mark background location permission as explained
  static Future<void> markBackgroundLocationPermissionExplained() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_backgroundLocationPermissionKey, true);
  }

  // Mark as "don't ask again"
  static Future<void> setDontAskAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dontAskAgainKey, true);
  }

  // Reset "don't ask again" (useful for testing or user changes mind)
  static Future<void> resetDontAskAgain() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dontAskAgainKey, false);
  }

  // Get comprehensive permission status
  static Future<Map<String, bool>> getPermissionStatus() async {
    final locationGranted = await isLocationPermissionGranted();
    final backgroundLocationGranted = await isBackgroundLocationPermissionGranted();
    final locationServiceEnabled = await isLocationServiceEnabled();

    return {
      'locationGranted': locationGranted,
      'backgroundLocationGranted': backgroundLocationGranted,
      'locationServiceEnabled': locationServiceEnabled,
    };
  }

  // Check if all required permissions are granted
  static Future<bool> areAllPermissionsGranted() async {
    final status = await getPermissionStatus();
    return status['locationGranted'] == true && 
           status['backgroundLocationGranted'] == true && 
           status['locationServiceEnabled'] == true;
  }

  // Check if we should show permission screen (considers "don't ask again")
  static Future<bool> shouldShowPermissionScreen() async {
    final allGranted = await areAllPermissionsGranted();
    if (allGranted) return false;
    
    final prefs = await SharedPreferences.getInstance();
    final dontAskAgain = prefs.getBool(_dontAskAgainKey) ?? false;
    return !dontAskAgain;
  }
} 