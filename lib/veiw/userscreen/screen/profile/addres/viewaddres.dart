import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/profile/addres/addrescontroller.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/core/conistant/routs.dart';
import 'package:hos/data/model/addres_model.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class ViewMyAddres extends StatelessWidget {
  ViewMyAddres({super.key});

  final AddressController controller = Get.put(AddressController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Appbarbackicon(herotag: '', title: 'Saved Addresses'.tr),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        onPressed: () => Get.toNamed(Approute.addnewaddres),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: Text('add'.tr),
      ),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          if (controller.statusrequest == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return HandlingDataView(
            emptyStyle: EmptyStateStyle.style2,
            statusrequest: controller.statusrequest!,
            mediaType: HandlingMediaType.svgImage,
            mode: HandlingMode.fullScreen,
            showRetryButton: true,
            widget: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 1100
                    ? 3
                    : width >= 600
                        ? 2
                        : 2;
                final spacing = width < 600 ? 12.0 : 18.0;
                final maxWidth = width > 1200 ? 1200.0 : width;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: MasonryGridView.builder(
                      padding: EdgeInsets.all(spacing),
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                      ),
                      mainAxisSpacing: spacing,
                      crossAxisSpacing: spacing,
                      itemCount: controller.listaddresdata.length,
                      itemBuilder: (context, index) {
                        final address = controller.listaddresdata[index];

                        return AddressCard(
                          address: address,
                          isDefault: controller.isdefault == address.id,
                          onDelete: () {
                            if (address.id != null) {
                              controller.deleteAddres(address.id!, context);
                            }
                          },
                          onSetDefault: () {
                            if (address.id != null) {
                              controller.updatedefault(address.id!);
                            }
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class AddressCard extends StatelessWidget {
  final AddressModel address;
  final bool isDefault;
  final VoidCallback onDelete;
  final VoidCallback onSetDefault;

  const AddressCard({
    super.key,
    required this.address,
    required this.isDefault,
    required this.onDelete,
    required this.onSetDefault,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final compact = cardWidth < 280;
        final cardHeight = (cardWidth * 1.5).clamp(230.0, 340.0).toDouble();
        final horizontalPadding = compact ? 12.0 : 16.0;
        final titleSize = compact ? 17.0 : 20.0;

        return Container(
          height: cardHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 20 : 26),
            boxShadow: const [
              BoxShadow(
                color: AppColors.darkShadow,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    'https://images.unsplash.com/photo-1568605114967-8130f3a36994?q=80&w=1200&auto=format&fit=crop',
                placeholder: (context, url) => Container(
                  color: Theme.of(context).cardColor,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Theme.of(context).cardColor,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromARGB(0, 0, 0, 0),
                      Color.fromARGB(89, 0, 0, 0),
                      Color.fromARGB(217, 0, 0, 0),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              if (isDefault)
                PositionedDirectional(
                  top: 14,
                  start: 14,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: cardWidth * 0.65),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.arabic.withAlpha(230),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'default_address'.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightSurface,
                      ),
                    ),
                  ),
                ),
              PositionedDirectional(
                top: 12,
                end: 12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: AppColors.lightSurface.withAlpha(64),
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      color: AppColors.lightSurface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: onDelete,
                          value: 'delete'.tr,
                          child: Row(
                            children: [
                              Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'delete'.tr,
                                style: TextStyle(
                                  color: Colors.red.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          onTap: onSetDefault,
                          value: 'Set as default'.tr,
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Set as default'.tr,
                                style: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PositionedDirectional(
                start: horizontalPadding,
                end: horizontalPadding,
                bottom: compact ? 12 : 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address.name ?? '',
                      style: TextStyle(
                        color: AppColors.lightSurface,
                        fontSize: titleSize,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${address.city ?? ''}, ${address.street ?? ''}',
                      style: const TextStyle(
                        color: Color.fromARGB(217, 255, 255, 255),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: compact ? 8 : 12),
                    _infoChip(
                      Icons.phone_outlined,
                      address.phone ?? 'No phone',
                      compact: compact,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoChip(
    IconData icon,
    String label, {
    required bool compact,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.lightSurface.withAlpha(38),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                color: AppColors.lightSurface,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
