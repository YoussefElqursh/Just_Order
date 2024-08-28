import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/shared/widget/custom_radio_button_widget.dart';

class PayMethodScreen extends StatefulWidget {
  const PayMethodScreen({super.key});

  static const String routeName = 'PayMethodScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const PayMethodScreen(),
    );
  }

  @override
  State<PayMethodScreen> createState() => _PayMethodScreenState();
}

class _PayMethodScreenState extends State<PayMethodScreen> {
  String? paymentMethod;
  String? cardKind;
  bool clicked1 = false;
  bool clicked2 = false;
  bool clicked3 = false;
  bool clicked4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Payment Method',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 50.0),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: clicked1
                            ? const Color(0xFFE02C45)
                            : const Color(0x4CAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: const Color(0x19548229),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: setPhoto(
                            kind: 1,
                            path: 'assets/images/cash.svg',
                            width: 20.0,
                            height: 20.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 5),
                          customRadioButtonWidget(
                            context: context,
                            width: MediaQuery.sizeOf(context).width - 111,
                            hasDivider: false,
                            label: 'Cash on Delivery',
                            value: 'Cash on Delivery',
                            groupName: paymentMethod,
                            onChanged: (value) {
                              setState(() {
                                paymentMethod = value!;
                                clicked1 = true;
                                clicked2 = false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: clicked2
                            ? const Color(0xFFE02C45)
                            : const Color(0x4CAFAFAF),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x19548229),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Center(
                              child: setPhoto(
                                kind: 1,
                                path: 'assets/images/credit.svg',
                                width: 20.0,
                                height: 20.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 5),
                              customRadioButtonWidget(
                                context: context,
                                width: MediaQuery.sizeOf(context).width - 111,
                                hasDivider: false,
                                label: 'Credit/Debit Card',
                                value: 'Credit/Debit Card',
                                groupName: paymentMethod,
                                onChanged: (value) {
                                  setState(() {
                                    paymentMethod = value!;
                                    clicked1 = false;
                                    clicked2 = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        child: clicked2
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 65,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: clicked3
                                                    ? const Color(0xFFE02C45)
                                                    : const Color(0x4CAFAFAF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 34,
                                                height: 34,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0x19548229),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: setPhoto(
                                                    kind: 1,
                                                    path:
                                                        'assets/images/Visa.svg',
                                                    width: 20.0,
                                                    height: 20.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  customRadioButtonWidget(
                                                    context: context,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width -
                                                        156,
                                                    hasDivider: false,
                                                    label:
                                                        'xxxx xxxx xxxx 8954',
                                                    value: 'visa',
                                                    groupName: cardKind,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        cardKind = value!;
                                                        clicked2 = true;
                                                        clicked3 = true;
                                                        clicked4 = false;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 65,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: clicked4
                                                    ? const Color(0xFFE02C45)
                                                    : const Color(0x4CAFAFAF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 34,
                                                height: 34,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color:
                                                      const Color(0x19548229),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                child: Center(
                                                  child: setPhoto(
                                                    kind: 1,
                                                    path:
                                                        'assets/images/Mastercard.svg',
                                                    width: 20.0,
                                                    height: 20.0,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const SizedBox(height: 5),
                                                  customRadioButtonWidget(
                                                    context: context,
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width -
                                                        156,
                                                    hasDivider: false,
                                                    label:
                                                        'xxxx xxxx xxxx 1457',
                                                    value: 'mastercard',
                                                    groupName: cardKind,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        cardKind = value!;
                                                        clicked2 = true;
                                                        clicked4 = true;
                                                        clicked3 = false;
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width,
                                          height: 65,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 1,
                                                strokeAlign: BorderSide
                                                    .strokeAlignCenter,
                                                color: Color(0x4CAFAFAF),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 34,
                                                height: 34,
                                                clipBehavior: Clip.antiAlias,
                                                decoration:
                                                    const ShapeDecoration(
                                                  color: Color(0xFFE02C45),
                                                  shape: CircleBorder(),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    navigateTo(context,
                                                        'EnterCardDataScreenRoute');
                                                  },
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                  style: const ButtonStyle(
                                                    shape:
                                                        WidgetStatePropertyAll(
                                                      CircleBorder(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 28.0),
                                              const Text(
                                                'Add Card',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
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
