import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_order/models/item_model.dart';
import 'package:just_order/repository/item_repository.dart';

part 'item_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit(this._repository) : super(ItemsInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Item> _allItems = [];
  final ItemRepository _repository;

  Future<void> fetchItemsByCategory(String categoryName) async {
    emit(ItemsLoading());
    try {
      _allItems = await _repository.getItemsByCategory(categoryName);
      final snapshot = await _firestore
          .collection('items')
          .where('category', isEqualTo: categoryName)
          .get();

      final items = snapshot.docs
          .map((doc) => Item.fromMap(doc.data()))
          .toList();

      emit(ItemsLoaded(items));
    } catch (e) {
      emit(ItemsError(e.toString()));
    }
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      emit(ItemsLoaded(_allItems));
    } else {
      final filtered = _allItems
          .where((item) =>
          item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(ItemsLoaded(filtered));
    }
  }
}
