// import 'dart:convert';

// import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:hos/core/class/crud.dart';
import 'package:hos/core/conistant/routs.dart';
// import 'package:hos/core/functions/handlingdata.dart';
import 'package:hos/core/localization/transilation.dart';
import 'package:hos/core/serveces/binding.dart';

import 'package:hos/core/serveces/myservisec.dart';
// import 'package:hos/test.dart';
// import 'package:hos/veiw/wedget/SharedProductCard.dart';
// import 'package:http/http.dart' as http;

import 'core/localization/changlocal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialservisec();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalController controller = Get.put(LocalController());
    return GetMaterialApp(
      // home: AdminDashboard(),
      debugShowCheckedModeBanner: false,
      initialBinding: MyBinding(),
      locale: controller.language,
      getPages: routes,
      translations: Mytransilation(),
      theme: controller.apptheme,
    );
  }
}

// class Testname extends GetxController {
//   String url = "http://10.0.2.2:8000/api/items";
//   List data = [];
//   Future<void> getItem() async {
//     try {
//       var response = await http.get(
//         Uri.parse(url),
//         // headers: {
//         //   "Accept": "application/json",
//         //   "Content-Type": "application/json",
//         // },
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         var responseBody = jsonDecode(response.body);

//         if (responseBody["status"] == true) {
//           data.clear();
//           return data.addAll(responseBody["items"]);
//         }
//       } else {
//         print("there is soumtiong");
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//     update();
//   }

//   @override
//   void onInit() {
//     getItem();
//     super.onInit();
//   }
// }

// class TestView extends StatelessWidget {
//   TestView({super.key});
//   Testname testname = Get.put(Testname());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 1,
//               offset: Offset(1, 0),
//               color: Colors.black.withAlpha(90),
//               spreadRadius: BorderSide.strokeAlignCenter,
//             ),
//           ],
//         ),
//         height: 50,
//         width: 200,
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: CupertinoColors.black,
//           ),
//           onPressed: () {},
//           child: Center(
//             child: Text("Hossam", style: TextStyle(color: Colors.white)),
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 2,
//               child: GetBuilder<Testname>(
//                 builder: (controller) {
//                   return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       mainAxisSpacing: 0.9,
//                       crossAxisSpacing: 10,
//                     ),
//                     itemCount: controller.data.length,
//                     itemBuilder: (context, i) {
//                       var ss = controller.data.isEmpty
//                           ? "Hossam is the beast"
//                           : controller.data[i]["items_name"];
//                       return SharedProductCard(
//                         image: "image",
//                         title: ss,
//                         price: "200",
//                         rating: 4.5,
//                         actionButton: IconButton(
//                           onPressed: () {},
//                           icon: Icon(Icons.assessment),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
