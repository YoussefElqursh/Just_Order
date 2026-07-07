part of 'popular_today_cubit.dart';

enum PopularTodayStatus { initial, loading, success, failure }

class PopularTodayState extends Equatable {
  final PopularTodayStatus status;
  final List<Restaurant> restaurants;
  final List<Restaurant> filteredRestaurants;
  final User? user;
  final String tableCode;
  final String errorMessage;

  const PopularTodayState({
    required this.status,
    required this.restaurants,
    required this.filteredRestaurants,
    required this.user,
    required this.tableCode,
    required this.errorMessage,
  });

  factory PopularTodayState.initial() {
    return const PopularTodayState(
      status: PopularTodayStatus.initial,
      restaurants: [],
      filteredRestaurants: [],
      user: null,
      tableCode: '',
      errorMessage: '',
    );
  }

  PopularTodayState copyWith({
    PopularTodayStatus? status,
    List<Restaurant>? restaurants,
    List<Restaurant>? filteredRestaurants,
    User? user,
    String? tableCode,
    String? errorMessage,
  }) {
    return PopularTodayState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      filteredRestaurants: filteredRestaurants ?? this.filteredRestaurants,
      user: user ?? this.user,
      tableCode: tableCode ?? this.tableCode,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    restaurants,
    filteredRestaurants,
    user,
    tableCode,
    errorMessage,
  ];
}
