import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/Utils/util.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/enums/payment_type.dart';
import 'package:just_order/models/enums/status.dart';
import 'package:just_order/models/order_model.dart' as order_model;
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/screens/cart/widgets/order_cart_widget.dart';
import 'package:just_order/shared/style/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});

  static const String routeName = 'MyCartScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const MyCartScreen(),
    );
  }

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  Restaurant? restaurant;
  User? user;

  bool isVisible = true;
  String tableCode = '';
  double serviceFees = 0;

  @override
  void initState() {
    super.initState();
    _loadRestaurantAndUser();
    _loadTableCode();
    _getServiceFees();
  }

  Future<void> _loadTableCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      tableCode = prefs.getString('code') ?? 'Unknown';
    });
  }

  Future<void> _getServiceFees() async {
    double fetchedServiceFees = await Util.getServiceFees();
    if (mounted) {
      setState(() {
        serviceFees = fetchedServiceFees;
      });
    }
  }

  Future<void> _loadRestaurantAndUser() async {
    final prefs = await SharedPreferences.getInstance();
    final restaurantString =
// ignore: use_build_context_synchronously
        prefs.getString(AppLocalizations.of(context)!.restaurant_name);
    final userString = prefs.getString('user');
    if (restaurantString != null) {
      setState(() {
        restaurant = Restaurant.fromJson(restaurantString);
      });
    }
    if (userString != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userString));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.my_cart,
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
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                top: 10.0,
                bottom: 10.0,
              ),
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
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leadingWidth: 55.0,
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            clipBehavior: Clip.none,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      width: 1,
                                      strokeAlign: BorderSide.strokeAlignCenter,
                                      color: Color(0xFFEBEBEB),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: restaurant?.imageUrl ?? '',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 250,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  errorWidget: (
                                    context,
                                    url,
                                    error,
                                  ) =>
                                      const Icon(Icons.broken_image_rounded),
                                  memCacheWidth:
                                      (MediaQuery.of(context).size.width *
                                              MediaQuery.of(context)
                                                  .devicePixelRatio)
                                          .round(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 10.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      restaurant?.name ??
                                          AppLocalizations.of(context)!
                                              .restaurant_name,
                                      style: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      AppLocalizations.of(context)!
                                          .pizza_pies_crepes,
                                      style: const TextStyle(
                                        color: Color(0xFFAFAFAF),
                                        fontSize: 10,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        const Divider(
                          height: 1,
                          color: Color(0x4CC8C8C8),
                        ),
                        const SizedBox(height: 12.0),
                        Visibility(
                          visible: isVisible,
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            selected: true,
                            selectedTileColor: const Color(0x5FE02C45),
                            leading: const Icon(
                              Icons.info_outline,
                              color: Color(0xFFE02C45),
                              size: 24.0,
                            ),
                            title: Text(
                              AppLocalizations.of(context)!
                                  .any_items_found_in_anothe_cart_is_saved,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                            titleTextStyle: const TextStyle(
                              color: Color(0xFFE02C45),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              style: const ButtonStyle(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(
                                Icons.close,
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25.0),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!.items,
                                      style: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' ',
                                      style: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '(${filteredItems.length} Items)',
                                      style: TextStyle(
                                        color:
                                            state.themeMode == ThemeMode.light
                                                ? Colors.black
                                                : Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  cartProvider.clearCart();
                                },
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.remove_all,
                                  style: const TextStyle(
                                    color: Color(0xFFE02C45),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final cartItem = filteredItems[index];
                              return buildOrderCartWidget(
                                context: context,
                                cartItem: cartItem,
                                onPressed1: () {
                                  setState(() {
                                    cartItem.quantity--;
                                    if (cartItem.quantity == 0) {
                                      cartProvider
                                          .removeItem(cartItem.cartItemId);
                                    }
                                  });
                                },
                                counter: cartItem.quantity,
                                onPressed2: () {
                                  setState(() {
                                    cartItem.quantity++;
                                  });
                                },
                                state: state,
                              );
                            },
                            separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(vertical: 15.0),
                              child: Divider(
                                height: 1,
                                color: Color(0x4CC8C8C8),
                              ),
                            ),
                            itemCount: filteredItems.length,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.0),
                    child: Divider(
                      color: Color(0x4CC8C8C8),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.payment_summary,
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
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.subtotal,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Text(
                                // ignore: avoid_types_as_parameter_names
                                '${AppLocalizations.of(context)!.egp} ${filteredItems.fold(0.0, (sum, item) => sum + item.totalPrice).toStringAsFixed(2)}',
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
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.delivery_fee,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Text(
                                '${AppLocalizations.of(context)!.egp} ${restaurant?.deliveryFee ?? 0.0}',
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
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.service_fees,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Text(
                                '${AppLocalizations.of(context)!.egp} $serviceFees',
                                style: const TextStyle(
                                  color: Color(0xFFE02C45),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(
                            height: 1,
                            color: Color(0x4CC8C8C8),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.total,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              const Spacer(),
                              Text(
                                // ignore: avoid_types_as_parameter_names
                                '${AppLocalizations.of(context)!.egp}${(filteredItems.fold(0.0, (sum, item) => sum + item.totalPrice) + serviceFees + (restaurant?.deliveryFee ?? 0.0)).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              color: state.themeMode == ThemeMode.dark
                  ? Colors.black
                  : Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Divider(
                        height: 1,
                        color: Color(0x7FAFAFAF),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: MaterialButton(
                        onPressed: () async {
                          if (filteredItems.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  AppLocalizations.of(context)!
                                      .your_cart_is_empty,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                backgroundColor: const Color(0xFFE02C45),
                              ),
                            );
                          } else {
                            final order = order_model.Order(
                              orderId: FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc()
                                  .id,
                              userId: user?.userId ?? 'userId',
                              clubId: restaurant?.clubId ?? 'clubId',
                              restaurantId:
                                  restaurant?.restaurantId ?? 'restaurantId',
                              orderCode: 'temp',
                              status: Status.pending,
                              paymentType: PaymentType.cash,
                              serviceFee: serviceFees,
                              deliveryFee: (restaurant!.deliveryFee)!,
                              orderTimeOut: restaurant?.orderTimeOut ?? 0,
                              createdAt: DateTime.now(),
                              subTotal: filteredItems.fold(
                                0.0, // ignore: avoid_types_as_parameter_names
                                (summation, item) =>
                                    summation + item.totalPrice,
                              ),
                              totalAmount: filteredItems.fold(
                                    0.0, // ignore: avoid_types_as_parameter_names
                                    (summation, item) =>
                                        summation + item.totalPrice,
                                  ) +
                                  serviceFees +
                                  restaurant!.deliveryFee!,
                              orderCodeForRestaurant: 'temp',
                              orderTable: tableCode,
                              processed: false,
                              addedToInvoice: false,
                              deliveredByRestaurant: restaurant!.hasOwnDelivery,
                              deliveryTip:0,
                            );
                            String orderCode =
                                await order.generateUniqueOrderCode();
                            String orderCodeForRestaurant =
                                order.generateOrderCodeForRestaurant();
                            order.orderCode = orderCode;
                            order.orderCodeForRestaurant =
                                orderCodeForRestaurant;

                            Navigator.pushNamed(
                              // ignore: use_build_context_synchronously
                              context,
                              'PayMethodScreenRoute',
                              arguments: {
                                'order': order,
                                'cartItems': filteredItems,
                              },
                            );
                          }
                        },
                        height: 42,
                        minWidth: MediaQuery.sizeOf(context).width,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        color: const Color(0xFFE02C45),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.checkout,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
    );
  }
}
