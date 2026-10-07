import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

/// ==================================================
///                 PROFILE CONTROLLER
/// ==================================================
class ProfileController extends GetxController {
  final Myservisec myservisec = Get.find<Myservisec>();

  String get username =>
      myservisec.sharedPreferences.getString("usersname") ?? "";

  var gender = ''.obs; // 'male' | 'female' | ''
  var birthday = Rxn<DateTime>();
  var nationality = ''.obs;
  var phone = ''.obs;
  var isPhoneVerified = false.obs;
  var isSaving = false.obs;

  final List<String> topNationalities = const [
    'Egypt',
    'Sudan',
    'Saudi Arabia',
    'Syrian Arab Republic',
  ];

  final List<String> allNationalities = const [
    'Egypt',
    'Sudan',
    'Saudi Arabia',
    'Syrian Arab Republic',
    'Jordan',
    'Lebanon',
    'Iraq',
    'Yemen',
    'Libya',
    'Morocco',
    'Algeria',
    'Tunisia',
    'United Arab Emirates',
    'Kuwait',
    'Qatar',
    'Palestine',
  ];

  /// نسبة اكتمال الملف الشخصي
  int completion(String first, String last) {
    int done = 0;
    if (first.trim().isNotEmpty) done++;
    if (last.trim().isNotEmpty) done++;
    if (isPhoneVerified.value) done++;
    if (gender.value.isNotEmpty) done++;
    if (birthday.value != null) done++;
    if (nationality.value.isNotEmpty) done++;
    return (done / 6 * 100).round();
  }

  Future<void> saveProfile({
    required String firstName,
    required String lastName,
  }) async {
    isSaving.value = true;
    try {
      // TODO: استبدلها بالنداء الفعلي للـ backend
      await Future.delayed(const Duration(milliseconds: 900));
      Get.back();
      Get.snackbar(
        "Saved",
        "Your profile has been updated",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(14),
      );
    } finally {
      isSaving.value = false;
    }
  }
}

/// ==================================================
///                    UI THEME
/// ==================================================
class _EPColors {
  static const primary = Color(0xFF2962FF);
  static const border = Color(0xFFE5E7EB);
  static const title = Color(0xFF111827);
  static const subtitle = Color(0xFF6B7280);
}

/// ==================================================
///                 EDIT PROFILE VIEW
/// ==================================================
class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final ProfileController controller = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;

  @override
  void initState() {
    super.initState();
    final parts = controller.username.trim().split(' ');
    _firstCtrl = TextEditingController(text: parts.first);
    _lastCtrl = TextEditingController(
      text: parts.length > 1 ? parts.sublist(1).join(' ') : '',
    );
    _firstCtrl.addListener(() => setState(() {}));
    _lastCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    super.dispose();
  }

  // bool get _canSave =>
  //     _firstCtrl.text.trim().isNotEmpty && _lastCtrl.text.trim().isNotEmpty;

  // ---------------- Actions ----------------
  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: controller.birthday.value ?? DateTime(now.year - 20),
      firstDate: DateTime(1940),
      lastDate: now,
    );
    if (picked != null) controller.birthday.value = picked;
  }

  void _showAllNationalities() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.7),
        decoration: const BoxDecoration(
          color: Color(0xFFE0E3E8),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            for (final c in controller.allNationalities)
              ListTile(
                title: Text(c, style: TextStyle(color: Colors.black)),
                trailing: Obx(
                  () => controller.nationality.value == c
                      ? const Icon(Icons.check, color: Colors.black)
                      : const SizedBox.shrink(),
                ),
                onTap: () {
                  controller.nationality.value = c;
                  Get.back();
                },
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- Build ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarbackicon(title: "Your Profile", herotag: "herotag"),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameRow(),
                      const SizedBox(height: 28),
                      _buildGenderSection(),
                      const SizedBox(height: 28),
                      _buildBirthdaySection(),
                      const SizedBox(height: 28),
                      _buildNationalitySection(),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ---------------- Sections ----------------
  Widget _sectionHeader(String title, {String? subtitle, Widget? trailing}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _EPColors.subtitle,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _outlinedBox({required Widget child, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: _EPColors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }

  // First name / Last name
  Widget _buildNameRow() {
    return Row(
      children: [Expanded(child: _nameField(_firstCtrl, "First name*"))],
    );
  }

  Widget _nameField(TextEditingController c, String label) {
    return TextFormField(
      controller: c,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: _EPColors.subtitle, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _EPColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _EPColors.primary, width: 1.4),
        ),
      ),
    );
  }

  // Phone number

  // Gender
  Widget _buildGenderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader("Gender"),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(child: _genderTile("male", "Male", Icons.male)),
            const SizedBox(width: 12),
            Expanded(child: _genderTile("female", "Female", Icons.female)),
          ],
        ),
      ],
    );
  }

  Widget _genderTile(String value, String label, IconData icon) {
    return Obx(() {
      final selected = controller.gender.value == value;
      return InkWell(
        onTap: () => controller.gender.value = value,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? _EPColors.primary : _EPColors.border,
              width: selected ? 1.4 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: _EPColors.subtitle),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label, style: const TextStyle(fontSize: 14)),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                size: 22,
                color: selected ? _EPColors.primary : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      );
    });
  }

  // Birthday
  Widget _buildBirthdaySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          "Birthday",
          subtitle: "Exclusive offers for you on your special day",
        ),
        const SizedBox(height: 14),
        Obx(() {
          final d = controller.birthday.value;
          return _outlinedBox(
            onTap: _pickBirthday,
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: _EPColors.subtitle,
                ),
                const SizedBox(width: 10),
                Text(
                  d == null
                      ? "Add your birthday"
                      : "${d.day.toString().padLeft(2, '0')}/"
                            "${d.month.toString().padLeft(2, '0')}/${d.year}",
                  style: TextStyle(
                    fontSize: 14,
                    color: d == null ? _EPColors.subtitle : _EPColors.title,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Nationality
  Widget _buildNationalitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          "Nationality",
          subtitle: "Help us curate your catalogue",
          trailing: GestureDetector(
            onTap: _showAllNationalities,
            child: const Text(
              "View all",
              style: TextStyle(
                color: _EPColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Obx(
          () => Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final c in controller.topNationalities)
                ChoiceChip(
                  label: Text(c),
                  selected: controller.nationality.value == c,
                  onSelected: (_) => controller.nationality.value = c,
                  selectedColor: _EPColors.primary.withOpacity(0.12),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: controller.nationality.value == c
                        ? _EPColors.primary
                        : _EPColors.border,
                  ),
                  labelStyle: TextStyle(
                    fontSize: 13,
                    color: controller.nationality.value == c
                        ? _EPColors.primary
                        : _EPColors.title,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------- Bottom bar ----------------
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),

      child: SizedBox(
        width: double.infinity,
        child: Checkbutton(onTap: () {}, buttonName: "Save"),
      ),
    );
  }
}
