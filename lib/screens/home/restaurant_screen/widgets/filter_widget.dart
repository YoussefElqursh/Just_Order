import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/meal_widget.dart';

class FilterWidget extends StatefulWidget {
  final List<Item> items;
  final String filters;
  final ThemeState state;

  const FilterWidget({
    required this.items,
    super.key,
    required this.filters,
    required this.state,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Item> items = widget.items;
    final String filters = widget.filters;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            filters,
            style: TextStyle(
              color: widget.state.themeMode == ThemeMode.light
                  ? Colors.black
                  : Colors.white,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 12.0),
          items.isNotEmpty
              ? SizedBox(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height - 582,
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildMealWidget(
                      context: context,
                      item: items[index],
                      state: widget.state,
                    ),
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
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Meals',
                        style: TextStyle(
                          color: widget.state.themeMode == ThemeMode.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
