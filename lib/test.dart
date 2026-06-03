import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyListController extends GetxController {
  // 1. مفتاح للتحكم في AnimatedList من خلال الـ Controller
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  // 2. قائمة البيانات العادية (مراقبة بـ GetX)
  var items = <String>[].obs;

  // دالة لإضافة عنصر جديد
  void addItem() {
    int newIndex = items.length;
    // أ: إضافة العنصر لقائمة البيانات
    items.add("عنصر جديد رقم ${newIndex + 1}");

    // ب: إخبار الـ AnimatedList بتشغيل أنميشن الإضافة
    listKey.currentState?.insertItem(
      newIndex,
      duration: const Duration(milliseconds: 600), // مدة الأنميشن
    );
  }

  // دالة لحذف عنصر
  void removeItem(int index) {
    if (index >= 0 && index < items.length) {
      // حفظ العنصر قبل حذفه لعرضه أثناء أنميشن الاختفاء
      // final removedItem = items[index];

      // أ: تشغيل أنميشن الحذف في الـ AnimatedList أولاً
      listKey.currentState?.removeItem(
        index,
        (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.red[100],
            child: ListTile(
              title: Text("Hossam هو الوحش"), // يمكنك عرض removedItem هنا إذا أردت
              trailing: const Icon(
                Icons.delete,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
        ),
        duration: const Duration(milliseconds: 500),
      );

      // ب: حذف العنصر فعلياً من قائمة البيانات
      items.removeAt(index);
    }
  }

  // دالة مساعدة لبناء شكل العنصر أثناء الاختفاء (تأثير الحذف)
}

// استيراد الـ Controller

class MyAnimatedList extends StatelessWidget {
  // استدعاء الـ Controller
  final MyListController controller = Get.put(MyListController());

  MyAnimatedList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(20),
          ),
          menuPadding: EdgeInsets.all(20),
          popUpAnimationStyle: AnimationStyle(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 500),
          ),
          onOpened: () {
            print("Hossam");
          },
          color: Colors.amber,
          elevation: 1,

          borderRadius: BorderRadius.circular(30),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: Text("Go to Aim"),
              onTap: () {
                print("Hosssam is the beast");
              },
            ),
            PopupMenuItem(child: Text("data")),
            PopupMenuItem(child: Text("data")),
          ],
        ),
        title: const Text("AnimatedList مع GetX ودمج الحركات"),
        backgroundColor: Colors.indigo,
      ),
      body: AnimatedList(
        // ربط المفتاح الموجود في الـ Controller بهذه القائمة
        key: controller.listKey,
        initialItemCount: controller.items.length,
        itemBuilder: (context, index, animation) {
          // بناء العنصر مع تأثير حركي مزدوج
          return ScaleTransition(
            scale: animation, // الحركة الأولى: التلاشي (0 -> 1)
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1), // الدخول من اليمين (1 -> 0)
                end: Offset.zero,
              ).animate(animation), // الحركة الثانية: الانزلاق
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.indigo[100],
                child: ListTile(
                  title: Text(controller.items[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        controller.removeItem(index), // استدعاء دالة الحذف
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addItem, // استدعاء دالة الإضافة
        child: const Icon(Icons.add),
      ),
    );
  }

  // دالة مساعدة لبناء شكل العنصر (تأثير الإضافة والعرض العادي)
  // Widget _buildItem(String title, Animation<double> animation, int index) {
  //   // دمج حركتين: FadeTransition و SlideTransition
  //   return FadeTransition(
  //     opacity: animation, // الحركة الأولى: التلاشي (0 -> 1)
  //     child: SlideTransition(
  //       position: Tween<Offset>(
  //         begin: const Offset(1, 0), // الدخول من اليمين (1 -> 0)
  //         end: Offset.zero,
  //       ).animate(animation), // الحركة الثانية: الانزلاق
  //       child: Card(
  //         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
  //         color: Colors.indigo[100],
  //         child: ListTile(
  //           title: Text(title),
  //           trailing: IconButton(
  //             icon: const Icon(Icons.delete, color: Colors.red),
  //             onPressed: () =>
  //                 controller.removeItem(index), // استدعاء دالة الحذف
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
