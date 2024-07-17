import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

class RestaurantsWidget extends StatefulWidget {
  const RestaurantsWidget({super.key});

  @override
  State<RestaurantsWidget> createState() => _RestaurantsWidgetState();
}

class _RestaurantsWidgetState extends State<RestaurantsWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        navigateTo(context, 'RestaurantScreenRoute');
      },
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: ShapeDecoration(
              image: const DecorationImage(
                image: NetworkImage("https://via.placeholder.com/90x90"),
                fit: BoxFit.cover,
              ),
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  width: 1.50,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFEBEBEB),
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 160,
                  height: 24.0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Havarti',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: (){},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Color(0xFF898888),
                          size: 15,),
                      ),
                    ],
                  ),
                ),

                const Text(
                     'Sandwiches, Fast Food, Egyptian',
                     style: TextStyle(
                       color: Color(0xFFAFAFAF),
                       fontSize: 10,
                       fontFamily: 'Inter',
                       fontWeight: FontWeight.w400,
                     ),
                     overflow: TextOverflow.ellipsis,
                     maxLines: 1,
                   ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.yellow.shade700, size: 15),
                    const SizedBox(width: 6),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '4.8',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: ' (79)',
                            style: TextStyle(
                              color: Color(0xFFAFAFAF),
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.timer, color: Colors.black, size: 15,),
                        SizedBox(width: 6),
                        Text(
                          '21 mins',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 6),
                    Text(
                      '•',
                      style: TextStyle(
                        color: Color(0xFFAFAFAF),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(width: 6),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.delivery_dining_outlined, color: Colors.black, size: 15,),
                        SizedBox(width: 6),
                        Text(
                          'Free',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
