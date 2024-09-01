import 'package:flutter/material.dart';

class FilterModel {
  IconData prefix;
  String filterTitle;
  IconData suffix;

  FilterModel(
    this.suffix, {
    required this.prefix,
    required this.filterTitle,
  });
}
