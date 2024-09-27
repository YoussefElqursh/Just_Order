import 'package:dio/dio.dart';
import 'package:just_order/shared/constant/payment_gateway_constants.dart';

class DioHelperPayment {
  static late Dio dio;

  // to get data from url
  static Future<Response> getData(
      {required String url,
        Map<String, dynamic>? query,
        Map<String, dynamic> headers = const {
          'Content-Type': 'application/json'
        }}) async {
    dio = Dio(
      BaseOptions(
        baseUrl: PaymentGatewayConstants.baseUrl,
        headers: headers,
        receiveDataWhenStatusError: true,
      ),
    );
    return await dio.get(url, queryParameters: query);
  }

  // post data
  static Future<Response> postData(
      {required String url,
        required Map<String, dynamic>? data,
        Map<String, dynamic> headers = const {'Content-Type': 'application/json'},
        Map<String, dynamic>? query}) async {
    dio = Dio(
      BaseOptions(
        baseUrl: PaymentGatewayConstants.baseUrl,
        headers: headers,
        receiveDataWhenStatusError: true,
      ),
    );
    return await dio.post(url, data: data, queryParameters: query);
  }
}