import 'package:flutter/material.dart';
import 'package:just_order/shared/function/functions.dart';
import 'package:just_order/shared/widget/custom_check_box_button_widget.dart';
import 'package:just_order/shared/widget/custom_radio_button_widget.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key});

  static const String routeName = 'MealDetailsScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const MealDetailsScreen(),
    );
  }

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  int counter = 1;
  bool isChecked = false;
  bool isChecked1 = false;
  String mealSize = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://via.placeholder.com/360x250"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 250,
                        right: 20,
                        child: Container(
                          width: 60,
                          height: 30,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          clipBehavior: Clip.antiAlias,
                          decoration: const ShapeDecoration(
                            color: Color(0xFFE02C45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '10% Off',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
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
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 50.0, left: 20.0, right: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Chicken Ranch Pizza',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Juicy chicken, tangy ranch dressing, melted cheese, fresh vegetables, crispy pizza crust. ',
                        style: TextStyle(
                          color: Color(0xFFAFAFAF),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 26.0),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'EGP 120.00',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Spacer(),
                          Text(
                            'EGP 130.00',
                            style: TextStyle(
                              color: Color(0xFFE02C45),
                              fontSize: 12,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Color(0xFFE02C45),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      const SizedBox(height: 26.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pizza Size',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Choose 1 option ',
                                style: TextStyle(
                                  color: Color(0xFFAFAFAF),
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            width: 63,
                            height: 23,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x0CE02C45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Required',
                                style: TextStyle(
                                  color: Color(0xFFE02C45),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      customRadioButtonWidget(
                          context: context,
                          width: MediaQuery.sizeOf(context).width,
                          hasDivider: true,
                          label: 'Medium',
                          groupName: mealSize,
                          value: 'Medium',
                          onChanged: (value) {
                            setState(() {
                              mealSize = value.toString();
                            });
                          }),
                      const SizedBox(height: 10.0),
                      customRadioButtonWidget(
                          context: context,
                          width: MediaQuery.sizeOf(context).width,
                          hasDivider: false,
                          hasExtraText: true,
                          extraText: '(+EGP 60.00)',
                          label: 'Large',
                          groupName: mealSize,
                          value: 'Large',
                          onChanged: (value) {
                            setState(() {
                              mealSize = value.toString();
                            });
                          }),
                      const SizedBox(height: 26.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Extras',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                              SizedBox(height: 6),
                              Text('Choose up to 1 option ',
                                  style: TextStyle(
                                    color: Color(0xFFAFAFAF),
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            width: 63,
                            height: 23,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0xFFF4F4F4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Optional',
                                style: TextStyle(
                                  color: Color(0xFF898888),
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25.0),
                      customCheckBoxButtonWidget(
                        context: context,
                        hasExtraText: true,
                        extraText: '(+EGP 30.00)',
                        label: 'Extra medium cheese',
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = !isChecked;
                          });
                        },
                      ),
                      const SizedBox(height: 10.0),
                      customCheckBoxButtonWidget(
                        context: context,
                        hasDivider: false,
                        hasExtraText: true,
                        extraText: '(+EGP 40.00)',
                        label: 'Extra large cheese',
                        value: isChecked1,
                        onChanged: (value) {
                          setState(() {
                            isChecked1 = !isChecked1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(
                height: 1,
                color: Color(0x4CC8C8C8),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Quantity Order',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                          const Spacer(),
                          Container(
                            width: 34,
                            height: 34,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x0CE02C45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  counter--;
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: Color(0xFFE02C45),
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
                          const SizedBox(width: 10.0),
                          Text('$counter',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1),
                          const SizedBox(width: 10.0),
                          Container(
                            width: 34,
                            height: 34,
                            clipBehavior: Clip.antiAlias,
                            decoration: ShapeDecoration(
                              color: const Color(0x0CE02C45),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  counter++;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xFFE02C45),
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
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        height: 42,
                        minWidth: MediaQuery.sizeOf(context).width,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        color: const Color(0xFFE02C45),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Add to Cart ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                            Spacer(),
                            Text('EGP 300.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                            SizedBox(width: 2),
                            Text('EGP 320.00',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateTo(context, 'MyCartScreenRoute');
        },
        backgroundColor: const Color(0xFFE02C45),
        shape: const CircleBorder(
          side: BorderSide(
            color: Color(0xFFE02C45),
          ),
        ),
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18,),
      ),
    );
  }
}
