import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared/shared.dart';
import '../constants/web_colors.dart';
import '../services/web_api_service.dart';
import '../widgets/nav_header.dart';
import '../widgets/landing_widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// /become-a-donor — Multi-step donor registration page
// ─────────────────────────────────────────────────────────────────────────────
class BecomeDonorScreen extends StatefulWidget {
  const BecomeDonorScreen({super.key});

  @override
  State<BecomeDonorScreen> createState() => _BecomeDonorScreenState();
}

class _BecomeDonorScreenState extends State<BecomeDonorScreen> {
  int _step = 0;   // 0-based; 4 steps total + step 4 = confirmation
  bool _submitting = false;

  // Form data
  final _step0Key = GlobalKey<FormState>();
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  // Step 0 — Personal info
  final _firstNameCtrl  = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl   = TextEditingController();
  final _contactCtrl    = TextEditingController();
  final _occupationCtrl = TextEditingController();
  DateTime? _birthday;
  String _donorType = 'Community';

  // Step 0 — Pasig address
  final _streetCtrl = TextEditingController();
  String _brgy = WebApiService.pasigBarangays.first;
  final _cityCtrl = TextEditingController(text: 'Pasig City');

  // Step 1 — Infant & lactation info
  final _childNameCtrl    = TextEditingController();
  final _birthWeightCtrl  = TextEditingController();
  final _notesCtrl        = TextEditingController();
  DateTime? _childBirthday;

  // Step 2 — Medical questionnaire
  final Map<String, bool> _questionnaire = {
    'I had a normal pregnancy and delivery.': true,
    'I am in good health with no active infection or illness.': true,
    'I am not currently smoking or using tobacco products.': true,
    'I do not drink alcohol or use recreational drugs.': true,
    'I am not on any medications that affect breast milk safety.': true,
    'I have not received a blood transfusion in the past 12 months.': true,
    'I do not have HIV, Hepatitis B/C, HTLV, or Syphilis.': true,
    'I am willing to undergo free serology screening at the Milk Bank clinic.': true,
  };

  // Step 3 — Preferred appointment date & slot
  DateTime? _appointmentDate;
  List<ScreeningTimeSlot> _slots = [];
  bool _loadingSlots = false;
  String? _selectedSlot;

  Map<String, dynamic>? _confirmationData;

  @override
  void dispose() {
    for (final c in [
      _firstNameCtrl,
      _middleNameCtrl,
      _lastNameCtrl,
      _contactCtrl,
      _occupationCtrl,
      _streetCtrl,
      _cityCtrl,
      _childNameCtrl,
      _birthWeightCtrl,
      _notesCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Navigation ──────────────────────────────────────────────────────────────
  Future<void> _next() async {
    bool valid = true;
    switch (_step) {
      case 0: valid = _step0Key.currentState?.validate() ?? false; break;
      case 1: valid = _step1Key.currentState?.validate() ?? false; break;
      case 2: valid = _step2Key.currentState?.validate() ?? false; break;
      case 3:
        if (_appointmentDate == null) {
          _snack('Please select a preferred appointment date.'); return;
        }
        if (_selectedSlot == null) {
          _snack('Please select an available time slot.'); return;
        }
        await _submit(); return;
    }
    if (!valid) return;
    if (_step == 0 && _birthday == null) { _snack('Please enter your date of birth.'); return; }
    if (_step == 1 && _childBirthday == null) { _snack('Please enter your infant\'s date of birth.'); return; }
    setState(() => _step++);
  }

  void _back() { if (_step > 0) setState(() => _step--); }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: WebColors.error, behavior: SnackBarBehavior.floating));
  }

  // ── Fetch slots when date is chosen ────────────────────────────────────────
  Future<void> _pickAppointmentDate() async {
    final now  = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate:  now.add(const Duration(days: 90)),
      selectableDayPredicate: (d) => d.weekday != DateTime.sunday && d.weekday != DateTime.saturday,
    );
    if (date == null) return;
    setState(() { _appointmentDate = date; _selectedSlot = null; _loadingSlots = true; });
    final slots = await WebApiService.fetchScreeningSlots(date);
    setState(() { _slots = slots; _loadingSlots = false; });
  }

  // ── Submit ──────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    setState(() => _submitting = true);
    final payload = {
      'firstName':          _firstNameCtrl.text.trim(),
      'middleName':         _middleNameCtrl.text.trim(),
      'lastName':           _lastNameCtrl.text.trim(),
      'birthday':           _birthday?.toIso8601String(),
      'street':             _streetCtrl.text.trim(),
      'brgy':               _brgy,
      'city':               _cityCtrl.text.trim(),
      'contactNumber':      _contactCtrl.text.trim(),
      'occupation':         _occupationCtrl.text.trim(),
      'donorType':          _donorType,
      'childName':          _childNameCtrl.text.trim(),
      'childBirthday':      _childBirthday?.toIso8601String(),
      'birthWeight':        _birthWeightCtrl.text.trim(),
      'breastfeedingInfo':  _notesCtrl.text.trim(),
      'questionnaireAnswers': Map.fromEntries(_questionnaire.entries.map(
          (e) => MapEntry(e.key, e.value ? 'Yes' : 'No'))),
      'preferredAppointmentDate': _appointmentDate?.toIso8601String(),
      'preferredTimeSlot':  _selectedSlot,
    };

    final result = await WebApiService.submitDonorApplication(payload);
    setState(() { _submitting = false; _confirmationData = result; _step = 4; });
  }

  // ── Build ───────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WebColors.pageBackground,
      appBar: const NavHeader(),
      body: SingleChildScrollView(child: Column(children: [
        // Page header banner
        Container(width: double.infinity,
          decoration: const BoxDecoration(gradient: WebColors.primaryGradient),
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 32),
          child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 820),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.arrow_back_rounded, color: Colors.white70, size: 16),
                  SizedBox(width: 6),
                  Text('Back to Home', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ),
              const SizedBox(height: 14),
              const Text('Become a MilkLink Donor',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
              const SizedBox(height: 8),
              const Text('Help save premature babies in Pasig City NICUs. Your breast milk donation costs nothing — but means everything.',
                  style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.5)),
            ]),
          )),
        ),

        const SizedBox(height: 32),

        Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              if (_step < 4) ...[
                _StepIndicator(currentStep: _step, total: 4),
                const SizedBox(height: 28),
              ],
              _buildStepContent(),
            ]),
          ),
        )),

        const SizedBox(height: 48),
        SiteFooter(),
      ])),
    );
  }

  Widget _buildStepContent() {
    switch (_step) {
      case 0: return _buildStep0();
      case 1: return _buildStep1();
      case 2: return _buildStep2();
      case 3: return _buildStep3();
      case 4: return _buildConfirmation();
      default: return const SizedBox();
    }
  }

  // ─── Step 0: Personal Info & Pasig Address ──────────────────────────────────
  Widget _buildStep0() => _StepCard(
    title: 'Personal Information & Pasig Address',
    icon: Icons.person_outline,
    color: WebColors.primaryBlue,
    onNext: _next,
    child: Form(key: _step0Key, child: Column(children: [
      _row2([
        _field('First Name *', _firstNameCtrl, required: true),
        _field('Middle Name', _middleNameCtrl),
      ]),
      _field('Last Name *', _lastNameCtrl, required: true),
      _row2([
        _datePicker('Date of Birth *', _birthday, (d) => setState(() => _birthday = d)),
        _dropdown('Donor Type', _donorType, ['Community', 'Referred', 'Staff'],
            (v) => setState(() => _donorType = v!)),
      ]),
      _field('Contact Number *', _contactCtrl, required: true, keyboard: TextInputType.phone,
          hint: '09XX XXX XXXX'),
      _field('Occupation (Optional)', _occupationCtrl),

      _sectionLabel('Home Address in Pasig City'),
      _field('Street / Building *', _streetCtrl, required: true),
      _row2([
        _barangayDropdown(),
        _field('City', _cityCtrl, readOnly: true),
      ]),
    ])),
  );

  // ─── Step 1: Infant & Lactation Info ───────────────────────────────────────
  Widget _buildStep1() => _StepCard(
    title: 'Infant Details & Lactation History',
    icon: Icons.child_care_rounded,
    color: WebColors.softTeal,
    onNext: _next, onBack: _back,
    child: Form(key: _step1Key, child: Column(children: [
      _field('Infant\'s Full Name *', _childNameCtrl, required: true),
      _row2([
        _datePicker('Infant\'s Date of Birth *', _childBirthday, (d) => setState(() => _childBirthday = d)),
        _field('Birth Weight (grams)', _birthWeightCtrl, keyboard: TextInputType.number, hint: 'e.g. 3,200 g'),
      ]),
      TextFormField(
        controller: _notesCtrl, maxLines: 3,
        decoration: _inputDec('Breastfeeding Notes (Optional)',
            hint: 'e.g. How long breastfeeding, any challenges, medication history…'),
      ),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: WebColors.tealLight, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: WebColors.softTeal.withValues(alpha: 0.3))),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Icon(Icons.info_outline_rounded, color: WebColors.softTeal, size: 18),
          SizedBox(width: 10),
          Expanded(child: Text(
              'Your infant\'s information helps our screening team verify eligibility and ensure your donation is properly processed under Pasig City Human Milk Bank protocols.',
              style: TextStyle(fontSize: 12, color: WebColors.tealDark, height: 1.5))),
        ]),
      ),
    ])),
  );

  // ─── Step 2: Medical Questionnaire ─────────────────────────────────────────
  Widget _buildStep2() => _StepCard(
    title: 'Basic Medical & Lifestyle Screening',
    icon: Icons.health_and_safety_outlined,
    color: WebColors.coralAccent,
    onNext: _next, onBack: _back,
    child: Form(key: _step2Key, child: Column(children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: WebColors.softBlue, borderRadius: BorderRadius.circular(10)),
        child: const Text(
            'Please answer honestly. All information is kept strictly confidential and used only for Milk Bank eligibility assessment.',
            style: TextStyle(fontSize: 13, color: WebColors.primaryNavy)),
      ),
      const SizedBox(height: 16),
      ..._questionnaire.keys.map((q) => CheckboxListTile(
        value: _questionnaire[q],
        onChanged: (v) => setState(() => _questionnaire[q] = v ?? false),
        title: Text(q, style: const TextStyle(fontSize: 13, color: WebColors.textPrimary)),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: WebColors.primaryBlue,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      )),
      const SizedBox(height: 10),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: WebColors.warningBg, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: WebColors.warning.withValues(alpha: 0.3))),
        child: Row(children: const [
          Icon(Icons.warning_amber_rounded, color: WebColors.warmAmber, size: 18),
          SizedBox(width: 8),
          Expanded(child: Text(
              'All donors MUST pass a free serology blood test (CBC, HIV, HBsAg, Anti-HCV, VDRL) at our clinic before donating. This is mandatory under DOH guidelines.',
              style: TextStyle(fontSize: 12, color: Color(0xFF78350F)))),
        ]),
      ),
    ])),
  );

  // ─── Step 3: Preferred Appointment ─────────────────────────────────────────
  Widget _buildStep3() => _StepCard(
    title: 'Preferred Screening Appointment',
    icon: Icons.calendar_today_rounded,
    color: WebColors.warmAmber,
    onNext: _submitting ? null : _next,
    onBack: _back,
    nextLabel: _submitting ? 'Submitting…' : 'Submit Application',
    child: Form(key: _step3Key, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Select your preferred appointment date at the Pasig City HMB Screening Clinic (Mon–Fri).',
          style: TextStyle(fontSize: 13, color: WebColors.textSecondary)),
      const SizedBox(height: 16),
      InkWell(
        onTap: _pickAppointmentDate,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _appointmentDate != null ? WebColors.primaryBlue : WebColors.border)),
          child: Row(children: [
            const Icon(Icons.event_rounded, color: WebColors.primaryBlue, size: 22),
            const SizedBox(width: 12),
            Text(
              _appointmentDate != null ? DateFormat('EEEE, MMMM dd, yyyy').format(_appointmentDate!) : 'Tap to pick a date…',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: _appointmentDate != null ? WebColors.primaryNavy : WebColors.textSecondary),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down_rounded, color: WebColors.textSecondary),
          ]),
        ),
      ),

      if (_loadingSlots)
        const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(strokeWidth: 2))),

      if (_slots.isNotEmpty) ...[
        const SizedBox(height: 20),
        const Text('Available Time Slots',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
        const SizedBox(height: 10),
        Wrap(spacing: 10, runSpacing: 10, children: _slots.map((slot) {
          final sel = _selectedSlot == slot.slotTime;
          return GestureDetector(
            onTap: slot.isAvailable ? () => setState(() => _selectedSlot = slot.slotTime) : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: !slot.isAvailable ? WebColors.pageBackground : sel ? WebColors.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: !slot.isAvailable ? WebColors.border : sel ? WebColors.primaryBlue : WebColors.waveBlue),
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(slot.slotTime, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                    color: !slot.isAvailable ? WebColors.textMuted : sel ? Colors.white : WebColors.primaryNavy)),
                Text('${slot.remaining} of ${slot.capacity} slots left',
                    style: TextStyle(fontSize: 10,
                        color: !slot.isAvailable ? WebColors.textMuted : sel ? Colors.white70 : WebColors.textSecondary)),
              ]),
            ),
          );
        }).toList()),
      ],

      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: WebColors.pageBackground, borderRadius: BorderRadius.circular(10),
            border: Border.all(color: WebColors.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Pasig City HMB Screening Clinic',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
          SizedBox(height: 6),
          Text("📍  Room 204, 2nd Floor, Pasig City Children's Hospital\n"
              '⏰  Mon–Fri   8:00 AM – 5:00 PM\n'
              '📞  (02) 8643-0000 loc. 204',
              style: TextStyle(fontSize: 12, color: WebColors.textSecondary, height: 1.6)),
        ]),
      ),
    ])),
  );

  // ─── Confirmation ───────────────────────────────────────────────────────────
  Widget _buildConfirmation() {
    final success = _confirmationData?['success'] != false;
    final donorId = _confirmationData?['donorId'] ?? 'Registration Received';
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(36),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: WebColors.border),
          boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 6))],
        ),
        child: Column(children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: success ? WebColors.tealLight : WebColors.errorBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              success ? Icons.check_circle_rounded : Icons.error_outline_rounded,
              color: success ? WebColors.softTeal : WebColors.error, size: 44,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            success ? '🎉 Application Submitted!' : 'Submission Notice',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900,
                color: success ? WebColors.primaryNavy : WebColors.error),
          ),
          const SizedBox(height: 10),
          if (success) ...[
            Text('Thank you, ${_firstNameCtrl.text}! Your MilkLink donor application has been received.',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: WebColors.textSecondary)),
            const SizedBox(height: 20),
            Container(padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: WebColors.softBlue, borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                const Icon(Icons.badge_outlined, color: WebColors.primaryBlue, size: 24),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Your Donor Reference', style: TextStyle(fontSize: 12, color: WebColors.textSecondary)),
                  Text(donorId.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: WebColors.primaryBlue)),
                ]),
              ]),
            ),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('What Happens Next:',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: WebColors.primaryNavy))),
            const SizedBox(height: 12),
            ...[
              '1.  Our team will review your application within 1–2 business days.',
              '2.  You will receive a call or SMS to confirm your screening appointment.',
              '3.  Attend your free serology screening at Room 204, Pasig City Children\'s Hospital.',
              '4.  Upon passing, you\'ll receive your official MilkLink Donor ID and QR code.',
              '5.  Begin your donation journey — home pickup or milk letting event attendance!',
            ].map((s) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Icon(Icons.check_circle_rounded, color: WebColors.softTeal, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(s, style: const TextStyle(fontSize: 13, color: WebColors.textSecondary, height: 1.5))),
              ]),
            )),
          ] else ...[
            const SizedBox(height: 10),
            Text(_confirmationData?['message']?.toString() ?? 'We received your request.',
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: WebColors.textSecondary)),
          ],
          const SizedBox(height: 28),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pushNamed('/'),
              child: const Text('Back to Home'),
            ),
            const SizedBox(width: 14),
            if (success)
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                style: ElevatedButton.styleFrom(backgroundColor: WebColors.primaryBlue, foregroundColor: Colors.white),
                child: const Text('Go to Login'),
              ),
          ]),
        ]),
      ),
    ]);
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────
  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: WebColors.primaryNavy)),
  );

  Widget _field(String label, TextEditingController ctrl,
      {bool required = false, TextInputType? keyboard, String? hint, bool readOnly = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: ctrl, readOnly: readOnly, keyboardType: keyboard,
          decoration: _inputDec(label, hint: hint),
          validator: required ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null : null,
        ),
      );

  Widget _barangayDropdown() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: DropdownButtonFormField<String>(
      initialValue: _brgy,
      decoration: _inputDec('Barangay *'),
      isExpanded: true,
      items: WebApiService.pasigBarangays
          .map((b) => DropdownMenuItem(value: b, child: Text(b, style: const TextStyle(fontSize: 13))))
          .toList(),
      onChanged: (v) => setState(() => _brgy = v!),
    ),
  );

  Widget _dropdown(String label, String value, List<String> items, void Function(String?) onChanged) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: DropdownButtonFormField<String>(
          initialValue: value, decoration: _inputDec(label), isExpanded: true,
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: onChanged,
        ),
      );

  Widget _datePicker(String label, DateTime? val, void Function(DateTime) onPick) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InkWell(
          onTap: () async {
            final now = DateTime.now();
            final d = await showDatePicker(
              context: context,
              initialDate: val ?? now.subtract(const Duration(days: 365 * 25)),
              firstDate: now.subtract(const Duration(days: 365 * 60)),
              lastDate: now,
            );
            if (d != null) onPick(d);
          },
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: _inputDec(label),
            child: Text(
              val != null ? DateFormat('MMM dd, yyyy').format(val) : 'Select date…',
              style: TextStyle(fontSize: 14, color: val != null ? WebColors.textPrimary : WebColors.textSecondary),
            ),
          ),
        ),
      );

  Widget _row2(List<Widget> children) => Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: LayoutBuilder(builder: (ctx, cst) {
      if (cst.maxWidth > 500) {
        return Row(children: [
          Expanded(child: children[0]),
          const SizedBox(width: 12),
          Expanded(child: children[1]),
        ]);
      }
      return Column(children: children);
    }),
  );

  InputDecoration _inputDec(String label, {String? hint}) => InputDecoration(
    labelText: label, hintText: hint,
    filled: true, fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: WebColors.border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: WebColors.border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: WebColors.primaryBlue, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: WebColors.error)),
    labelStyle: const TextStyle(fontSize: 13, color: WebColors.textSecondary),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Step progress indicator
// ─────────────────────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int total;

  const _StepIndicator({required this.currentStep, required this.total});

  static const labels = ['Personal Info', 'Infant Info', 'Health Screen', 'Appointment'];

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(total * 2 - 1, (i) {
      if (i.isOdd) {
        final done = currentStep > i ~/ 2;
        return Expanded(child: Container(height: 2,
          color: done ? WebColors.primaryBlue : WebColors.border));
      }
      final stepIdx = i ~/ 2;
      final done   = currentStep > stepIdx;
      final active = currentStep == stepIdx;
      return Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: done || active ? WebColors.primaryBlue : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: done || active ? WebColors.primaryBlue : WebColors.border, width: 2),
            boxShadow: active ? [BoxShadow(color: WebColors.primaryBlue.withValues(alpha: 0.25), blurRadius: 8)] : null,
          ),
          child: Center(child: done
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
              : Text('${stepIdx + 1}',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                      color: active ? Colors.white : WebColors.textSecondary))),
        ),
        const SizedBox(height: 4),
        Text(labels[stepIdx], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
            color: active ? WebColors.primaryBlue : done ? WebColors.textSecondary : WebColors.textMuted)),
      ]);
    }));
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step card wrapper (white card with title + nav buttons)
// ─────────────────────────────────────────────────────────────────────────────
class _StepCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final String? nextLabel;

  const _StepCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
    this.onNext,
    this.onBack,
    this.nextLabel,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(20),
      border: Border.all(color: WebColors.border),
      boxShadow: const [BoxShadow(color: Color(0x07000000), blurRadius: 16, offset: Offset(0, 5))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Container(padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: WebColors.primaryNavy))),
      ]),
      const SizedBox(height: 20),
      const Divider(color: WebColors.divider),
      const SizedBox(height: 20),
      child,
      const SizedBox(height: 24),
      Row(children: [
        if (onBack != null) ...[
          OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: WebColors.textSecondary, side: const BorderSide(color: WebColors.border),
              minimumSize: const Size(100, 48), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.arrow_back_rounded, size: 16), SizedBox(width: 6), Text('Back'),
            ]),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(child: ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: WebColors.primaryBlue, foregroundColor: Colors.white,
            minimumSize: const Size(0, 50), elevation: 2,
            shadowColor: WebColors.primaryBlue.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(nextLabel ?? 'Continue'),
            if (nextLabel == null) ...[const SizedBox(width: 6), const Icon(Icons.arrow_forward_rounded, size: 16)],
          ]),
        )),
      ]),
    ]),
  );
}

