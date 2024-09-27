import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../models/cart_item_model.dart';
import '../../models/invoice_model.dart';
import '../../models/order_model.dart';

class PaymentGatewayScreen extends StatefulWidget {
  static const String routeName = 'PaymentGatewayRoute';
  final String secretClient;
  final Order order;
  final List<CartItem> cartItems;
  final Invoice invoice;

  const PaymentGatewayScreen(
      {super.key,
      required this.secretClient,
      required this.order,
      required this.cartItems,
      required this.invoice});

  static Route route(
      {required String secretClient,
      required Order order,
      required List<CartItem> cartItems,
      required Invoice invoice}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => PaymentGatewayScreen(
        secretClient: secretClient,
        order: order,
        cartItems: cartItems,
        invoice: invoice,
      ), // Future work send the saved token
    );
  }

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreen(
      secretClient: secretClient,
      order: order,
      cartItems: cartItems,
      invoice: invoice);
}

class _PaymentGatewayScreen extends State<PaymentGatewayScreen> {
  final String secretClient;
  final Order order;
  final List<CartItem> cartItems;
  final Invoice invoice;

  _PaymentGatewayScreen({
    required this.secretClient,
    required this.order,
    required this.cartItems,
    required this.invoice,
  });

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          clearCache: true,
          iframeAllowFullscreen: true,
        ),
        onWebViewCreated: (controller) {
          String publicKey = dotenv.get("PYAMOB_PUBLIC_KEY");
          if (this.secretClient.isEmpty || publicKey.isEmpty) {
            throw ("Can't establish a payment gateway screen due to lack of api/secret key");
          }
          controller.loadUrl(
              urlRequest: URLRequest(
                  url: WebUri(
                      'https://accept.paymob.com/unifiedcheckout/?publicKey=$publicKey&clientSecret=$secretClient')));
        },
        onLoadStop: (controller, url) {
          if (url != null && url.queryParameters.containsKey("success")) {
            bool success = url.queryParameters["success"]?.toLowerCase() == "true";
            if (success) {
              print("Success ");
              Navigator.pushNamedAndRemoveUntil(context, 'OrderConfirmedScreenRoute', (route) => false);
              Navigator.pushNamed(context, 'OrderConfirmedScreenRoute',
                  arguments: {
                    'order':order,
                    'cartItems': cartItems,
                    'invoice': invoice,
                  });
            } else {
              // TODO: Create a UI to show what happened
              Navigator.pop(context);
            }
          } else {
            // Need to handle the timeout
            print("Failed to parse the url");
          }
        },
      ),
    );
  }
}
