import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/class/searchclass.dart';
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
        leading: Hero(tag: "Search", child: BackButtonCircle()),
      ),
      body: GetBuilder<SearchMix>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Searchbar(
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
                SizedBox(height: 20),
                controller.recentSearches.isEmpty &&
                        controller.search!.text.isEmpty
                    ? Center(child: Text("Type to search...".tr))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Recent Searches".tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            onTap: () {
                              controller.clearRecentSearches();
                            },
                            child: Text("Clear All".tr),
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
                        style: TextStyle(fontSize: 13),
                      ),
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

                Expanded(
                  child: ListView.builder(
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
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            border: Border.all(
                              color: Colors.grey.withAlpha(50),
                              strokeAlign: BorderSide.strokeAlignCenter,
                            ),
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
                                    "${item.itemsImage}",
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
                                        // fontSize: 16,
                                        // fontWeight: FontWeight.bold,
                                        // color: Colors.black87,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${item.itemsPrice} ${"EGP".tr}',
                                      style: TextStyle(
                                        // fontSize: 15,
                                        color: Colors.blue,
                                        // fontWeight: FontWeight.w700,
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
                  ),
                ),
              ],
            ),
          );
          // ==========================================
          // 2. حالة عرض نتائج البحث (الـ ListView)
          // ==========================================
        },
      ),
    );
  }
}


/*






*/