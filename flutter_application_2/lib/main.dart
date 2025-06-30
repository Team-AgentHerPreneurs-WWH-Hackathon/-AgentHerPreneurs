import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:isolate'; // For compute
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(EmpowerHerApp());
}

class EmpowerHerApp extends StatelessWidget {
  const EmpowerHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EmpowerHer AI',
      theme: ThemeData(
        primaryColor: Color(0xFF6B46C1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6B46C1),
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        primaryColor: Color(0xFF6B46C1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF6B46C1),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    
    _controller.forward();
    
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6B46C1),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.business_center,
                  size: 60,
                  color: Color(0xFF6B46C1),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'EmpowerHer AI',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your AI-Powered Business Companion',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isListening = false;
  String _currentLanguage = 'English';
  String _currentTheme = 'Light';
  String _currentFontSize = 'Medium';
  String _currentFontStyle = 'Roboto';
  final List<String> _languages = ['English', 'हिंदी', 'தமிழ்', 'বাংলা', 'मराठी', 'తెలుగు', 'ಕನ್ನಡ', 'മലയാളം', 'ਪੰਜਾਬੀ'];
  final List<String> _fontSizes = ['Small', 'Medium', 'Large'];
  final List<String> _fontStyles = ['Roboto', 'Sans Serif', 'Serif'];
  final List<Widget> _screens = [
    DashboardScreen(),
    AgentsScreen(),
    ProfileScreen(),
    FinanceAgentScreen(),
    SchemeAgentScreen(),  
    MarketingAgentScreen(),
    LearningAgentScreen(),
    BusinessLifePlannerScreen(),
    SafetyAgentScreen(),
  ];
  // Update methods
  void _updateTheme(String theme) {
    setState(() {
      _currentTheme = theme;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Theme changed to $theme')),
    );
  }

  void _updateLanguage(String language) {
    setState(() {
      _currentLanguage = language;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $language')),
    );
  }

  void _updateFont(String size, String style) {
    setState(() {
      _currentFontSize = size;
      _currentFontStyle = style;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Font updated to $size, $style')),
    );
  }
  void _startListening() {
    setState(() {
      _isListening = true;
    });
    
    Timer(Duration(seconds: 3), () {
      setState(() {
        _isListening = false;
      });
      _showVoiceResult();
    });
  }

  void _showVoiceResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.mic, color: Color(0xFF6B46C1)),
            SizedBox(width: 10),
            Text('Voice Command Processed'),
          ],
        ),
        content: Text('I heard: "Show me my business expenses for this month"'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedIndex = 1; // Navigate to AgentsScreen
                Timer(Duration(milliseconds: 500), () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FinanceAgentScreen()),
                  );
                });
              });
            },
            child: Text('View Expenses'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Notifications',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: _currentFontStyle),
            ),
            SizedBox(height: 15),
            _buildNotificationItem(
              'GST Filing Due',
              'Your GST return is due in 3 days',
              Icons.warning,
              Colors.orange,
            ),
            _buildNotificationItem(
              'New Grant Available',
              'Women entrepreneur scheme open for applications',
              Icons.card_giftcard,
              Colors.green,
            ),
            _buildNotificationItem(
              'Suspicious Activity',
              'Potential fraud detected on your account',
              Icons.security,
              Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontFamily: _currentFontStyle),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600], fontFamily: _currentFontStyle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EmpowerHer AI',
          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: _currentFontStyle),
        ),
        backgroundColor: Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.language),
            onSelected: _updateLanguage,
            itemBuilder: (context) => _languages
                .map((lang) => PopupMenuItem(
                      value: lang,
                      child: Text(lang, style: TextStyle(fontFamily: _currentFontStyle)),
                    ))
                .toList(),
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () => _showNotifications(),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: _startListening,
        backgroundColor: _isListening ? Colors.red : Color(0xFF6B46C1),
        child: _isListening
            ? Icon(Icons.stop, color: Colors.white)
            : Icon(Icons.mic, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF6B46C1),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy),
            label: 'Assistants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Priya!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Your business is growing 📈',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 25),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Monthly Revenue',
                  '₹45,230',
                  Icons.trending_up,
                  Colors.green,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Active Orders',
                  '23',
                  Icons.shopping_cart,
                  Colors.blue,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 15),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Safety Score',
                  '98%',
                  Icons.security,
                  Colors.green,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildStatCard(
                  'Learning Progress',
                  '75%',
                  Icons.school,
                  Colors.purple,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 25),
          
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.2,
            children: [
              _buildActionCard(
                'Record Expense',
                Icons.receipt,
                Color(0xFF6B46C1),
                () => _showExpenseDialog(context),
              ),
              _buildActionCard(
                'Find Schemes',
                Icons.card_giftcard,
                Colors.green,
                () => _navigateToSchemes(context),
              ),
              _buildActionCard(
                'Check Safety',
                Icons.security,
                Colors.red,
                () => _showSafetyCheck(context),
              ),
              _buildActionCard(
                'Learn & Grow',
                Icons.school,
                Colors.blue,
                () => _showLearningOptions(context),
              ),
            ],
          ),
          
          SizedBox(height: 25),
          
          Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          _buildActivityItem(
            'Expense Added',
            'Office supplies - ₹1,200',
            '2 hours ago',
            Icons.receipt,
          ),
          _buildActivityItem(
            'Payment Received',
            'Customer payment - ₹5,500',
            '4 hours ago',
            Icons.payment,
          ),
          _buildActivityItem(
            'Safety Alert',
            'Suspicious message detected',
            '1 day ago',
            Icons.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF6B46C1)),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Record Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Expense recorded successfully!')),
              );
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _navigateToSchemes(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Searching for eligible schemes...')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SchemeAgentScreen()),
    );
  }

  void _showSafetyCheck(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.green),
            SizedBox(width: 10),
            Text('Safety Check'),
          ],
        ),
        content: Text('Your account is secure. No threats detected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLearningOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Modules',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            ListTile(
              leading: Icon(Icons.account_balance, color: Color(0xFF6B46C1)),
              title: Text('Financial Literacy'),
              subtitle: Text('Learn about managing business finances'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.gavel, color: Color(0xFF6B46C1)),
              title: Text('Legal Basics'),
              subtitle: Text('Understand business registration and compliance'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.trending_up, color: Color(0xFF6B46C1)),
              title: Text('Digital Marketing'),
              subtitle: Text('Grow your business online'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class AgentsScreen extends StatelessWidget {
  const AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Agents',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Your personal AI assistants',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          SizedBox(height: 25),
          
          Expanded(
            child: ListView(
              children: [
                _buildAgentCard(
                  'Finance & Legal Assistant',
                  'Manages your finances, taxes, and legal compliance',
                  Icons.account_balance,
                  Color(0xFF6B46C1),
                  'Active - Last used 2 hours ago',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FinanceAgentScreen()),
                  ),
                ),
                _buildAgentCard(
                  'Scheme & Support Connector',
                  'Finds eligible schemes and connects you to support',
                  Icons.card_giftcard,
                  Colors.green,
                  'Active - Found 3 new schemes',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SchemeAgentScreen()),
                  ),
                ),
                _buildAgentCard(
                  'Fraud Detection & Safety',
                  'Protects you from scams and ensures safe transactions',
                  Icons.security,
                  Colors.red,
                  'Active - Blocked 2 threats today',
                  () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SafetyAgentScreen())),
                ),
                _buildAgentCard(
                  'Customer Interaction & Marketing',
                  'Handles customer queries and marketing automation',
                  Icons.chat,
                  Colors.blue,
                  'Active - 15 messages handled',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MarketingAgentScreen()),
                  ),
                ),
                _buildAgentCard(
                  'Learning Agent',
                  'Provides personalized learning content and tutorials',
                  Icons.school,
                  Colors.orange,
                  'Active - 3 lessons completed',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LearningAgentScreen()),
                  ),
                ),
                _buildAgentCard(
                  'Business Life Planner',
                  'Plans your business activities and personal schedule',
                  Icons.calendar_today,
                  Colors.purple,
                  'Active - 5 events scheduled',
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BusinessLifePlannerScreen()),
                  ),
                ),
                _buildAgentCard(
                  'Supervisor Agent',
                  'Coordinates all agents and provides unified guidance',
                  Icons.supervisor_account,
                  Colors.teal,
                  'Always Active - Monitoring all agents',
                  () => _showAgentDetails(context, 'Supervisor Agent'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentCard(
    String title,
    String description,
    IconData icon,
    Color color,
    String status,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAgentDetails(BuildContext context, String agentName) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    agentName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  children: [
                    _buildAgentStat('Tasks Completed Today', '12'),
                    _buildAgentStat('Success Rate', '98.5%'),
                    _buildAgentStat('Last Active', '2 hours ago'),
                    SizedBox(height: 20),
                    Text(
                      'Recent Activities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildActivityLog('Processed GST reminder', '2 hours ago'),
                    _buildActivityLog('Found new grant opportunity', '4 hours ago'),
                    _buildActivityLog('Updated expense tracker', '6 hours ago'),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$agentName activated!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B46C1),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 48),
                      ),
                      child: Text('Activate Agent'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgentStat(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B46C1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog(String activity, String time) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: Color(0xFF6B46C1)),
          SizedBox(width: 12),
          Expanded(child: Text(activity)),
          Text(
            time,
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
   const ProfileScreen({super.key});

  // Callback functions passed from HomeScreen
  //final VoidCallback _showAppSettings = () {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6B46C1), Color(0xFF9333EA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFF6B46C1),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Priya Sharma',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Handmade Crafts Business',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    'Premium Member',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 25),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard('Business Age', '2 Years', Icons.business),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _buildStatCard('Total Sales', '₹2.5L+', Icons.trending_up),
              ),
            ],
          ),
          
          SizedBox(height: 25),
          
          Text(
            'Account Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          
          Expanded(
            child: ListView(
              children: [
                _buildProfileOption(
                  'Personal Information',
                  'Update your profile details',
                  Icons.person,
                  () => _showPersonalInfo(context),
                ),
                _buildProfileOption(
                  'Business Details',
                  'Manage your business information',
                  Icons.business,
                  () => _showBusinessDetails(context),
                ),
                _buildProfileOption(
                  'Language & Region',
                  'Change app language and region settings',
                  Icons.language,
                  () => _showLanguageSettings(context),
                ),
                _buildProfileOption(
                  'Privacy & Security',
                  'Manage your privacy and security settings',
                  Icons.lock,
                  () => _showPrivacySettings(context),
                ),
                _buildProfileOption(
                  'Notifications',
                  'Configure notification preferences',
                  Icons.notifications,
                  () => _showNotificationSettings(context),
                ),
                _buildProfileOption(
                  'Help & Support',
                  'Get help and contact support',
                  Icons.help,
                  () => _showHelpSupport(context),
                ),
                _buildProfileOption(
                  'About EmpowerHer AI',
                  'App version and information',
                  Icons.info,
                  () => _showAbout(context),
                ),
                _buildProfileOption(
                  'App Settings',
                  'Customize app appearance and language',
                  Icons.settings,
                  () => _showAppSettings(context),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _showAppSettings(BuildContext context) {
    final homeState = context.findAncestorStateOfType<_HomeScreenState>();
    if (homeState == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Theme',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.brightness_6),
                  ),
                  value: homeState._currentTheme,
                  items: ['Light', 'Dark']
                      .map((theme) => DropdownMenuItem(
                            value: theme,
                            child: Text(theme),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {});
                    if (value != null) homeState._updateTheme(value);
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'App Language',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.language),
                  ),
                  value: homeState._currentLanguage,
                  items: homeState._languages
                      .map((lang) => DropdownMenuItem(
                            value: lang,
                            child: Text(lang),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {});
                    if (value != null) homeState._updateLanguage(value);
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Font Size',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.format_size),
                  ),
                  value: homeState._currentFontSize,
                  items: homeState._fontSizes
                      .map((size) => DropdownMenuItem(
                            value: size,
                            child: Text(size),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {});
                    if (value != null) homeState._updateFont(value, homeState._currentFontStyle);
                  },
                ),
                SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Font Style',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.font_download),
                  ),
                  value: homeState._currentFontStyle,
                  items: homeState._fontStyles
                      .map((style) => DropdownMenuItem(
                            value: style,
                            child: Text(style),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {});
                    if (value != null) homeState._updateFont(homeState._currentFontSize, value);
                  },
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Settings saved successfully!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6B46C1),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF6B46C1), size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B46C1),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF6B46C1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF6B46C1), size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showPersonalInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              controller: TextEditingController(text: 'p***@gmail.com'),
              enabled: false,
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              controller: TextEditingController(text: '+91-9****1234'),
              enabled: false,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile updated successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showBusinessDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Business Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Business Type',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Registration Number',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.numbers),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Business details updated successfully!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Language & Region',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Language',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              value: 'English',
              items: ['English', 'हिंदी', 'தமிழ்', 'বাংলা']
                  .map((lang) => DropdownMenuItem(
                        value: lang,
                        child: Text(lang),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 15),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              value: 'India',
              items: ['India', 'United States', 'United Kingdom', 'Other']
                  .map((region) => DropdownMenuItem(
                        value: region,
                        child: Text(region),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Language settings updated!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy & Security',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Two-Factor Authentication'),
              subtitle: Text('Enable 2FA for added security'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Data Sharing'),
              subtitle: Text('Allow data sharing for analytics'),
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: Text('Change Password'),
              subtitle: Text('Update your account password'),
              leading: Icon(Icons.lock, color: Color(0xFF6B46C1)),
              onTap: () => _showChangePassword(context),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Privacy settings updated!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password changed successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6B46C1),
              foregroundColor: Colors.white,
            ),
            child: Text('Change Password'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text('Push Notifications'),
              subtitle: Text('Receive push notifications'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('Email Notifications'),
              subtitle: Text('Receive notifications via email'),
              value: false,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: Text('SMS Notifications'),
              subtitle: Text('Receive notifications via SMS'),
              value: false,
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Notification settings updated!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6B46C1),
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Help & Support',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xFF6B46C1)),
              title: Text('Contact Support'),
              subtitle: Text('support@empowerher.ai'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.book, color: Color(0xFF6B46C1)),
              title: Text('Help Center'),
              subtitle: Text('Browse FAQs and guides'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat, color: Color(0xFF6B46C1)),
              title: Text('Live Chat'),
              subtitle: Text('Chat with our support team'),
              onTap: () {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B46C1),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About EmpowerHer AI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'EmpowerHer AI is your all-in-one business companion designed to support women entrepreneurs with AI-powered tools for finance, safety, learning, and more.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '© 2025 EmpowerHer AI. All rights reserved.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6B46C1),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 48),
              ),
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class MarketingAgentScreen extends StatefulWidget {
  const MarketingAgentScreen({super.key});

  @override
  _MarketingAgentScreenState createState() => _MarketingAgentScreenState();
}

class _MarketingAgentScreenState extends State<MarketingAgentScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Week', 'This Month', 'Last 30 Days', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marketing Assistant'),
        backgroundColor: Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0), // Reduced from 20.0
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Marketing Dashboard',
                      style: TextStyle(
                        fontSize: 22, // Reduced from 24
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B46C1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (value) => setState(() => _selectedPeriod = value!),
                    items: _periods.map((period) => DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    )).toList(),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF6B46C1)),
                    style: TextStyle(color: Colors.black87, fontSize: 14), // Reduced from 16
                    dropdownColor: Colors.white,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildMarketingCard(
                          'Messages Handled',
                          '15',
                          '+3 Today',
                          Icons.chat,
                          Colors.blue,
                        ),
                      ),
                      SizedBox(width: 10.0), // Reduced from 15.0
                      Expanded(
                        flex: 1,
                        child: _buildMarketingCard(
                          'Campaign Views',
                          '320',
                          '+50 This Week',
                          Icons.visibility,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0), // Reduced from 15.0
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildMarketingCard(
                          'Customer Queries',
                          '8',
                          '2 Pending',
                          Icons.question_answer,
                          Colors.orange,
                        ),
                      ),
                      SizedBox(width: 10.0), // Reduced from 15.0
                      Expanded(
                        flex: 1,
                        child: _buildMarketingCard(
                          'Sales Leads',
                          '5',
                          '+1 This Month',
                          Icons.trending_up,
                          Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.0), // Reduced from 7.5
                      child: ElevatedButton.icon(
                        onPressed: () => _startCampaign(context),
                        icon: Icon(Icons.campaign, size: 18.0), // Reduced from default
                        label: Text('Start Campaign'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          minimumSize: Size(0, 45.0), // Reduced from 50.0
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0), // Reduced from 15.0
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0), // Reduced from 7.5
                      child: ElevatedButton.icon(
                        onPressed: () => _viewAnalytics(context),
                        icon: Icon(Icons.analytics, size: 18.0), // Reduced from default
                        label: Text('View Analytics'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          minimumSize: Size(0, 45.0), // Reduced from 50.0
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Recent Customer Interactions',
                style: TextStyle(
                  fontSize: 16, // Reduced from 18
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B46C1),
                ),
              ),
              SizedBox(height: 12.0), // Reduced from 15.0
              Column(
                children: [
                  _buildInteractionItem(
                    'Query: Order Status',
                    'Responded at 01:00 AM IST',
                    'June 30, 2025',
                  ),
                  _buildInteractionItem(
                    'Feedback: Product Quality',
                    'Pending Response',
                    'June 29, 2025',
                  ),
                  _buildInteractionItem(
                    'Lead: New Client Inquiry',
                    'Follow-up Scheduled',
                    'June 28, 2025',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMarketingCard(String title, String amount, String change, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.0), // Reduced from 16.0
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20.0), // Reduced from 24.0
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 11.0, // Reduced from 12.0
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Reduced from 10.0
          Text(
            amount,
            style: TextStyle(
              fontSize: 18.0, // Reduced from 20.0
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.0, // Reduced from 14.0
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionItem(String title, String status, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0), // Reduced from 10.0
      padding: EdgeInsets.all(12.0), // Reduced from 16.0
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0), // Reduced from 10.0
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0), // Reduced from 16.0
              ),
              Text(
                status,
                style: TextStyle(
                  color: status.contains('Pending') ? Colors.red : Colors.grey[600],
                  fontSize: 11.0, // Reduced from 12.0
                ),
              ),
            ],
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11.0, // Reduced from 12.0
            ),
          ),
        ],
      ),
    );
  }

  void _startCampaign(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Start Marketing Campaign'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Campaign Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Target Audience',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Duration (e.g., 1 Week)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Campaign started successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text('Start'),
          ),
        ],
      ),
    );
  }

  void _viewAnalytics(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Analytics for $_selectedPeriod',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Reduced from 16
            ),
            SizedBox(height: 8.0), // Reduced from 10
            Text('Messages Handled: 15'),
            Text('Campaign Views: 320'),
            Text('Conversion Rate: 12%'),
            SizedBox(height: 15.0), // Reduced from 20
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
class FinanceAgentScreen extends StatefulWidget {
  const FinanceAgentScreen({super.key});

  @override
  _FinanceAgentScreenState createState() => _FinanceAgentScreenState();
}

class _FinanceAgentScreenState extends State<FinanceAgentScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['This Week', 'This Month', 'Last 30 Days', 'This Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finance & Legal Assistant'),
        backgroundColor: Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Finance Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (value) => setState(() => _selectedPeriod = value!),
                    items: _periods.map((period) => DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    )).toList(),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF6B46C1)),
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    dropdownColor: Colors.white,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Finance Stats in a Grid Layout
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildFinanceCard(
                          'Total Revenue',
                          '₹45,230',
                          '+₹5,000 This Month',
                          Icons.trending_up,
                          Colors.green,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: _buildFinanceCard(
                          'Expenses',
                          '₹12,450',
                          '+₹1,200 This Week',
                          Icons.money_off,
                          Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildFinanceCard(
                          'Profit',
                          '₹32,780',
                          '+₹3,800 This Month',
                          Icons.attach_money,
                          Colors.teal,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: _buildFinanceCard(
                          'Pending Invoices',
                          '2',
                          'Due in 3 Days',
                          Icons.receipt,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addExpense(context),
                      icon: Icon(Icons.receipt),
                      label: Text('Add Expense'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF6B46C1),
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _viewReports(context),
                      icon: Icon(Icons.insert_chart),
                      label: Text('View Reports'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Recent Transactions
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),
              Column(
                children: [
                  _buildTransactionItem(
                    'Office Supplies',
                    '₹1,200',
                    'Expense',
                    'June 29, 2025',
                  ),
                  _buildTransactionItem(
                    'Customer Payment',
                    '₹5,500',
                    'Revenue',
                    'June 28, 2025',
                  ),
                  _buildTransactionItem(
                    'Rent Payment',
                    '₹8,000',
                    'Expense',
                    'June 25, 2025',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFinanceCard(String title, String amount, String change, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.0),
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String description, String amount, String type, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                type,
                style: TextStyle(
                  color: type == 'Revenue' ? Colors.green : Colors.red,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          Text(
            '$amount - $date',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  void _addExpense(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Amount (₹)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date (e.g., June 30, 2025)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Expense added successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6B46C1)),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _viewReports(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reports for $_selectedPeriod',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Total Revenue: ₹45,230'),
            Text('Total Expenses: ₹12,450'),
            Text('Net Profit: ₹32,780'),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class SchemeAgentScreen extends StatefulWidget {
  const SchemeAgentScreen({super.key});

  @override
  _SchemeAgentScreenState createState() => _SchemeAgentScreenState();
}

class _SchemeAgentScreenState extends State<SchemeAgentScreen> {
  String _selectedCategory = 'All Schemes';
  final List<String> _categories = ['All Schemes', 'Government', 'Private', 'Women-Specific'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheme & Support Connector'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scheme Finder',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedCategory,
                    onChanged: (value) => setState(() => _selectedCategory = value!),
                    items: _categories.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )).toList(),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.green),
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    dropdownColor: Colors.white,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Scheme Stats
              _buildSchemeCard(
                'Available Schemes',
                '5',
                '3 New This Month',
                Icons.card_giftcard,
                Colors.green,
              ),
              SizedBox(height: 25.0),

              // Action Button
              ElevatedButton.icon(
                onPressed: () => _searchSchemes(context),
                icon: Icon(Icons.search),
                label: Text('Search Schemes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 25.0),

              // Available Schemes
              Text(
                'Available Schemes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),
              Column(
                children: [
                  _buildSchemeItem(
                    'PM Mudra Loan',
                    'Up to ₹10L for women entrepreneurs',
                    'Government',
                    'July 15, 2025',
                  ),
                  _buildSchemeItem(
                    'Women Startup India',
                    'Grant up to ₹1Cr',
                    'Government',
                    'August 1, 2025',
                  ),
                  _buildSchemeItem(
                    'SheMeansBusiness',
                    'Free digital marketing training',
                    'Private',
                    'Ongoing',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeCard(String title, String amount, String change, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.0),
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeItem(String title, String description, String category, String deadline) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.0,
                ),
              ),
              Text(
                category,
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          Text(
            'Deadline: $deadline',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  void _searchSchemes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Schemes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search Keyword (e.g., Loan, Grant)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: 'All Schemes',
              items: _categories.map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              )).toList(),
              onChanged: (value) {},
            ),
            SizedBox(height: 20.0),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Searching for schemes...')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Search'),
          ),
        ],
      ),
    );
  }
}

class LearningAgentScreen extends StatefulWidget {
  const LearningAgentScreen({super.key});

  @override
  _LearningAgentScreenState createState() => _LearningAgentScreenState();
}

class _LearningAgentScreenState extends State<LearningAgentScreen> {
  final TextEditingController _queryController = TextEditingController();
  String _selectedLanguage = 'en';
  final List<String> _languages = ['en', 'hi', 'ta', 'bn', 'mr', 'te', 'kn', 'ml', 'pa'];
  final List<String> _languageNames = ['English', 'हिंदी', 'தமிழ்', 'বাংলা', 'मराठी', 'తెలుగు', 'ಕನ್ನಡ', 'മലയാളം', 'ਪੰਜਾਬੀ'];
  final List<Map<String, String>> _chatHistory = [];
  bool _isLoading = false;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => print('WebView loading: $url'),
          onPageFinished: (url) => print('WebView loaded: $url'),
          onWebResourceError: (error) => print('WebView error: ${error.description}'),
        ),
      )
      ..loadFlutterAsset('assets/jotform.html')
      ..addJavaScriptChannel('FlutterCommunication',
          onMessageReceived: (message) => print('JS message: ${message.message}'));
  }

  // Commented out chat functionality since no backend exists
  /*
  Future<String> _fetchResponse(String query, String lang) async {
    final url = Uri.parse('http://10.0.2.2:5000/chat');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query, 'lang': lang}),
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] as String;
      } else {
        return 'Error: Server returned ${response.statusCode}';
      }
    } catch (e) {
      print('Network error: $e');
      return 'Error: Network issue - $e';
    }
  }

  Future<void> _sendQuery() async {
    if (_queryController.text.isEmpty) return;

    final currentTime = '06:05 PM IST, June 30, 2025';
    setState(() {
      _isLoading = true;
      _chatHistory.add({'role': 'user', 'text': _queryController.text, 'time': currentTime});
    });

    final response = await _fetchResponse(_queryController.text, _selectedLanguage);

    setState(() {
      _chatHistory.add({'role': 'bot', 'text': response, 'time': currentTime});
      _queryController.clear();
      _isLoading = false;
    });

    if (_chatHistory.length > 20) {
      setState(() {
        _chatHistory.removeRange(0, _chatHistory.length - 20);
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Learning Assistant'),
        backgroundColor: Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Learning Dashboard',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B46C1),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (value) => setState(() => _selectedLanguage = value!),
                  items: _languages.map((lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(_languageNames[_languages.indexOf(lang)]),
                  )).toList(),
                  underline: SizedBox(),
                  icon: Icon(Icons.arrow_drop_down, color: Color(0xFF6B46C1)),
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                  dropdownColor: Colors.white,
                  alignment: Alignment.centerRight,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  final message = _chatHistory[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: message['role'] == 'user' ? Color(0xFF6B46C1).withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 5.0,
                          offset: Offset(0, 2.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['text']!,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: message['role'] == 'user' ? Color(0xFF6B46C1) : Colors.black87,
                          ),
                        ),
                        Text(
                          message['time']!,
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.0),
            Expanded(
              flex: 1,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Provide Feedback',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B46C1),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Expanded(
                        child: WebViewWidget(controller: _webViewController),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Flexible(
                  flex: 4,
                  child: TextField(
                    controller: _queryController,
                    decoration: InputDecoration(
                      hintText: 'Ask about business skills or progress...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      prefixIcon: Icon(Icons.question_answer, color: Color(0xFF6B46C1), size: 18.0),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                Flexible(
                  flex: 1,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Color(0xFF6B46C1), strokeWidth: 2.0)
                      : ElevatedButton(
                          onPressed: () {
                            // Placeholder since no chat backend exists
                            final currentTime = '06:05 PM IST, June 30, 2025';
                            setState(() {
                              _chatHistory.add({'role': 'user', 'text': _queryController.text, 'time': currentTime});
                              _queryController.clear();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6B46C1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: Size(0, 40.0),
                          ),
                          child: Icon(Icons.send, size: 16.0),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// ... (FinanceAgentScreen, SchemeAgentScreen, and MarketingAgentScreen code remain unchanged)

// New BusinessLifePlannerScreen
class BusinessLifePlannerScreen extends StatefulWidget {
  const BusinessLifePlannerScreen({super.key});

  @override
  _BusinessLifePlannerState createState() => _BusinessLifePlannerState();
}

class _BusinessLifePlannerState extends State<BusinessLifePlannerScreen> {
  String _selectedPeriod = 'This Week';
  final List<String> _periods = ['This Week', 'This Month', 'Next 7 Days', 'Next 30 Days'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Life Planner'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Planning Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (value) => setState(() => _selectedPeriod = value!),
                    items: _periods.map((period) => DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    )).toList(),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.purple),
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    dropdownColor: Colors.white,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Planning Stats in a Grid Layout
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildPlannerCard(
                          'Events Scheduled',
                          '5',
                          '+1 Today',
                          Icons.event,
                          Colors.purple,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: _buildPlannerCard(
                          'Tasks Completed',
                          '8',
                          '+2 Today',
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildPlannerCard(
                          'Upcoming Deadlines',
                          '3',
                          '2 Due Tomorrow',
                          Icons.alarm,
                          Colors.orange,
                        ),
                      ),
                      SizedBox(width: 15.0),
                      Expanded(
                        child: _buildPlannerCard(
                          'Meetings Planned',
                          '4',
                          '+1 This Week',
                          Icons.people,
                          Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addEvent(context),
                      icon: Icon(Icons.add),
                      label: Text('Add Event'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _viewSchedule(context),
                      icon: Icon(Icons.calendar_today),
                      label: Text('View Schedule'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.0),

              // Upcoming Events
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),
              Column(
                children: [
                  _buildEventItem(
                    'Team Meeting',
                    '10:00 AM - 11:00 AM',
                    'June 30, 2025',
                  ),
                  _buildEventItem(
                    'Project Deadline',
                    '2:00 PM - 3:00 PM',
                    'July 1, 2025',
                  ),
                  _buildEventItem(
                    'Client Call',
                    '9:00 AM - 10:00 AM',
                    'July 2, 2025',
                  ),
                  _buildEventItem(
                    'Weekly Review',
                    '3:00 PM - 4:00 PM',
                    'July 6, 2025',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlannerCard(String title, String amount, String change, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24.0),
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(String title, String time, String date) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  void _addEvent(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Event'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Time (e.g., 10:00 AM - 11:00 AM)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Date (e.g., July 1, 2025)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Event added successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _viewSchedule(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('View Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Schedule for $_selectedPeriod',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('June 30, 2025: Team Meeting (10:00 AM - 11:00 AM)'),
            Text('July 1, 2025: Project Deadline (2:00 PM - 3:00 PM)'),
            Text('July 2, 2025: Client Call (9:00 AM - 10:00 AM)'),
            SizedBox(height: 20),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class SafetyAgentScreen extends StatefulWidget {
  const SafetyAgentScreen({super.key});

  @override
  _SafetyAgentScreenState createState() => _SafetyAgentScreenState();
}

class _SafetyAgentScreenState extends State<SafetyAgentScreen> {
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'Last 30 Days'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fraud Detection & Safety'),
        backgroundColor: Color(0xFF6B46C1),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0), // Reduced from 20.0 to 16.0
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Safety Dashboard',
                      style: TextStyle(
                        fontSize: 22, // Reduced from 24
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6B46C1),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedPeriod,
                    onChanged: (value) => setState(() => _selectedPeriod = value!),
                    items: _periods.map((period) => DropdownMenuItem(
                      value: period,
                      child: Text(period),
                    )).toList(),
                    underline: SizedBox(),
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF6B46C1)),
                    style: TextStyle(color: Colors.black87, fontSize: 14), // Reduced from 16
                    dropdownColor: Colors.white,
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildSafetyCard(
                          'Threats Blocked',
                          '2',
                          '+1 Today',
                          Icons.shield,
                          Colors.red,
                        ),
                      ),
                      SizedBox(width: 10.0), // Reduced from 15.0
                      Expanded(
                        flex: 1,
                        child: _buildSafetyCard(
                          'Safe Transactions',
                          '95%',
                          '+2% This Week',
                          Icons.verified,
                          Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0), // Reduced from 15.0
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildSafetyCard(
                          'Suspicious Alerts',
                          '3',
                          'Reviewed at 02:10 AM IST',
                          Icons.warning,
                          Colors.orange,
                        ),
                      ),
                      SizedBox(width: 10.0), // Reduced from 15.0
                      Expanded(
                        flex: 1,
                        child: _buildSafetyCard(
                          'Security Score',
                          '98%',
                          'Updated June 30, 2025',
                          Icons.security,
                          Color(0xFF6B46C1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.0), // Reduced from 7.5
                      child: ElevatedButton.icon(
                        onPressed: () => _runSafetyCheck(context),
                        icon: Icon(Icons.security, size: 18.0), // Reduced from default
                        label: Text('Run Safety Check'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6B46C1),
                          foregroundColor: Colors.white,
                          minimumSize: Size(0, 45.0), // Reduced from 50.0
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0), // Reduced from 15.0
                  Flexible(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.0), // Reduced from 7.5
                      child: ElevatedButton.icon(
                        onPressed: () => _viewSecurityLogs(context),
                        icon: Icon(Icons.history, size: 18.0), // Reduced from default
                        label: Text('View Logs'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          minimumSize: Size(0, 45.0), // Reduced from 50.0
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                'Recent Security Alerts',
                style: TextStyle(
                  fontSize: 16, // Reduced from 18
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B46C1),
                ),
              ),
              SizedBox(height: 12.0), // Reduced from 15.0
              Column(
                children: [
                  _buildAlertItem(
                    'Suspicious Login Attempt',
                    'Blocked at 02:15 AM IST, June 30, 2025',
                    Icons.lock,
                    Colors.red,
                  ),
                  _buildAlertItem(
                    'Unusual Transaction',
                    'Flagged at 11:30 PM IST, June 29, 2025',
                    Icons.payment,
                    Colors.orange,
                  ),
                  _buildAlertItem(
                    'Phishing Email Detected',
                    'Quarantined at 10:15 PM IST, June 29, 2025',
                    Icons.email,
                    Colors.yellow,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSafetyCard(String title, String amount, String change, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12.0), // Reduced from 16.0
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20.0), // Reduced from 24.0
              Text(
                change,
                style: TextStyle(
                  color: color,
                  fontSize: 11.0, // Reduced from 12.0
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0), // Reduced from 10.0
          Text(
            amount,
            style: TextStyle(
              fontSize: 18.0, // Reduced from 20.0
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12.0, // Reduced from 14.0
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String title, String timestamp, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.0), // Reduced from 10.0
      padding: EdgeInsets.all(12.0), // Reduced from 16.0
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0), // Reduced from 10.0
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5.0,
            offset: Offset(0, 2.0),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.0), // Reduced from 8.0
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6.0), // Reduced from 8.0
            ),
            child: Icon(icon, color: color, size: 18.0), // Reduced from 20.0
          ),
          SizedBox(width: 10.0), // Reduced from 15.0
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0, // Reduced from 16.0
                  ),
                ),
                Text(
                  timestamp,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11.0, // Reduced from 12.0
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 14.0), // Reduced from 16.0
        ],
      ),
    );
  }

  void _runSafetyCheck(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: Color(0xFF6B46C1)),
            SizedBox(width: 8.0), // Reduced from 10
            Text('Safety Check'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Scanning your account for threats...',
              style: TextStyle(fontSize: 14), // Reduced from 16
            ),
            SizedBox(height: 15.0), // Reduced from 20
            CircularProgressIndicator(color: Color(0xFF6B46C1)),
            SizedBox(height: 15.0), // Reduced from 20
            Text(
              'Last check: 02:10 AM IST, June 30, 2025',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]), // Reduced from 12
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Safety check completed. No threats detected.')),
              );
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewSecurityLogs(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Security Logs'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logs for $_selectedPeriod',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Reduced from 16
            ),
            SizedBox(height: 8.0), // Reduced from 10
            Text('Blocked Login Attempt: 02:15 AM IST, June 30, 2025'),
            Text('Flagged Transaction: 11:30 PM IST, June 29, 2025'),
            Text('Phishing Email: 10:15 PM IST, June 29, 2025'),
            SizedBox(height: 15.0), // Reduced from 20
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}