import 'package:flutter/material.dart';

Container buildOrderStateWidget({
  required BuildContext context,
  required double width,
}) {
  return Container(
    height: 96,
    width: MediaQuery.sizeOf(context).width,
    decoration: const ShapeDecoration(
      color: Colors.white,
      shape: RoundedRectangleBorder(
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
          decoration: const ShapeDecoration(
            color: Colors.red,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Colors.red,
              ),
              borderRadius: BorderRadius.only(
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
                        image: const DecorationImage(
                          image: NetworkImage("https://via.placeholder.com/40x40"),
                          fit: BoxFit.cover,
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0xFFF4F4F4),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
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
                              const Text(
                                'Pizza King',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'OrderDetailsScreenRoute');
                                },
                                child: const Icon(
                                  Icons.more_horiz,
                                  color: Color(0xFF898888),
                                  size: 18.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFF898888),
                                size: 12,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '20-41-5252:20-20',
                                style: TextStyle(
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
                const Row(
                  children: [
                    Text(
                      'Order ID: 55',
                      style: TextStyle(
                        color: Color(0xFF898888),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Spacer(),
                    Text(
                      'EGP 10',
                      style: TextStyle(
                        color: Colors.black,
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
