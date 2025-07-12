import 'package:cached_network_image/cached_network_image.dart';
import 'package:dartz/dartz.dart' as fp;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/repository/payment_repository/payment_repository.dart';
import 'package:just_order/screens/order/order_confirmed_screen.dart';
import 'package:just_order/screens/order/widgets/order_components_widget.dart';
import 'package:just_order/shared/style/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSummaryScreen extends StatefulWidget {
  final Order order;
  final List<CartItem> cartItems;

  const OrderSummaryScreen({
    super.key,
    required this.order,
    required this.cartItems,
  });

  static const String routeName = 'OrderSummaryScreenRoute';

  static Route route({
    required Order order,
    required List<CartItem> cartItems,
  }) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => OrderSummaryScreen(
        order: order,
        cartItems: cartItems,
      ),
    );
  }

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  Restaurant? restaurant;
  final PaymentRepository _paymentRepository = PaymentRepository();

  final TextEditingController _deliveryTipController = TextEditingController();

  double deliveryTip = 0.0;
  double baseTotal = 0.0;
  double finalTotal = 0.0;


  @override
  void initState() {
    super.initState();
    _loadRestaurant();
    baseTotal = widget.order.totalAmount; // Your original total value
    finalTotal = widget.order.totalAmount; // Your original total value
    _deliveryTipController.addListener(_updateTipValue);
  }

  @override
  void dispose() {
    _deliveryTipController.removeListener(_updateTipValue);
    _deliveryTipController.dispose();
    super.dispose();
  }

  Future<void> _loadRestaurant() async {
    final prefs = await SharedPreferences.getInstance();
    final restaurantString =
        // ignore: use_build_context_synchronously
        prefs.getString(AppLocalizations.of(context)!.restaurant_name);
    if (restaurantString != null) {
      setState(() {
        restaurant = Restaurant.fromJson(restaurantString);
      });
    }
  }

  void _updateTipValue() {
    final text = _deliveryTipController.text;
    setState(() {
      if (text.isEmpty) {
        deliveryTip = 0.0;
      } else {
        deliveryTip = double.tryParse(text) ?? 0.0;
        deliveryTip = deliveryTip.abs();
      }
      finalTotal = baseTotal + deliveryTip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.order_summary,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height: 50,
                                  placeholder: (
                                    context,
                                    url,
                                  ) =>
                                      const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColor.primaryColor,
                                    ),
                                  ),
                                  errorWidget: (
                                    context,
                                    url,
                                    error,
                                  ) =>
                                      const Icon(
                                    Icons.broken_image_rounded,
                                  ),
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
                                      restaurant?.name ?? 'Restaurant Name',
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
                        const SizedBox(height: 25.0),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: AppLocalizations.of(context)!.items,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: '(${widget.cartItems.length})',
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
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
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width,
                          child: ListView.separated(
                            itemBuilder: (context, index) =>
                                buildOrderComponentsWidget(
                              widget.cartItems[index],
                              state,
                              context,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 16.0),
                            itemCount: widget.cartItems.length,
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
                      height: 1,
                      color: Color(0x4CC8C8C8),
                      thickness: 1,
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
                                '${AppLocalizations.of(context)!.egp}${restaurant?.deliveryFee}',
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
                            children: [
                              Text(
                                'Delivery Tip',
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
                              SizedBox(
                                width: 70,
                                height: 46,
                                child: _buildLabeledTextField(
                                  hint: '0.00',
                                  controller: _deliveryTipController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  themeMode: state.themeMode,
                                  themeDark: state.themeMode == ThemeMode.light
                                      ? false
                                      : true,
                                ),
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
                                '${AppLocalizations.of(context)!.egp} ${(finalTotal).toStringAsFixed(2)}',
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        if (widget.order.paymentType.name == 'cash') {
                          widget.order.totalAmount = finalTotal;
                          widget.order.deliveryTip = int.parse(_deliveryTipController.text);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderConfirmedScreen(
                                order: widget.order,
                                cartItems: widget.cartItems,
                              ),
                            ),
                          );
                        } else {
                          // We keep track to to two digits after point
                          widget.order.totalAmount = finalTotal;
                          widget.order.deliveryTip = int.parse(_deliveryTipController.text);
                          int amount = (widget.order.totalAmount * 100).toInt();
                          final fp.Either<String, String> res =
                              await _paymentRepository.pay(
                            amount: amount,
                            itemsList: widget.cartItems,
                          );
                          res.fold(
                            (left) {
                              // Show UI error here to try again
                              debugPrint("Failed to initiate the payment ");
                            },
                            (right) {
                              String clientSecret = right;
                              // ROUTE to gateway screen
                              Navigator.pushNamed(
                                context,
                                "PaymentGatewayRoute",
                                arguments: {
                                  "clientSecret": clientSecret,
                                  "order": widget.order,
                                  "cartItems": widget.cartItems,
                                },
                              );
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
                          AppLocalizations.of(context)!.confirm_order,
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

Widget _buildLabeledTextField({
  required String hint,
  required TextEditingController controller,
  required ThemeMode themeMode,
  required bool themeDark,
  TextInputType? keyboardType,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  final textColor = themeMode == ThemeMode.light ? Colors.black : Colors.white;

  final inputStyle = TextStyle(
    color: textColor,
    fontSize: 12,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
  );

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    validator: validator,
    style: inputStyle,
    decoration: InputDecoration(
      constraints: const BoxConstraints(
        maxHeight: 42,
      ),
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color(0xFFCCCCCC) /* Gray-Smoke */,
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
      ),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0x4CAFAFAF),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0xFFE02C45),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 1,
          color: Color(0x4CAFAFAF),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
    ),
  );
}
