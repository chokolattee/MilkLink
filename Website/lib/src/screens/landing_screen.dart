import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:milklink_shared/milklink_shared.dart';
import '../constants/web_colors.dart';
import '../services/web_api_service.dart';
import '../widgets/landing_widgets.dart';
import '../widgets/nav_header.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final _scrollController = ScrollController();

  final _aboutKey      = GlobalKey();
  final _howItWorksKey = GlobalKey();
  final _galleryKey    = GlobalKey();
  final _updatesKey    = GlobalKey();

  // Data futures
  late Future<WebImpactStats>          _metricsFuture;
  late Future<List<LettingEventModel>> _eventsFuture;
  late Future<List<AnnouncementModel>> _announcementsFuture;
  late Future<List<ArticleModel>>      _articlesFuture;

  @override
  void initState() {
    super.initState();
    _metricsFuture        = WebApiService.fetchImpactMetrics();
    _eventsFuture         = WebApiService.fetchUpcomingEvents();
    _announcementsFuture  = WebApiService.fetchAnnouncements();
    _articlesFuture       = WebApiService.fetchArticles();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WebColors.background,
      appBar: NavHeader(
        onAbout:      () => _scrollTo(_aboutKey),
        onHowItWorks: () => _scrollTo(_howItWorksKey),
        onGallery:    () => _scrollTo(_galleryKey),
        onUpdates:    () => _scrollTo(_updatesKey),
        onArticles:   () => _scrollTo(_updatesKey),
        onEvents:     () => _scrollTo(_updatesKey),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: [
          _HeroSection(),
          Container(key: _aboutKey,       child: _AboutSection(metricsFuture: _metricsFuture)),
          Container(key: _howItWorksKey,  child: const _HowItWorksSection()),
          Container(key: _galleryKey,     child: const _GallerySection()),
          Container(key: _updatesKey,
              child: _UpdatesSection(
                eventsFuture:         _eventsFuture,
                announcementsFuture:  _announcementsFuture,
                articlesFuture:       _articlesFuture,
              )),
          SiteFooter(
            onAbout:      () => _scrollTo(_aboutKey),
            onHowItWorks: () => _scrollTo(_howItWorksKey),
            onGallery:    () => _scrollTo(_galleryKey),
            onUpdates:    () => _scrollTo(_updatesKey),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. HERO SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: WebColors.heroGradient),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 32, vertical: isMobile ? 48 : 80),
            child: isMobile
                ? Column(children: [_HeroText(), const SizedBox(height: 40), _HeroVisual()])
                : Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    Expanded(flex: 55, child: _HeroText()),
                    const SizedBox(width: 48),
                    Expanded(flex: 45, child: _HeroVisual()),
                  ]),
          ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Eyebrow badge
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: WebColors.tealLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WebColors.softTeal.withValues(alpha: 0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: const [
          Icon(Icons.water_drop_rounded, size: 14, color: WebColors.softTeal),
          SizedBox(width: 6),
          Text('Pasig City Human Milk Bank — MilkLink Portal',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: WebColors.tealDark)),
        ]),
      ),
      const SizedBox(height: 20),

      const Text(
        "Every Drop of\nDonor Milk Saves\na Pasig Baby's Life.",
        style: TextStyle(fontSize: 42, fontWeight: FontWeight.w900,
            color: WebColors.primaryNavy, height: 1.2, letterSpacing: -1),
      ),
      const SizedBox(height: 18),
      const Text(
        'MilkLink connects compassionate lactating mothers with premature and critically ill newborns in Pasig City NICUs — through safe, free, and DOH-accredited breast milk donation.',
        style: TextStyle(fontSize: 16, color: WebColors.textSecondary, height: 1.65),
      ),
      const SizedBox(height: 32),

      Wrap(spacing: 12, runSpacing: 12, children: [
        // Primary CTA
        Builder(builder: (ctx) => ElevatedButton.icon(
          onPressed: () => Navigator.of(ctx).pushNamed('/become-a-donor'),
          icon: const Icon(Icons.favorite_rounded, size: 18),
          label: const Text('Become a Donor Today'),
          style: ElevatedButton.styleFrom(
            backgroundColor: WebColors.primaryBlue, foregroundColor: Colors.white,
            minimumSize: const Size(220, 54),
            elevation: 4, shadowColor: WebColors.primaryBlue.withValues(alpha: 0.35),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        )),

        // Secondary CTA
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.local_hospital_outlined, size: 18),
          label: const Text('Request Donor Milk'),
          style: OutlinedButton.styleFrom(
            foregroundColor: WebColors.primaryNavy,
            side: const BorderSide(color: WebColors.primaryNavy, width: 1.5),
            minimumSize: const Size(190, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ]),

      const SizedBox(height: 28),
      // Trust signals
      Wrap(spacing: 20, runSpacing: 8, children: const [
        _TrustBadge(Icons.shield_outlined, 'DOH Accredited'),
        _TrustBadge(Icons.science_outlined, 'Pasteurization Certified'),
        _TrustBadge(Icons.lock_outlined,    'Privacy Protected'),
      ]),
    ],
  );
}

class _TrustBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TrustBadge(this.icon, this.label);

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 15, color: WebColors.softTeal),
    const SizedBox(width: 5),
    Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: WebColors.textSecondary)),
  ]);
}

class _HeroVisual extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Colors.white, WebColors.softBlue.withValues(alpha: 0.5)],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: WebColors.waveBlue),
      boxShadow: [BoxShadow(color: WebColors.primaryBlue.withValues(alpha: 0.1),
          blurRadius: 32, offset: const Offset(0, 12))],
    ),
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 80, height: 80,
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [WebColors.primaryBlue, WebColors.primaryNavy]),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: WebColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 20, offset: const Offset(0, 8))],
        ),
        child: const Icon(Icons.water_drop_rounded, color: Colors.white, size: 44),
      ),
      const SizedBox(height: 20),
      const Text('Pasig City Human Milk Bank',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: WebColors.primaryNavy)),
      const SizedBox(height: 6),
      const Text('Pasig City Children\'s Hospital\nRoom 204, Ortigas Ave',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: WebColors.textSecondary, height: 1.5)),
      const SizedBox(height: 20),

      // Mini stats row
      Row(children: const [
        Expanded(child: _MiniStat('1,485+', 'Liters\nDonated', WebColors.primaryBlue)),
        SizedBox(width: 10),
        Expanded(child: _MiniStat('864', 'NICU Babies\nSupported', WebColors.softTeal)),
        SizedBox(width: 10),
        Expanded(child: _MiniStat('432', 'Active\nDonors', WebColors.coralAccent)),
      ]),

      const SizedBox(height: 20),
      const Divider(color: WebColors.border),
      const SizedBox(height: 14),
      const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.phone_rounded, size: 14, color: WebColors.softTeal),
        SizedBox(width: 6),
        Text('Hotline: (02) 8643-0000 loc. 204',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: WebColors.textSecondary)),
      ]),
    ]),
  );
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _MiniStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withValues(alpha: 0.2)),
    ),
    child: Column(children: [
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
      const SizedBox(height: 2),
      Text(label, textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: WebColors.textSecondary, height: 1.3)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. ABOUT & IMPACT SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  final Future<WebImpactStats> metricsFuture;
  const _AboutSection({required this.metricsFuture});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      backgroundColor: WebColors.pageBackground,
      child: Column(children: [
        const SectionHeading(
          eyebrow: 'About the Milk Bank',
          title: 'Safe, Screened, and Life-Saving',
          subtitle: 'The Pasig City Human Milk Bank follows strict DOH and WHO guidelines to collect, screen, process, and distribute pasteurized donor human milk to NICU patients.',
        ),
        const SizedBox(height: 48),

        // About cards
        LayoutBuilder(builder: (ctx, cst) {
          final isWide = cst.maxWidth > 700;
          return Flex(
            direction: isWide ? Axis.horizontal : Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(flex: isWide ? 1 : 0, child: _AboutCard(
                icon: Icons.science_outlined, color: WebColors.primaryBlue,
                title: 'Holder Pasteurization',
                body: 'Every batch is heated to exactly 62.5 °C for 30 minutes then rapidly cooled to below 4 °C — eliminating pathogens while preserving vital immune factors.',
              )),
              SizedBox(width: isWide ? 20 : 0, height: isWide ? 0 : 16),
              Flexible(flex: isWide ? 1 : 0, child: _AboutCard(
                icon: Icons.health_and_safety_outlined, color: WebColors.softTeal,
                title: 'Donor Eligibility',
                body: 'Donor mothers must be in good health, exclusively breastfeeding, non-smokers, free of infectious disease, and pass a full serology panel (CBC, HIV, HBsAg, VDRL).',
              )),
              SizedBox(width: isWide ? 20 : 0, height: isWide ? 0 : 16),
              Flexible(flex: isWide ? 1 : 0, child: _AboutCard(
                icon: Icons.local_hospital_outlined, color: WebColors.coralAccent,
                title: 'NICU Priority System',
                body: 'Pasteurized donor milk is allocated to the most vulnerable recipients first — VLBW infants, NEC-risk patients, and premature babies below 32 weeks gestational age.',
              )),
            ],
          );
        }),

        const SizedBox(height: 56),

        // Impact counters
        const SectionHeading(eyebrow: 'Community Impact', title: 'By the Numbers'),
        const SizedBox(height: 32),

        FutureBuilder<WebImpactStats>(
          future: metricsFuture,
          builder: (ctx, snap) {
            final stats = snap.data ?? const WebImpactStats(
              litersDonated: 1_485.5, nicuBabiesSupported: 864,
              activeDonors: 432,      partnerHospitals: 8,
            );
            return LayoutBuilder(builder: (ctx, cst) {
              final count = cst.maxWidth > 700 ? 4 : 2;
              return Wrap(spacing: 16, runSpacing: 16,
                  children: [
                    SizedBox(width: (cst.maxWidth - 16 * (count - 1)) / count,
                        child: StatCard(icon: Icons.water_drop_outlined,
                            value: '${stats.litersDonated.toStringAsFixed(0)} L',
                            label: 'Liters Donated', color: WebColors.primaryBlue)),
                    SizedBox(width: (cst.maxWidth - 16 * (count - 1)) / count,
                        child: StatCard(icon: Icons.child_care_rounded,
                            value: stats.nicuBabiesSupported.toString(),
                            label: 'NICU Babies Supported', color: WebColors.softTeal)),
                    SizedBox(width: (cst.maxWidth - 16 * (count - 1)) / count,
                        child: StatCard(icon: Icons.people_alt_outlined,
                            value: stats.activeDonors.toString(),
                            label: 'Active Pasig Donors', color: WebColors.coralAccent)),
                    SizedBox(width: (cst.maxWidth - 16 * (count - 1)) / count,
                        child: StatCard(icon: Icons.local_hospital_outlined,
                            value: stats.partnerHospitals.toString(),
                            label: 'Partner Hospitals', color: WebColors.warmAmber)),
                  ],
              );
            });
          },
        ),
      ]),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  const _AboutCard({required this.icon, required this.color, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: WebColors.border),
      boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 3))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 24),
      ),
      const SizedBox(height: 14),
      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
      const SizedBox(height: 8),
      Text(body, style: const TextStyle(fontSize: 13, color: WebColors.textSecondary, height: 1.6)),
    ]),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. HOW IT WORKS SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    final steps = [
      _Step(1, Icons.app_registration_rounded, 'Online Registration & Health Screening',
          'Fill out your personal details, Pasig barangay address, and answer our health eligibility questionnaire online through MilkLink.',
          WebColors.primaryBlue),
      _Step(2, Icons.local_shipping_outlined, 'Milk Letting & Collection',
          'Schedule a free home pickup from our mobile collection team or attend one of our community milk letting events across Pasig City.',
          WebColors.softTeal),
      _Step(3, Icons.science_outlined, 'Pasteurization & Lab Testing',
          'Your donation undergoes Holder pasteurization, full serology testing, and strict cold-chain tracking in our DOH-certified facility.',
          WebColors.warmAmber),
      _Step(4, Icons.child_care_rounded, 'Safe NICU Distribution',
          'Screened, pasteurized donor milk is delivered to Pasig City NICU patients — protecting fragile preemies from infection and malnutrition.',
          WebColors.coralAccent),
    ];

    return SectionWrapper(
      child: Column(children: [
        const SectionHeading(
          eyebrow: 'How It Works',
          title: 'Simple. Safe. Life-Giving.',
          subtitle: "From your home to a premature baby's bedside — here's how the MilkLink process protects every drop.",
        ),
        const SizedBox(height: 48),

        LayoutBuilder(builder: (ctx, cst) {
          if (cst.maxWidth > 700) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: steps.asMap().entries.map((e) {
                final isLast = e.key == steps.length - 1;
                return Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: ProcessStepCard(
                    stepNumber: e.value.number, icon: e.value.icon,
                    title: e.value.title, description: e.value.desc,
                    color: e.value.color, isLast: isLast,
                  )),
                  if (!isLast) const SizedBox(width: 4),
                ]));
              }).toList(),
            );
          }
          // Mobile: vertical list
          return Column(children: steps.map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _MobileStep(s),
          )).toList());
        }),
      ]),
    );
  }
}

class _Step {
  final int number;
  final IconData icon;
  final String title;
  final String desc;
  final Color color;
  const _Step(this.number, this.icon, this.title, this.desc, this.color);
}

class _MobileStep extends StatelessWidget {
  final _Step s;
  const _MobileStep(this.s);

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(children: [
        Container(width: 44, height: 44,
            decoration: BoxDecoration(color: s.color, shape: BoxShape.circle),
            child: Icon(s.icon, color: Colors.white, size: 22)),
        Container(width: 2, height: 60, color: s.color.withValues(alpha: 0.2)),
      ]),
      const SizedBox(width: 16),
      Expanded(child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Step ${s.number}: ${s.title}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
          const SizedBox(height: 6),
          Text(s.desc, style: const TextStyle(fontSize: 13, color: WebColors.textSecondary, height: 1.5)),
        ]),
      )),
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. GALLERY SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _GallerySection extends StatelessWidget {
  const _GallerySection();

  static const _items = [
    _GalleryData(Icons.people_alt_rounded, 'Oplan Gatas — Barangay Rosario Milk Drive',
        'Community Event', 'Nov 2, 2026', 'Brgy. Rosario, Pasig City',
        'Over 60 volunteer mothers from Barangay Rosario participated in a full-day community milk letting drive, donating over 42 litres of screened breast milk for NICU babies.',
        WebColors.primaryBlue),
    _GalleryData(Icons.local_hospital_rounded, 'Pasig City Children\'s Hospital Milk Bank Facility',
        'HMB Facility', 'Oct 18, 2026', 'Room 204, Pasig City Children\'s Hospital',
        'The state-of-the-art Human Milk Bank facility features DOH-certified Holder pasteurization equipment, medical-grade freezers, and a dedicated screening clinic.',
        WebColors.softTeal),
    _GalleryData(Icons.pregnant_woman_rounded, 'Maternal Education & Lactation Workshop',
        'Health Education', 'Oct 5, 2026', 'Barangay Health Center, Kapitolyo',
        'Pasig City nurses and lactation counsellors conducted a free breastfeeding and milk expression workshop for 85 expectant and new mothers at Kapitolyo Health Center.',
        WebColors.coralAccent),
    _GalleryData(Icons.science_rounded, 'Lab Screening & Pasteurization Process',
        'Quality Control', 'Sep 20, 2026', 'Milk Bank Laboratory, Pasig City',
        'The MilkLink laboratory team demonstrates the gold-standard Holder pasteurization process — 62.5 °C for 30 minutes — ensuring every bottle of donor milk is completely safe.',
        WebColors.warmAmber),
    _GalleryData(Icons.child_care_rounded, 'NICU Milk Distribution — Pasig City',
        'NICU Delivery', 'Sep 12, 2026', 'NICU, Pasig City Children\'s Hospital',
        'Cold-chain certified nurse coordinators deliver a fresh batch of pasteurized donor milk to the NICU team, nourishing 8 premature infants with the life-saving gift of human milk.',
        WebColors.softTeal),
    _GalleryData(Icons.local_shipping_rounded, 'Mobile Home Pickup — Barangay Manggahan',
        'Home Collection', 'Aug 29, 2026', 'Brgy. Manggahan, Pasig City',
        'The MilkLink mobile cold-chain collection team completes door-to-door pickup of 23 L of freshly frozen donor breast milk from 11 registered homes across Barangay Manggahan.',
        WebColors.coralAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      backgroundColor: WebColors.pageBackground,
      child: Column(children: [
        const SectionHeading(
          eyebrow: 'Donations Gallery',
          title: 'Stories of Compassion\nfrom Pasig City',
          subtitle: 'Real moments from our milk letting drives, facilities, and community heroes.',
        ),
        const SizedBox(height: 40),
        LayoutBuilder(builder: (ctx, cst) {
          int cols = cst.maxWidth > 900 ? 3 : cst.maxWidth > 580 ? 2 : 1;
          final itemW = (cst.maxWidth - 16.0 * (cols - 1)) / cols;
          return Wrap(spacing: 16, runSpacing: 16, children: _items.map((item) =>
            SizedBox(width: itemW, child: GalleryCard(
              icon: item.icon, title: item.title, category: item.category,
              date: item.date, location: item.location, description: item.description,
              color: item.color,
              onTap: () => _showLightbox(context, item),
            )),
          ).toList());
        }),
      ]),
    );
  }

  void _showLightbox(BuildContext context, _GalleryData item) {
    showDialog(
      context: context, barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 680),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            // Visual area
            Container(height: 220,
              decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [item.color.withValues(alpha: 0.15), item.color.withValues(alpha: 0.04)])),
              child: Stack(children: [
                Center(child: Icon(item.icon, size: 72, color: item.color.withValues(alpha: 0.5))),
                Positioned(top: 10, right: 10,
                    child: CircleAvatar(backgroundColor: Colors.white,
                        child: IconButton(icon: const Icon(Icons.close_rounded, size: 18, color: WebColors.textPrimary),
                            onPressed: () => Navigator.pop(ctx)))),
              ]),
            ),
            Padding(padding: const EdgeInsets.all(24), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800,
                    color: WebColors.primaryNavy)),
                const SizedBox(height: 8),
                Row(children: [
                  const Icon(Icons.calendar_today_rounded, size: 13, color: WebColors.textSecondary),
                  const SizedBox(width: 5),
                  Text(item.date, style: const TextStyle(fontSize: 12, color: WebColors.textSecondary)),
                  const SizedBox(width: 14),
                  const Icon(Icons.location_on_rounded, size: 13, color: WebColors.coralAccent),
                  const SizedBox(width: 5),
                  Expanded(child: Text(item.location, style: const TextStyle(fontSize: 12, color: WebColors.textSecondary))),
                ]),
                const SizedBox(height: 14),
                const Divider(color: WebColors.divider),
                const SizedBox(height: 14),
                Text(item.description, style: const TextStyle(fontSize: 14, color: WebColors.textPrimary, height: 1.6)),
                const SizedBox(height: 20),
                Align(alignment: Alignment.centerRight, child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Close'))),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}

class _GalleryData {
  final IconData icon;
  final String title;
  final String category;
  final String date;
  final String location;
  final String description;
  final Color color;
  const _GalleryData(this.icon, this.title, this.category, this.date, this.location, this.description, this.color);
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. EVENTS, ANNOUNCEMENTS & ARTICLES SECTION
// ─────────────────────────────────────────────────────────────────────────────
class _UpdatesSection extends StatefulWidget {
  final Future<List<LettingEventModel>>   eventsFuture;
  final Future<List<AnnouncementModel>>   announcementsFuture;
  final Future<List<ArticleModel>>        articlesFuture;

  const _UpdatesSection({
    required this.eventsFuture,
    required this.announcementsFuture,
    required this.articlesFuture,
  });

  @override
  State<_UpdatesSection> createState() => _UpdatesSectionState();
}

class _UpdatesSectionState extends State<_UpdatesSection> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      child: Column(children: [
        const SectionHeading(
          eyebrow: 'Community Updates',
          title: 'Events, Notices & Articles',
          subtitle: 'Stay informed with the latest milk letting events, official announcements, and educational resources.',
        ),
        const SizedBox(height: 32),

        // Tab bar
        Container(
          decoration: BoxDecoration(
            color: WebColors.pageBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: WebColors.border),
          ),
          padding: const EdgeInsets.all(4),
          child: TabBar(
            controller: _tab,
            indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 4, offset: Offset(0, 1))]),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: WebColors.primaryBlue,
            unselectedLabelColor: WebColors.textSecondary,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            tabs: const [
              Tab(text: '📅  Upcoming Events'),
              Tab(text: '📢  Announcements'),
              Tab(text: '📰  Articles'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        SizedBox(height: 480,
          child: TabBarView(controller: _tab, children: [
            // Events tab
            FutureBuilder<List<LettingEventModel>>(
              future: widget.eventsFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const _Loading();
                final events = snap.data ?? [];
                if (events.isEmpty) return const _EmptyState('No upcoming events scheduled.');
                return _CardGrid(children: events.map((e) {
                  final d = e.details.date;
                  return EventCard(
                    title:     e.activity,
                    date:      '${DateFormat('MMM').format(d)} ${d.day}',
                    time:      '${e.details.time.start} – ${e.details.time.end}',
                    venue:     e.venue.name,
                    barangay:  e.venue.barangay,
                    onRegister: () => _showEventRsvp(context, e),
                  );
                }).toList());
              },
            ),

            // Announcements tab
            FutureBuilder<List<AnnouncementModel>>(
              future: widget.announcementsFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const _Loading();
                final items = snap.data ?? [];
                if (items.isEmpty) return const _EmptyState('No announcements at this time.');
                return _CardGrid(children: items.map((a) => AnnouncementCard(
                  title: a.title, description: a.description,
                  date: a.formattedCreatedAt, tags: a.tags,
                  onReadMore: () => _showAnnouncementDetail(context, a),
                )).toList());
              },
            ),

            // Articles tab
            FutureBuilder<List<ArticleModel>>(
              future: widget.articlesFuture,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) return const _Loading();
                final items = snap.data ?? [];
                if (items.isEmpty) return const _EmptyState('No articles published yet.');
                return _CardGrid(children: items.map((a) => ArticleCard(
                  title: a.title, description: a.description,
                  date: a.formattedCreatedAt, imageUrl: a.firstImageUrl,
                  onReadMore: () => _showArticleDetail(context, a),
                )).toList());
              },
            ),
          ]),
        ),
      ]),
    );
  }

  void _showEventRsvp(BuildContext context, LettingEventModel event) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool done = false;

    showDialog(
      context: context, barrierColor: Colors.black54,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(padding: const EdgeInsets.all(28), child: done
            ? Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.check_circle_rounded, color: WebColors.softTeal, size: 56),
                const SizedBox(height: 14),
                const Text('RSVP Confirmed!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: WebColors.primaryNavy)),
                const SizedBox(height: 8),
                Text('Thank you! You\'re registered for ${event.activity}.',
                    textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: WebColors.textSecondary)),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Done')),
              ])
            : Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(event.activity, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: WebColors.primaryNavy))),
                  IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
                ]),
                const SizedBox(height: 4),
                Text('${DateFormat('MMM dd, yyyy').format(event.details.date)} · ${event.details.time.start} – ${event.details.time.end}',
                    style: const TextStyle(fontSize: 12, color: WebColors.textSecondary)),
                Text(event.venue.fullAddress, style: const TextStyle(fontSize: 12, color: WebColors.textSecondary)),
                const SizedBox(height: 20),
                Form(key: formKey, child: Column(children: [
                  TextFormField(controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                  const SizedBox(height: 12),
                  TextFormField(controller: phoneCtrl, keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Mobile Number', prefixIcon: Icon(Icons.phone_outlined)),
                      validator: (v) => v == null || v.trim().length < 7 ? 'Enter a valid number' : null),
                ])),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: OutlinedButton(
                      onPressed: () { Navigator.pop(ctx); Navigator.of(context).pushNamed('/become-a-donor'); },
                      child: const Text('Register as Donor'))),
                  const SizedBox(width: 10),
                  Expanded(child: ElevatedButton(
                      onPressed: () { if (formKey.currentState?.validate() == true) setS(() => done = true); },
                      child: const Text('Confirm RSVP'))),
                ]),
              ]),
          ),
        ),
      )),
    );
  }

  void _showAnnouncementDetail(BuildContext context, AnnouncementModel a) {
    showDialog(context: context, barrierColor: Colors.black54, builder: (ctx) =>
      Dialog(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: a.tags.any((t) => t.toLowerCase() == 'urgent') ? WebColors.coralSoft : WebColors.softBlue,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
              child: Row(children: [
                Icon(Icons.campaign_rounded, color: a.tags.any((t) => t.toLowerCase() == 'urgent')
                    ? WebColors.coralAccent : WebColors.primaryBlue, size: 24),
                const SizedBox(width: 10),
                Expanded(child: Text(a.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: WebColors.primaryNavy))),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
              ])),
            Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 6, children: a.tags.map((t) => Chip(
                label: Text(t, style: const TextStyle(fontSize: 11)),
                backgroundColor: t.toLowerCase() == 'urgent' ? WebColors.coralSoft : WebColors.tealLight,
                side: BorderSide.none, padding: const EdgeInsets.symmetric(horizontal: 4),
              )).toList()),
              const SizedBox(height: 14),
              Text(a.description, style: const TextStyle(fontSize: 14, color: WebColors.textPrimary, height: 1.65)),
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerRight, child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('Close'))),
            ])),
          ])),
        ),
      ),
    );
  }

  void _showArticleDetail(BuildContext context, ArticleModel a) {
    showDialog(context: context, barrierColor: Colors.black54, builder: (ctx) =>
      Dialog(backgroundColor: Colors.white, surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700, maxHeight: 720),
          child: Column(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: WebColors.border))),
              child: Row(children: [
                const Icon(Icons.menu_book_rounded, color: WebColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                const Text('Maternal Education Article', style: TextStyle(fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
              ])),
            Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: WebColors.primaryNavy, height: 1.3)),
                const SizedBox(height: 8),
                Text(a.formattedCreatedAt, style: const TextStyle(fontSize: 12, color: WebColors.textSecondary)),
                const SizedBox(height: 16),
                const Divider(color: WebColors.divider),
                const SizedBox(height: 16),
                SelectableText(a.content.isNotEmpty ? a.content : a.description,
                    style: const TextStyle(fontSize: 14, color: WebColors.textPrimary, height: 1.7)),
              ],
            ))),
            Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC),
                  border: Border(top: BorderSide(color: WebColors.border))),
              child: Align(alignment: Alignment.centerRight, child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx), child: const Text('Close')))),
          ]),
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) => const Center(
    child: CircularProgressIndicator(color: WebColors.primaryBlue, strokeWidth: 2.5));
}

class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState(this.message);
  @override
  Widget build(BuildContext context) => Center(child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const Icon(Icons.inbox_rounded, size: 48, color: WebColors.border),
      const SizedBox(height: 10),
      Text(message, style: const TextStyle(color: WebColors.textSecondary)),
    ],
  ));
}

class _CardGrid extends StatelessWidget {
  final List<Widget> children;
  const _CardGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, cst) {
      final cols = cst.maxWidth > 700 ? (cst.maxWidth > 1000 ? 3 : 2) : 1;
      final w = (cst.maxWidth - 16.0 * (cols - 1)) / cols;
      return SingleChildScrollView(
        child: Wrap(spacing: 16, runSpacing: 16,
            children: children.map((c) => SizedBox(width: w, child: c)).toList()),
      );
    });
  }
}

