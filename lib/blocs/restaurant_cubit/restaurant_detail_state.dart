import 'package:equatable/equatable.dart';
import 'package:just_order/models/item_model.dart';

/// Immutable state for [RestaurantDetailCubit].
///
/// Holds everything the RestaurantScreen needs to render itself, with
/// no Flutter/widget dependencies so it can be unit-tested in isolation.
class RestaurantDetailState extends Equatable {
  final bool isLoading;
  final List<Item> items;

  /// Items grouped by category name, precomputed once when items load so
  /// the UI never has to filter the full list on every rebuild.
  final Map<String, List<Item>> itemsByCategory;

  final bool isFavorite;
  final double rating;
  final int ratingCount;
  final String? errorMessage;

  const RestaurantDetailState({
    this.isLoading = true,
    this.items = const [],
    this.itemsByCategory = const {},
    this.isFavorite = false,
    this.rating = 4.7,
    this.ratingCount = 30265,
    this.errorMessage,
  });

  List<Item> itemsFor(String category) => itemsByCategory[category] ?? const [];

  RestaurantDetailState copyWith({
    bool? isLoading,
    List<Item>? items,
    Map<String, List<Item>>? itemsByCategory,
    bool? isFavorite,
    double? rating,
    int? ratingCount,
    String? errorMessage,
  }) {
    return RestaurantDetailState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      itemsByCategory: itemsByCategory ?? this.itemsByCategory,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        items,
        itemsByCategory,
        isFavorite,
        rating,
        ratingCount,
        errorMessage,
      ];
}
