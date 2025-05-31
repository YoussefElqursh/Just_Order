import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/order_model.dart' as order_model;
import 'package:just_order/models/restaurant_model.dart';

class UserRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Restaurant>> getRestaurants(String code) async {
    String clubId = int.parse(code.substring(0, 2)).toString();

    QuerySnapshot snapshot = await firestore
        .collection('restaurants')
        .where('clubId', isEqualTo: clubId)
        .get();

    List<Restaurant> restaurants = [];

    for (var doc in snapshot.docs) {
      restaurants.add(Restaurant.fromMap(doc.data() as Map<String, dynamic>));
    }

    return restaurants;
  }

  Future<List<Item>> getItems(List<String> itemIds) async {
    List<Item> items = [];
    Set<String> itemIdSet = itemIds.toSet();
    List<Future<void>> futures = [];

    for (int i = 0; i < itemIds.length; i += 20) {
      // Adjusted batch size to 20
      final batchIds =
          itemIds.sublist(i, i + 20 > itemIds.length ? itemIds.length : i + 20);

      futures.add(
        firestore
            .collection('items')
            .where(FieldPath.documentId, whereIn: batchIds)
            .get()
            .then(
          (QuerySnapshot snapshot) {
            for (var doc in snapshot.docs) {
              Item item = Item.fromMap(doc.data() as Map<String, dynamic>);
              if (item.available && itemIdSet.contains(doc.id)) {
                items.add(item);
              }
            }
          },
        ),
      );
    }

    await Future.wait(futures);
    return items;
  }

  Future<String> pushOrder(
      order_model.Order order,
      List<CartItem> cartItems,
      ) async {
    final orderRef = firestore.collection('orders').doc(order.orderId);

    for (CartItem cartItem in cartItems) {
      cartItem.cartItemId = orderRef.collection('cartItems').doc().id;
    }

    await firestore.runTransaction((transaction) async {
      transaction.set(orderRef, order.toMap());

      for (CartItem cartItem in cartItems) {
        final cartItemRef =
        orderRef.collection('cartItems').doc(cartItem.cartItemId);
        transaction.set(cartItemRef, cartItem.toMap());
      }
    });

    return 'Order placed successfully with order id: ${order.orderId} and cart items: ${cartItems.length}';
  }

}
