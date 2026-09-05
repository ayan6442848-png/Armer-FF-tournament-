
                        
import 'package:flutter/material.dart';

void main() {
  runApp(const TournamentApp());
}

class TournamentApp extends StatelessWidget {
  const TournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Free Fire Tournament',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

// Global Simulated Data Stores
List<Map<String, String>> tournamentMatches = [
  {
    'title': 'Solo Battle Royale - Map: Bermuda',
    'subtitle': 'Entry Fee: ₹20 | Prize Pool: ₹500',
    'fee': '20',
    'prize': '500',
    'time': '06:00 PM',
  },
];

List<Map<String, String>> userProfiles = [
  {'name': 'Ayan Khan', 'uid': '987654321', 'balance': '150'},
  {'name': 'FF_Pro_Player', 'uid': '123456789', 'balance': '50'},
];

List<Map<String, String>> transactionHistory = [
  {'user': 'Ayan Khan', 'type': 'Deposit', 'amount': '100', 'status': 'Approved', 'date': '05 Sep 2026'},
  {'user': 'FF_Pro_Player', 'type': 'Withdrawal', 'amount': '50', 'status': 'Pending', 'date': '05 Sep 2026'},
];

double totalRevenueCollected = 500.0;
double totalPrizeDistributed = 300.0;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeTab(),
    WalletTab(),
    ProfileTab(),
  ];

  void _openAdminLogin() {
    TextEditingController pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Admin Access'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter Admin Secret PIN (1234)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (pinController.text == '1234') {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FullAdminDashboard()),
                ).then((_) => setState(() {}));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Admin PIN!')),
                );
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FF Tournament Hub'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings),
            onPressed: _openAdminLogin,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.deepOrange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: 'Tournaments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
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

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upcoming Matches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: tournamentMatches.length,
              itemBuilder: (context, index) {
                final match = tournamentMatches[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.fireplace, color: Colors.deepOrange, size: 40),
                    title: Text(match['title'] ?? ''),
                    subtitle: Text('${match['subtitle']}\nTime: ${match['time']}'),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Join'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FullAdminDashboard extends StatefulWidget {
  const FullAdminDashboard({super.key});

  @override
  State<FullAdminDashboard> createState() => _FullAdminDashboardState();
}

class _FullAdminDashboardState extends State<FullAdminDashboard> {
  final _titleController = TextEditingController();
  final _feeController = TextEditingController();
  final _prizeController = TextEditingController();
  final _timeController = TextEditingController();

  void _addNewMatch() {
    if (_titleController.text.isNotEmpty && _feeController.text.isNotEmpty) {
      setState(() {
        tournamentMatches.add({
          'title': _titleController.text,
          'subtitle': 'Entry Fee: ₹${_feeController.text} | Prize Pool: ₹${_prizeController.text}',
          'fee': _feeController.text,
          'prize': _prizeController.text,
          'time': _timeController.text.isEmpty ? '08:00 PM' : _timeController.text,
        });
      });
      _titleController.clear();
      _feeController.clear();
      _prizeController.clear();
      _timeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match Added!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double netProfit = totalRevenueCollected - totalPrizeDistributed;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Master Panel'),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.deepOrange,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.add), text: 'Add Match'),
              Tab(icon: Icon(Icons.people), text: 'Customers'),
              Tab(icon: Icon(Icons.history), text: 'Transactions'),
              Tab(icon: Icon(Icons.analytics), text: 'Profit Analytics'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Add Match
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Match Name (e.g. Squad Bermuda)'),
                  ),
                  TextField(
                    controller: _feeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Entry Fee (₹)'),
                  ),
                  TextField(
                    controller: _prizeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Prize Pool (₹)'),
                  ),
                  TextField(
                    controller: _timeController,
                    decoration: const InputDecoration(labelText: 'Match Time (e.g. 08:00 PM)'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addNewMatch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Publish Match'),
                  ),
                ],
              ),
            ),

            // Tab 2: Customers
            ListView.builder(
              itemCount: userProfiles.length,
              itemBuilder: (context, index) {
                final user = userProfiles[index];
                return ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user['name'] ?? ''),
                  subtitle: Text('FF UID: ${user['uid']}'),
                  trailing: Text(
                    '₹${user['balance']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                  ),
                );
              },
            ),

            // Tab 3: Deposit/Withdrawal History
            ListView.builder(
              itemCount: transactionHistory.length,
              itemBuilder: (context, index) {
                final tx = transactionHistory[index];
                bool isDeposit = tx['type'] == 'Deposit';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(
                      isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isDeposit ? Colors.green : Colors.red,
                    ),
                    title: Text('${tx['user']} (${tx['type']})'),
                    subtitle: Text('Amount: ₹${tx['amount']} | Date: ${tx['date']}'),
                    trailing: Chip(
                      label: Text(tx['status'] ?? ''),
                      backgroundColor: tx['status'] == 'Approved' ? Colors.green.shade100 : Colors.orange.shade100,
                    ),
                  ),
                );
              },
            ),

            // Tab 4: Profit Analytics
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.green.shade50,
                    child: ListTile(
                      title: const Text('Total Entry Fees Received'),
                      trailing: Text('₹$totalRevenueCollected', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ),
                  Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      title: const Text('Total Prizes Paid Out'),
                      trailing: Text('₹$totalPrizeDistributed', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                  ),
                  const Divider(height: 30),
                  Card(
                    color: Colors.black,
                    child: ListTile(
                      title: const Text('Net Admin Profit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      trailing: Text(
                        '₹$netProfit',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WalletTab extends StatelessWidget {
  const WalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Your Wallet Balance',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.account_balance_wallet, color: Colors.green, size: 36),
              title: Text('Available Balance: ₹150'),
              subtitle: Text('Deposit / Withdraw via UPI'),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Player Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(Icons.person, size: 36),
              title: Text('Ayan Khan'),
              subtitle: Text('Free Fire UID: 987654321'),
            ),
          ),
        ],
      ),
    );
  }
}
