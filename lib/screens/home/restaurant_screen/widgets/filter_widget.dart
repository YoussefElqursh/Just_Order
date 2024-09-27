import 'package:flutter/material.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/meal_widget.dart';

class FilterWidget extends StatefulWidget {
  final List<Item> items;

  const FilterWidget({required this.items, super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Item> items = widget.items;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            'Trending',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 12.0),
          SizedBox(
            width: double.infinity,
            child: ListView.separated(
              itemBuilder: (context, index) =>
                  buildMealWidget(context: context, item: items[index]),
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              itemCount: items.length,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
