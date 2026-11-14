import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:milklink_shared/milklink_shared.dart';
import 'src/screens/landing_screen.dart';
import 'src/screens/become_donor_screen.dart';
import 'src/screens/login_screen.dart';

void main() {
  runApp(const MilkLinkWebApp());
}

class MilkLinkWebApp extends StatelessWidget {
  const MilkLinkWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Extend the shared AppTheme and wire in Poppins (already declared in AppTheme)
    final baseTheme = AppTheme.theme;

    return MaterialApp(
      title: 'MilkLink — Pasig City Human Milk Bank Portal',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        // Override text theme with Poppins (already in shared, reinforced here)
        textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
        // Ensure web-appropriate scroll behaviour
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(AppColors.primaryBlue.withValues(alpha: 0.4)),
          trackColor: WidgetStateProperty.all(AppColors.border),
        ),
      ),
      // Named routes — go_router is optional for now; flutter Navigator 1.0 works fine
      initialRoute: '/',
      routes: {
        '/':               (_) => const LandingScreen(),
        '/become-a-donor': (_) => const BecomeDonorScreen(),
        '/login':          (_) => const LoginPlaceholderScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const LandingScreen(),
        settings: settings,
      ),
    );
  }
}
