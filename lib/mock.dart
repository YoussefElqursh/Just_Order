import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/invoice_model.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/order_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';

class Mock {
  late User user;
  late User user2;
  late User user3;

  late Restaurant restaurant;
  late Restaurant restaurant2;
  late Restaurant restaurant3;

  late Order order;
  late Order order2;
  late Order order3;

  late Item item;
  late Item item2;
  late Item item3;

  late Invoice invoice;
  late Invoice invoice2;
  late Invoice invoice3;

  late CartItem cartItem;
  late CartItem cartItem2;
  late CartItem cartItem3;

  Mock._create();

  static Future<Mock> create() async {
    Mock mock = Mock._create();


    return mock;
  }
}
