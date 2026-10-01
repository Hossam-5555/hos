import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/controler/admincontroller/categories/addcatcontroller.dart';
import 'package:hos/data/model/categoriesmodel.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

/// Add:  Get.to(() => const CategoryFormScreen());
/// Edit: Get.to(() => CategoryFormScreen(category: model));
class CategoryFormScreen extends GetView<CategoryFormController> {
  const CategoryFormScreen({super.key, this.category});

  final CategoriesModel? category;

  @override
  Widget build(BuildContext context) {
    Get.put(CategoryFormController(category));
    final theme = Theme.of(context);

    return GetBuilder<CategoryFormController>(
      builder: (c) => Scaffold(
        appBar: Appbarbackicon(
          title: (c.isEdit ? 'edit_category' : 'add_category').tr,
          herotag: "addcategory",
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 720;
              final hPad = wide ? 32.0 : 16.0;

              final imageCard = _Card(child: _ImagePicker(c: c));
              final fieldsCard = _Card(child: _Fields(c: c));

              return Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 960),
                  child: Form(
                    key: c.formKey,
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsetsDirectional.fromSTEB(
                        hPad,
                        20,
                        hPad,
                        32,
                      ),
                      child: Column(
                        children: [
                          if (wide)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 300, child: imageCard),
                                const SizedBox(width: 20),
                                Expanded(child: fieldsCard),
                              ],
                            )
                          else ...[
                            imageCard,
                            const SizedBox(height: 16),
                            fieldsCard,
                          ],
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: c.isLoading ? null : c.submit,
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: c.isLoading
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      (c.isEdit ? 'update' : 'add').tr,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _ImagePicker extends StatelessWidget {
  const _ImagePicker({required this.c});
  final CategoryFormController c;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = c.file != null || c.existingImageUrl != null;

    Widget preview;
    if (c.file != null) {
      preview = Image.file(c.file!, fit: BoxFit.cover);
    } else if (c.existingImageUrl != null) {
      preview = Image.network(
        c.existingImageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image_outlined),
      );
    } else {
      preview = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo_rounded,
            size: 32,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'upload_image'.tr,
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            'category_image'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: c.chooseImage,
          child: Container(
            height: 150,
            width: 150,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.primary.withAlpha(hasImage ? 255 : 90),
                width: 1.5,
              ),
            ),
            child: preview,
          ),
        ),
        if (hasImage) ...[
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: c.chooseImage,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: Text('change_image'.tr),
          ),
        ],
      ],
    );
  }
}

class _Fields extends StatelessWidget {
  const _Fields({required this.c});
  final CategoryFormController c;

  InputDecoration _dec(
    BuildContext context,
    String label,
    String hint,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: c.name,
          textInputAction: TextInputAction.next,
          textDirection: TextDirection.ltr,
          decoration: _dec(
            context,
            'category_name_en'.tr,
            'enter_category_name'.tr,
            Icons.category_outlined,
          ),
          validator: c.requiredValidator,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: c.namear,
          textInputAction: TextInputAction.next,
          textDirection: TextDirection.rtl,
          decoration: _dec(
            context,
            'category_name_ar'.tr,
            'enter_category_name'.tr,
            Icons.language_outlined,
          ),
          validator: c.requiredValidator,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: c.description,
          minLines: 3,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
          decoration: _dec(
            context,
            'description'.tr,
            'enter_description'.tr,
            Icons.notes_outlined,
          ),
        ),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          contentPadding: EdgeInsets.zero,
          title: Text('status'.tr),
          subtitle: Text(
            (c.isActive ? 'active' : 'inactive').tr,
            style: TextStyle(
              color: c.isActive ? Colors.green : theme.disabledColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          value: c.isActive,
          onChanged: c.toggleActive,
        ),
      ],
    );
  }
}
