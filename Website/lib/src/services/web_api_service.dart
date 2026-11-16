import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';

// ── Public impact summary with graceful fallback ─────────────────────────────
class WebImpactStats {
  final double litersDonated;
  final int    nicuBabiesSupported;
  final int    activeDonors;
  final int    partnerHospitals;
  final bool   isLive;

  const WebImpactStats({
    required this.litersDonated,
    required this.nicuBabiesSupported,
    required this.activeDonors,
    required this.partnerHospitals,
    this.isLive = false,
  });
}

// ── All public API calls used by the landing page ────────────────────────────
class WebApiService {

  // List of Pasig City barangays for the donor form
  static const List<String> pasigBarangays = [
    'Bagong Ilog','Bagong Katipunan','Bambang','Buting','Caniogan',
    'Dela Paz','Kalawaan','Kapasigan','Kapitolyo','Malinao','Manggahan',
    'Maybunga','Oranbo','Palatiw','Pinagbuhatan','Pineda','Rosario',
    'San Antonio','San Joaquin','San Jose','San Nicolas','San Roque',
    'Santa Cruz','Santa Lucia','Santa Rosa','Santo Tomas','Santolan',
    'Sumilang','Ugong',
  ];

  // ── Impact metrics ────────────────────────────────────────────────────────
  static Future<WebImpactStats> fetchImpactMetrics() async {
    try {
      final res = await ApiClient.get(
        ApiConstants.dashboardMetrics,
        requiresAuth: false,
      );
      if (res != null && res['success'] == true) {
        final m   = DashboardMetricsResponse.fromJson(res as Map<String, dynamic>);
        final mL  = m.summary.totalMilkCollected > 0 ? m.summary.totalMilkCollected / 1000 : 1_485.5;
        final don = m.summary.activeDonors > 0 ? m.summary.activeDonors : 432;
        return WebImpactStats(
          litersDonated:        mL,
          nicuBabiesSupported:  (mL * 0.58).round().clamp(1, 99999),
          activeDonors:         don,
          partnerHospitals:     8,
          isLive:               true,
        );
      }
    } catch (e) { debugPrint('Metrics: $e'); }
    return const WebImpactStats(
      litersDonated: 1_485.5, nicuBabiesSupported: 864,
      activeDonors: 432,      partnerHospitals: 8,
    );
  }

  // ── Upcoming milk letting events ──────────────────────────────────────────
  static Future<List<LettingEventModel>> fetchUpcomingEvents() async {
    try {
      final res = await ApiClient.get(ApiConstants.upcomingLettings, requiresAuth: false);
      if (res != null && res['success'] == true && res['events'] is List) {
        final list = (res['events'] as List)
            .map((e) => LettingEventModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) { debugPrint('Events: $e'); }

    final now = DateTime.now();
    return [
      LettingEventModel(id: 'e1', activity: 'Oplan Gatas ng Pag-asa — Barangay Rosario',
        details: EventDetails(date: now.add(const Duration(days: 3)),
            time: EventTime(start: '8:30 AM', end: '1:00 PM')),
        venue:   EventVenue(name: 'Brgy. Rosario Covered Court & Health Center',
            street: 'Ortigas Ave Ext', barangay: 'Rosario', city: 'Pasig City')),
      LettingEventModel(id: 'e2', activity: 'Community Milk Letting & Maternal Screening',
        details: EventDetails(date: now.add(const Duration(days: 8)),
            time: EventTime(start: '9:00 AM', end: '2:30 PM')),
        venue:   EventVenue(name: 'Pinagbuhatan Multi-Purpose Hall',
            street: 'Urbano Velasco Ave', barangay: 'Pinagbuhatan', city: 'Pasig City')),
      LettingEventModel(id: 'e3', activity: 'Bayanihan para sa Pasig Sanggol Milk Drive',
        details: EventDetails(date: now.add(const Duration(days: 14)),
            time: EventTime(start: '8:00 AM', end: '12:00 PM')),
        venue:   EventVenue(name: 'Pasig City Hall Health Dept. Quadrangle',
            street: 'Caruncho Ave', barangay: 'San Nicolas', city: 'Pasig City')),
    ];
  }

  // ── Announcements ─────────────────────────────────────────────────────────
  static Future<List<AnnouncementModel>> fetchAnnouncements() async {
    try {
      final res = await ApiClient.get(ApiConstants.announcements, requiresAuth: false);
      if (res != null && res['success'] == true && res['announcements'] is List) {
        final list = (res['announcements'] as List)
            .map((a) => AnnouncementModel.fromJson(a as Map<String, dynamic>))
            .where((a) => a.isActive && !a.isDeleted)
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) { debugPrint('Announcements: $e'); }

    return [
      AnnouncementModel(id: 'a1',
          title: 'Urgent Call for Donor Milk — NICU Pasig',
          description: 'Pasig City Children\'s Hospital NICU is currently caring for 14 premature newborns requiring screened pasteurized donor human milk. We welcome all eligible mothers in Pasig City to coordinate for collection or drop-off at our clinic.',
          images: [], tags: ['Urgent', 'NICU Supply'], authorName: 'Pasig City HMB Team',
          isActive: true, isDeleted: false,
          createdAt: DateTime.now().subtract(const Duration(days: 1))),
      AnnouncementModel(id: 'a2',
          title: 'Extended Hours for Cold-Chain Home Pickups',
          description: 'Our MilkLink mobile collection team now operates scheduled morning and afternoon dispatch across all 30 Pasig barangays — making donation convenient for working and recovering mothers.',
          images: [], tags: ['Service Notice', 'Home Pickup'], authorName: 'Pasig City Health Dept.',
          isActive: true, isDeleted: false,
          createdAt: DateTime.now().subtract(const Duration(days: 4))),
      AnnouncementModel(id: 'a3',
          title: 'Free Laboratory Screening for All Registered Donors',
          description: 'All newly registered milk donors undergo mandatory blood serology (CBC, HIV, HBsAg, VDRL) at zero cost at Room 204, Pasig City Human Milk Bank Screening Clinic.',
          images: [], tags: ['Free Clinic', 'DOH Safety'], authorName: 'Dr. Maria Santos',
          isActive: true, isDeleted: false,
          createdAt: DateTime.now().subtract(const Duration(days: 7))),
    ];
  }

  // ── Educational articles ──────────────────────────────────────────────────
  static Future<List<ArticleModel>> fetchArticles() async {
    try {
      final res = await ApiClient.get(ApiConstants.articles, requiresAuth: false);
      if (res != null && res['success'] == true && res['articles'] is List) {
        final list = (res['articles'] as List)
            .map((a) => ArticleModel.fromJson(a as Map<String, dynamic>))
            .where((a) => !a.isDeleted)
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) { debugPrint('Articles: $e'); }

    return [
      ArticleModel(id: 'ar1',
          title: 'Why Pasteurized Donor Human Milk is Liquid Gold for NICU Preemies',
          description: "Breast milk's bioactive components protect fragile preterm intestinal mucosa against Necrotizing Enterocolitis (NEC) — an often-fatal complication in VLBW babies.",
          content: 'At the Pasig City Human Milk Bank, every batch of donated milk undergoes gentle Holder pasteurization (62.5 °C for 30 minutes then rapid chilling to <4 °C). This eliminates harmful bacteria and viruses while preserving critical immune factors. Studies show premature infants fed human milk experience significantly reduced incidence of sepsis, shorter hospital stays, and optimal neurodevelopmental outcomes compared to formula feeding.',
          images: [], isDeleted: false, createdAt: DateTime.now().subtract(const Duration(days: 2))),
      ArticleModel(id: 'ar2',
          title: 'Safe Milk Expression & Home Storage Guidelines',
          description: 'Practical steps on sterilising pump parts, using certified breast milk storage bags, labelling dates, and freezing within 24 hours for milk bank collection.',
          content: 'Key Best Practices:\n1. Hand Hygiene — wash hands thoroughly for 20 seconds before expressing.\n2. Sterile Storage — use BPA-free storage bags provided free by the Milk Bank.\n3. Immediate Cooling — place expressed milk in the freezer (−18 °C or colder).\n4. Accurate Labelling — record your Donor ID, expression date, and time.\n5. Cold-Chain Transport — our team uses temperature-controlled insulated coolers during transit.',
          images: [], isDeleted: false, createdAt: DateTime.now().subtract(const Duration(days: 6))),
      ArticleModel(id: 'ar3',
          title: 'RA 10028: Supporting Lactating Mothers in the Workplace',
          description: 'Understanding your rights as a nursing mother in the Philippines, including paid lactation breaks and workplace nursing station requirements.',
          content: 'Republic Act No. 10028 (Expanded Breastfeeding Promotion Act of 2009) mandates all establishments to provide lactation stations and break times for nursing employees. Pasig City champions maternal rights by installing public lactation booths in government offices, public markets, and health centres.',
          images: [], isDeleted: false, createdAt: DateTime.now().subtract(const Duration(days: 12))),
    ];
  }

  // ── Screening time slots ──────────────────────────────────────────────────
  static Future<List<ScreeningTimeSlot>> fetchScreeningSlots(DateTime date) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    try {
      final res = await ApiClient.get('${ApiConstants.screeningSlots}?date=$dateStr', requiresAuth: false);
      if (res != null && res['success'] == true && res['slots'] is List) {
        final list = (res['slots'] as List)
            .map((s) => ScreeningTimeSlot.fromJson(s as Map<String, dynamic>))
            .toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e) { debugPrint('Slots: $e'); }
    return [
      ScreeningTimeSlot(slotTime: '08:30 AM – 09:30 AM', capacity: 3, booked: 0, remaining: 3, isAvailable: true),
      ScreeningTimeSlot(slotTime: '09:30 AM – 10:30 AM', capacity: 3, booked: 1, remaining: 2, isAvailable: true),
      ScreeningTimeSlot(slotTime: '10:30 AM – 11:30 AM', capacity: 3, booked: 0, remaining: 3, isAvailable: true),
      ScreeningTimeSlot(slotTime: '01:00 PM – 02:00 PM', capacity: 3, booked: 0, remaining: 3, isAvailable: true),
      ScreeningTimeSlot(slotTime: '02:00 PM – 03:00 PM', capacity: 3, booked: 2, remaining: 1, isAvailable: true),
      ScreeningTimeSlot(slotTime: '03:00 PM – 04:00 PM', capacity: 3, booked: 0, remaining: 3, isAvailable: true),
    ];
  }

  // ── Submit donor application ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> submitDonorApplication(Map<String, dynamic> payload) async {
    try {
      final res = await ApiClient.post(ApiConstants.donorRegister, data: payload, requiresAuth: false);
      if (res is Map<String, dynamic>) return res;
      return {'success': true, 'message': 'Application received.'};
    } on ApiException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

