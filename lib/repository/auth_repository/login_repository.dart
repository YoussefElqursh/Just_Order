import 'package:just_order/mock.dart';
import 'package:just_order/models/user_model.dart';

class LoginRepository {
  late Mock _mockData;

  LoginRepository() {
    _initializeMockData();
  }

  Future<void> _initializeMockData() async {
    _mockData = await Mock.create();
  }

  Future<User?> login(String email, String password) async {
    // Ensure _mockData is initialized before using it
    await _initializeMockData();

    return _mockData.users.firstWhere(
      (user) => user.email == email && user.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
  }
// ... other methods for registration, logout, etc.
}
