import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/searchclass.dart';
import 'package:hos/core/conistant/linkApi.dart';
import 'package:hos/veiw/wedget/items/itemsappbar.dart';
import 'package:hos/veiw/wedget/searchbar.dart';

// ignore: must_be_immutable
class Searchpage extends StatelessWidget {
  Searchpage({super.key});

  final controller = Get.put(SearchMix());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Searchbar(
          focusNode: controller.focusNode,
          textInputAction: controller.textInputAction,
          onPressedIcon: () {
            // 👈 لما يدوس بحث، بنضيف الكلمة للسجل وننفذ البحث
            controller.addToRecentSearches(controller.search!.text);
            controller.onsearch();
          },
          onChanged: controller.checksearch,
          title: "Search products...".tr,
          mycontroller: controller.search!,
        ),
        leading: Hero(tag: "Search", child: BackButtonCircle()),
      ),
      body: GetBuilder<SearchMix>(
        builder: (controller) {
          // ==========================================
          // 1. حالة شريط البحث فاضي (عرض سجل البحث)
          // ==========================================
          if (controller.search!.text.isEmpty) {
            if (controller.recentSearches.isEmpty) {
              return Center(
                child: Text(
                  "Type to search...".tr,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Searches".tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          controller.clearRecentSearches();
                        },
                        child: Text(
                          "Clear All".tr,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(controller.recentSearches.length, (
                      index,
                    ) {
                      return ActionChip(
                        label: Text(
                          controller.recentSearches[index],
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade100,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onPressed: () {
                          // لما يضغط على كلمة قديمة، بنحطها في شريط البحث ونشغل الفانكشن
                          controller.search!.text =
                              controller.recentSearches[index];
                          controller.addToRecentSearches(
                            controller.recentSearches[index],
                          );
                          controller.onsearch();
                        },
                      );
                    }),
                  ),
                ],
              ),
            );
          }

          // ==========================================
          // 2. حالة عرض نتائج البحث (الـ ListView)
          // ==========================================
          return ListView.builder(
            // 👈 شيلت الـ NeverScrollable عشان اليوزر يقدر يعمل سكرول لو النتايج كتير
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 10, bottom: 20),
            itemCount: controller.searchlist.length,
            itemBuilder: (context, i) {
              final item = controller.searchlist[i];
              return InkWell(
                onTap: () {
                  controller.gotoitemsdatails(item);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ), // إطار خفيف بدل الـ Card العادي
                  ),
                  child: Row(
                    children: [
                      // 🖼️ صورة المنتج
                      Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "${LinkApi.imageitems}/${item.itemsImage}",
                            fit: BoxFit
                                .contain, // contain أحسن عشان الصورة متتقصش
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      // 📝 تفاصيل المنتج
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.itemsName ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${item.itemsPrice} ${"EGP".tr}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // أيقونة سهم صغير شيك في الآخر
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
