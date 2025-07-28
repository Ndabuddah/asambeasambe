// lib/constants/app_styles.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles {
  // Font Sizes
  static const double fontSizeXSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeRegular = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;

  // Font Weights
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Button Styles
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 0,
  );

  static final ButtonStyle secondaryButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: AppTheme.primaryColor,
    side: BorderSide(color: AppTheme.primaryColor),
    padding: EdgeInsets.symmetric(vertical: 16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static final ButtonStyle textButtonStyle = TextButton.styleFrom(
    foregroundColor: AppTheme.primaryColor,
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  );

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: fontSizeXXLarge,
    fontWeight: fontWeightBold,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: fontSizeXLarge,
    fontWeight: fontWeightSemiBold,
    color: Colors.white,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: fontSizeRegular,
    fontWeight: fontWeightRegular,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: fontSizeSmall,
    fontWeight: fontWeightRegular,
    color: AppTheme.greyText,
  );

  // Input Decoration
  static InputDecoration inputDecoration({
    required String hintText,
    IconData? prefixIcon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: AppTheme.greyText),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppTheme.greyText) : null,
      suffix: suffix,
      filled: true,
      fillColor: AppTheme.darkerBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppTheme.darkerBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 0,
        offset: Offset(0, 4),
      ),
    ],
  );
}
