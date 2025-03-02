import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_order/models/category_model.dart';

part 'category_state.freezed.dart';
@freezed
class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = _Initial;
  const factory CategoryState.loading() = _Loading;
  const factory CategoryState.success(List<Categories?> category) = _Sucess;
  const factory CategoryState.addedSuccessfully() = _AddedSuccessfully;
  const factory CategoryState.error(String message) = _Error;
}