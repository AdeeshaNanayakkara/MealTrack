import 'package:flutter/material.dart';

class AdjustGoalsPage extends StatefulWidget {
  final VoidCallback? onGoalsSaved;
  const AdjustGoalsPage({super.key, this.onGoalsSaved});

  @override
  State<AdjustGoalsPage> createState() => _AdjustGoalsPageState();
}

class _AdjustGoalsPageState extends State<AdjustGoalsPage> {
  // State variables for the goal values
  double _calorieGoal = 2000;
  double _carbsGoal = 250;
  double _proteinGoal = 100;
  double _fatsGoal = 70;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Daily Goal Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Set Your Daily Nutrition Goals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Customize your daily targets for calories and macronutrients to align with your health journey.',
              style: TextStyle(fontSize: 15, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            // Calorie Goal Card
            _buildAdjustmentCard(
              title: 'Calorie Goal',
              icon: Icons.local_fire_department_outlined,
              iconColor: Colors.orange,
              unit: 'kcal',
              value: _calorieGoal,
              min: 1000,
              max: 4000,
              onChanged: (newValue) {
                setState(() {
                  _calorieGoal = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            // Macronutrient cards
            _buildAdjustmentCard(
              title: 'Carbohydrates',
              icon: Icons.egg_outlined,
              iconColor: Colors.brown,
              unit: 'g',
              value: _carbsGoal,
              min: 50,
              max: 500,
              onChanged: (newValue) {
                setState(() {
                  _carbsGoal = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildAdjustmentCard(
              title: 'Proteins',
              icon: Icons.fitness_center_outlined,
              iconColor: Colors.red,
              unit: 'g',
              value: _proteinGoal,
              min: 20,
              max: 300,
              onChanged: (newValue) {
                setState(() {
                  _proteinGoal = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            _buildAdjustmentCard(
              title: 'Fats',
              icon: Icons.water_drop_outlined,
              iconColor: Colors.yellow.shade700,
              unit: 'g',
              value: _fatsGoal,
              min: 20,
              max: 150,
              onChanged: (newValue) {
                setState(() {
                  _fatsGoal = newValue;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement save logic to update user goals in Firestore
                print('Save Goals Tapped!');
                print('Calories: $_calorieGoal');
                print('Carbs: $_carbsGoal');
                print('Protein: $_proteinGoal');
                print('Fats: $_fatsGoal');
                if (widget.onGoalsSaved != null) widget.onGoalsSaved!();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: const Color(0xFF3366FF),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save Goals'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdjustmentCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String unit,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 24),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${value.round()} $unit',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3366FF))),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    onChanged((value - (title == 'Calories' ? 50 : 5))
                        .clamp(min, max));
                  },
                ),
                Expanded(
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    divisions: (max - min) ~/ (title == 'Calories' ? 50 : 5),
                    label: value.round().toString(),
                    onChanged: onChanged,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    onChanged((value + (title == 'Calories' ? 50 : 5))
                        .clamp(min, max));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}