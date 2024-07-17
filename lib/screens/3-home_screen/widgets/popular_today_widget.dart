import 'package:flutter/material.dart';

class PopularTodayWidget extends StatefulWidget {
  const PopularTodayWidget({super.key});

  @override
  State<PopularTodayWidget> createState() => _PopularTodayWidgetState();
}

class _PopularTodayWidgetState extends State<PopularTodayWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 155,
          height: 120,
          decoration: const ShapeDecoration(
            image: DecorationImage(
              image: NetworkImage("https://via.placeholder.com/155x120"),
              fit: BoxFit.cover,
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1.50,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFFEBEBEB),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 5),
              const Text(
                'Sandwiches, Fast Food',
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
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.yellow.shade700, size: 12),
                  const SizedBox(width: 6),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '4.3',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' (86)',
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
            ],
          ),
        ),
      ],
    );
  }
}
