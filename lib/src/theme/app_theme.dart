import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // Modern color palette
  static const primaryPurple = Color(0xFF6366F1);
  static const primaryBlue = Color(0xFF3B82F6);
  static const accentPink = Color(0xFFEC4899);
  static const accentCyan = Color(0xFF06B6D4);

  static const surfaceWhite = Color(0xFFFAFAFA);
  static const surfaceCard = Colors.white;
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);

  static const gradientStart = Color(0xFF6366F1);
  static const gradientEnd = Color(0xFF8B5CF6);

  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        primary: primaryPurple,
        secondary: accentPink,
        surface: surfaceCard,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: surfaceWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceCard,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 28.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        color: surfaceCard,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5.w),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: primaryPurple, width: 2.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: accentPink, width: 1.5.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: accentPink, width: 2.w),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        hintStyle: TextStyle(color: textTertiary),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: textSecondary,
        textColor: textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          textStyle: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: textPrimary,
          fontSize: 32.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        titleMedium: TextStyle(
          color: textPrimary,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: textPrimary,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: textSecondary,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: textTertiary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
