import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideapp/constants/app_colors.dart';
import 'package:rideapp/services/permission_service.dart';
import 'package:rideapp/widgets/common/custom_button.dart';

class LocationPermissionScreen extends StatefulWidget {
  final bool isDriver;
  final VoidCallback? onPermissionGranted;

  const LocationPermissionScreen({
    super.key,
    required this.isDriver,
    this.onPermissionGranted,
  });

  @override
  State<LocationPermissionScreen> createState() => _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool _isLoading = false;
  bool _locationGranted = false;
  bool _backgroundLocationGranted = false;
  bool _locationServiceEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionStatus();
  }

  Future<void> _checkPermissionStatus() async {
    final status = await PermissionService.getPermissionStatus();
    setState(() {
      _locationGranted = status['locationGranted'] ?? false;
      _backgroundLocationGranted = status['backgroundLocationGranted'] ?? false;
      _locationServiceEnabled = status['locationServiceEnabled'] ?? false;
    });
  }

  Future<void> _requestLocationPermission() async {
    setState(() => _isLoading = true);

    try {
      final granted = await PermissionService.requestLocationPermission();
      if (granted) {
        await PermissionService.markLocationPermissionExplained();
        setState(() => _locationGranted = true);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to request location permission');
    } finally {
      setState(() => _isLoading = false);
      await _checkPermissionStatus();
    }
  }

  Future<void> _requestBackgroundLocationPermission() async {
    setState(() => _isLoading = true);

    try {
      final granted = await PermissionService.requestBackgroundLocationPermission();
      if (granted) {
        await PermissionService.markBackgroundLocationPermissionExplained();
        setState(() => _backgroundLocationGranted = true);
      }
    } catch (e) {
      _showErrorSnackBar('Failed to request background location permission');
    } finally {
      setState(() => _isLoading = false);
      await _checkPermissionStatus();
    }
  }

  Future<void> _openLocationSettings() async {
    try {
      final canOpen = await Geolocator.openLocationSettings();
      if (!canOpen) {
        _showErrorSnackBar('Cannot open location settings. Please enable location services manually.');
      }
      await _checkPermissionStatus();
    } catch (e) {
      _showErrorSnackBar('Failed to open location settings. Please enable location services manually.');
    }
  }

  Future<void> _openAppSettings() async {
    try {
      final canOpen = await Geolocator.openAppSettings();
      if (!canOpen) {
        _showErrorSnackBar('Cannot open app settings. Please enable location permissions manually.');
      }
      await _checkPermissionStatus();
    } catch (e) {
      _showErrorSnackBar('Failed to open app settings. Please enable location permissions manually.');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAllGranted = _locationGranted && _backgroundLocationGranted && _locationServiceEnabled;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Header
              Icon(
                Icons.location_on,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 24),

              Text(
                'Location Permission Required',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              Text(
                widget.isDriver ? 'As a driver, we need your location to help passengers find you and track your rides.' : 'As a passenger, we need your location to find nearby drivers and track your ride.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Permission Status Cards
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required Permissions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Location Services Status
                      _buildPermissionCard(
                        icon: Icons.location_on,
                        title: 'Location Services',
                        description: 'Enable location services in your device settings',
                        isGranted: _locationServiceEnabled,
                        onTap: _openLocationSettings,
                        showButton: !_locationServiceEnabled,
                        buttonText: 'Open Settings',
                        showSettingsButton: false,
                      ),

                      const SizedBox(height: 16),

                      // Location Permission Status
                      _buildPermissionCard(
                        icon: Icons.my_location,
                        title: 'Location Permission',
                        description: 'Allow RideApp to access your location while using the app',
                        isGranted: _locationGranted,
                        onTap: _locationGranted ? null : _requestLocationPermission,
                        showButton: !_locationGranted && _locationServiceEnabled,
                        buttonText: 'Grant Permission',
                        showSettingsButton: false,
                      ),

                      const SizedBox(height: 16),

                      // Background Location Permission Status
                      _buildPermissionCard(
                        icon: Icons.location_searching,
                        title: 'Background Location',
                        description: widget.isDriver
                            ? 'Essential for receiving ride requests when app is minimized. Without this, you won\'t get notified of new ride requests when the app is in background.'
                            : 'Essential for tracking your ride progress and ensuring driver can find you. Without this, ride tracking will stop when app is minimized.',
                        isGranted: _backgroundLocationGranted,
                        onTap: _backgroundLocationGranted ? null : _requestBackgroundLocationPermission,
                        showButton: !_backgroundLocationGranted && _locationGranted,
                        buttonText: 'Grant Permission',
                        showSettingsButton: false,
                      ),

                      const SizedBox(height: 24),

                      // Privacy Notice
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.privacy_tip,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Privacy Notice',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• Your location is only used to provide ride services\n'
                              '• Location data is encrypted and securely transmitted\n'
                              '• We do not sell or share your location data\n'
                              '• You can revoke permissions anytime in settings\n'
                              '• Background location only works when actively using the app\n'
                              '• Location sharing stops immediately when ride ends',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Don't Ask Again Option
                      if (!isAllGranted)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Can\'t use the app without location permissions',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Location access is essential for ride services. You can enable permissions later in Settings.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () async {
                                        await PermissionService.setDontAskAgain();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Don\'t Ask Again',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Maybe Later',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                      // Continue Button
                      if (isAllGranted)
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Continue',
                            onPressed: () {
                              widget.onPermissionGranted?.call();
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard({
    required IconData icon,
    required String title,
    required String description,
    required bool isGranted,
    required VoidCallback? onTap,
    required bool showButton,
    required String buttonText,
    bool showSettingsButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGranted ? Colors.green[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isGranted ? Colors.green : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isGranted ? Colors.green : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isGranted ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isGranted ? Colors.green[700] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (showButton)
            TextButton(
              onPressed: _isLoading ? null : onTap,
              child: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : Text(
                      buttonText,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          if (showSettingsButton && !isGranted)
            TextButton(
              onPressed: _isLoading ? null : _openAppSettings,
              child: Text(
                'Open Settings',
                style: TextStyle(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (isGranted)
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 24,
            ),
        ],
      ),
    );
  }
}
