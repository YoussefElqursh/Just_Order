import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

class PlaceDetailsSheet extends StatefulWidget {
  const PlaceDetailsSheet({super.key});

  @override
  State<PlaceDetailsSheet> createState() => _PlaceDetailsSheetState();
}

class _PlaceDetailsSheetState extends State<PlaceDetailsSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 5,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0x4CAFAFAF),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Club Name',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          maxLines: 1,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: true,
                          style: const TextStyle(
                            color: Color(0x4CAFAFAF),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 2.3,
                              maxHeight: 42,
                            ),
                            hintText: 'club name',
                            hintStyle: const TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Table code',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          maxLines: 1,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                          readOnly: true,
                          style: const TextStyle(
                            color: Color(0x4CAFAFAF),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.sizeOf(context).width / 2.3,
                              maxHeight: 42,
                            ),
                            hintText: 'table code',
                            hintStyle: const TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                width: 1,
                                color: Color(0x4CAFAFAF),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: () {
                      navigateTo(context, 'SelectYourPlaceRoute');
                    },
                    height: 36,
                    clipBehavior: Clip.antiAlias,
                    color: const Color(0xFFE02C45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Scan Again',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.remove,
                color: Color(0xFFE02C45),
                size: 18,
              ),
            ),
          ],
        ));
  }
}
