import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/models/category_model.dart';
import 'package:just_order/repository/category_repository.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryCubit(this.categoryRepository) : super(CategoryInitial());

  List<Categories?> _allCategories = [];

  Future<void> fetchCategories() async {
    emit(CategoryLoading());
    try {
      _allCategories = await categoryRepository.getCategories();
      emit(CategoryLoaded(_allCategories));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }

  void searchCategory(String query) {
    if (query.isEmpty) {
      emit(CategoryLoaded(_allCategories));
    } else {
      final filtered = _allCategories
          .where((c) =>
          c!.categoryName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(CategoryLoaded(filtered));
    }
  }
}
