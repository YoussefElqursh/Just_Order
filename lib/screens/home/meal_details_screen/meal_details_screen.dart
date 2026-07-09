import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/shared/widget/custom_check_box_button_widget.dart';
import 'package:just_order/shared/widget/custom_radio_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:just_order/core/storage/storage_service.dart';

class MealDetailsScreen extends StatefulWidget {
  final Item item;
  final Restaurant? restaurant;

  const MealDetailsScreen({super.key, required this.item, this.restaurant});

  static const String routeName = 'MealDetailsScreenRoute';

  static Route route(Item item, [Restaurant? restaurant]) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => MealDetailsScreen(item: item, restaurant: restaurant),
    );
  }

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  Restaurant? restaurant;
  int counter = 1;
  String? selectedSize;
  Map<String, double> selectedExtras = {};
  double totalPrice = 0.0;
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    restaurant = widget.restaurant;
    price = widget.item.price;
    if (widget.item.sizes != null && widget.item.sizes!.isNotEmpty) {
      selectedSize = widget.item.sizes!.keys.first;
      price = widget.item.sizes![selectedSize]!;
      totalPrice = price;
    } else {
      totalPrice = widget.item.price;
    }
  }

  void updateTotalPrice() {
    double basePrice = selectedSize != null
        ? widget.item.sizes![selectedSize]!
        : widget.item.price;
    double extrasPrice = selectedExtras.values.fold(
      0.0,
      (sum, item) => sum + item,
    );
    totalPrice = (basePrice + extrasPrice) * counter;
  }

  void updatePrice() {
    if (selectedSize != null) {
      price = widget.item.sizes![selectedSize]!;
    } else {
      price = widget.item.price;
    }
  }

  Future<void> _addToCart() async {
    final prefs = StorageService.instance;
    Restaurant? activeRestaurant = restaurant;
    if (activeRestaurant == null) {
      final restaurantString =
          // ignore: use_build_context_synchronously
          prefs.getString(AppLocalizations.of(context)!.restaurant_name);
      if (restaurantString != null) {
        activeRestaurant = Restaurant.fromJson(restaurantString);
      }
    }
    // ignore: use_build_context_synchronously
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final cartItem = CartItem(
      cartItemId: '${UniqueKey().toString()}_${activeRestaurant?.restaurantId}',
      item: widget.item,
      quantity: counter,
      price: price,
      extras: selectedExtras,
      size: selectedSize != null ? {selectedSize!: price} : null,
    );
    cartProvider.addItem(cartItem);
    if (activeRestaurant != null) {
      await prefs.setString(
        AppLocalizations.of(context)!.restaurant_name,
        jsonEncode(activeRestaurant.toJson()),
      );
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Item item = widget.item;
    final cartProvider = Provider.of<CartProvider>(context);
    final filteredItems = restaurant != null
        ? cartProvider.items
              .where(
                (item) =>
                    item.cartItemId.endsWith('_${restaurant!.restaurantId}'),
              )
              .toList()
        : cartProvider.items;
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        clipBehavior: Clip.none,
                        children: [
                          CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 250,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColor.primaryColor,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.broken_image_rounded),
                            memCacheWidth:
                                (MediaQuery.of(context).size.width *
                                        MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                          ),
                          Visibility(
                            visible: item.discount > 0,
                            maintainSize: false,
                            // Ensures no space is taken when not visible
                            maintainAnimation: false,
                            maintainState: false,
                            child: Positioned(
                              top: 250,
                              right: 20,
                              child: Container(
                                width: 60,
                                height: 30,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 4,
                                ),
                                clipBehavior: Clip.antiAlias,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFE02C45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    '0% Off',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 50.0,
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: state.themeMode == ThemeMode.dark
                                      ? Colors.black
                                      : const Color(0xFFF4F4F4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              color: state.themeMode == ThemeMode.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 26.0),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.egp} ${price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const Spacer(),
                                Text(
                                  AppLocalizations.of(context)!.egp_0_00,
                                  style: const TextStyle(
                                    color: Color(0xFFE02C45),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Color(0xFFE02C45),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                          if (item.sizes != null && item.sizes!.isNotEmpty) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.options,
                                      style: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.choose_1_option,
                                      style: const TextStyle(
                                        color: Color(0xFFAFAFAF),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 63,
                                  height: 23,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: state.themeMode == ThemeMode.light
                                        ? const Color(0x0CE02C45)
                                        : const Color(0x5FE02C45),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.required,
                                      style: const TextStyle(
                                        color: Color(0xFFE02C45),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                            for (var size in item.sizes!.keys) ...[
                              customRadioButtonWidget(
                                context: context,
                                hasExtraText: true,
                                extraText:
                                    '(${AppLocalizations.of(context)!.plus_egp} ${item.sizes![size]!.toStringAsFixed(2)})',
                                width: MediaQuery.sizeOf(context).width,
                                hasDivider: true,
                                label: size.toUpperCase(),
                                value: size,
                                groupName: selectedSize,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSize = value;
                                    updateTotalPrice();
                                    updatePrice();
                                  });
                                },
                                state: state,
                              ),
                              const SizedBox(height: 10.0),
                            ],
                          ],
                          if (item.extras != null &&
                              item.extras!.isNotEmpty) ...[
                            const SizedBox(height: 26.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.extras,
                                      style: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.choose_up_to_1_option,
                                      style: const TextStyle(
                                        color: Color(0xFFAFAFAF),
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Container(
                                  width: 63,
                                  height: 23,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: state.themeMode == ThemeMode.dark
                                        ? const Color(0x5FE02C45)
                                        : const Color(0x4CAFAFAF),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppLocalizations.of(context)!.optional,
                                      style: const TextStyle(
                                        color: Color(0xFF898888),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 25.0),
                            for (var extra in item.extras!.keys) ...[
                              customCheckBoxButtonWidget(
                                context: context,
                                hasExtraText: true,
                                extraText:
                                    '(+${AppLocalizations.of(context)!.plus_egp} ${item.extras![extra]!.toStringAsFixed(2)})',
                                label: extra,
                                value: selectedExtras.containsKey(extra),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
                                      selectedExtras.putIfAbsent(
                                        extra,
                                        () => item.extras![extra]!,
                                      );
                                    } else {
                                      selectedExtras.remove(extra);
                                    }
                                    updateTotalPrice();
                                  });
                                },
                                state: state,
                              ),
                              const SizedBox(height: 15.0),
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50.0),
                ],
              ),
            ),
          ),
          floatingActionButton: Badge(
            label: Text('${filteredItems.length}'),
            alignment: AlignmentDirectional.topStart,
            backgroundColor: Colors.white,
            textColor: const Color(0xFFE02C45),
            isLabelVisible: true,
            smallSize: 12,
            child: FloatingActionButton(
              onPressed: () {
                navigateTo(context, 'MyCartScreenRoute');
              },
              backgroundColor: const Color(0xFFE02C45),
              shape: const CircleBorder(
                side: BorderSide(color: Color(0xFFE02C45)),
              ),
              child: Image.asset(
                'assets/icons/cart.png',
                height: 20,
                width: 20,
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              color: state.themeMode == ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(height: 1, color: Color(0x4CC8C8C8)),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.quantity_order,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Container(
                                width: 34,
                                height: 34,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: state.themeMode == ThemeMode.light
                                      ? const Color(0x0CE02C45)
                                      : const Color(0x5FE02C45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (counter > 1) counter--;
                                      updateTotalPrice();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Color(0xFFE02C45),
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                '$counter',
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const SizedBox(width: 10.0),
                              Container(
                                width: 34,
                                height: 34,
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                  color: state.themeMode == ThemeMode.light
                                      ? const Color(0x0CE02C45)
                                      : const Color(0x5FE02C45),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      counter++;
                                      updateTotalPrice();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFFE02C45),
                                    size: 18,
                                  ),
                                  style: ButtonStyle(
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          MaterialButton(
                            onPressed: _addToCart,
                            height: 42,
                            minWidth: MediaQuery.sizeOf(context).width,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            color: const Color(0xFFE02C45),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.add_to_cart,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const Spacer(),
                                Text(
                                  '${AppLocalizations.of(context)!.plus_egp} ${totalPrice.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  AppLocalizations.of(context)!.egp_0_00,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.dark
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

