import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:hos/core/conistant/locationdata.dart';
import 'package:hos/core/class/crud.dart';
import 'package:hos/veiw/wedget/auth/Textfealdauth.dart';
import 'package:hos/veiw/wedget/auth/checkbutton.dart';
import 'package:latlong2/latlong.dart';

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

// ignore: must_be_immutable
class Addresspage<T extends GetxController> extends StatefulWidget {
  final T controller;
  TextEditingController? details;
  String? selectedGovernorate;
  String? selectedCity;
  String? selectedLocationType;
  Statusrequest statusrequest;
  void Function() onTap;
  ValueChanged<String?>? onChanged;
  ValueChanged<String?>? onChangedcity;
  ValueChanged<String?>? onChangedtype;
  MapController map;
  List<String> locationTypes;
  Size size;
  Future<LatLng?> Function() currentlocation;
  Addresspage({
    super.key,
    required this.controller,
    required this.details,
    this.selectedGovernorate,
    this.selectedCity,
    required this.statusrequest,
    required this.onTap,
    required this.size,
    this.onChanged,
    this.onChangedcity,
    required this.selectedLocationType,
    required this.locationTypes,
    this.onChangedtype,
    required this.map,
    required this.currentlocation,
  });

  @override
  State<Addresspage<T>> createState() => _AddresspageState<T>();
}

class _AddresspageState<T extends GetxController> extends State<Addresspage<T>>
    with SingleTickerProviderStateMixin {
  LatLng? selectedPoint;
  LatLng? displayedPoint;
  late AnimationController _animController;
  LatLngTween? _tween;
  late final MapOptions _mapOptions; // ✅ instance ثابتة
  bool _isLocating = false; // ✅ حالة التحميل

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

    // ✅ تتعمل مرة واحدة بس، مش هتتغير كل rebuild
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

  Future<void> _handleTap(TapPosition tapPosition, LatLng point) async {
    // ✅ تحقق من الـ bounds قبل أي حركة
    if (!_egyptBounds.contains(point)) return;

    setState(() => selectedPoint = point);
    _animateMarkerTo(point);
    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        widget.onChanged?.call(place.administrativeArea);
        widget.onChangedcity?.call(place.locality);
      }
    } catch (_) {}
  }

  Future<void> _handleCurrentLocation() async {
    if (_isLocating) return; // منع الضغط المتكرر أثناء التحميل

    setState(() => _isLocating = true);

    final point = await widget.currentlocation();

    if (!mounted) return; // احتياط لو الـ widget اتشال أثناء الانتظار

    if (point == null) {
      setState(() => _isLocating = false);
      return;
    }

    setState(() => selectedPoint = point);
    _animateMarkerTo(point);

    try {
      final placemarks = await geocoding.placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        widget.onChanged?.call(place.administrativeArea);
        widget.onChangedcity?.call(place.locality);
      }
    } catch (_) {}

    if (mounted) setState(() => _isLocating = false);
  }

  void _openDetailsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LocationDetailsSheet<T>(
        controller: widget.controller,
        details: widget.details,
        selectedGovernorate: widget.selectedGovernorate,
        selectedCity: widget.selectedCity,
        selectedLocationType: widget.selectedLocationType,
        statusrequest: widget.statusrequest,
        onTap: widget.onTap,
        size: widget.size,
        onChanged: widget.onChanged,
        onChangedcity: widget.onChangedcity,
        onChangedtype: widget.onChangedtype,
        locationTypes: widget.locationTypes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: widget.map,
          options: _mapOptions, // ✅ نفس الـ instance كل مرة
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
                    width: 46,
                    height: 46,
                    alignment: Alignment.topCenter,
                    child: const _SelectedLocationPin(),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          top: 16,
          right: 16,
          child: SafeArea(
            child: GestureDetector(
              onTap: _handleCurrentLocation,
              child: Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: _isLocating
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Icon(Icons.gps_fixed, color: Colors.white),
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          left: 20,
          right: 20,
          bottom: selectedPoint != null ? 24 : -80,
          child: SafeArea(
            top: false,
            child: _AddDetailsButton(onTap: _openDetailsSheet),
          ),
        ),
      ],
    );
  }
}

class _SelectedLocationPin extends StatelessWidget {
  const _SelectedLocationPin();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_on,
      color: Colors.redAccent,
      size: 46,
      shadows: [
        Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
      ],
    );
  }
}

class _AddDetailsButton extends StatelessWidget {
  final void Function() onTap;

  const _AddDetailsButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_location_alt, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'إضافة تفاصيل للموقع',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationDetailsSheet<T extends GetxController> extends StatelessWidget {
  final T controller;
  final TextEditingController? details;
  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedLocationType;
  final Statusrequest statusrequest;
  final void Function() onTap;
  final Size size;
  final ValueChanged<String?>? onChanged;
  final ValueChanged<String?>? onChangedcity;
  final ValueChanged<String?>? onChangedtype;
  final List<String> locationTypes;

  const _LocationDetailsSheet({
    super.key,
    required this.controller,
    required this.details,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedLocationType,
    required this.statusrequest,
    required this.onTap,
    required this.size,
    required this.onChanged,
    required this.onChangedcity,
    required this.onChangedtype,
    required this.locationTypes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.75),
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? const Color(0xFF232429).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'نوع المكان',
                        prefixIcon: Icon(Icons.place),
                      ),
                      value: selectedLocationType,
                      items: locationTypes
                          .map(
                            (String type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: onChangedtype,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                            items: (f, cs) =>
                                EgyptLocations.governorates.keys.toList(),
                            selectedItem: selectedGovernorate,
                            onChanged: onChanged,
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(
                                labelText: 'المحافظة',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownSearch<String>(
                            items: (f, cs) => selectedGovernorate == null
                                ? []
                                : (EgyptLocations
                                          .governorates[selectedGovernorate] ??
                                      []),
                            selectedItem: selectedCity,
                            onChanged: onChangedcity,
                            decoratorProps: const DropDownDecoratorProps(
                              decoration: InputDecoration(labelText: 'المركز'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Textfealdauth(
                        obscureText: false,
                        suffixIcon: Icons.location_on,
                        hint: 'تفاصيل المكان',
                        textEditingController: details!,
                        valid: (val) => null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GetBuilder<T>(
                      builder: (controller) => Checkbutton(
                        statusrequest: statusrequest,
                        buttonColor: Colors.black,
                        width: size.width,
                        onTap: () {
                          Navigator.of(context).pop();
                          onTap();
                        },
                        buttonName: "Save location",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
