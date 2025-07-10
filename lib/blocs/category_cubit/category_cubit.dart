import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/repository/category_repository.dart';

import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryCubit(this._categoryRepository)
      : super(const CategoryState.initial());

  void listenToCategories() {
    _categoryRepository.getCategoriesStream().listen((categories) {
      if (!isClosed) {
        emit(CategoryState.success(categories));
      }
    });
  }

  Future<void> fetchCategoriesByIds(List<String> categoryIds) async {
    try {
      emit(const CategoryState.loading());
      List<Categories> categories = [];

      for (var categoryId in categoryIds) {
        final category = await _categoryRepository.getCategoryById(categoryId);
        if (category != null) {
          categories.add(category);
        }
      }

      emit(CategoryState.success(categories)); // Emit list of categories
    } catch (e) {
      emit(CategoryState.error(e.toString()));
    }
  }

  Future<void> addCategory(Categories category, String restaurantId) async {
    emit(const CategoryState.loading()); // Emit loading state
    try {
      await _categoryRepository.addCategoryToFirestore(category, restaurantId);

      if (!isClosed) {
        emit(const CategoryState.addedSuccessfully()); // Emit success state
      }
    } catch (e) {
      if (!isClosed) {
        emit(CategoryState.error(e.toString())); // Emit error state
      }
    }
  }

  Future<void> updateCategory(Categories category) async {
    emit(const CategoryState.loading());
    try {
      await _categoryRepository.updateCategory(category);

      // Fetch updated clubs after updating
      final categories = _categoryRepository.getCategoriesStream();

      if (!isClosed) {
        emit(CategoryState.success(
          categories as List<Categories?>,
        )); // Emit the updated list of clubs
      }
    } catch (e) {
      if (!isClosed) {
        emit(CategoryState.error(e.toString()));
      }
    }
  }
}
