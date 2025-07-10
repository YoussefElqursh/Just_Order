import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/category_model.dart' as category_model;

class CategoryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<category_model.Categories?>> getCategoriesStream() {
    return _firestore.collection('categories').snapshots().map(
      (snapshot) {
        return snapshot.docs
            .map(
              (doc) => category_model.Categories.fromJson(
                doc.data(),
              ),
            )
            .toList();
      },
    );
  }

  Future<List<category_model.Categories?>> getCategories() async {
    QuerySnapshot snapshot = await _firestore.collection('categories').get();

    List<category_model.Categories?> categories = [];

    for (var doc in snapshot.docs) {
      categories.add(category_model.Categories.fromJson(
          doc.data() as Map<String, dynamic>));
    }

    return categories;
  }

  Future<category_model.Categories?> getCategoryById(String categoryId) async {
    final doc = await _firestore.collection('categories').doc(categoryId).get();
    if (doc.exists) {
      return category_model.Categories.fromJson(doc.data()!);
    }
    return null;
  }

  Future<void> addCategoryToFirestore(
    category_model.Categories category,
    String restaurantId,
  ) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    try {
      // Reference to category document
      DocumentReference categoryRef =
          firestore.collection('categories').doc(category.categoryId);

      // Reference to restaurant document
      DocumentReference restaurantRef =
          firestore.collection('restaurants').doc(restaurantId);

      // Add category to "categories" collection
      batch.set(categoryRef, category.toJson());

      // Add category ID to the categoriesId array in the restaurant document
      batch.update(restaurantRef, {
        'categoriesId': FieldValue.arrayUnion([category.categoryId]),
      });

      // Commit batch write
      await batch.commit();

      debugPrint("Category added successfully and linked to the restaurant.");
    } catch (e) {
      debugPrint("Error adding category: $e");
      rethrow; // Ensure the error is propagated to Cubit
    }
  }

  Future<void> updateCategory(
    category_model.Categories category,
  ) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.categoryId) // Using clubId as the document ID
          .update(category.toJson());
    } catch (e) {
      debugPrint("Error updating club: $e");
    }
  }
}
