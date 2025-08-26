import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
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
      settings: const RouteSettings(name: routeName),
      builder: (_) => OrderConfirmedScreen(order: order, cartItems: cartItems),
    );
  }

  @override
  State<OrderConfirmedScreen> createState() => _OrderConfirmedScreenState();
}

class _OrderConfirmedScreenState extends State<OrderConfirmedScreen> {
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(minutes: 1), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => MainLayout()),
              (route) => false,
        );
      }
    });
    _pushOrderToDatabase();
  }

  Future<void> _pushOrderToDatabase() async {
    await userRepository.pushOrder(widget.order, widget.cartItems);
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';
    final restaurantString = prefs.getString('restaurant_name');

    Restaurant? restaurant;
    if (restaurantString != null) {
      restaurant = Restaurant.fromJson(restaurantString);
    }

    final body = {
      'from': widget.order.userId,
      'to': restaurant?.managerId,
      'topic': 'client_to_restaurant',
      'messageId': 1,
      'locale': localeCode,
      'orderId': widget.order.orderId,
    };

    unawaited(
      DioHelperPayment.postData(
        url: 'https://notify.justorder-eg.com/events',
        data: body,
      ),
    );
  }

  Future<bool> _onWillPop() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MainLayout()),
      (route) => false,
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.sizeOf(context);
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final isLight = state.themeMode == ThemeMode.light;
        final textColor = isLight ? Colors.black : Colors.white;

        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: media.width,
                  height: media.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: media.width * 0.85,
                            padding: EdgeInsets.all(media.width * 0.05),
                            decoration: BoxDecoration(
                              color: isLight ? Colors.white : Colors.black,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x19000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: media.height * 0.08),
                                _headerText(
                                  AppLocalizations.of(context)!.bon_appetit,
                                  color: const Color(0xFFE02C45),
                                  size: 14,
                                ),
                                const SizedBox(height: 12),
                                _headerText(
                                  AppLocalizations.of(context)!.order_confirmed,
                                  color: textColor,
                                  size: 18,
                                  weight: FontWeight.w700,
                                ),
                                const SizedBox(height: 12),
                                QrImageView(
                                  data: widget.order.orderCode,
                                  size: media.width * 0.35,
                                  backgroundColor: isLight
                                      ? Colors.white
                                      : Colors.black,
                                  foregroundColor: textColor,
                                ),
                                const SizedBox(height: 8),
                                _headerText(
                                  widget.order.orderCode,
                                  color: textColor,
                                  size: 16,
                                  weight: FontWeight.bold,
                                ),
                                const SizedBox(height: 24),
                                _infoRow(
                                  AppLocalizations.of(context)!.subtotal,
                                  '${AppLocalizations.of(context)!.egp} ${widget.cartItems.fold(0.0, (sum, item) => sum + item.totalPrice)}',
                                  textColor,
                                ),
                                _infoRow(
                                  AppLocalizations.of(context)!.delivery_fee,
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.deliveryFee}',
                                  textColor,
                                ),
                                _infoRow(
                                  'Delivery Tip',
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.deliveryTip}',
                                  textColor,
                                ),
                                _infoRow(
                                  AppLocalizations.of(context)!.service_fee,
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.serviceFee}',
                                  textColor,
                                ),
                                _infoRow(
                                  AppLocalizations.of(context)!.payment_method,
                                  widget.order.paymentType.name,
                                  textColor,
                                ),
                                const Divider(color: Color(0x4CC8C8C8)),
                                const SizedBox(height: 8),
                                _infoRow(
                                  AppLocalizations.of(context)!.total,
                                  '${AppLocalizations.of(context)!.egp} ${widget.order.totalAmount}',
                                  textColor,
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: -media.height * 0.15,
                            child: Lottie.asset(
                              'assets/animation/Done.json',
                              height: media.width * 0.8,
                              width: media.width * 0.8,
                              repeat: false,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _headerText(
    String text, {
    Color color = Colors.black,
    double size = 14,
    FontWeight weight = FontWeight.w600,
  }) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: size, fontWeight: weight),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _infoRow(
    String title,
    String value,
    Color textColor, {
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
