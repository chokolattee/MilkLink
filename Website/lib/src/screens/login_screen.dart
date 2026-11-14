import 'package:flutter/material.dart';
import '../constants/web_colors.dart';

/// Placeholder /login route — the actual login screen is in the Mobile app.
/// This page tells hospital staff, admins, and registered donors how to access the portal.
class LoginPlaceholderScreen extends StatelessWidget {
  const LoginPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WebColors.pageBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / icon
                Container(
                  width: 72, height: 72,
                  decoration: const BoxDecoration(
                    gradient: WebColors.primaryGradient, shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 20),

                const Text('MilkLink Portal Login',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: WebColors.primaryNavy)),
                const SizedBox(height: 8),
                const Text('Pasig City Human Milk Bank',
                    style: TextStyle(fontSize: 13, color: WebColors.textSecondary)),
                const SizedBox(height: 28),

                // Info card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: WebColors.border),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Portal Access',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
                    const SizedBox(height: 14),
                    _infoRow(Icons.admin_panel_settings_outlined, WebColors.primaryBlue,
                        'Administrators & Staff', 'Manage donors, inventory, events, and reports.'),
                    const SizedBox(height: 10),
                    _infoRow(Icons.person_outlined, WebColors.softTeal,
                        'Registered Donors', 'Track your donation status, appointments, and milk pickups.'),
                    const SizedBox(height: 10),
                    _infoRow(Icons.local_hospital_outlined, WebColors.coralAccent,
                        'Hospital Partners', 'Request pasteurized donor milk for NICU patients.'),
                  ]),
                ),

                const SizedBox(height: 20),

                const Text(
                  'This portal is currently accessible via the MilkLink Mobile App or by invitation from the Pasig City Human Milk Bank administration.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: WebColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 24),

                // Contact
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: WebColors.softBlue, borderRadius: BorderRadius.circular(10)),
                  child: Row(children: const [
                    Icon(Icons.phone_in_talk_rounded, color: WebColors.primaryBlue, size: 18),
                    SizedBox(width: 10),
                    Expanded(child: Text(
                        'For login assistance, call: (02) 8643-0000 loc. 204\nor email: milkbank@pasigcity.gov.ph',
                        style: TextStyle(fontSize: 12, color: WebColors.primaryNavy, height: 1.5))),
                  ]),
                ),

                const SizedBox(height: 24),
                Row(children: [
                  Expanded(child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/'),
                    child: const Text('← Back to Home'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/become-a-donor'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: WebColors.primaryBlue, foregroundColor: Colors.white),
                    child: const Text('Become a Donor'),
                  )),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _infoRow(IconData icon, Color color, String title, String sub) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: color, size: 18)),
    const SizedBox(width: 10),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
      Text(sub, style: const TextStyle(fontSize: 12, color: WebColors.textSecondary)),
    ])),
  ],
);

