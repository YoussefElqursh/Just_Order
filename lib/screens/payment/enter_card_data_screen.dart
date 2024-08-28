import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';

class EnterCardDataScreen extends StatefulWidget {
  const EnterCardDataScreen({super.key});

  static const String routeName = 'EnterCardDataScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const EnterCardDataScreen(),
    );
  }

  @override
  State<EnterCardDataScreen> createState() => _EnterCardDataScreenState();
}

class _EnterCardDataScreenState extends State<EnterCardDataScreen> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Card',
          style: TextStyle(
            color: Colors.black,
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
          height: MediaQuery.sizeOf(context).height - 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                SizedBox(
                  width: 200,
                  height: 25,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      setPhoto(
                          kind: 1,
                          path: 'assets/images/Meeza.svg',
                          height: 20.0,
                          width: 50.0),
                      setPhoto(
                          kind: 1,
                          path: 'assets/images/Visa.svg',
                          height: 20.0,
                          width: 50.0),
                      setPhoto(
                          kind: 1,
                          path: 'assets/images/Mastercard.svg',
                          height: 20.0,
                          width: 50.0),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cardholder Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      style: const TextStyle(
                        color: Color(0xFF23262A),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      keyboardType: TextInputType.name,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        constraints: const BoxConstraints(
                          maxWidth: 370,
                          maxHeight: 42,
                        ),
                        hintText: 'John Doe',
                        hintStyle: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                              color: Color(0x4CAFAFAF),
                              strokeAlign: BorderSide.strokeAlignCenter,
                              width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                              color: Color(0x4CAFAFAF),
                              strokeAlign: BorderSide.strokeAlignCenter,
                              width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Number',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      style: const TextStyle(
                        color: Color(0xFF23262A),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      keyboardType: TextInputType.number,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        constraints: const BoxConstraints(
                          maxWidth: 370,
                          maxHeight: 42,
                        ),
                        hintText: 'John Doe',
                        hintStyle: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                              color: Color(0x4CAFAFAF),
                              strokeAlign: BorderSide.strokeAlignCenter,
                              width: 1.5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                              color: Color(0x4CAFAFAF),
                              strokeAlign: BorderSide.strokeAlignCenter,
                              width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width - 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Expire Date',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            style: const TextStyle(
                              color: Color(0xFF23262A),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            keyboardType: TextInputType.datetime,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Color(0xFFAFAFAF),
                                size: 15,
                              ),
                              constraints: const BoxConstraints(
                                maxWidth: 150,
                                maxHeight: 42,
                              ),
                              hintText: 'MM/YY',
                              hintStyle: const TextStyle(
                                color: Color(0xFFCCCCCC),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: Color(0x4CAFAFAF),
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: Color(0x4CAFAFAF),
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Security Code (CCV)',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            style: const TextStyle(
                              color: Color(0xFF23262A),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              constraints: const BoxConstraints(
                                maxWidth: 150,
                                maxHeight: 42,
                              ),
                              suffixIcon: const Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFFAFAFAF),
                                size: 16,
                              ),
                              hintText: '123',
                              hintStyle: const TextStyle(
                                color: Color(0xFFCCCCCC),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: Color(0x4CAFAFAF),
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                    color: Color(0x4CAFAFAF),
                                    strokeAlign: BorderSide.strokeAlignCenter,
                                    width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: const Color(0xFFE02C45),
                      checkColor: Colors.white,
                      side:
                          const BorderSide(color: Color(0xFFAFAFAF), width: 1),
                      onChanged: (value) {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                    ),
                    const Text(
                      'Save this card for faster payments.',
                      style: TextStyle(
                        color: Color(0xFF898888),
                        fontSize: 10,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
                const Spacer(),
                MaterialButton(
                  onPressed: () {
                    navigateTo(context, 'OrderSummaryScreenRoute');
                  },
                  height: 42,
                  minWidth: MediaQuery.sizeOf(context).width,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  color: const Color(0xFFE02C45),
                  child: const Center(
                    child: Text('Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
