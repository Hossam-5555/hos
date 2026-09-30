import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:latlong2/latlong.dart';

// استيراد الملفات الخاصة بمشروعك
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/conistant/locationdata.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';

// ==========================================
// 0. مقياس الأبعاد (Responsive)
// ==========================================
// التصميم الأساسي على عرض 390، والمعامل محصور بين 0.85 و 1.2
const double _kDesignWidth = 390;
const double _kSheetMaxWidth = 600;

double _scaleOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return (width / _kDesignWidth).clamp(0.85, 1.2).toDouble();
}

// ==========================================
// 1. كلاس التحريك للـ Marker
// ==========================================
class LatLngTween extends Tween<LatLng> {
  LatLngTween({required LatLng begin, required LatLng end})
    : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    return LatLng(
      lerpDouble(begin!.latitude, end!.latitude, t)!,
      lerpDouble(begin!.longitude, end!.longitude, t)!,
    );
  }
}

// ==========================================
// 2. الصفحة الرئيسية (الصفحة + الخريطة في كلاس واحد)
// ==========================================
class AddNewAddres extends StatefulWidget {
  const AddNewAddres({super.key});

  @override
  State<AddNewAddres> createState() => _AddNewAddresState();
}

class _AddNewAddresState extends State<AddNewAddres>
    with SingleTickerProviderStateMixin {
  // الكنترولر مباشرة بدون تمريره كـ parameters
  final AddressController c = Get.put(AddressController());

  LatLng? selectedPoint;
  LatLng? displayedPoint;
  late AnimationController _animController;
  LatLngTween? _tween;
  late final MapOptions _mapOptions;
  bool _isLocating = false;

  static final LatLngBounds _egyptBounds = LatLngBounds(
    const LatLng(22.0, 25.0),
    const LatLng(31.7, 36.0),
  );

  @override
  void initState() {
    super.initState();
    _animController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 350),
        )..addListener(() {
          if (_tween != null) {
            setState(() => displayedPoint = _tween!.evaluate(_animController));
          }
        });

    _mapOptions = MapOptions(
      initialCenter: const LatLng(26.8206, 30.8025),
      initialZoom: 6.0,
      onTap: _handleTap,
      minZoom: 3.0,
      maxZoom: 18.0,
      initialRotation: 0,
      cameraConstraint: CameraConstraint.contain(bounds: _egyptBounds),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateMarkerTo(LatLng point) {
    final start = displayedPoint ?? point;
    _tween = LatLngTween(begin: start, end: point);
    _animController.forward(from: 0);
  }

  // تحديد المحافظة والمركز من إحداثيات النقطة
  Future<void> _fillLocationFrom(LatLng point) async {
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        c.onGovernorateChanged(place.administrativeArea);
        c.onCityChanged(place.locality);
      }
    } catch (_) {}
  }

  Future<void> _handleTap(TapPosition tapPosition, LatLng point) async {
    if (!_egyptBounds.contains(point)) return;

    setState(() => selectedPoint = point);
    _animateMarkerTo(point);
    await _fillLocationFrom(point);
  }

  Future<void> _handleCurrentLocation() async {
    if (_isLocating) return;

    setState(() => _isLocating = true);

    final point = await c.getcurrentlocation();

    if (!mounted) return;

    if (point == null) {
      setState(() => _isLocating = false);
      return;
    }

    setState(() => selectedPoint = point);
    _animateMarkerTo(point);
    await _fillLocationFrom(point);

    if (mounted) setState(() => _isLocating = false);
  }

  void _openDetailsSheet() {
    // لو الشيت اتفتح تاني بعد نجاح سابق، نرجع للفورم مش لشاشة النجاح
    c.isuccess.value = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      constraints: const BoxConstraints(maxWidth: _kSheetMaxWidth),
      builder: (_) => const _LocationDetailsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _scaleOf(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final circleButton = math.max(48.0, 50 * s);
    final pinSize = 46 * s;
    final detailsButtonHeight = 56 * s;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          FlutterMap(
            mapController: c.map,
            options: _mapOptions,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.hos',
              ),
              if (displayedPoint != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: displayedPoint!,
                      width: pinSize,
                      height: pinSize,
                      alignment: Alignment.topCenter,
                      child: _SelectedLocationPin(size: pinSize),
                    ),
                  ],
                ),
            ],
          ),
          PositionedDirectional(
            top: 16 * s,
            end: 16 * s,
            child: SafeArea(
              child: GestureDetector(
                onTap: _handleCurrentLocation,
                child: Container(
                  height: circleButton,
                  width: circleButton,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: _isLocating
                      ? Padding(
                          padding: EdgeInsets.all(12 * s),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Icon(
                          Icons.gps_fixed,
                          color: Colors.white,
                          size: 24 * s,
                        ),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            top: 16 * s,
            start: 16 * s,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 10.0 * s),
                child: Center(
                  child: Container(
                    width: circleButton,
                    height: circleButton,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE0E3E8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_sharp,
                          color: Colors.black,
                        ),
                        iconSize: 20 * s,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            left: 20 * s,
            right: 20 * s,
            // وهو مخفي نزوّده بقيمة الـ safe area والظل عشان ميظهرش جزء منه
            bottom: selectedPoint != null
                ? 24 * s
                : -(detailsButtonHeight + bottomInset + 24 * s),
            child: SafeArea(
              top: false,
              child: _AddDetailsButton(onTap: _openDetailsSheet, scale: s),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 3. عناصر واجهة المستخدم الفرعية
// ==========================================
class _SelectedLocationPin extends StatelessWidget {
  final double size;

  const _SelectedLocationPin({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.location_on,
      color: Colors.redAccent,
      size: size,
      shadows: const [
        Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }
}

class _AddDetailsButton extends StatelessWidget {
  final void Function() onTap;
  final double scale;

  const _AddDetailsButton({required this.onTap, required this.scale});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16 * scale);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 56 * scale,
          padding: EdgeInsets.symmetric(horizontal: 12 * scale),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_location_alt,
                color: Colors.white,
                size: 24 * scale,
              ),
              SizedBox(width: 8 * scale),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Add New Address',
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. الـ BottomSheet (متصل بالكنترولر مباشرة)
// ==========================================
class _LocationDetailsSheet extends StatelessWidget {
  const _LocationDetailsSheet();

  AddressController get c => Get.find<AddressController>();

  // عرض المحتوى الفعلي داخل الشيت (بعد الـ padding)
  double _contentWidth(BuildContext context, double s) {
    final sheetWidth = math.min(
      MediaQuery.sizeOf(context).width,
      _kSheetMaxWidth,
    );
    return sheetWidth - (2 * 20 * s);
  }

  @override
  Widget build(BuildContext context) {
    final s = _scaleOf(context);
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;

    // أقصى ارتفاع: 75% من الشاشة، بس مايتعداش المساحة المتاحة فوق الكيبورد
    final availableHeight =
        screenHeight - media.viewInsets.bottom - media.padding.top;
    final maxSheetHeight = math.min(screenHeight * 0.75, availableHeight);

    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24 * s)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(maxHeight: maxSheetHeight),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF232429).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24 * s)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20 * s),
                // أي update() في الكنترولر بيعيد بناء الشيت بالقيم الجديدة
                child: GetBuilder<AddressController>(
                  builder: (_) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40 * s,
                            height: 4 * s,
                            margin: EdgeInsets.only(bottom: 16 * s),
                            decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        // أول ما isuccess تبقى true الفورم يختفي بـ fade
                        // وحجم الشيت يتغير بسلاسة لشاشة النجاح
                        Obx(
                          () => AnimatedCrossFade(
                            duration: const Duration(milliseconds: 400),
                            sizeCurve: Curves.easeInOut,
                            firstCurve: Curves.easeOut,
                            secondCurve: Curves.easeIn,
                            crossFadeState: c.isuccess.value
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: _buildFormContent(context),
                            secondChild: _buildSuccessContent(context),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 1. واجهة كتابة البيانات
  Widget _buildFormContent(BuildContext context) {
  final s = _scaleOf(context);
  final contentWidth = _contentWidth(context, s);

  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(5 * s),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20 * s),
    
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black.withOpacity(0.05),
      //     blurRadius: 20,
      //     offset: const Offset(0, 6),
      //   ),
      // ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =========================
        // Header
        // =========================
        Row(
          children: [
            Container(
              width: 48 * s,
              height: 48 * s,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14 * s),
              ),
              child: Icon(
                Icons.location_on_rounded,
                color: Colors.white,
                size: 25 * s,
              ),
            ),

            SizedBox(width: 12 * s),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إضافة عنوان جديد',
                    style: TextStyle(
                      fontSize: 18 * s,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  SizedBox(height: 4 * s),

                  Text(
                    'أدخل تفاصيل العنوان لتسهيل توصيل طلباتك',
                    style: TextStyle(
                      fontSize: 12.5 * s,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 22 * s),

        // =========================
        // Location section
        // =========================
        Text(
          'معلومات الموقع',
          style: TextStyle(
            fontSize: 14 * s,
            fontWeight: FontWeight.w700,
          ),
        ),

        SizedBox(height: 10 * s),

        DropdownSearch<String>(
          items: (f, cs) => EgyptLocations.governorates.keys.toList(),
          selectedItem: c.selectedGovernorate,
          onChanged: c.onGovernorateChanged,
          decoratorProps: DropDownDecoratorProps(
            decoration: InputDecoration(
              filled: true,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * s),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * s),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12 * s),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.2,
                ),
              ),
              labelText: 'المحافظة' ,
              prefixIcon: const Icon(Icons.map_outlined),
            ),
          ),
        ),

        SizedBox(height: 12 * s),

        Row(
          children: [
            // نوع المكان
            Expanded(
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  filled: true,alignLabelWithHint: false,
                  labelText: 'نوع المكان',
                  prefixIcon: const Icon(Icons.place_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12 * s),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12 * s),
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                ),
                value: c.selectedLocationType,
                items: c.locationTypes
                    .map(
                      (String type) => DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: c.onLocationTypeChanged,
              ),
            ),

            SizedBox(width: 10 * s),

            // المركز
            Expanded(
              child: DropdownSearch<String>(
                items: (f, cs) => c.selectedGovernorate == null
                    ? []
                    : (EgyptLocations
                            .governorates[c.selectedGovernorate] ??
                        []),
                selectedItem: c.selectedCity,
                onChanged: c.onCityChanged,
                decoratorProps: DropDownDecoratorProps(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'المركز',
                    prefixIcon: const Icon(Icons.location_city_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12 * s),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12 * s),
                      borderSide: BorderSide(
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 20 * s),

        // =========================
        // Address details
        // =========================
        Text(
          'تفاصيل العنوان',
          style: TextStyle(
            fontSize: 14 * s,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),

        SizedBox(height: 10 * s),

        Textfealdauth(
          obscureText: false,
          suffixIcon: Icons.location_on_outlined,
          hint: 'الشارع، رقم المبنى، الدور، الشقة...',
          textEditingController: c.street!,
          valid: (val) => null,
        ),

        SizedBox(height: 12 * s),

        Textfealdauth.phone(
          phone: true,
          obscureText: false,
          suffixIcon: Icons.phone_outlined,
          hint: 'رقم الهاتف',
          textEditingController: c.phone!,
          valid: (val) => null,
        ),

        SizedBox(height: 20 * s),

        // =========================
        // Save button
        // =========================
        Checkbutton(
          statusrequest: c.statusrequest ?? Statusrequest.none,
          buttonColor: Colors.black,
          width: contentWidth,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            c.addaddres(context);
          },
          buttonName: "Save location",
        ),
      ],
    ),
  );
}

  // 2. واجهة النجاح المباشرة
  Widget _buildSuccessContent(BuildContext context) {
    final s = _scaleOf(context);
    final contentWidth = _contentWidth(context, s);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 10 * s),
        // الأيقونة بتكبر بحركة بسيطة أول ما النجاح يظهر
        AnimatedScale(
          scale: c.isuccess.value ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          child: Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 70 * s,
          ),
        ),
        SizedBox(height: 14 * s),
        Text(
          "تم حفظ العنوان بنجاح!",
          style: TextStyle(fontSize: 18 * s, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 6 * s),
        Text(
          "تم تسجيل بيانات الموقع بنجاح في حسابك",
          style: TextStyle(fontSize: 13 * s, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24 * s),
        SizedBox(
          width: double.infinity,
          height: 48 * s,
          child: Checkbutton(
            statusrequest: Statusrequest.none,
            buttonColor: Colors.black,
            width: contentWidth,
            onTap: () {
              c.street?.clear();
              c.phone?.clear();
              c.isuccess.value = false;
            },
            buttonName: "New Address",
          ),
        ),
        SizedBox(height: 12 * s),
        SizedBox(
          width: double.infinity,
          height: 48 * s,
          child: Checkbutton(
            statusrequest: Statusrequest.none,
            buttonColor: Colors.grey.shade800,
            width: contentWidth,
            onTap: () {
              Navigator.pop(context);
            },
            buttonName: "Close & Back",
          ),
        ),
        SizedBox(height: 10 * s),
      ],
    );
  }
}
