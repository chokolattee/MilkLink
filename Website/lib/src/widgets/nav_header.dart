import 'package:flutter/material.dart';
import '../constants/web_colors.dart';

class NavHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAbout;
  final VoidCallback? onHowItWorks;
  final VoidCallback? onGallery;
  final VoidCallback? onUpdates;
  final VoidCallback? onArticles;
  final VoidCallback? onEvents;

  const NavHeader({
    super.key,
    this.onAbout,
    this.onHowItWorks,
    this.onGallery,
    this.onUpdates,
    this.onArticles,
    this.onEvents,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 960;

    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: WebColors.border)),
        boxShadow: [BoxShadow(color: Color(0x08000000), offset: Offset(0, 2), blurRadius: 10)],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  if (ModalRoute.of(context)?.settings.name != '/') {
                    Navigator.of(context).pushNamed('/');
                  }
                },
                child: Row(children: [
                  _Logo(),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('MilkLink',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800,
                              color: WebColors.primaryNavy, letterSpacing: -0.4)),
                      Text('Pasig City Human Milk Bank',
                          style: TextStyle(fontSize: 10.5, color: WebColors.textSecondary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ]),
              ),

              const Spacer(),

              if (!isMobile) ...[
                _NavBtn('About',       onTap: onAbout),
                _NavBtn('How It Works',onTap: onHowItWorks),
                _NavBtn('Gallery',     onTap: onGallery),
                _NavBtn('Articles', icon: Icons.article_outlined,  onTap: onArticles ?? onUpdates),
                _NavBtn('Events',   icon: Icons.event_outlined,     onTap: onEvents   ?? onUpdates),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/login'),
                  icon: const Icon(Icons.login_rounded, size: 15),
                  label: const Text('Login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: WebColors.primaryNavy,
                    side: const BorderSide(color: WebColors.primaryNavy, width: 1.2),
                    minimumSize: const Size(90, 40),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pushNamed('/become-a-donor'),
                  icon: const Icon(Icons.favorite_rounded, size: 15),
                  label: const Text('Become a Donor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebColors.primaryBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(140, 40),
                    elevation: 2,
                    shadowColor: WebColors.primaryBlue.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ] else ...[
                IconButton(
                  icon: const Icon(Icons.menu_rounded, color: WebColors.primaryNavy, size: 28),
                  onPressed: () => _showMobileMenu(context),
                ),
              ],
            ]),
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 36, height: 4,
                decoration: BoxDecoration(color: WebColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            _mobileNavTile(Icons.info_outline_rounded, 'About', onAbout, ctx),
            _mobileNavTile(Icons.sync_alt_rounded, 'How It Works', onHowItWorks, ctx),
            _mobileNavTile(Icons.photo_library_outlined, 'Gallery', onGallery, ctx),
            _mobileNavTile(Icons.event_outlined, 'Events', onEvents ?? onUpdates, ctx),
            _mobileNavTile(Icons.article_outlined, 'Articles', onArticles ?? onUpdates, ctx),
            const Divider(height: 24),
            Row(children: [
              Expanded(child: OutlinedButton(
                  onPressed: () { Navigator.pop(ctx); Navigator.of(context).pushNamed('/login'); },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Login'))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(
                  onPressed: () { Navigator.pop(ctx); Navigator.of(context).pushNamed('/become-a-donor'); },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebColors.primaryBlue, foregroundColor: Colors.white,
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Become a Donor'))),
            ]),
          ]),
        ),
      ),
    );
  }
}

Widget _mobileNavTile(IconData icon, String label, VoidCallback? cb, BuildContext ctx) =>
    ListTile(
      leading: Icon(icon, color: WebColors.primaryBlue, size: 22),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      onTap: () { Navigator.pop(ctx); cb?.call(); },
      dense: true,
    );

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42, height: 42,
      decoration: BoxDecoration(
        color: WebColors.softBlue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: WebColors.waveBlue, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/images/milklink_logo.png',
        package: 'milklink_shared',
        fit: BoxFit.contain
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  const _NavBtn(this.label, {this.icon, this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 2),
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: WebColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[Icon(icon, size: 15, color: WebColors.textSecondary), const SizedBox(width: 5)],
        Text(label),
      ]),
    ),
  );
}

