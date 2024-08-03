class MealDetails {
  List<String>? mainItems;
  List<String>? sideItems;
  List<String>? drinkItems;
  List<String>? sauceItems;
  bool selectMultipleMain;
  bool selectMultipleSide;
  bool selectMultipleDrink;
  bool selectMultipleSauce;

  MealDetails({
    this.mainItems,
    this.sideItems,
    this.drinkItems,
    this.sauceItems,
    required this.selectMultipleMain,
    required this.selectMultipleSide,
    required this.selectMultipleDrink,
    required this.selectMultipleSauce,
  });

  static fromMap(item) {
    return MealDetails(
      mainItems: item['mainItems']?.cast<String>(),
      sideItems: item['sideItems']?.cast<String>(),
      drinkItems: item['drinkItems']?.cast<String>(),
      sauceItems: item['sauceItems']?.cast<String>(),
      selectMultipleMain: item['selectMultipleMain'],
      selectMultipleSide: item['selectMultipleSide'],
      selectMultipleDrink: item['selectMultipleDrink'],
      selectMultipleSauce: item['selectMultipleSauce'],
    );
  }
}
