import 'package:flutter/material.dart';
import 'package:eatro/Feature/Auth/services/auth_service.dart';
import 'package:eatro/Feature/Auth/pages/goals_page.dart';
import 'package:eatro/Feature/Auth/pages/adjust_goals_page.dart';
//import 'package:eatro/Feature/Auth/pages/meal_box_page.dart';
import 'meal_box_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  Widget _buildNutrientItem(
    IconData icon,
    String label,
    String value,
    String unit,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700], size: 28),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  String? _userName;
  String? _photoURL;
  bool _isAdjustingGoals = false;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _pages = <Widget>[
      HomeTab(onRecordMeal: () => _onItemTapped(3)),
      GoalsPage(onAdjustGoals: () => setState(() => _isAdjustingGoals = true)),
      const Center(child: Text('History Page')),
      const MealBoxPage(),
    ];
  }

  Future<void> _loadUserDetails() async {
    final userDetails = await _authService.getUserDetails();
    if (userDetails != null && userDetails.exists) {
      final data = userDetails.data() as Map<String, dynamic>?;
      if (mounted) {
        setState(() {
          _userName = data?['name'] ?? 'User';
          _photoURL = data?['photoURL'];
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _isAdjustingGoals = false;
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: _isAdjustingGoals
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => setState(() => _isAdjustingGoals = false),
              )
            : IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        title: Text(
          _isAdjustingGoals ? 'Daily Goal Settings' : 'EATRO',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: _isAdjustingGoals
            ? []
            : <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () async {
                    await _authService.signOut();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _photoURL != null
                        ? NetworkImage(_photoURL!)
                        : null,
                    child: _photoURL == null && _userName != null
                        ? Text(
                            _userName!.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
      ),
      body: _isAdjustingGoals
          ? AdjustGoalsPage(
              onGoalsSaved: () => setState(() => _isAdjustingGoals = false),
            )
          : IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: _isAdjustingGoals
          ? null
          : buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            _selectedIndex == 0 ? Icons.home_filled : Icons.home_outlined,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(_selectedIndex == 1 ? Icons.flag : Icons.flag_outlined),
          label: 'Goals',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _selectedIndex == 2 ? Icons.history : Icons.history_outlined,
          ),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            _selectedIndex == 3
                ? Icons.restaurant_menu
                : Icons.restaurant_menu_outlined,
          ),
          label: 'Meal Box',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color(0xFF3366FF),
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      elevation: 10,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Inter',
      ),
      unselectedLabelStyle: const TextStyle(fontFamily: 'Inter'),
    );
  }
}

class HomeTab extends StatelessWidget {
  final VoidCallback onRecordMeal;
  const HomeTab({super.key, required this.onRecordMeal});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fastfood, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Meal Box Status',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Colors.grey[200],
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMonitoringItem(
                            Icons.thermostat,
                            'Temperature',
                            '4',
                            '°C',
                          ),
                          _buildMonitoringItem(
                            Icons.scale,
                            'Live Weight',
                            '870',
                            'g',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color.fromARGB(221, 3, 194, 22),
                    ),
                    minHeight: 15,
                    borderRadius: BorderRadius.circular(7.5),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '250',
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              'g',
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Eating in Progress',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: onRecordMeal, // Use the callback here
                    icon: const Icon(Icons.receipt_long),
                    label: const Text('Record Meal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3366FF),
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.summarize_outlined, color: Colors.grey[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Nutritional Summary',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '1850',
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'kcal',
                          style: TextStyle(
                            fontSize: 40,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutrientItem(
                        Icons.rice_bowl_outlined,
                        'Carbs',
                        '220',
                        'g',
                      ),
                      _buildNutrientItem(
                        Icons.fitness_center,
                        'Proteins',
                        '85',
                        'g',
                      ),
                      _buildNutrientItem(
                        Icons.water_drop_outlined,
                        'Fats',
                        '60',
                        'g',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientItem(
    IconData icon,
    String label,
    String value,
    String unit,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700], size: 28),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildMonitoringItem(
    IconData icon,
    String label,
    String value,
    String unit,
  ) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[700], size: 28),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            Text(
              unit,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
