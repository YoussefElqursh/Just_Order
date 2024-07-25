import 'item_model.dart';

class Branch {
  String branchId;
  String location;
  String managerId;
  List<Item> items;

  Branch({
    required this.branchId,
    required this.location,
    required this.managerId,
    required this.items,
  });
}