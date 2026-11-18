import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared/shared.dart';
import 'src/screens/landing_screen.dart';
import 'src/screens/become_donor_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DonorProvider()),
        ChangeNotifierProvider(create: (_) => EventsProvider()),
        ChangeNotifierProvider(create: (_) => ArticlesProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const MilkLinkWebApp(),
    ),
  );
}

class MilkLinkWebApp extends StatelessWidget {
  const MilkLinkWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = AppTheme.theme;

    return MaterialApp(
      title: 'MilkLink — Pasig City Human Milk Bank Portal',
      debugShowCheckedModeBanner: false,
      theme: baseTheme.copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(baseTheme.textTheme),
        // Ensure web-appropriate scroll behaviour
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(AppColors.primaryBlue.withValues(alpha: 0.4)),
          trackColor: WidgetStateProperty.all(AppColors.border),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':               (_) => const LandingScreen(),
        '/become-a-donor': (_) => const BecomeDonorScreen(),
        '/admin':          (_) => const AdminDashboardScreen(),
        '/staff':          (_) => const StaffDashboardScreen(),
        '/donor':          (_) => const MainNavigationScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const LandingScreen(),
        settings: settings,
      ),
    );
  }
}

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Admin Dashboard')));
  }
}

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Staff Dashboard')));
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Donor Portal')));
  }
}
