import 'package:flutter/material.dart';

import '../constants/web_colors.dart';

// ─── Shared section wrapper ───────────────────────────────────────────────────
class SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final EdgeInsets padding;

  const SectionWrapper({
    super.key,
    required this.child,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(vertical: 72, horizontal: 24),
  });

  @override
  Widget build(BuildContext context) => Container(
    color: backgroundColor ?? WebColors.background,
    width: double.infinity,
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

// ─── Section heading ─────────────────────────────────────────────────────────
class SectionHeading extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  const SectionHeading({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: alignment,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: WebColors.softBlue,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          eyebrow,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: WebColors.primaryBlue,
            letterSpacing: 0.6,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        title,
        textAlign: alignment == CrossAxisAlignment.center
            ? TextAlign.center
            : TextAlign.left,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: WebColors.primaryNavy,
          height: 1.25,
        ),
      ),
      if (subtitle != null) ...[
        const SizedBox(height: 10),
        Text(
          subtitle!,
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.left,
          style: const TextStyle(
            fontSize: 16,
            color: WebColors.textSecondary,
            height: 1.6,
          ),
        ),
      ],
    ],
  );
}

// ─── Stat card ───────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: WebColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x06000000),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 26),
        ),
        const SizedBox(height: 14),
        Text(
          value,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: WebColors.textSecondary,
            height: 1.3,
          ),
        ),
      ],
    ),
  );
}

// ─── Process step card ───────────────────────────────────────────────────────
class ProcessStepCard extends StatelessWidget {
  final int stepNumber;
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final bool isLast;

  const ProcessStepCard({
    super.key,
    required this.stepNumber,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(child: Icon(icon, color: Colors.white, size: 28)),
            ),
            const SizedBox(height: 14),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Center(
                child: Text(
                  '$stepNumber',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: WebColors.primaryNavy,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: WebColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      if (!isLast)
        Padding(
          padding: const EdgeInsets.only(top: 28),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: WebColors.border,
            size: 22,
          ),
        ),
    ],
  );
}

// ─── Gallery card ────────────────────────────────────────────────────────────
class GalleryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String category;
  final String date;
  final String location;
  final String description;
  final Color color;
  final VoidCallback? onTap;

  const GalleryCard({
    super.key,
    required this.icon,
    required this.title,
    required this.category,
    required this.date,
    required this.location,
    required this.description,
    required this.color,
    this.onTap,
  });

  @override
  State<GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<GalleryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? widget.color.withValues(alpha: 0.4)
                : WebColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? widget.color.withValues(alpha: 0.15)
                  : const Color(0x06000000),
              blurRadius: _hovered ? 20 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Visual placeholder
            Container(
              height: 160,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.color.withValues(alpha: 0.12),
                    widget.color.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      widget.icon,
                      size: 56,
                      color: widget.color.withValues(alpha: 0.5),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: widget.color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        widget.category,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.open_in_full_rounded,
                        size: 14,
                        color: WebColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: WebColors.primaryNavy,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 11,
                        color: WebColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 11,
                          color: WebColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 11,
                        color: WebColors.coralAccent,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            color: WebColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// ─── Event card ──────────────────────────────────────────────────────────────
class EventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String venue;
  final String barangay;
  final VoidCallback? onRegister;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    required this.barangay,
    this.onRegister,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: WebColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x05000000),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date badge
        Container(
          width: 56,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [WebColors.primaryBlue, WebColors.primaryNavy],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.split(' ').length > 1 ? date.split(' ')[1] : '—',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                date.split(' ').isNotEmpty ? date.split(' ')[0] : '',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: WebColors.primaryNavy,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              _infoRow(Icons.access_time_rounded, time, WebColors.softTeal),
              const SizedBox(height: 3),
              _infoRow(
                Icons.location_on_rounded,
                '$barangay · $venue',
                WebColors.coralAccent,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: onRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: WebColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: const Text('Register to Join'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _infoRow(IconData icon, String text, Color color) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Icon(icon, size: 13, color: color),
    const SizedBox(width: 5),
    Expanded(
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, color: WebColors.textSecondary),
      ),
    ),
  ],
);

// ─── Announcement card ───────────────────────────────────────────────────────
class AnnouncementCard extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final List<String> tags;
  final VoidCallback? onReadMore;

  const AnnouncementCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.tags,
    this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    final isUrgent = tags.any((t) => t.toLowerCase() == 'urgent');
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUrgent
              ? WebColors.coralAccent.withValues(alpha: 0.3)
              : WebColors.border,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: isUrgent ? WebColors.coralSoft : WebColors.softBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.campaign_rounded,
                  size: 18,
                  color: isUrgent
                      ? WebColors.coralAccent
                      : WebColors.primaryBlue,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WebColors.primaryNavy,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: WebColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                date,
                style: const TextStyle(
                  fontSize: 11,
                  color: WebColors.textMuted,
                ),
              ),
              const Spacer(),
              ...tags
                  .take(2)
                  .map(
                    (t) => Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: t.toLowerCase() == 'urgent'
                              ? WebColors.coralSoft
                              : WebColors.tealLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          t,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: t.toLowerCase() == 'urgent'
                                ? WebColors.coralDark
                                : WebColors.tealDark,
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onReadMore,
            style: TextButton.styleFrom(
              foregroundColor: WebColors.primaryBlue,
              padding: EdgeInsets.zero,
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Read Details'),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Article card ────────────────────────────────────────────────────────────
class ArticleCard extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final String? imageUrl;
  final VoidCallback? onReadMore;

  const ArticleCard({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
    this.onReadMore,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hovered
              ? WebColors.primaryBlue.withValues(alpha: 0.3)
              : WebColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: _hovered
                ? WebColors.primaryBlue.withValues(alpha: 0.08)
                : const Color(0x05000000),
            blurRadius: _hovered ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top image or placeholder
          Container(
            height: 130,
            decoration: BoxDecoration(
              color: WebColors.softBlue,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              image: widget.imageUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.imageUrl!),
                      fit: BoxFit.cover,
                      onError: (err, stack) {},
                    )
                  : null,
            ),
            child: widget.imageUrl == null
                ? Center(
                    child: Icon(
                      Icons.menu_book_rounded,
                      size: 42,
                      color: WebColors.primaryBlue.withValues(alpha: 0.4),
                    ),
                  )
                : null,
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: WebColors.primaryNavy,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  widget.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: WebColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 11,
                      color: WebColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.date,
                      style: const TextStyle(
                        fontSize: 11,
                        color: WebColors.textMuted,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: widget.onReadMore,
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Read More',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: WebColors.primaryBlue,
                            ),
                          ),
                          SizedBox(width: 3),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: WebColors.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// ─── Footer ──────────────────────────────────────────────────────────────────
class SiteFooter extends StatelessWidget {
  final VoidCallback? onAbout;
  final VoidCallback? onHowItWorks;
  final VoidCallback? onGallery;
  final VoidCallback? onUpdates;

  const SiteFooter({
    super.key,
    this.onAbout,
    this.onHowItWorks,
    this.onGallery,
    this.onUpdates,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      color: WebColors.primaryNavy,
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 56, 32, 32),
                child: isMobile
                    ? _buildMobileFooter(context)
                    : _buildDesktopFooter(context),
              ),
            ),
          ),
          Container(
            color: const Color(0xFF05183A),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
            child: Center(
              child: Wrap(
                spacing: 16,
                runSpacing: 6,
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    '© 2026 Pasig City Human Milk Bank — MilkLink Portal',
                    style: TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                  _footerLink('Department of Health Compliant', null),
                  _footerLink('Privacy Policy', null),
                  _footerLink('Terms of Use', null),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.verified_outlined,
                        size: 13,
                        color: Colors.white60,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'DOH-Accredited Milk Bank Facility',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFooter(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Brand column
      Expanded(flex: 3, child: _BrandColumn()),
      const SizedBox(width: 48),
      // Quick links
      Expanded(
        flex: 2,
        child: _FooterColumn('Quick Links', [
          _FooterLinkItem('Home', () => Navigator.of(context).pushNamed('/')),
          _FooterLinkItem('About Us', onAbout),
          _FooterLinkItem('How It Works', onHowItWorks),
          _FooterLinkItem('Gallery', onGallery),
          _FooterLinkItem('Events & Updates', onUpdates),
          _FooterLinkItem(
            'Become a Donor',
            () => Navigator.of(context).pushNamed('/become-a-donor'),
          ),
          _FooterLinkItem(
            'Staff Login',
            () => Navigator.of(context).pushNamed('/login'),
          ),
        ]),
      ),
      const SizedBox(width: 48),
      // Donor info column
      Expanded(
        flex: 2,
        child: _FooterColumn('Donor Eligibility', const [
          'Currently breastfeeding a healthy infant',
          'In good health, no active infections',
          'Non-smoker, no alcohol or recreational drugs',
          'Has passed basic health questionnaire',
          'Willing to undergo free serology screening',
        ]),
      ),
      const SizedBox(width: 48),
      // Contact column
      Expanded(flex: 3, child: _ContactColumn()),
    ],
  );

  Widget _buildMobileFooter(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _BrandColumn(),
      const SizedBox(height: 32),
      _ContactColumn(),
      const SizedBox(height: 24),
      _FooterColumn('Quick Links', [
        _FooterLinkItem(
          'Become a Donor',
          () => Navigator.of(context).pushNamed('/become-a-donor'),
        ),
        _FooterLinkItem('Events & Updates', onUpdates),
        _FooterLinkItem(
          'Staff Login',
          () => Navigator.of(context).pushNamed('/login'),
        ),
      ]),
    ],
  );
}

class _BrandColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'MilkLink',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(height: 14),
      const Text(
        "Pasig City Human Milk Bank Portal — connecting volunteer donor mothers with premature and critically ill infants in Pasig City's NICUs through safe, screened, and pasteurized donor human milk.",
        style: TextStyle(fontSize: 13, color: Colors.white60, height: 1.6),
      ),
      const SizedBox(height: 20),
      Wrap(
        spacing: 10,
        runSpacing: 8,
        children: const [
          _BadgePill(Icons.health_and_safety_outlined, 'DOH Accredited'),
          _BadgePill(Icons.science_outlined, 'Pasteurization Certified'),
        ],
      ),
    ],
  );
}

class _ContactColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: const [
      Text(
        'Contact & Location',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 14),
      _ContactRow(
        Icons.location_on_rounded,
        "Pasig City Children's Hospital — Human Milk Bank\nRoom 204, 2nd Floor\nOrtigas Ave, Pasig City, Metro Manila",
      ),
      SizedBox(height: 10),
      _ContactRow(
        Icons.access_time_rounded,
        'Mon–Fri  8:00 AM – 5:00 PM\nSat  8:00 AM – 12:00 PM\nSun & Holidays  Closed',
      ),
      SizedBox(height: 10),
      _ContactRow(
        Icons.phone_rounded,
        'Milk Bank Desk  (02) 8643-0000 loc. 204\nUrgent NICU Request  0917-123-4567',
      ),
      SizedBox(height: 10),
      _ContactRow(Icons.email_rounded, 'milkbank@pasigcity.gov.ph'),
    ],
  );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 15, color: const Color(0xFF93C5FD)),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}

class _FooterColumn extends StatelessWidget {
  final String heading;
  final List<dynamic> items;
  const _FooterColumn(this.heading, this.items);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        heading,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      const SizedBox(height: 14),
      ...items.map((item) {
        if (item is _FooterLinkItem) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: GestureDetector(
              onTap: item.onTap,
              child: Text(
                item.label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white60,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 13,
                  color: Color(0xFF34D399),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item as String,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }),
    ],
  );
}

class _FooterLinkItem {
  final String label;
  final VoidCallback? onTap;
  const _FooterLinkItem(this.label, this.onTap);
}

Widget _footerLink(String label, VoidCallback? onTap) => GestureDetector(
  onTap: onTap,
  child: Text(
    label,
    style: const TextStyle(fontSize: 11, color: Colors.white38),
  ),
);

class _BadgePill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _BadgePill(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white24),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF93C5FD)),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
      ],
    ),
  );
}
