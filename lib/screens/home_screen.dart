import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../calculation/date_calculation.dart';

class HomeScreen extends StatefulWidget {
  final DateTime? dueDate;
  final String motherName;

  const HomeScreen({Key? key, this.dueDate, required this.motherName}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<bool> _checklistItems = [];
  List<String> _checklistTitles = [];
  List<String> _favoriteTips = [];
  List<String> _favoriteQuotes = [];

  @override
  void initState() {
    super.initState();
    _initializeChecklists();
  }

  void _initializeChecklists() {
    _checklistTitles = [
      'Take prenatal vitamins',
      'Schedule your next doctor’s appointment',
      'Stay hydrated',
      'Practice relaxation techniques',
      'Join a prenatal class'
    ];
    _checklistItems = List.generate(_checklistTitles.length, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime? lmpDate;
    int daysPassed = 0;
    int weeksPassed = 0;
    int monthsPassed = 0;

    if (widget.dueDate != null) {
      DateCalculator dateCalculator = DateCalculator(widget.dueDate);
      lmpDate = dateCalculator.getLmpDate();
      daysPassed = dateCalculator.calculateDaysPassed(currentDate, lmpDate);
      weeksPassed = dateCalculator.calculateWeeksPassed(daysPassed);
      monthsPassed = dateCalculator.calculateMonthsPassed(currentDate, lmpDate);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motherley'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddChecklistDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: itemList(daysPassed, weeksPassed, monthsPassed),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemList(int daysPassed, int weeksPassed, int monthsPassed) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return greetingCard();
          case 1:
            return dueDateCard();
          case 2:
            return pregnancyProgressCard(daysPassed, weeksPassed, monthsPassed);
          case 3:
            return healthTipsCarousel();
          case 4:
            return interactiveChecklist();
          case 5:
            return emotionalSupportSection();
          case 6:
            return favoriteTipsSection();
          case 7:
            return favoriteQuotesSection();
          default:
            return Container();
        }
      },
      separatorBuilder: (context, index) => const SizedBox(height: 20),
      itemCount: 8,
    );
  }

  Widget greetingCard() {
    return SizedBox(
      height: 150,
      child: Card(
        color: Colors.pink[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          trailing: Image.asset(
            'assets/images/—Pngtree—pregnant_6034376.png',
            height: 60,
          ),
          title: Text(
            'Hello, ${widget.motherName}!',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
          subtitle: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                'Hope you are having a wonderful day!',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dueDateCard() {
    return Card(
      color: Colors.teal[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/baby.png',
                height: 50,
              ),
              const SizedBox(height: 10),
              Text(
                '${widget.dueDate != null ? DateFormat('EEEE, MMMM d, y').format(widget.dueDate!) : 'Not available'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pregnancyProgressCard(int daysPassed, int weeksPassed, int monthsPassed) {
    return Card(
      color: Colors.orange[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: const Center(
          child: Text(
            'Pregnancy Progress',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressColumn('Days', daysPassed),
              const SizedBox(width: 20),
              _buildProgressColumn('Weeks', weeksPassed),
              const SizedBox(width: 20),
              _buildProgressColumn('Months', monthsPassed),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressColumn(String label, int value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget healthTipsCarousel() {
    final tips = [
      'Stay hydrated and drink plenty of water.',
      'Eat a balanced diet rich in fruits and vegetables.',
      'Regular prenatal check-ups are essential.',
      'Stay active with safe exercises for pregnant women.',
      'Practice relaxation techniques to manage stress.'
    ];

    return Card(
      color: Colors.lightBlue[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text(
              'Health Tips',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: PageView.builder(
                itemCount: tips.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tips[index],
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            onPressed: () {
                              _addFavoriteTip(tips[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget interactiveChecklist() {
    if (_checklistItems.isEmpty || _checklistTitles.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.yellow[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          const ListTile(
            title: Text(
              'Pregnancy Checklist',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(_checklistItems.length, (index) {
            return AnimatedCrossFade(
              firstChild: _buildChecklistItem(index, true),
              secondChild: _buildChecklistItem(index, false),
              crossFadeState: _checklistItems[index] ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChecklistItem(int index, bool showComplete) {
    return ListTile(
      title: Text(_checklistTitles[index]),
      trailing: Checkbox(
        value: _checklistItems[index],
        onChanged: (value) {
          setState(() {
            _checklistItems[index] = value ?? false;
          });
        },
      ),
    );
  }

  Widget emotionalSupportSection() {
    return Card(
      color: Colors.green[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: const ListTile(
        title: Text(
          'Emotional Support',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'It\'s important to talk about your feelings and seek support.',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget favoriteTipsSection() {
    return Card(
      color: Colors.purple[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: const Text(
          'Favorite Tips',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_favoriteTips.isNotEmpty
            ? _favoriteTips.join(', ')
            : 'No favorite tips yet.'),
      ),
    );
  }

  Widget favoriteQuotesSection() {
    return Card(
      color: Colors.orange[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: const Text(
          'Favorite Quotes',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_favoriteQuotes.isNotEmpty
            ? _favoriteQuotes.join(', ')
            : 'No favorite quotes yet.'),
      ),
    );
  }

  void _showAddChecklistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String newChecklistTitle = '';
        return AlertDialog(
          title: const Text('Add Checklist Item'),
          content: TextField(
            onChanged: (value) {
              newChecklistTitle = value;
            },
            decoration: const InputDecoration(labelText: 'Checklist Title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (newChecklistTitle.isNotEmpty) {
                  setState(() {
                    _checklistTitles.add(newChecklistTitle);
                    _checklistItems.add(false);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addFavoriteTip(String tip) {
    setState(() {
      _favoriteTips.add(tip);
    });
  }
}
