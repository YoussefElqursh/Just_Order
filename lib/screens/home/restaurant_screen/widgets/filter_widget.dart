import 'package:flutter/material.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/meal_widget.dart';

class FilterWidget extends StatefulWidget {
  final List<String> itemIds;

  const FilterWidget({required this.itemIds, Key? key}) : super(key: key);

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  late Future<List<Item>> _itemsFuture;
  final UserRepository userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _itemsFuture = userRepository.getItems(widget.itemIds);
  }

  @override
  Widget build(BuildContext context) {
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
          FutureBuilder<List<Item>>(
            future: _itemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading items'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No items found'));
              } else {
                List<Item> items = snapshot.data!;
                return SizedBox(
                  width: double.infinity,
                  child: ListView.separated(
                    itemBuilder: (context, index) => buildMealWidget(context: context, item: items[index]),
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
                );
              }
            },
          ),
        ],
      ),
    );
  }
}