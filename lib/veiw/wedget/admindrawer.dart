import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/Homecontroller.dart';
import 'package:hos/core/class/gotoanypage.dart';
import 'package:hos/veiw/userscreen/screen/auth/login.dart';

// ignore: must_be_immutable
class AdminDrawer extends GetView<adminHomecontroller> {
   AdminDrawer({super.key});
Gotoanypagecalss go=Gotoanypagecalss();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =======================
          //      USER HEADER
          // =======================
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blueAccent),
            accountName: const Text("Admin Panel"),
            accountEmail: const Text("admin@example.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.admin_panel_settings,
                size: 35,
                color: Colors.blueAccent,
              ),
            ),
          ),

          // =======================
          //       MENU ITEMS
          // =======================
          _drawerItem(
            icon: Icons.dashboard_outlined,
            title: "Dashboard",
            onTap: () => Get.toNamed("/dashboard"),
          ),

          _drawerItem(
            icon: Icons.category_outlined,
            title: "Categories",
            onTap: () => Get.toNamed("/categories"),
          ),

          _drawerItem(
            icon: Icons.shopping_bag_outlined,
            title: "Products",
            onTap: () => Get.toNamed("/products"),
          ),

          _drawerItem(
            icon: Icons.people_alt_outlined,
            title: "Users",
            onTap: () => Get.toNamed("/users"),
          ),

          _drawerItem(
            icon: Icons.shopping_cart_checkout_outlined,
            title: "Orders",
            onTap: () => Get.toNamed("/orders"),
          ),

          _drawerItem(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            onTap: () => Get.toNamed("/notifications"),
          ),

          // =======================
          //      LOGOUT BUTTON
          // =======================
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: Colors.red.withOpacity(0.1),
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                go.Gotoanypage(Login(),true);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
      hoverColor: Colors.blue.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
