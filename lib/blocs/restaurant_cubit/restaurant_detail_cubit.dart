import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/core/storage/storage_service.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/user_repository/user_repository.dart';

import 'restaurant_detail_state.dart';

/// Owns every side effect that used to live inside `_RestaurantScreenState`:
/// fetching menu items, checking/toggling "favourite" in Firestore, and
/// persisting the last-viewed restaurant + rating locally.
///
/// The widget layer only ever calls these public methods and reads
/// [RestaurantDetailState] — it never touches Firestore or StorageService
/// directly.
class RestaurantDetailCubit extends Cubit<RestaurantDetailState> {
  final Restaurant restaurant;
  final User user;
  final UserRepository _userRepository;
  final FirebaseFirestore _firestore;
  final StorageService _storage;

  RestaurantDetailCubit({
    required this.restaurant,
    required this.user,
    UserRepository? userRepository,
    FirebaseFirestore? firestore,
    StorageService? storage,
  })  : _userRepository = userRepository ?? UserRepository(),
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? StorageService.instance,
        super(const RestaurantDetailState());

  /// Runs every start-up task in parallel, then saves the restaurant to
  /// local prefs (fire-and-forget, matching the previous behaviour).
  Future<void> initialize() async {
    _loadSavedRating();

    await Future.wait([
      _loadItems(),
      _checkIfFavorite(),
    ]);
  }

  Future<void> _loadItems() async {
    try {
      final fetchedItems = await _userRepository.getItems(restaurant.itemIds);

      final Map<String, List<Item>> grouped = {};
      for (final item in fetchedItems) {
        grouped.putIfAbsent(item.category, () => []).add(item);
      }

      emit(state.copyWith(
        items: fetchedItems,
        itemsByCategory: grouped,
        isLoading: false,
      ));
    } catch (e) {
      debugPrint('Failed to load items: $e');
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load menu items',
      ));
    }
  }

  Future<void> _checkIfFavorite() async {
    try {
      final doc = await _favouriteDocRef.get(const GetOptions(source: Source.cache));
      emit(state.copyWith(isFavorite: doc.exists));
    } catch (e) {
      debugPrint('Favorite check error: $e');
    }
  }

  Future<void> toggleFavorite() async {
    final newValue = !state.isFavorite;
    emit(state.copyWith(isFavorite: newValue));

    try {
      if (newValue) {
        await _favouriteDocRef.set({
          'favouriteRestaurant': restaurant.restaurantId,
        });
      } else {
        final docSnapshot = await _favouriteDocRef.get();
        if (docSnapshot.exists) await _favouriteDocRef.delete();
      }
    } catch (e) {
      debugPrint('Failed to update favorite: $e');
      // Roll back optimistic update on failure.
      emit(state.copyWith(isFavorite: !newValue));
    }
  }

  DocumentReference<Map<String, dynamic>> get _favouriteDocRef => _firestore
      .collection('users')
      .doc(user.userId)
      .collection('favouriteRestaurant')
      .doc(restaurant.restaurantId);

  void _loadSavedRating() {
    final savedRating = _storage.getDouble('restaurant_rating');
    if (savedRating != null) {
      emit(state.copyWith(rating: savedRating));
    }
  }

  Future<void> submitRating(double rating) async {
    await _storage.setDouble('restaurant_rating', rating);
    emit(state.copyWith(
      rating: rating,
      ratingCount: state.ratingCount + 1,
    ));
  }

  /// Persists the current restaurant under [localizedKey] (e.g. an
  /// AppLocalizations string) so it can be restored as "last viewed".
  Future<void> saveRestaurantToPrefs(String localizedKey) async {
    await _storage.setString(localizedKey, jsonEncode(restaurant.toJson()));
  }

  Future<void> removeRestaurantFromPrefs() async {
    await _storage.remove('last_restaurant_${user.userId}');
  }
}
