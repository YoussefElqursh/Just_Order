import 'package:cloud_firestore/cloud_firestore.dart';

class Util {
  Util._(); // Private constructor to prevent instantiation

  static Future<double> getServiceFees() async {
    try {
      QuerySnapshot docs =
          await FirebaseFirestore.instance.collection('settings').get();

      if (docs.docs.isNotEmpty) {
        var data = docs.docs[0].data() as Map<String, dynamic>;
        double serviceFees = (data['serviceFees'] ?? 30).toDouble();
        print('Service fees : ${serviceFees}');
        return serviceFees;
      }
      //TODO: We should throw and error and handle it bit for now we add default value
      return 30.0;
    } catch (e) {
      print(e);
      return 30.0;
    }
  }
}
