import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/viewcontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/functions/showdialoge.dart';
import 'package:hos/veiw/adminscreen/Home/categories/addcat.dart';
import 'package:hos/veiw/wedget/Admin/SheardCard.dart';

class ViewCategories extends StatelessWidget {
  const ViewCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الـ Controller في الـ Memory
    Get.put(ViewCatController());

    // final ThemeData theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(
          () => const Addcategories(),
          transition: Transition.cupertino,
        ),
        backgroundColor: Colors.transparent, // شفاف ليظهر التدرج
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Colors.cyanAccent.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Icon(
              Icons.add_moderator_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      body: GetBuilder<ViewCatController>(
        builder: (controller) {
          return HandlingDataView(
            mode: HandlingMode.fullScreen,
            mediaType: HandlingMediaType.animation,
            statusrequest: controller.statusrequest,
            widget: SafeArea(
              child: controller.catdata.isEmpty
                  ? Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // توسيط عمودي
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          // تحديد أبعاد ثابتة أو نسبة من الشاشة
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.width * 0.6,
                          child: SvgPicture.asset(
                            "${Imageasset.emptycart}",
                            fit: BoxFit
                                .contain, // لضمان احتواء الصورة داخل الحاوية دون قص
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "السلة فارغة تسوق الان ",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      itemCount: controller.catdata.length,
                      // تجاوب تلقائي مع جميع مقاسات الشاشات (Responsive)
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 0.78,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemBuilder: (context, index) {
                        final categoryItem = controller.catdata[index];
                        return CategoryCard(
                          onTap: () {
                            controller.gotoproducts(categoryItem);
                          },
                          name: controller.isarabic
                              ? categoryItem.nameAr
                              : categoryItem.name,
                          onEdit: () => controller.gotoeditpage(categoryItem),
                          onDelete: () {
                            AppCupertinoDialog.show(
                              title: "حذف المنتج",
                              message: "هل أنت متأكد من حذف المنتج؟",
                              onConfirm: () {
                                controller.delete(categoryItem.id!);
                              },
                            );
                          },
                          imageUrl: categoryItem.image!,
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }

  // دالة إظهار نافذة التأكيد منفصلة ومستقلة لتبسيط الـ build method
}

// ==========================================
// كارت القسم كـ Widget مستقل لتحسين الأداء (Highly Optimized Widget)
// ==========================================
// ignore: must_be_immutable
// class CategoryCard extends StatefulWidget {
//   final dynamic item;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;
//   final VoidCallback onTap;
//   final bool isarabic;

//   const CategoryCard({
//     super.key,
//     required this.item,
//     required this.onEdit,
//     required this.onDelete,
//     required this.onTap,
//     required this.isarabic,
//   });

//   @override
//   State<CategoryCard> createState() => _CategoryCardState();
// }

// class _CategoryCardState extends State<CategoryCard> {
//   bool _showActions = false;

//   void _hideActions() {
//     if (_showActions) {
//       setState(() => _showActions = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final categoryName = widget.isarabic
//         ? widget.item.nameAr ?? ""
//         : widget.item.name ?? "";

//     return GestureDetector(
//       onTap: () {
//         if (_showActions) {
//           _hideActions();
//         } else {
//           widget.onTap();
//         }
//       },
//       onLongPress: () {
//         setState(() => _showActions = true);
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 220),
//         curve: Curves.easeOutCubic,
//         transform: Matrix4.translationValues(
//           0,
//           _showActions ? -7 : 0,
//           0,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(
//                 _showActions ? 0.13 : 0.05,
//               ),
//               blurRadius: _showActions ? 20 : 14,
//               offset: Offset(0, _showActions ? 10 : 6),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20),
//           child: Stack(
//             fit: StackFit.expand,
//             children: [
//               // صورة القسم كخلفية للكارت بالكامل
//               CachedNetworkImage(
//                 imageUrl: widget.item.image ?? "",
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   color: const Color(0xffF4F6FA),
//                   child: const Center(
//                     child: SizedBox(
//                       width: 25,
//                       height: 25,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                       ),
//                     ),
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   color: const Color(0xffF4F6FA),
//                   child: const Icon(
//                     Icons.image_not_supported_rounded,
//                     color: Colors.grey,
//                     size: 30,
//                   ),
//                 ),
//               ),

//               // تدرج خفيف يجعل اسم القسم واضحاً فوق الصورة
//               const DecoratedBox(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       Colors.transparent,
//                       Colors.transparent,
//                       Color(0xCC000000),
//                     ],
//                     stops: [0.0, 0.48, 1.0],
//                   ),
//                 ),
//               ),

//               // اسم القسم في مكان أزرار التعديل والحذف
//               AnimatedPositioned(
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.easeOut,
//                 left: 10,
//                 right: 10,
//                 bottom: _showActions ? 58 : 12,
//                 child: AnimatedOpacity(
//                   duration: const Duration(milliseconds: 150),
//                   opacity: _showActions ? 0 : 1,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 9,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.32),
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.16),
//                       ),
//                     ),
//                     child: Text(
//                       categoryName,
//                       textAlign: TextAlign.center,
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               // الأزرار تظهر فقط بعد الضغط المطول
//               AnimatedPositioned(
//                 duration: const Duration(milliseconds: 220),
//                 curve: Curves.easeOutBack,
//                 left: 10,
//                 right: 10,
//                 bottom: _showActions ? 10 : -55,
//                 child: AnimatedOpacity(
//                   duration: const Duration(milliseconds: 150),
//                   opacity: _showActions ? 1 : 0,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: _buildActionButton(
//                           icon: Icons.edit_rounded,
//                           label: "تعديل",
//                           color: Colors.blueAccent,
//                           onTap: widget.onEdit,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: _buildActionButton(
//                           icon: Icons.delete_rounded,
//                           label: "حذف",
//                           color: Colors.redAccent,
//                           onTap: widget.onDelete,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               // زر إغلاق صغير بعد ظهور الخيارات
//               if (_showActions)
//                 Positioned(
//                   top: 8,
//                   right: 8,
//                   child: GestureDetector(
//                     onTap: _hideActions,
//                     child: Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: Colors.black.withOpacity(0.42),
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Colors.white.withOpacity(0.25),
//                         ),
//                       ),
//                       child: const Icon(
//                         Icons.close_rounded,
//                         color: Colors.white,
//                         size: 18,
//                       ),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildActionButton({
//     required IconData icon,
//     required String label,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: () {
//           onTap();
//           _hideActions();
//         },
//         borderRadius: BorderRadius.circular(14),
//         child: Container(
//           height: 42,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.94),
//             borderRadius: BorderRadius.circular(14),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.12),
//                 blurRadius: 7,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, color: color, size: 18),
//               const SizedBox(width: 6),
//               Text(
//                 label,
//                 style: TextStyle(
//                   color: color,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
