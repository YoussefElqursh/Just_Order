import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';
import 'package:just_order/core/storage/storage_service.dart';

part 'popular_today_state.dart';

class PopularTodayCubit extends Cubit<PopularTodayState> {
  final UserRepository _userRepository;

  PopularTodayCubit(this._userRepository) : super(PopularTodayState.initial());

  Future<void> loadData() async {
    emit(state.copyWith(status: PopularTodayStatus.loading));
    try {
      final prefs = StorageService.instance;

      final tableCode = prefs.getString('code') ?? 'Unknown';
      final userString = prefs.getString('user');
      final user = userString != null ? User.fromJson(jsonDecode(userString)) : null;

      final restaurants = await _userRepository.getRestaurants(tableCode);

      emit(state.copyWith(
        status: PopularTodayStatus.success,
        restaurants: restaurants,
        filteredRestaurants: restaurants,
        user: user,
        tableCode: tableCode,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PopularTodayStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void searchRestaurants(String query) {
    if (query.isEmpty) {
      emit(state.copyWith(filteredRestaurants: state.restaurants));
    } else {
      final filtered = state.restaurants
          .where((r) => r.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(state.copyWith(filteredRestaurants: filtered));
    }
  }
}
