
class MonthData {
  final int month;
  final List<FoodGroup> foodGroups;

  MonthData({required this.month, required this.foodGroups});

  factory MonthData.fromJson(Map<String, dynamic> json) {
    var list = json['foodGroups'] as List;
    List<FoodGroup> foodGroupsList =
    list.map((i) => FoodGroup.fromJson(i)).toList();

    return MonthData(
      month: json['month'],
      foodGroups: foodGroupsList,
    );
  }
}

class FoodGroup {
  final String group;
  final List<String> foods;
  final String nutritionalValue;
  final String effectsOnBaby;

  FoodGroup({
    required this.group,
    required this.foods,
    required this.nutritionalValue,
    required this.effectsOnBaby,
  });

  factory FoodGroup.fromJson(Map<String, dynamic> json) {
    return FoodGroup(
      group: json['group'],
      foods: List<String>.from(json['foods']),
      nutritionalValue: json['nutritionalValue'],
      effectsOnBaby: json['effectsOnBaby'],
    );
  }
}
