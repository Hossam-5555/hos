import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hos/core/conistant/imageasset.dart';
import 'package:hos/veiw/userscreen/screen/searchpage.dart';
import 'package:hos/veiw/wedget/Homepage/homescrenAction.dart';

import 'package:hos/veiw/wedget/items/filteritems.dart';

class CustomItemsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic controller;
  final double width;

  const CustomItemsAppBar({
    super.key,
    required this.controller,
    required this.width,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      leading: const BackButtonCircle(),
      actions: [
        Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 5),
          child: Homescrenaction(
            onPressed: () {
              Get.to(
                () => Searchpage(),
                transition: Transition.fadeIn,
                duration: const Duration(milliseconds: 400),
              );
            },
            herotag: "Search",
            child: SvgPicture.asset(Imageasset.search),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 10),
          child: _FilterButton(controller: controller),
        ),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  final dynamic controller;

  const _FilterButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 52,
        width: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: const Color.fromARGB(255, 196, 196, 196).withAlpha(60),
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: MaterialButton(
          onPressed: () => openAdvancedFilter(context),
          child: SvgPicture.asset(Imageasset.filter, height: 25, width: 25),
        ),
      ),
    );
  }
}

class BackButtonCircle extends StatelessWidget {
  const BackButtonCircle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Center(
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_sharp, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}

void openAdvancedFilter(BuildContext context) {
  Get.put(FilterController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const AdvancedFilterSheet(),
  );
}
