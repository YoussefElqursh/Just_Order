import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/shared/function/functions.dart';

import '../../../shared/widget/common_order_state_widget.dart';

class PreparingOrderScreen extends StatefulWidget {
  final List<Order> orders;
  final Map<String, Restaurant> restaurantMap;

  const PreparingOrderScreen(
      {super.key, required this.orders, required this.restaurantMap});

  static const String routeName = 'PreparingOrderScreenRoute';

  static Route route(
      {required List<Order> orders,
      required Map<String, Restaurant> restaurantMap}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) =>
          PreparingOrderScreen(orders: orders, restaurantMap: restaurantMap),
    );
  }

  @override
  State<PreparingOrderScreen> createState() => _PreparingOrderScreenState();
}

class _PreparingOrderScreenState extends State<PreparingOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              AppLocalizations.of(context)!.preparing_orders,
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
              padding:
                  const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Container(
                width: 34,
                height: 34,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: const Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  if (widget.orders.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            setPhoto(
                              kind: 0,
                              path: 'assets/images/order.png',
                              height: 100,
                              width: 250,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              AppLocalizations.of(context)!.no_preparing_orders,
                              style: TextStyle(
                                color: state.themeMode == ThemeMode.light
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.separated(
                      itemBuilder: (context, index) => buildOrderStateWidget(
                        context: context,
                        width: 70,
                        order: widget.orders[index],
                        restaurant: widget
                            .restaurantMap[widget.orders[index].restaurantId]!,
                        state: state,
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 12.0,
                      ),
                      itemCount: widget.orders.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
