import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/meal_widget.dart';
import 'package:just_order/shared/widget/shimmer_widget.dart';

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
  FilterWidgetState createState() => FilterWidgetState();
}

class FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header text
          Text(
            widget.filters,
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

          // Content area
          Expanded(
            child: widget.items.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => buildMealWidget(
                      context: context,
                      item: widget.items[index],
                      state: widget.state,
                    ),
                    separatorBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    itemCount: widget.items.length,
                  )
                : Center(
                    child: Text(
                      'No Meals',
                      style: TextStyle(
                        color: widget.state.themeMode == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class FilterWidgetShimmer extends StatelessWidget {
  const FilterWidgetShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerLoading.rectangular(
              height: 120,
              width: double.infinity,
              shapeBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            const ShimmerLoading.rectangular(height: 16, width: 100),
            const SizedBox(height: 4),
            const ShimmerLoading.rectangular(height: 14, width: 60),
            const SizedBox(height: 8),
            const ShimmerLoading.rectangular(height: 16, width: 80),
          ],
        );
      },
    );
  }
}
