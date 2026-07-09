import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/repository/item_repository.dart';
import 'package:just_order/screens/home/categories_screen/logic/item_cubit.dart';
import 'package:just_order/screens/home/meal_details_screen/meal_details_screen.dart';

class ItemsOfCategoryScreen extends StatefulWidget {
  final Categories category;

  const ItemsOfCategoryScreen({super.key, required this.category});

  @override
  State<ItemsOfCategoryScreen> createState() => _ItemsOfCategoryScreenState();
}

class _ItemsOfCategoryScreenState extends State<ItemsOfCategoryScreen> {
  late ItemsCubit itemsCubit;
  final ItemRepository _itemRepository = ItemRepository();
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
                onPressed: () => Navigator.pop(context),
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
                  fillColor: themeState.themeMode == ThemeMode.light
                      ? Colors.grey[100]
                      : Colors.grey[800],
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
                      child: CircularProgressIndicator(
                        color: AppColor.primaryColor,
                      ),
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
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio:
                            0.78, // Adjusts the height/width ratio to fit the new text & restaurant info comfortably
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];

                        // Wrap each grid item item in a FutureBuilder to handle the asynchronous restaurant lookup
                        return FutureBuilder<Restaurant?>(
                          future: _itemRepository.getRestaurantForItem(item),
                          builder: (context, snapshot) {
                            final restaurant = snapshot.data;
                            final isRestaurantLoading =
                                snapshot.connectionState ==
                                ConnectionState.waiting;

                            return Card(
                              margin: EdgeInsets
                                  .zero, // Resets native card margin to behave well in grids
                              elevation: 1.5,
                              clipBehavior: Clip
                                  .antiAlias, // Clips the image neatly to the card's rounded corners
                              color: themeState.themeMode == ThemeMode.light
                                  ? AppColor.whiteColor
                                  : AppColor.blackColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: isRestaurantLoading || restaurant == null
                                    ? null // Disables tap until data is ready
                                    : () {
                                        Navigator.push(
                                          context,
                                          MealDetailsScreen.route(
                                            item,
                                            restaurant,
                                          ),
                                        );
                                      },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // 1. Item Image
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: item.imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                color: Colors.grey.withAlpha(
                                                  20,
                                                ),
                                                child: const Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: AppColor
                                                              .primaryColor,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(
                                                Icons.broken_image_rounded,
                                              ),
                                        ),
                                      ),
                                    ),

                                    // 2. Info Content Padding
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Item Name
                                          Text(
                                            item.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 6),

                                          // Restaurant info row or loading state
                                          if (isRestaurantLoading)
                                            Row(
                                              children: [
                                                Container(
                                                  width: 16,
                                                  height: 16,
                                                  decoration:
                                                      const BoxDecoration(
                                                        color: Colors.black12,
                                                        shape: BoxShape.circle,
                                                      ),
                                                ),
                                                const SizedBox(width: 6),
                                                Container(
                                                  width: 50,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          else if (restaurant != null)
                                            Row(
                                              children: [
                                                // Restaurant Small Logo Thumbnail
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        restaurant.imageUrl ??
                                                        '', // Replace with your exact field name
                                                    width: 18,
                                                    height: 18,
                                                    fit: BoxFit.cover,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.store,
                                                              size: 12,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                  ),
                                                ),
                                                const SizedBox(width: 6),
                                                // Restaurant Name Text
                                                Expanded(
                                                  child: Text(
                                                    restaurant.name,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey[600],
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          else
                                            const SizedBox(
                                              height: 18,
                                            ), // Invisible spacer if repository fails to grab data
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
