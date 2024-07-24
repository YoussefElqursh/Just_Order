import 'branch_model.dart';

class Restaurant {
  String restaurantId;
  String name;
  String managerId;
  List<Branch> branches;

  Restaurant({
    required this.restaurantId,
    required this.name,
    required this.managerId,
    required this.branches,
  });
}


