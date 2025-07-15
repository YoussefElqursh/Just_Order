import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: ShapeDecoration(
              color: const Color(0x19007BFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: setPhoto(
              kind: 0,
              path: 'assets/icons/order.png',
              height: 24,
              width: 24,
            ),
          ),
          const SizedBox(width: 12),
           SizedBox(
            width: 240,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 6,
              children: [
                const Text(
                  'New Order Received',
                  style: TextStyle(
                    color: Color(0xFF090909) /* Black */,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    height: 1.29,
                  ),
                ),
                const Spacer(),
                const Text.rich(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Order ',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: '#984',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: ' from restaurant ',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: 'Pizza King',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: ' has been placed by User ',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: '@MonaAli',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(
                          color: Color(0xFF898888) /* Gray-Dark */,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () {
                    return;
                  },
                  height: 32,
                  color: const Color(0x0CE02C45),
                  elevation: 0.0,
                  highlightElevation: 0.0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minWidth: 80,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'View Order',
                    style: TextStyle(
                      color: Color(0xFFE02C45) /* Primary */,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            spacing: 6,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const ShapeDecoration(
                  color: Color(0xFFE02C45),
                  shape: CircleBorder(),
                ),
              ),
              const Spacer(),
              const Text(
                '10 minutes ago',
                style: TextStyle(
                  color: Color(0xFF898888) /* Gray-Dark */,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                  height: 1.33,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
