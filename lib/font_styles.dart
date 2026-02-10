import 'package:flutter/material.dart';

class AppFonts {
  // Font Weight Constants
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ตรวจสอบว่าฟอนต์มีอยู่หรือไม่
  static String _getFontWithFallback(String fontFamily) {
    // ในการใช้งานจริง อาจต้องตรวจสอบว่าฟอนต์โหลดสำเร็จหรือไม่
    return fontFamily;
  }

  // Crimson Pro - สำหรับข้อความเชิญ (มี weight ครบ)
  static TextStyle crimsonPro({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: _getFontWithFallback('Crimson_Pro'),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      // เพิ่ม fallback fonts
      fontFamilyFallback: const ['Roboto', 'Times New Roman', 'serif'],
    );
  }

  // Glacial Indifference - สำหรับข้อความทั่วไป
  static TextStyle glacialIndifference({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    double letterSpacing = 0.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: _getFontWithFallback('Glacial_Indifference'),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
    );
  }

  // Season - สำหรับข้อความพิเศษ (มี weight หลากหลาย)
  static TextStyle season({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: _getFontWithFallback('Season'),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      fontFamilyFallback: const ['Roboto', 'Georgia', 'serif'],
    );
  }

  // TT Hoves Pro - สำหรับข้อความหัวเรื่อง (มี weight ครบ)
  static TextStyle ttHovesPro({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0.0,
    double? height,
    List<Shadow>? shadows,
  }) {
    return TextStyle(
      fontFamily: _getFontWithFallback('TT_Hoves_Pro'),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      shadows: shadows,
      fontFamilyFallback: const ['Roboto', 'Helvetica', 'Arial', 'sans-serif'],
    );
  }

  // Kanit - สำหรับข้อความภาษาไทย (มี weight ครบทุกตัว)
  static TextStyle kanit({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    FontStyle fontStyle = FontStyle.normal,
    double letterSpacing = 0.0,
    double? height,
  }) {
    return TextStyle(
      fontFamily: _getFontWithFallback('Kanit'),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
      fontFamilyFallback: const ['Roboto', 'Arial', 'sans-serif'],
    );
  }

  // Helper methods สำหรับใช้งานทั่วไป
  static TextStyle heading1({Color? color}) =>
      crimsonPro(fontSize: 32, fontWeight: bold, color: color);

  static TextStyle heading2({Color? color}) =>
      crimsonPro(fontSize: 24, fontWeight: semiBold, color: color);

  static TextStyle heading3({Color? color}) =>
      ttHovesPro(fontSize: 20, fontWeight: medium, color: color);

  static TextStyle body({Color? color}) =>
      glacialIndifference(fontSize: 16, color: color);

  static TextStyle bodyLarge({Color? color}) =>
      glacialIndifference(fontSize: 18, color: color);

  static TextStyle bodySmall({Color? color}) =>
      glacialIndifference(fontSize: 14, color: color);

  static TextStyle caption({Color? color}) =>
      glacialIndifference(fontSize: 12, color: color);

  static TextStyle invitation({Color? color}) => crimsonPro(
    fontSize: 18,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.0,
    fontWeight: regular,
    color: color,
  );

  static TextStyle invitationLarge({Color? color}) => crimsonPro(
    fontSize: 24,
    fontStyle: FontStyle.italic,
    letterSpacing: 1.2,
    fontWeight: medium,
    color: color,
  );

  static TextStyle decorative({Color? color}) =>
      season(fontSize: 20, fontWeight: regular, color: color);

  static TextStyle decorativeBold({Color? color}) =>
      season(fontSize: 24, fontWeight: bold, color: color);

  // Button styles
  static TextStyle button({Color? color}) => ttHovesPro(
    fontSize: 16,
    fontWeight: semiBold,
    letterSpacing: 0.5,
    color: color,
  );

  static TextStyle buttonLarge({Color? color}) => ttHovesPro(
    fontSize: 18,
    fontWeight: semiBold,
    letterSpacing: 0.5,
    color: color,
  );

  // Thai text styles using Kanit
  static TextStyle thaiBody({Color? color}) =>
      kanit(fontSize: 16, color: color);

  static TextStyle thaiBodyLarge({Color? color}) =>
      kanit(fontSize: 18, color: color);

  static TextStyle thaiBodySmall({Color? color}) =>
      kanit(fontSize: 14, color: color);

  static TextStyle thaiHeading1({Color? color}) =>
      kanit(fontSize: 32, fontWeight: bold, color: color);

  static TextStyle thaiHeading2({Color? color}) =>
      kanit(fontSize: 24, fontWeight: semiBold, color: color);

  static TextStyle thaiHeading3({Color? color}) =>
      kanit(fontSize: 20, fontWeight: medium, color: color);

  static TextStyle thaiCaption({Color? color}) =>
      kanit(fontSize: 12, color: color);
}
