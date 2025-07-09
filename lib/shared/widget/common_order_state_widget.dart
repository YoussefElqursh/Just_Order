import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/shared/style/colors.dart';
import 'package:just_order/shared/widget/common_button.dart';
import 'package:qr_flutter/qr_flutter.dart';

Widget buildOrderStateWidget({
  required BuildContext context,
  required double width,
  required Order order,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return Container(
    height: 96,
    width: MediaQuery.sizeOf(context).width,
    decoration: ShapeDecoration(
      color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0x4CAFAFAF),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container(
        //   width: 5,
        //   height: 96,
        //   decoration: ShapeDecoration(
        //     color: borderColor,
        //     shape: RoundedRectangleBorder(
        //       side: BorderSide(
        //         width: 1,
        //         strokeAlign: BorderSide.strokeAlignCenter,
        //         color: borderColor,
        //       ),
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(8),
        //         bottomLeft: Radius.circular(8),
        //       ),
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 40,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_rounded),
                        memCacheWidth: (MediaQuery.of(context).size.width *
                            MediaQuery.of(context).devicePixelRatio)
                            .round(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - width - 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                restaurant.name,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'OrderDetailsScreenRoute',
                                      arguments: [
                                        order,
                                        restaurant,
                                      ]);
                                },
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Color(0xFF898888),
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF898888),
                                size: 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateFormat('dd MMM yyyy hh:mm a')
                                    .format(order.createdAt),
                                style: const TextStyle(
                                  color: Color(0xFF898888),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Order ID: ${order.orderId}',
                      style: const TextStyle(
                        color: Color(0xFF898888),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Text(
                      'EGP ${order.totalAmount}',
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildOrderPendingStateWidget({
  required BuildContext context,
  required double width,
  required Order order,
  required Restaurant restaurant,
  required Function()? onPressed,
  required ThemeState state,
}) {
  // Calculate the time difference in minutes
  final now = DateTime.now();
  final orderTime = order.createdAt;
  final timeDifference = now.difference(orderTime).inMinutes;

  // Define color thresholds
  Color borderColor;
  if (timeDifference <= order.orderTimeOut * 0.25) {
    borderColor = Colors.green; // 0-25% of the order time
  } else if (timeDifference <= order.orderTimeOut * 0.5) {
    borderColor = Colors.yellow; // 25-50% of the order time
  } else if (timeDifference <= order.orderTimeOut * 0.75) {
    borderColor = Colors.orange; // 50-75% of the order time
  } else {
    borderColor = Colors.red; // 75-100% of the order time
  }

  return Container(
    height: 146,
    width: MediaQuery.sizeOf(context).width,
    decoration: ShapeDecoration(
      color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0x4CAFAFAF),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 146,
          decoration: ShapeDecoration(
            color: borderColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: borderColor,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 40,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_rounded),
                        memCacheWidth: (MediaQuery.of(context).size.width *
                            MediaQuery.of(context).devicePixelRatio)
                            .round(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - width - 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                restaurant.name,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'OrderDetailsScreenRoute',
                                      arguments: [
                                        order,
                                        restaurant,
                                      ]);
                                },
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Color(0xFF898888),
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF898888),
                                size: 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateFormat('dd MMM yyyy hh:mm a')
                                    .format(order.createdAt),
                                style: const TextStyle(
                                  color: Color(0xFF898888),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Order ID: ${order.orderId}',
                      style: const TextStyle(
                        color: Color(0xFF898888),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Text(
                      'EGP ${order.totalAmount}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                buildMaterialButton(
                  context: context,
                  onPressed: onPressed,
                  title: 'Cancel',
                  height: 36,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildOrderPreparingStateWidget({
  required BuildContext context,
  required double width,
  required Order order,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  // Calculate the time difference in minutes
  final now = DateTime.now();
  final orderTime = order.createdAt;
  final timeDifference = now.difference(orderTime).inMinutes;

  // Define color thresholds
  Color borderColor;
  if (timeDifference <= order.orderTimeOut * 0.25) {
    borderColor = Colors.green; // 0-25% of the order time
  } else if (timeDifference <= order.orderTimeOut * 0.5) {
    borderColor = Colors.yellow; // 25-50% of the order time
  } else if (timeDifference <= order.orderTimeOut * 0.75) {
    borderColor = Colors.orange; // 50-75% of the order time
  } else {
    borderColor = Colors.red; // 75-100% of the order time
  }

  return Container(
    height: 96,
    width: MediaQuery.sizeOf(context).width,
    decoration: ShapeDecoration(
      color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignCenter,
          color: Color(0x4CAFAFAF),
        ),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 5,
          height: 96,
          decoration: ShapeDecoration(
            color: borderColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: borderColor,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width - width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 40,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_rounded),
                        memCacheWidth: (MediaQuery.of(context).size.width *
                            MediaQuery.of(context).devicePixelRatio)
                            .round(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width - width - 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                restaurant.name,
                                style: TextStyle(
                                  color: state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'OrderDetailsScreenRoute',
                                      arguments: [
                                        order,
                                        restaurant,
                                      ]);
                                },
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Color(0xFF898888),
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF898888),
                                size: 12,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                DateFormat('dd MMM yyyy hh:mm a')
                                    .format(order.createdAt),
                                style: const TextStyle(
                                  color: Color(0xFF898888),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Order ID: ${order.orderId}',
                      style: const TextStyle(
                        color: Color(0xFF898888),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const Spacer(),
                    Text(
                      'EGP ${order.totalAmount}',
                      style: TextStyle(
                        color: state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildOrderOnWayStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
  required void Function()? onTap,
  bool isExpanded = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: !isExpanded ? 106 : 200,
      width: MediaQuery.sizeOf(context).width,
      decoration: ShapeDecoration(
        color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x4CAFAFAF),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: restaurant.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 40,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_rounded),
                          memCacheWidth: (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio)
                              .round(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - width - 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      'OrderDetailsScreenRoute',
                                      arguments: [
                                        order,
                                        restaurant,
                                      ],
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF898888),
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF898888),
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('dd MMM yyyy hh:mm a')
                                      .format(order.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF898888),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Order ID: ${order.orderId}',
                        style: const TextStyle(
                          color: Color(0xFF898888),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      Text(
                        'EGP ${order.totalAmount}',
                        style: TextStyle(
                          color: state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: isExpanded,
                    child: SizedBox(
                      width: MediaQuery.sizeOf(context).width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        spacing: 10,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                border: Border.all(
                                    color: const Color(0x66AFAFAF),
                                    style: BorderStyle.solid)),
                            child: QrImageView(
                              data: order.orderCode,
                              size: 80,
                              version: QrVersions.auto,
                              backgroundColor: state.themeMode == ThemeMode.dark
                                  ? Colors.black
                                  : Colors.white,
                              foregroundColor:
                                  state.themeMode == ThemeMode.light
                                      ? Colors.black
                                      : Colors.white,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              height: 30,
                              width: 2,
                              decoration: const ShapeDecoration(
                                color: Color(0x66AFAFAF),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    color: Color(0x66AFAFAF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            order.orderCode,
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildOrderDeliveredStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        'OrderDetailsScreenRoute',
        arguments: [
          order,
          restaurant,
        ],
      );
    },
    child: Container(
      height: 96,
      width: MediaQuery.sizeOf(context).width,
      decoration: ShapeDecoration(
        color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x4CAFAFAF),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: restaurant.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 40,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_rounded),
                          memCacheWidth: (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio)
                              .round(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - width - 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, 'OrderDetailsScreenRoute',
                                        arguments: [
                                          order,
                                          restaurant,
                                        ]);
                                  },
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF898888),
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF898888),
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('dd MMM yyyy hh:mm a')
                                      .format(order.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF898888),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Order ID: ${order.orderId}',
                        style: const TextStyle(
                          color: Color(0xFF898888),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      Text(
                        'EGP ${order.totalAmount}',
                        style: TextStyle(
                          color: state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
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
  );
}

Widget buildOrderDeclinedStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        'OrderDetailsScreenRoute',
        arguments: [
          order,
          restaurant,
        ],
      );
    },
    child: Container(
      height: 96,
      width: MediaQuery.sizeOf(context).width,
      decoration: ShapeDecoration(
        color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x4CAFAFAF),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: restaurant.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 40,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_rounded),
                          memCacheWidth: (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio)
                              .round(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - width - 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      'OrderDetailsScreenRoute',
                                      arguments: [
                                        order,
                                        restaurant,
                                      ],
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF898888),
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF898888),
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('dd MMM yyyy hh:mm a')
                                      .format(order.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF898888),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Order ID: ${order.orderId}',
                        style: const TextStyle(
                          color: Color(0xFF898888),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      Text(
                        'EGP ${order.totalAmount}',
                        style: TextStyle(
                          color: state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
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
  );
}

Widget buildOrderAutoDeclinedStateWidget({
  required BuildContext context,
  required Order order,
  required double width,
  required Restaurant restaurant,
  required ThemeState state,
}) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        'OrderDetailsScreenRoute',
        arguments: [
          order,
          restaurant,
        ],
      );
    },
    child: Container(
      height: 96,
      width: MediaQuery.sizeOf(context).width,
      decoration: ShapeDecoration(
        color: state.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: Color(0x4CAFAFAF),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width - width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignCenter,
                              color: Color(0xFFF4F4F4),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: restaurant.imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 40,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_rounded),
                          memCacheWidth: (MediaQuery.of(context).size.width *
                              MediaQuery.of(context).devicePixelRatio)
                              .round(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width - width - 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    color: state.themeMode == ThemeMode.light
                                        ? Colors.black
                                        : Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      'OrderDetailsScreenRoute',
                                      arguments: [
                                        order,
                                        restaurant,
                                      ],
                                    );
                                  },
                                  child: const Icon(
                                    Icons.more_horiz,
                                    color: Color(0xFF898888),
                                    size: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_month_outlined,
                                  color: Color(0xFF898888),
                                  size: 12,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  DateFormat('dd MMM yyyy hh:mm a')
                                      .format(order.createdAt),
                                  style: const TextStyle(
                                    color: Color(0xFF898888),
                                    fontSize: 10,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Order ID: ${order.orderId}',
                        style: const TextStyle(
                          color: Color(0xFF898888),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      Text(
                        'EGP ${order.totalAmount}',
                        style: TextStyle(
                          color: state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
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
  );
}
