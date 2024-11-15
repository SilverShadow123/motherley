import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/monthly_data.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  late Future<List<MonthData>> monthData;

  @override
  void initState() {
    super.initState();
    monthData = loadMonthData();
  }

  Future<List<MonthData>> loadMonthData() async {
    String jsonString =
        await rootBundle.loadString('assets/motherly_monthly_data.json');
    final jsonData = json.decode(jsonString);
    List<MonthData> monthList = (jsonData['months'] as List)
        .map((month) => MonthData.fromJson(month))
        .toList();
    return monthList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pregnancy Nutrition',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.pink[300],
        elevation: 0,
      ),
      body: FutureBuilder<List<MonthData>>(
        future: monthData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else {
            return DefaultTabController(
              length: snapshot.data!.length,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.pink[100],
                    child: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.pink[300],
                      ),
                      tabs: snapshot.data!.map((month) {
                        return Tab(
                          child: Row(
                            children: [
                              const Icon(Icons.child_care, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Month ${month.month}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: snapshot.data!.map((month) {
                        return ListView.builder(
                          itemCount: month.foodGroups.length,
                          itemBuilder: (context, index) {
                            FoodGroup group = month.foodGroups[index];
                            return Card(
                              color: Colors.white,
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  leading: _getFoodGroupIcon(group.group),
                                  title: Text(
                                    group.group,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.pink[700],
                                    ),
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildFoodList(group.foods),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Nutritional Value: ${group.nutritionalValue}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Effects on Baby: ${group.effectsOnBaby}',
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildFoodList(List<String> foods) {
    return Wrap(
      spacing: 8.0,
      children: foods.map((food) {
        return Chip(
          label: Text(food),
          avatar: Icon(
            Icons.local_dining,
            size: 16,
            color: Colors.pink[500],
          ),
          backgroundColor: Colors.pink[50],
        );
      }).toList(),
    );
  }

  Icon _getFoodGroupIcon(String group) {
    switch (group) {
      case 'Fruits':
        return const Icon(Icons.apple, color: Colors.red);
      case 'Vegetables':
        return const Icon(Icons.grass, color: Colors.green);
      case 'Whole Grains':
        return const Icon(Icons.rice_bowl, color: Colors.brown);
      case 'Protein':
        return const Icon(Icons.egg, color: Colors.orange);
      case 'Dairy':
        return const Icon(Icons.local_drink, color: Colors.blue);
      case 'Healthy Fats':
        return const Icon(Icons.oil_barrel, color: Colors.yellow);
      default:
        return const Icon(Icons.food_bank, color: Colors.grey);
    }
  }
}
