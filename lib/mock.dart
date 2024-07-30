import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/club_model.dart';
import 'package:just_order/models/coupon_model.dart';
import 'package:just_order/models/enums/item_type.dart';
import 'package:just_order/models/enums/order_status.dart';
import 'package:just_order/models/enums/payment_type.dart';
import 'package:just_order/models/enums/user_type.dart';
import 'package:just_order/models/invoice_model.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/meal_details_model.dart';
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

  late MealDetails mealDetails;
  late MealDetails mealDetails2;
  late MealDetails mealDetails3;

  late Item item;
  late Item item2;
  late Item item3;

  late Invoice invoice;
  late Invoice invoice2;
  late Invoice invoice3;

  late Coupon coupon;
  late Coupon coupon2;
  late Coupon coupon3;

  late Club club;
  late Club club2;
  late Club club3;

  late CartItem cartItem;
  late CartItem cartItem2;
  late CartItem cartItem3;

  Mock._create();

  static Future<Mock> create() async {
    Mock mock = Mock._create();

    mock.user = User(
      userId: "1",
      firstName: "ziad",
      lastName: "ezzat",
      email: "ziadezzat@gmail.com",
      password: "123456",
      phoneNumber: "01000000000",
      userType: UserType.customer,
      emailVerified: true,
      phoneNumberVerified: true,
      createdAt: "2023-09-01T00:00:00.000Z",
    );
    mock.user2 = User(
      userId: "2",
      firstName: "youssif",
      lastName: "ramadan",
      email: "yousseframadan@gmail.com",
      password: "123456",
      phoneNumber: "01000000000",
      userType: UserType.customer,
      emailVerified: true,
      phoneNumberVerified: true,
      createdAt: "2022-09-01T00:00:00.000Z",
      updatedAt: "2023-09-01T00:00:00.000Z",
    );
    mock.user3 = User(
      userId: "3",
      firstName: "saif",
      lastName: "elden",
      email: "saifelden@gmail.com",
      password: "123456",
      phoneNumber: "01000000000",
      userType: UserType.customer,
      emailVerified: true,
      phoneNumberVerified: true,
      createdAt: "2020-09-01T00:00:00.000Z",
    );

    mock.mealDetails = MealDetails(
      mainItems: ['Burger', 'Pizza', 'Pasta'],
      sideItems: ['Fries', 'Salad', 'Soup'],
      drinkItems: ['Coke', 'Pepsi', 'Water'],
      sauceItems: ['Ketchup', 'Mayo', 'Mustard'],
      selectMultipleMain: true,
      selectMultipleSide: true,
      selectMultipleDrink: false,
      selectMultipleSauce: false,
    );
    mock.mealDetails2 = MealDetails(
      drinkItems: ['Coke', 'Pepsi', 'Water'],
      selectMultipleMain: false,
      selectMultipleSide: false,
      selectMultipleDrink: true,
      selectMultipleSauce: false,
    );
    mock.mealDetails3 = MealDetails(
      mainItems: ['Burger', 'Pizza', 'Pasta'],
      sideItems: ['Fries', 'Salad', 'Soup'],
      drinkItems: ['Coke', 'Pepsi', 'Water'],
      sauceItems: ['Ketchup', 'Mayo', 'Mustard'],
      selectMultipleMain: true,
      selectMultipleSide: true,
      selectMultipleDrink: false,
      selectMultipleSauce: false,
    );

    mock.item = Item(
      itemId: "1",
      name: "Chicken Burger",
      type: ItemType.meal,
      description: "A delicious chicken burger",
      price: 10.0,
      extras: ["Cheese", "Tomato", "Lettuce"],
      available: true,
      mealDetails: mock.mealDetails,
    );
    mock.item2 = Item(
      itemId: "2",
      name: "Beef Burger",
      type: ItemType.meal,
      description: "A delicious beef burger",
      price: 15.0,
      extras: ["Cheese", "Tomato", "Lettuce"],
      available: true,
      mealDetails: mock.mealDetails2,
    );
    mock.item3 = Item(
      itemId: "3",
      name: "Veggie Burger",
      type: ItemType.meal,
      description: "A delicious veggie burger",
      price: 20.0,
      extras: ["Cheese", "Tomato", "Lettuce"],
      available: true,
      mealDetails: mock.mealDetails3,
    );

    mock.invoice = Invoice(
      invoiceId: '1',
      orderId: '1',
      clubId: '1',
      restaurantId: '1',
      serviceFees: 10.0,
      totalFees: 100.0,
      createdAt: DateTime.now(),
    );
    mock.invoice2 = Invoice(
      invoiceId: '2',
      orderId: '2',
      clubId: '2',
      restaurantId: '2',
      serviceFees: 20.0,
      totalFees: 200.0,
      createdAt: DateTime.now(),
    );
    mock.invoice3 = Invoice(
      invoiceId: '3',
      orderId: '3',
      clubId: '3',
      restaurantId: '3',
      serviceFees: 30.0,
      totalFees: 300.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    mock.coupon = Coupon(
      couponId: '1',
      code: 'COUPON',
      discountPercentage: 10.0,
      createdAt: DateTime.now(),
      expiredAt: DateTime.now(),
    );
    mock.coupon2 = Coupon(
      couponId: '2',
      code: 'COUPON2',
      discountPercentage: 20.0,
      createdAt: DateTime.now(),
      expiredAt: DateTime.now(),
    );
    mock.coupon3 = Coupon(
      couponId: '3',
      code: 'COUPON3',
      discountPercentage: 30.0,
      createdAt: DateTime.now(),
      expiredAt: DateTime.now(),
    );

    mock.restaurant = Restaurant(
      restaurantId: "1",
      name: "elKarawan",
      managerId: "1",
      items: [
        mock.item,
        mock.item2,
        mock.item3,
      ],
    );
    mock.restaurant2 = Restaurant(
      restaurantId: "2",
      name: "elKedawy",
      managerId: "2",
      items: [
        mock.item,
        mock.item2,
        mock.item3,
      ],
    );
    mock.restaurant3 = Restaurant(
      restaurantId: "3",
      name: "amraaelsham",
      managerId: "3",
      items: [
        mock.item,
        mock.item2,
        mock.item3,
      ],
    );

    mock.cartItem = CartItem(
      cartItemId: '1',
      itemId: '1',
      quantity: 1,
      price: 10.0,
      description: 'description',
    );
    mock.cartItem2 = CartItem(
      cartItemId: '2',
      itemId: '2',
      quantity: 2,
      price: 20.0,
      description: 'description',
      extras: ['extra1', 'extra2'],
    );
    mock.cartItem3 = CartItem(
      cartItemId: '3',
      itemId: '3',
      quantity: 3,
      price: 30.0,
      description: 'description',
    );

    mock.order = Order(
      orderId: '1',
      userId: '1',
      clubId: '1',
      restaurantId: '1',
      cartItems: [
        mock.cartItem,
        mock.cartItem2,
        mock.cartItem3,
      ],
      deliveryId: '1',
      status: OrderStatus.pending,
      paymentType: PaymentType.cash,
      invoiceId: '1',
      notes: 'No onions',
      orderDateTime: DateTime.now(),
      createdAt: DateTime.now().toString(),
    );
    mock.order2 = Order(
      orderId: '2',
      userId: '2',
      clubId: '2',
      restaurantId: '2',
      cartItems: [
        mock.cartItem,
        mock.cartItem2,
        mock.cartItem3,
      ],
      deliveryId: '2',
      status: OrderStatus.accepted,
      paymentType: PaymentType.cash,
      invoiceId: '2',
      notes: 'No onions',
      orderDateTime: DateTime.now(),
      createdAt: DateTime.now().toString(),
    );
    mock.order3 = Order(
      orderId: '3',
      userId: '3',
      clubId: '3',
      restaurantId: '3',
      cartItems: [
        mock.cartItem,
        mock.cartItem2,
        mock.cartItem3,
      ],
      deliveryId: '3',
      status: OrderStatus.onTheWay,
      paymentType: PaymentType.card,
      invoiceId: '3',
      notes: 'No onions',
      orderDateTime: DateTime.now(),
      assignedDateTime: DateTime.now(),
      createdAt: DateTime.now().toString(),
    );

    mock.club = Club(
      clubId: '1',
      name: 'Club 1',
      location: 'Cairo',
      restaurants: [mock.restaurant, mock.restaurant2],
    );
    mock.club2 = Club(
      clubId: '2',
      name: 'Club 2',
      location: 'Giza',
      restaurants: [mock.restaurant, mock.restaurant3],
    );
    mock.club3 = Club(
      clubId: '3',
      name: 'Club 3',
      location: 'Alexandria',
      restaurants: [mock.restaurant2, mock.restaurant3],
    );

    return mock;
  }
}