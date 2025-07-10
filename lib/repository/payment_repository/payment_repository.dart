import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_order/models/cart_item_model.dart';

import '../../models/payments_model/payment_request_model.dart';
import '../../models/user_model.dart';
import '../../network/dio_helper.dart';
import '../../shared/constant/payment_gateway_constants.dart';

class PaymentRepository {
  Future<Either<String, String>> pay(
      {required int amount, required List<CartItem> itemsList}) async {
    // TODO: we can add here some validation and sanitation
    User? user = await User.getUserFromPreferences();
    if (user == null) {
      String errorMessage =
          "Something went wrong while trying to fetch your info";
      debugPrint(errorMessage);
      return left(errorMessage);
    }

    final Either<String, String> res = await _initiatePaymentRequest(
        amount: amount, user: user, itemsList: itemsList);
    return res.fold((l) {
      return left(l);
    }, (r) {
      // if success do the next step
      return right(r);
    });
  }

  Future<Either<String, String>> _initiatePaymentRequest(
      {required int amount,
      required User user,
      required List<CartItem> itemsList,
      int expiration = 5800,
      List<dynamic> paymentMethods = const [4619150]}) async {
    List<dynamic> items = [];
    /** TODO: I opened a support task with paymob because their api doesn't respect adding upp all items amounts
     ** So instead we add only one item with the whole amount */
    // itemsList.forEach((cartItem) => items.add(cartItem.toMap()));
    // int sum = 0;
    // for (var cartItem in items) {
    //   if (cartItem.containsKey("cartItemId")) {
    //     var value = cartItem["cartItemId"];
    //     cartItem.remove("cartItemId");
    //     cartItem["name"] = value;
    //   }
    //   if (cartItem.containsKey("price")) {
    //     var value = cartItem["price"];
    //     cartItem.remove("price");
    //     cartItem["amount"] = value * 100 * cartItem["quantity"];
    //     sum += (cartItem["amount"] as double).toInt();
    //   }
    // }
    // int totalFees = amount - sum;
    items.add({"name": "items", "amount": amount});
    try {
      var response = await DioHelperPayment.postData(
        url: PaymentGatewayConstants.intention,
        data: {
          "amount": amount,
          "currency": "EGP",
          "expiration": expiration,
          "payment_methods": paymentMethods,
          "items": items,
          "billing_data": {
            "apartment": "6",
            "first_name": user.firstName,
            "last_name": user.lastName,
            "phone_number": user.phoneNumber,
            "country": "EG",
            "email": user.email,
            "street": "938, Al-Jadeed Bldg",
            "building": "939",
            "floor": "1",
            "state": "Alkhuwair"
          },
          "special_reference": DateTime.now().millisecond.toString(),
          "customer": {
            "first_name": user.firstName,
            "last_name": user.lastName,
            "email": user.email,
          },
        },
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token ${dotenv.get("PAYMOB_SECRET_KEY")}',
        },
      );
      PaymentRequestModel paymentRequestModel =
          PaymentRequestModel.fromJson(response.data);
      return right(paymentRequestModel.clientSecret);
    } catch (e) {
      return left(e.toString());
    }
  }
}
