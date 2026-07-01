import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

/// ==================================================
///                 PROFILE CONTROLLER
/// ==================================================
class ProfileController extends GetxController {
  // ----- الحقول القابلة للمراقبة (Observables) ----
  Myservisec myservisec = Get.find<Myservisec>();

  String get username =>
      myservisec.sharedPreferences.getString("usersname") ?? "";
  var email = "hossam.yasser@example.com".obs;
  var phone = "01012345678".obs;
  var address = "المنصورة، الدقهلية".obs;
  var imagePath = "${Imageasset.twetter}".obs;

  // حالة التحميل أثناء الحفظ / اختيار الصورة
  var isSaving = false.obs;
  var isPickingImage = false.obs;

  final ImagePicker _picker = ImagePicker();

  /// اختيار صورة من المعرض أو الكاميرا
  Future<void> pickImage({required bool fromCamera}) async {
    try {
      isPickingImage.value = true;
      final XFile? pickedFile = await _picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        imagePath.value = pickedFile.path;
        Get.snackbar(
          "نجاح",
          "تم تحديث الصورة الشخصية",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800,
          margin: const EdgeInsets.all(14),
          borderRadius: 14,
          icon: const Icon(Icons.check_circle, color: Colors.green),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        "خطأ",
        "تعذر اختيار الصورة، حاول مرة أخرى",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
        margin: const EdgeInsets.all(14),
        borderRadius: 14,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
    } finally {
      isPickingImage.value = false;
    }
  }

  /// حفظ التعديلات (مع محاكاة اتصال بالسيرفر)
  Future<void> saveProfile({
    required String newName,
    required String newEmail,
    required String newPhone,
    required String newAddress,
  }) async {
    isSaving.value = true;
    try {
      // محاكاة زمن استجابة API — استبدلها بالنداء الفعلي للـ backend
      await Future.delayed(const Duration(milliseconds: 900));

      // username.value = newName.trim();
      // email.value = newEmail.trim();
      // phone.value = newPhone.trim();
      // address.value = newAddress.trim();

      Get.back();
      Get.snackbar(
        "تم الحفظ",
        "تم تحديث بياناتك بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        margin: const EdgeInsets.all(14),
        borderRadius: 14,
        icon: const Icon(Icons.check_circle, color: Colors.green),
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
  static const primaryDark = Color(0xFF0039CB);
  static const bg = Color(0xFFF6F7FB);
  static const label = Color(0xFF6B7280);
  static const danger = Color(0xFFE53935);
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

  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: controller.username);
    _emailCtrl = TextEditingController(text: controller.email.value);
    _phoneCtrl = TextEditingController(text: controller.phone.value);
    _addressCtrl = TextEditingController(text: controller.address.value);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  void _showImageSourceSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "تحديث الصورة الشخصية",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _sourceOption(
                  icon: Icons.photo_camera_outlined,
                  label: "الكاميرا",
                  onTap: () {
                    Get.back();
                    controller.pickImage(fromCamera: true);
                  },
                ),
                _sourceOption(
                  icon: Icons.photo_library_outlined,
                  label: "المعرض",
                  onTap: () {
                    Get.back();
                    controller.pickImage(fromCamera: false);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _EPColors.bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Icon(icon, color: _EPColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarbackicon(title: "Edit profile", herotag: ""),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAvatarSection(),
                const SizedBox(height: 32),
                _sectionCard(
                  title: "البيانات الشخصية",
                  icon: Icons.person_outline,
                  children: [
                    _buildField(
                      controller: _nameCtrl,
                      label: "الاسم الكامل",
                      hint: "أدخل اسمك بالكامل",
                      icon: Icons.badge_outlined,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "الاسم مطلوب";
                        }
                        if (v.trim().length < 3) {
                          return "الاسم قصير جدًا";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _emailCtrl,
                      label: "البريد الإلكتروني",
                      hint: "example@email.com",
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "البريد الإلكتروني مطلوب";
                        }
                        final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                        if (!regex.hasMatch(v.trim())) {
                          return "صيغة البريد غير صحيحة";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _phoneCtrl,
                      label: "رقم الهاتف",
                      hint: "01xxxxxxxxx",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      textDirection: TextDirection.ltr,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "رقم الهاتف مطلوب";
                        }
                        if (v.trim().length != 11) {
                          return "رقم الهاتف يجب أن يكون 11 رقمًا";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _sectionCard(
                  title: "عنوان الشحن",
                  icon: Icons.location_on_outlined,
                  children: [
                    _buildField(
                      controller: _addressCtrl,
                      label: "العنوان",
                      hint: "المدينة، الحي، الشارع",
                      icon: Icons.home_outlined,
                      maxLines: 2,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return "العنوان مطلوب لعمليات التوصيل";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSaveButton(),
                const SizedBox(height: 12),
                _buildCancelButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Avatar ----------------
  Widget _buildAvatarSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [_EPColors.primary, _EPColors.primaryDark],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _EPColors.primary.withOpacity(0.25),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Obx(() {
                  final path = controller.imagePath.value;
                  ImageProvider provider;
                  if (path.isNotEmpty &&
                      !path.startsWith('http') &&
                      File(path).existsSync()) {
                    provider = FileImage(File(path));
                  } else if (path.startsWith('http')) {
                    provider = NetworkImage(path);
                  } else {
                    provider = AssetImage(path);
                  }
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 62,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: provider,
                      ),
                      if (controller.isPickingImage.value)
                        Container(
                          width: 124,
                          height: 124,
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                            shape: BoxShape.circle,
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ),
                    ],
                  );
                }),
              ),
              Positioned(
                bottom: -2,
                left: 0,
                child: GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: _EPColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
              controller.username,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 4),
          Text(
            "عضو في المتجر منذ ٢٠٢٤",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  // ---------------- Section Card ----------------
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: _EPColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  // ---------------- Text Field ----------------
  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    TextDirection? textDirection,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _EPColors.label,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textDirection: textDirection,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
            errorStyle: const TextStyle(color: _EPColors.danger, fontSize: 12),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: _EPColors.primary,
                width: 1.4,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _EPColors.danger, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: _EPColors.danger, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------- Save Button ----------------
  Widget _buildSaveButton() {
    return Obx(
      () => SizedBox(
        height: 54,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _EPColors.primary,
            disabledBackgroundColor: _EPColors.primary.withOpacity(0.6),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: controller.isSaving.value
              ? null
              : () {
                  if (_formKey.currentState?.validate() ?? false) {
                    controller.saveProfile(
                      newName: _nameCtrl.text,
                      newEmail: _emailCtrl.text,
                      newPhone: _phoneCtrl.text,
                      newAddress: _addressCtrl.text,
                    );
                  }
                },
          child: controller.isSaving.value
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                )
              : const Text(
                  "حفظ التغييرات",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // ---------------- Cancel Button ----------------
  Widget _buildCancelButton() {
    return SizedBox(
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => Get.back(),
        child: Text(
          "إلغاء",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
      ),
    );
  }
}
