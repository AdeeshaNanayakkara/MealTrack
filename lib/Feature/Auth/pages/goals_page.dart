import 'package:flutter/material.dart';
import 'package:eatro/Feature/Auth/pages/adjust_goals_page.dart';

class GoalsPage extends StatelessWidget {
  final VoidCallback? onAdjustGoals;

  const GoalsPage({super.key, this.onAdjustGoals});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top large card
            Card(
              elevation: 4,
              color: const Color.fromARGB(255, 64, 52, 225),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://placehold.co/600x400/a0c4ff/ffffff?text=+',
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black38,
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      '450',
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(blurRadius: 10.0, color: Colors.black54),
                        ],
                      ),
                    ),
                    const Text(
                      'grams',
                      style: TextStyle(fontSize: 24, color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.thermostat_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "25°C-Optimal",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Grid of nutrient goals
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _buildGoalCard(
                  icon: Icons.local_fire_department,
                  iconColor: Colors.orange,
                  title: 'Calories',
                  currentValue: '1250',
                  unit: 'kcal',
                  target: 'Target: 2000kcal',
                  progress: 1250 / 2000,
                  progressColor: Colors.blue,
                ),
                _buildGoalCard(
                  icon: Icons.fitness_center,
                  iconColor: Colors.red,
                  title: 'Protein',
                  currentValue: '75',
                  unit: 'g',
                  target: 'Target: 100g',
                  progress: 75 / 100,
                  progressColor: Colors.blue,
                ),
                _buildGoalCard(
                  icon: Icons.egg,
                  iconColor: Colors.brown,
                  title: 'Carbs',
                  currentValue: '150',
                  unit: 'g',
                  target: 'Target: 250g',
                  progress: 150 / 250,
                  progressColor: Colors.pink,
                ),
                _buildGoalCard(
                  icon: Icons.water_drop,
                  iconColor: Colors.yellow.shade700,
                  title: 'Fats',
                  currentValue: '40',
                  unit: 'g',
                  target: 'Target: 60g',
                  progress: 40 / 60,
                  progressColor: Colors.pink,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Daily Goal Progress Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.track_changes, color: Colors.grey[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Daily Goal Progress',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Calories consumed vs. your daily target.',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 20),
                    LinearProgressIndicator(
                      value: 0.75,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF3366FF),
                      ),
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildProgressLegendItem(
                          const Color(0xFF3366FF),
                          'Consumed: 1850 kcal',
                        ),
                        _buildProgressLegendItem(
                          Colors.grey[300]!,
                          'Remaining: 650 kcal',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () {
                        // Navigate to the new AdjustGoalsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdjustGoalsPage(
                              onGoalsSaved: () {
                                // TODO: Implement what should happen after goals are saved.
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Adjust Goals'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor: Colors.grey[800],
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- HELPER WIDGETS (MOVED OUTSIDE THE CLASS) ---

Widget _buildGoalCard({
  required IconData icon,
  required Color iconColor,
  required String title,
  required String currentValue,
  required String unit,
  required String target,
  required double progress,
  required Color progressColor,
}) {
  return Card(
    elevation: 2,
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                currentValue,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Text(unit, style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          const Spacer(),
          Text(target, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    ),
  );
}

Widget _buildProgressLegendItem(Color color, String text) {
  return Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      const SizedBox(width: 5),
      Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
    ],
  );
}
