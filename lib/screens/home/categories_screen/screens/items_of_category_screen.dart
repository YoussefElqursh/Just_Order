import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_order/repository/item_repository.dart';
import 'package:just_order/screens/home/categories_screen/logic/item_cubit.dart';
import 'package:just_order/core/theme/colors.dart';

class ItemsOfCategoryScreen extends StatefulWidget {
  final Categories category;

  const ItemsOfCategoryScreen({super.key, required this.category});

  @override
  State<ItemsOfCategoryScreen> createState() => _ItemsOfCategoryScreenState();
}

class _ItemsOfCategoryScreenState extends State<ItemsOfCategoryScreen> {
  late ItemsCubit itemsCubit;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    itemsCubit = ItemsCubit(ItemRepository())
      ..fetchItemsByCategory(widget.category.categoryName);

    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      itemsCubit.searchItems(_searchController.text.trim());
    });
  }


  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    itemsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final themeState = themeCubit.state;

    return BlocProvider(
      create: (_) => itemsCubit,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.category.categoryName,
            style: TextStyle(
              color: themeState.themeMode == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
            child: Container(
              width: 34,
              height: 34,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFFF4F4F4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 18,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search items...',
                  filled: true,
                  fillColor: themeState.themeMode == ThemeMode.light ? Colors.grey[100] : Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ItemsCubit, ItemsState>(
                builder: (context, state) {
                  if (state is ItemsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.primaryColor),
                    );
                  } else if (state is ItemsLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(
                        child: Text('No items found for this category.'),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Card(
                          color: themeState.themeMode == ThemeMode.light ? AppColor.whiteColor : AppColor.blackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl: item.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.broken_image_rounded),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is ItemsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
