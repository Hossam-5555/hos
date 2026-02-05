import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/profilepagecontroller.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/core/class/gotoanypage.dart';
import 'package:hos/veiw/userscreen/screen/myfavorite.dart';
import 'package:hos/veiw/userscreen/screen/profile/order/orders.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/addres/viewaddres.dart';
import 'package:hos/veiw/userscreen/screen/profile/settings/settings.dart';

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(Profilepagecontroller());
    final gotoany = Get.put(Gotoanypagecalss());
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),

          // صورة المستخدم + الاسم
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: AlignmentGeometry.center,
              children: [
                const SizedBox(width: 16),
                Container(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 40),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text(
                            " Hossam Yasser",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            "hossam@email.com",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          iconColor: const Color.fromARGB(255, 26, 21, 9),
                          backgroundColor: Color.fromARGB(255, 194, 180, 166),
                        ),
                        label: Text(
                          "Edit profile",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 0,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(Imageasset.twetter),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cardorder(Icons.card_giftcard, "Orders", () {
                  gotoany.Gotoanypage(Orders(), false, {});
                }),
                cardorder(Icons.favorite, "Wishlist", () {
                  gotoany.Gotoanypage(Myfavorite(), false, {});
                }),
                cardorder(Icons.star_rate, "review", () {}),
              ],
            ),
          ),
          const SizedBox(height: 20),

       
          _buildOptionTile(Icons.location_on, "العناوين", () {
            gotoany.Gotoanypage(ViewMyAddres(), false, {});
          }),

          _buildOptionTile(Icons.credit_card, "طرق الدفع", () {}),

          _buildOptionTile(Icons.settings_outlined, "Settings", () {
            gotoany.Gotoanypage(Settings(), false, {});
          }),

          const SizedBox(height: 50),

          // زر تسجيل خروج
        ],
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Color.fromARGB(255, 201, 181, 162).withAlpha(100),
            shape: BoxShape.circle),
          child: Icon(icon, color: Color.fromARGB(255, 114, 99, 84))),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget cardorder(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 120,
        width: 120,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: const Color.fromARGB(255, 201, 181, 162),
              size: 30,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "8",
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
