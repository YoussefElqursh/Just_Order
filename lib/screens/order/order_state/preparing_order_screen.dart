import 'package:flutter/material.dart';
import '../../../shared/widget/common_order_state_widget.dart';

class PreparingOrderScreen extends StatefulWidget {
  const PreparingOrderScreen({super.key});

  static const String routeName = 'PreparingOrderScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const PreparingOrderScreen(),
    );
  }

  @override
  State<PreparingOrderScreen> createState() => _PreparingOrderScreenState();
}

class _PreparingOrderScreenState extends State<PreparingOrderScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Preparing Orders',
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
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
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
          child: ListView.separated(
            itemBuilder: (context, index) => buildOrderStateWidget(
              context: context,
              width: 70,),
            separatorBuilder: (context, index) => const SizedBox(
              height: 12.0,
            ),
            itemCount: 5,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}
