import 'package:flutter/material.dart';
//import 'package:eatro/Feature/Auth/services/auth_service.dart';

class MealBoxPage extends StatefulWidget {
  const MealBoxPage({super.key});

  @override
  State<MealBoxPage> createState() => _MealBoxPageState();
}

class _MealBoxPageState extends State<MealBoxPage> {
  final TextEditingController _mealController = TextEditingController();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  final List<String> _meals = [];
  bool _sessionStarted = false;
  bool _isSaving = false;

  void _startSession() {
    setState(() {
      _sessionStarted = true;
    });
  }

  void _addMeal() {
    final String meal = _mealController.text.trim();
    if (meal.isEmpty) {
      _showErrorSnackBar("Please enter a meal item.");
      return;
    }

    if (_meals.length >= 4) {
      _showErrorSnackBar("You can only add up to 4 meals per session.");
      return;
    }

    setState(() {
      _meals.insert(0, meal);
      _listKey.currentState?.insertItem(
        0,
        duration: const Duration(milliseconds: 500),
      );
      _mealController.clear();
    });
  }

  void _removeMeal(int index) {
    final String removedMeal = _meals.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) =>
          _buildMealItem(context, removedMeal, animation, onRemove: () {}),
      duration: const Duration(milliseconds: 500),
    );
    setState(() {}); // To rebuild and update button state
  }

  void _analyzeMeals() {
    if (_meals.length < 4) {
      _showErrorSnackBar("Please add 4 meals to analyze.");
      return;
    }
    setState(() => _isSaving = true);

    // Placeholder for future AI analysis
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _showSuccessSnackBar("Meals ready for analysis!");
        setState(() => _isSaving = false);
      }
    });
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.redAccent),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _mealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _sessionStarted ? _buildMealInputView() : _buildStartSessionView();
  }

  Widget _buildStartSessionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Image.asset(
                'lib/assets/logo.png',
                height: 40,
                errorBuilder: (c, e, s) => Icon(
                  Icons.restaurant_menu,
                  size: 40,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your Daily Nutrition Partner',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'No Active Meal Session',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Start a new meal session to begin tracking.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _startSession,
                icon: const Icon(Icons.play_circle_outline),
                label: const Text('Start New Meal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3366FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealInputView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _mealController,
                      decoration: const InputDecoration(
                        hintText: 'e.g., Rice, Chicken Curry...',
                        labelText: 'Add Meal Item',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _addMeal(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _addMeal,
                    icon: const Icon(Icons.add),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF3366FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: _meals.length,
              itemBuilder: (context, index, animation) {
                return _buildMealItem(
                  context,
                  _meals[index],
                  animation,
                  onRemove: () => _removeMeal(index),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: (_meals.length == 4 && !_isSaving)
                ? _analyzeMeals
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              backgroundColor: const Color(0xFF3366FF),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey,
            ),
            child: _isSaving
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text('Analyze Meal Box'),
          ),
        ],
      ),
    );
  }

  Widget _buildMealItem(
    BuildContext context,
    String meal,
    Animation<double> animation, {
    required VoidCallback onRemove,
  }) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: CircleAvatar(child: Text('${_meals.indexOf(meal) + 1}')),
          title: Text(
            meal,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: onRemove,
          ),
        ),
      ),
    );
  }
}
