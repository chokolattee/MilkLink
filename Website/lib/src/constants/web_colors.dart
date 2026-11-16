import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class WebColors {
  static const Color primaryNavy = AppColors.primaryNavy;
  static const Color primaryBlue = AppColors.primaryBlue;
  static const Color softBlue    = AppColors.softBlue;
  static const Color waveBlue    = AppColors.waveBlue;

  static const Color background     = AppColors.background;
  static const Color pageBackground = AppColors.pageBackground;
  static const Color surface        = AppColors.surface;

  static const Color textPrimary   = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textMuted     = AppColors.textMuted;

  static const Color border  = AppColors.border;
  static const Color divider = AppColors.divider;

  static const Color success   = AppColors.success;
  static const Color successBg = AppColors.successBg;
  static const Color warning   = AppColors.warning;
  static const Color warningBg = AppColors.warningBg;
  static const Color error     = AppColors.error;
  static const Color errorBg   = AppColors.errorBg;
  static const Color infoBg    = AppColors.infoBg;

  //Maternal & Neonatal Healthcare Accents 
  static const Color softTeal  = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFE6FFFA);
  static const Color tealDark  = Color(0xFF0F766E);

  static const Color coralAccent = Color(0xFFF43F5E);
  static const Color coralSoft   = Color(0xFFFFECEB);
  static const Color coralDark   = Color(0xFFE11D48);

  static const Color warmCream = Color(0xFFFFFBEB);
  static const Color warmAmber = Color(0xFFF59E0B);
  static const Color softPeach = Color(0xFFFFF7ED);

  //Gradients
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF0F6FF), Color(0xFFE8F4F8), Color(0xFFFFF7ED)],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B55B8), Color(0xFF0A2A5E)],
  );

  static const LinearGradient tealGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D9488), Color(0xFF047857)],
  );
}

