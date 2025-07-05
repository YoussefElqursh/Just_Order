import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/network/dio_helper.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirmedScreen extends StatefulWidget {
  final Order order;
  final List<CartItem> cartItems;

  const OrderConfirmedScreen({
    super.key,
    required this.order,
    required this.cartItems,
  });

  static const String routeName = 'OrderConfirmedScreenRoute';

  static Route route({
    required Order order,
    required List<CartItem> cartItems,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(
        name: routeName,
      ),
      builder: (context) => OrderConfirmedScreen(
        order: order,
        cartItems: cartItems,
      ),
    );
  }

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  late String formattedDate;
  late String formattedTime;
  UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _pushOrderToDatabase();
  }

  Future<void> _pushOrderToDatabase() async {
    await userRepository.pushOrder(widget.order, widget.cartItems);
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';
    Map<String, dynamic> body = {};
    body['from'] = widget.order.userId;
    body['to'] = widget.order.restaurantId;
    body['topic'] = 'client_to_restaurant';
    body['messageId'] = 1;
    body['locale'] = localeCode;
    body['orderId'] = widget.order.orderId;
    unawaited(DioHelperPayment.postData(url: 'https://notify.justorder-eg.com/events', data: body));
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainLayout()),
      (route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).width * 0.5),
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 280,
                        height: MediaQuery.sizeOf(context).height * 0.60,
                        padding: const EdgeInsets.all(20),
                        decoration: ShapeDecoration(
                          color: state.themeMode == ThemeMode.dark
                              ? Colors.black
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                              spreadRadius: 0,
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60.0),
                            Text(
                              AppLocalizations.of(context)!.bon_appetit,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFE02C45),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 12.0),
                            Text(
                              AppLocalizations.of(context)!.order_confirmed,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 12.0),
                            QrImageView(
                              data: widget.order.orderCode,
                              size: 120,
                              version: QrVersions.auto,
                              backgroundColor: state.themeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                              foregroundColor:
                                  state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                            Text(
                              widget.order.orderCode,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            const SizedBox(height: 32.0),
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
                                  '${AppLocalizations.of(context)!.egp} ${widget.cartItems.fold(0.0, (previousValue, element) => previousValue + element.totalPrice)}',
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
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.deliveryFee}',
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
                                  AppLocalizations.of(context)!.service_fee,
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
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.serviceFee}',
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
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.payment_method,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  widget.order.paymentType.name,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
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
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.totalAmount}',
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
                      Positioned(
                        bottom: 330,
                        child: Lottie.asset(
                          height: 350,
                          width: 350,
                          'assets/animation/Done.json',
                          repeat: false,
                        ),
                      ),
                    ],
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
