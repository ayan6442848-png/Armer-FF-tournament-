
                        
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
      home: const AuthScreen(),
    );
  }
}

// Global Application State & Storage
String adminUpiId = "9876543210@paytm";
String whatsappSupportNumber = "9289678990"; // WhatsApp Only Contact
bool autoApproveDeposits = false; // Admin Toggle for Auto Approve Deposit

// Logged In User State
bool isLoggedIn = false;
String currentUserName = "";
String currentFfUsername = "";
String currentUserPhone = "";
double userWalletBalance = 200.0;

// User Statistics
int totalMatchesPlayed = 0;
int totalMatchesWon = 0;
int totalMatchesLost = 0;
int totalKills = 0;
double totalEarning = 0.0;
double totalDepositAmt = 200.0;
double totalWithdrawAmt = 0.0;

// Video Tutorials Data List (Managed by Admin)
List<Map<String, String>> appTutorialVideos = [
  {
    'title': 'How to Join Tournament & Select Slot',
    'url': 'https://www.youtube.com/watch?v=sample1'
  },
  {
    'title': 'How to Deposit & Withdraw Money',
    'url': 'https://www.youtube.com/watch?v=sample2'
  }
];

// Matches Data Store
List<Map<String, dynamic>> tournamentMatches = [
  {
    'id': 'M101',
    'title': 'Bermuda War',
    'matchType': 'Solo', // Solo, Duo, or Squad
    'fee': 20.0,
    'prize': 500.0,
    'time': '06:00 PM',
    'totalSlots': 48,
    'roomId': '8877665',
    'roomPassword': '999',
    'bookedSlots': <int, String>{
      1: 'ProGamer123',
      5: 'FFKing99',
    },
  },
];

// User's Joined Matches
List<Map<String, dynamic>> myJoinedMatches = [];

// Match Results Data List
List<Map<String, dynamic>> completedMatchResults = [
  {
    'matchTitle': 'Bermuda Grand War (Solo)',
    'date': '05 Sep 2026',
    'results': [
      {'rank': '#1 Winner', 'player': 'FFKing99', 'kills': 8, 'winning': '₹250'},
      {'rank': '#2 Runner', 'player': 'ProGamer123', 'kills': 5, 'winning': '₹120'},
      {'rank': '#3 Third', 'player': 'SniperGod', 'kills': 3, 'winning': '₹50'},
    ]
  }
];

// Transactions History
List<Map<String, String>> transactionHistory = [
  {'type': 'Deposit', 'amount': '200', 'status': 'Approved', 'date': '05 Sep 2026', 'txnId': 'TXN12345678'},
];

double totalRevenueCollected = 500.0;
double totalPrizeDistributed = 200.0;

// ---------------- 1. AUTHENTICATION (LOGIN / SIGNUP) ----------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;
  final _nameController = TextEditingController();
  final _ffNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitAuth() {
    if (_ffNameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all mandatory fields!')),
      );
      return;
    }

    setState(() {
      isLoggedIn = true;
      currentFfUsername = _ffNameController.text.trim();
      currentUserName = _nameController.text.trim().isEmpty ? currentFfUsername : _nameController.text.trim();
      currentUserPhone = _phoneController.text.trim();
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sports_esports, size: 60, color: Colors.deepOrange),
                  const SizedBox(height: 10),
                  Text(
                    isLoginMode ? 'Login to Tournament App' : 'Create New Account',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  if (!isLoginMode) ...[
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _ffNameController,
                    decoration: const InputDecoration(labelText: 'Free Fire Username (IGN)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  if (!isLoginMode) ...[
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitAuth,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                      child: Text(isLoginMode ? 'LOGIN' : 'REGISTER ACCOUNT', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginMode = !isLoginMode;
                      });
                    },
                    child: Text(isLoginMode ? 'Don\'t have an account? Create One' : 'Already have an account? Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- MAIN APP HOME & NAVIGATION ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
          decoration: const InputDecoration(hintText: 'Enter Secret Admin PIN'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
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
    final List<Widget> pages = [
      HomeTab(onJoined: () => setState(() {})),
      const MyMatchesTab(),
      const WalletTab(),
      const ProfileTab(),
      const SettingsTab(),
    ];

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
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.deepOrange,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Tournaments'),
          BottomNavigationBarItem(icon: Icon(Icons.stars), label: 'My Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ---------------- TAB 1: ALL TOURNAMENTS & JOINING ----------------
class HomeTab extends StatefulWidget {
  final VoidCallback onJoined;
  const HomeTab({super, required this.onJoined});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  void _showJoinSlotDialog(Map<String, dynamic> match) {
    double fee = match['fee'];
    int totalSlots = match['totalSlots'] ?? 48;
    Map<int, String> bookedSlots = Map<int, String>.from(match['bookedSlots'] ?? {});
    int? selectedSlot;

    TextEditingController ignController = TextEditingController(text: currentFfUsername);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Join ${match['title']} (${match['matchType']})'),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Entry Fee: ₹$fee | Type: ${match['matchType']}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 15)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: ignController,
                        decoration: const InputDecoration(
                          labelText: 'Free Fire Username (Only IGN)',
                          hintText: 'Enter Game Name (No numeric UID)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Select Slot Number (1 to $totalSlots):', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 180,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 2.2,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: totalSlots,
                          itemBuilder: (context, index) {
                            int slotNum = index + 1;
                            bool isBooked = bookedSlots.containsKey(slotNum);
                            bool isSelected = selectedSlot == slotNum;

                            return ChoiceChip(
                              label: Text('$slotNum', style: const TextStyle(fontSize: 12)),
                              selected: isSelected,
                              disabledColor: Colors.grey.shade300,
                              selectedColor: Colors.deepOrange,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : (isBooked ? Colors.grey : Colors.black),
                                fontWeight: FontWeight.bold,
                              ),
                              onSelected: isBooked
                                  ? null
                                  : (selected) {
                                      setDialogState(() {
                                        selectedSlot = selected ? slotNum : null;
                                      });
                                    },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    String enteredName = ignController.text.trim();

                    if (enteredName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter your Free Fire Game Name!')),
                      );
                      return;
                    }

                    if (RegExp(r'^[0-9]+$').hasMatch(enteredName)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error: Only Free Fire Game Name (IGN) allowed! Do NOT enter numeric UID.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (selectedSlot == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select an available Slot Number!')),
                      );
                      return;
                    }

                    if (userWalletBalance < fee) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Insufficient Balance! Please Deposit in Wallet.')),
                      );
                      return;
                    }

                    setState(() {
                      userWalletBalance -= fee;
                      totalRevenueCollected += fee;
                      totalMatchesPlayed += 1;

                      bookedSlots[selectedSlot!] = enteredName;
                      match['bookedSlots'] = bookedSlots;

                      myJoinedMatches.add({
                        'matchId': match['id'],
                        'title': match['title'],
                        'matchType': match['matchType'],
                        'time': match['time'],
                        'slot': selectedSlot,
                        'ign': enteredName,
                        'roomId': match['roomId'],
                        'roomPassword': match['roomPassword'],
                      });
                    });

                    widget.onJoined();
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Joined successfully in Slot #$selectedSlot! Details in "My Matches".')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                  child: const Text('Pay & Join'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTutorialsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App Usage Tutorials'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: appTutorialVideos.length,
            itemBuilder: (context, index) {
              final vid = appTutorialVideos[index];
              return ListTile(
                leading: const Icon(Icons.play_circle_fill, color: Colors.red, size: 36),
                title: Text(vid['title'] ?? ''),
                subtitle: SelectableText(vid['url'] ?? ''),
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Active Tournaments', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: _showTutorialsDialog,
                icon: const Icon(Icons.video_library, size: 18),
                label: const Text('Tutorials'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade700, foregroundColor: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: tournamentMatches.length,
              itemBuilder: (context, index) {
                final match = tournamentMatches[index];
                Map<int, String> booked = Map<int, String>.from(match['bookedSlots'] ?? {});
                int totalSlots = match['totalSlots'] ?? 48;

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Chip(
                      label: Text(match['matchType'] ?? 'Solo', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.deepOrange,
                    ),
                    title: Text(match['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Entry Fee: ₹${match['fee']} | Prize: ₹${match['prize']}\nTime: ${match['time']} | Joined: ${booked.length}/$totalSlots Players',
                    ),
                    isThreeLine: true,
                    trailing: ElevatedButton(
                      onPressed: () => _showJoinSlotDialog(match),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
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

// ---------------- TAB 2: MY MATCHES & MATCH RESULTS ----------------
class MyMatchesTab extends StatelessWidget {
  const MyMatchesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            labelColor: Colors.deepOrange,
            indicatorColor: Colors.deepOrange,
            tabs: [
              Tab(icon: Icon(Icons.star), text: 'Joined Matches'),
              Tab(icon: Icon(Icons.emoji_events), text: 'Match Results'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Sub-Tab 1: Joined Matches
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: myJoinedMatches.isEmpty
                      ? const Center(
                          child: Text('You have not joined any match yet.\nJoin from Tournaments tab!',
                              textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                        )
                      : ListView.builder(
                          itemCount: myJoinedMatches.length,
                          itemBuilder: (context, index) {
                            final item = myJoinedMatches[index];
                            return Card(
                              color: Colors.deepOrange.shade50,
                              elevation: 3,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${item['title']} (${item['matchType']})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text('Time: ${item['time']} | Your Slot: Slot #${item['slot']}'),
                                    Text('Game IGN: ${item['ign']}'),
                                    const Divider(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.deepOrange),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SelectableText('Room ID: ${item['roomId'] ?? "Will update before match"}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                              SelectableText('Password: ${item['roomPassword'] ?? "123"}',
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                                            ],
                                          ),
                                          const Icon(Icons.lock_open, color: Colors.green, size: 30),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // Sub-Tab 2: Match Results (Kills, Winners & Earnings)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: completedMatchResults.isEmpty
                      ? const Center(child: Text('No match results declared yet.'))
                      : ListView.builder(
                          itemCount: completedMatchResults.length,
                          itemBuilder: (context, index) {
                            final matchRes = completedMatchResults[index];
                            List resultsList = matchRes['results'] ?? [];

                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ExpansionTile(
                                leading: const Icon(Icons.emoji_events, color: Colors.amber, size: 36),
                                title: Text(matchRes['matchTitle'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('Date: ${matchRes['date']}'),
                                children: [
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                    child: Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(1.2),
                                        1: FlexColumnWidth(2.0),
                                        2: FlexColumnWidth(1.0),
                                        3: FlexColumnWidth(1.2),
                                      },
                                      border: TableBorder.all(color: Colors.grey.shade300),
                                      children: [
                                        const TableRow(
                                          decoration: BoxDecoration(color: Colors.deepOrange),
                                          children: [
                                            Padding(padding: EdgeInsets.all(6), child: Text('Rank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                            Padding(padding: EdgeInsets.all(6), child: Text('Player IGN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                            Padding(padding: EdgeInsets.all(6), child: Text('Kills', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                            Padding(padding: EdgeInsets.all(6), child: Text('Prize', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                          ],
                                        ),
                                        ...resultsList.map((row) {
                                          return TableRow(
                                            children: [
                                              Padding(padding: const EdgeInsets.all(6), child: Text(row['rank'] ?? '', style: const TextStyle(fontSize: 12))),
                                              Padding(padding: const EdgeInsets.all(6), child: Text(row['player'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                                              Padding(padding: const EdgeInsets.all(6), child: Text('${row['kills']}', style: const TextStyle(fontSize: 12))),
                                              Padding(padding: const EdgeInsets.all(6), child: Text(row['winning'] ?? '', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12))),
                                            ],
                                          );
                                        }).toList()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- TAB 3: WALLET SYSTEM (DYNAMIC QR DEPOSIT & WITHDRAW) ----------------
class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  void _openDepositDialog() {
    TextEditingController amountController = TextEditingController(text: '100');
    TextEditingController txnController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            String enterAmt = amountController.text.trim();
            double amtVal = double.tryParse(enterAmt) ?? 0;

            // Generate UPI Link and Dynamic QR Code Image URL
            String upiUrl = "upi://pay?pa=$adminUpiId&pn=FFTournament&am=$amtVal&cu=INR";
            String qrImageUrl = "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=${Uri.encodeComponent(upiUrl)}&choe=UTF-8";

            return AlertDialog(
              title: const Text('Deposit Money via Scanner'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Enter Deposit Amount (₹)'),
                      onChanged: (val) {
                        setDialogState(() {});
                      },
                    ),
                    const SizedBox(height: 12),
                    Text('Scan & Pay ₹${amtVal > 0 ? amtVal : "0"}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                    const SizedBox(height: 8),

                    // Dynamic QR Scanner Container
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(border: Border.all(color: Colors.deepOrange, width: 2), borderRadius: BorderRadius.circular(12)),
                      child: Image.network(
                        qrImageUrl,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.qr_code_2, size: 140, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SelectableText('UPI ID: $adminUpiId', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: txnController,
                      decoration: const InputDecoration(
                        labelText: 'Transaction UTR / Ref ID',
                        border: OutlineInputBorder(),
                        hintText: 'Enter 12 Digit UTR Number',
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (amountController.text.isNotEmpty && txnController.text.isNotEmpty) {
                      double reqAmt = double.tryParse(amountController.text) ?? 0;

                      setState(() {
                        if (autoApproveDeposits) {
                          // AUTO-APPROVE LOGIC (If enabled by Admin)
                          userWalletBalance += reqAmt;
                          totalDepositAmt += reqAmt;
                          transactionHistory.add({
                            'type': 'Deposit',
                            'amount': amountController.text,
                            'status': 'Approved (Auto)',
                            'date': '05 Sep 2026',
                            'txnId': txnController.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Deposit Automatically Approved! Wallet Updated.'), backgroundColor: Colors.green),
                          );
                        } else {
                          // MANUAL APPROVAL LOGIC
                          transactionHistory.add({
                            'type': 'Deposit',
                            'amount': amountController.text,
                            'status': 'Pending',
                            'date': '05 Sep 2026',
                            'txnId': txnController.text,
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Deposit Request Submitted! Pending Admin Approval.')),
                          );
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                  child: const Text('Submit Deposit'),
                )
              ],
            );
          },
        );
      },
    );
  }

  void _openWithdrawDialog() {
    TextEditingController amountController = TextEditingController();
    TextEditingController upiController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₹)'),
            ),
            TextField(
              controller: upiController,
              decoration: const InputDecoration(labelText: 'Your UPI ID'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              double reqAmt = double.tryParse(amountController.text) ?? 0;
              if (reqAmt > 0 && reqAmt <= userWalletBalance && upiController.text.isNotEmpty) {
                setState(() {
                  // WITHDRAWAL IS ALWAYS MANUAL ADMIN APPROVAL
                  transactionHistory.add({
                    'type': 'Withdrawal',
                    'amount': amountController.text,
                    'status': 'Pending',
                    'date': '05 Sep 2026',
                    'txnId': upiController.text,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Withdrawal Request Sent! Admin will check and process it.')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Amount or Balance insufficient!')),
                );
              }
            },
            child: const Text('Withdraw Request'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.deepOrange.shade50,
            child: ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Colors.deepOrange, size: 40),
              title: const Text('Available Wallet Balance'),
              subtitle: Text('₹$userWalletBalance', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openDepositDialog,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Deposit'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openWithdrawDialog,
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Withdraw'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Transaction History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: transactionHistory.length,
              itemBuilder: (context, index) {
                final tx = transactionHistory[index];
                return ListTile(
                  title: Text('${tx['type']} - ₹${tx['amount']}'),
                  subtitle: Text('Ref/UPI: ${tx['txnId']}'),
                  trailing: Chip(
                    label: Text(tx['status'] ?? ''),
                    backgroundColor: tx['status']!.contains('Approved') ? Colors.green.shade100 : Colors.orange.shade100,
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

// ---------------- TAB 4: MY PROFILE & COMPLETE STATISTICS ----------------
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Card(
            color: Colors.deepOrange.shade50,
            child: ListTile(
              leading: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.deepOrange,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              title: Text(currentUserName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('FF Game IGN: $currentFfUsername\nPhone: ${currentUserPhone.isEmpty ? "N/A" : currentUserPhone}'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Match Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildStatCard('Total Earnings', '₹$totalEarning', Icons.attach_money, Colors.green),
          _buildStatCard('Total Kills', '$totalKills Kills', Icons.ads_click, Colors.red),
          _buildStatCard('Matches Played', '$totalMatchesPlayed', Icons.sports_esports, Colors.blue),
          _buildStatCard('Matches Won', '$totalMatchesWon', Icons.emoji_events, Colors.orange),
          _buildStatCard('Matches Lost', '$totalMatchesLost', Icons.sentiment_dissatisfied, Colors.grey),
          const SizedBox(height: 16),
          const Text('Wallet Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          _buildStatCard('Total Deposit', '₹$totalDepositAmt', Icons.arrow_downward, Colors.green),
          _buildStatCard('Total Withdrawal', '₹$totalWithdrawAmt', Icons.arrow_upward, Colors.redAccent),
        ],
      ),
    );
  }
}

// ---------------- TAB 5: SETTINGS & WHATSAPP ONLY SUPPORT ----------------
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings & Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            color: Colors.green.shade50,
            child: ListTile(
              leading: const Icon(Icons.chat_bubble, color: Colors.green, size: 32),
              title: const Text('Customer Support (WhatsApp Only)', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: SelectableText('WhatsApp Number: +91 $whatsappSupportNumber',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening WhatsApp for support on +91 $whatsappSupportNumber...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                child: const Text('Chat'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red, size: 32),
              title: const Text('Logout Account', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              subtitle: const Text('Sign out from this device'),
              onTap: () {
                isLoggedIn = false;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- ADMIN PANEL (TOGGLES, RESULTS DECLARATION, APPROVALS) ----------------
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
  final _totalSlotsController = TextEditingController(text: '48');
  final _roomIdController = TextEditingController();
  final _roomPassController = TextEditingController();
  String _selectedMatchType = 'Solo';

  final _resMatchTitleController = TextEditingController();
  final _resPlayerController = TextEditingController();
  final _resRankController = TextEditingController();
  final _resKillsController = TextEditingController();
  final _resWinningController = TextEditingController();

  void _addNewMatch() {
    if (_titleController.text.isNotEmpty && _feeController.text.isNotEmpty) {
      setState(() {
        tournamentMatches.add({
          'id': 'M${DateTime.now().millisecondsSinceEpoch}',
          'title': _titleController.text,
          'matchType': _selectedMatchType,
          'fee': double.tryParse(_feeController.text) ?? 0.0,
          'prize': double.tryParse(_prizeController.text) ?? 0.0,
          'time': _timeController.text.isEmpty ? '08:00 PM' : _timeController.text,
          'totalSlots': int.tryParse(_totalSlotsController.text) ?? 48,
          'roomId': _roomIdController.text.isEmpty ? 'TBD' : _roomIdController.text,
          'roomPassword': _roomPassController.text.isEmpty ? '123' : _roomPassController.text,
          'bookedSlots': <int, String>{},
        });
      });
      _titleController.clear();
      _feeController.clear();
      _prizeController.clear();
      _timeController.clear();
      _roomIdController.clear();
      _roomPassController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match Published Successfully!')));
    }
  }

  void _publishMatchResult() {
    if (_resMatchTitleController.text.isNotEmpty && _resPlayerController.text.isNotEmpty) {
      setState(() {
        completedMatchResults.add({
          'matchTitle': _resMatchTitleController.text,
          'date': '05 Sep 2026',
          'results': [
            {
              'rank': _resRankController.text.isEmpty ? '#1 Winner' : _resRankController.text,
              'player': _resPlayerController.text,
              'kills': int.tryParse(_resKillsController.text) ?? 0,
              'winning': '₹${_resWinningController.text.isEmpty ? '0' : _resWinningController.text}',
            }
          ]
        });
      });
      _resMatchTitleController.clear();
      _resPlayerController.clear();
      _resRankController.clear();
      _resKillsController.clear();
      _resWinningController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Match Result Published!')));
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
              Tab(icon: Icon(Icons.add), text: 'Create Match'),
              Tab(icon: Icon(Icons.emoji_events), text: 'Declare Results'),
              Tab(icon: Icon(Icons.history), text: 'Transactions'),
              Tab(icon: Icon(Icons.analytics), text: 'Profit & Controls'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1: Create Match
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Match Name')),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedMatchType,
                    decoration: const InputDecoration(labelText: 'Match Format (Type)'),
                    items: ['Solo', 'Duo', 'Squad'].map((String type) {
                      return DropdownMenuItem<String>(value: type, child: Text(type));
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedMatchType = val!),
                  ),
                  TextField(controller: _feeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Entry Fee (₹)')),
                  TextField(controller: _prizeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Prize Pool (₹)')),
                  TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'Match Time')),
                  TextField(controller: _totalSlotsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Slots')),
                  TextField(controller: _roomIdController, decoration: const InputDecoration(labelText: 'Room ID')),
                  TextField(controller: _roomPassController, decoration: const InputDecoration(labelText: 'Room Password')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _addNewMatch,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                    child: const Text('Publish Match'),
                  ),
                ],
              ),
            ),

            // Tab 2: Declare Results
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Text('Declare Tournament Match Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(controller: _resMatchTitleController, decoration: const InputDecoration(labelText: 'Match Name (e.g. Bermuda War)')),
                  TextField(controller: _resPlayerController, decoration: const InputDecoration(labelText: 'Player IGN (Game Name)')),
                  TextField(controller: _resRankController, decoration: const InputDecoration(labelText: 'Rank (e.g. #1 Winner, #2 Runner)')),
                  TextField(controller: _resKillsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Total Kills')),
                  TextField(controller: _resWinningController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Winning Prize Amount (₹)')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _publishMatchResult,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                    child: const Text('Publish Results'),
                  ),
                ],
              ),
            ),

            // Tab 3: Transactions Approval (Deposits & Withdrawals)
            ListView.builder(
              itemCount: transactionHistory.length,
              itemBuilder: (context, index) {
                final tx = transactionHistory[index];
                bool isDeposit = tx['type'] == 'Deposit';
                bool isPending = tx['status'] == 'Pending';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Icon(isDeposit ? Icons.arrow_downward : Icons.arrow_upward, color: isDeposit ? Colors.green : Colors.red),
                    title: Text('${tx['type']} - ₹${tx['amount']}'),
                    subtitle: Text('Ref/UPI: ${tx['txnId']}'),
                    trailing: isPending
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check_circle, color: Colors.green, size: 30),
                                onPressed: () {
                                  setState(() {
                                    tx['status'] = 'Approved';
                                    double amt = double.tryParse(tx['amount'] ?? '0') ?? 0;
                                    if (isDeposit) {
                                      userWalletBalance += amt;
                                      totalDepositAmt += amt;
                                    } else {
                                      userWalletBalance -= amt;
                                      totalWithdrawAmt += amt;
                                      totalPrizeDistributed += amt;
                                    }
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transaction Approved!')));
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.cancel, color: Colors.red, size: 30),
                                onPressed: () {
                                  setState(() {
                                    tx['status'] = 'Rejected';
                                  });
                                },
                              ),
                            ],
                          )
                        : Chip(
                            label: Text(tx['status'] ?? ''),
                            backgroundColor: tx['status']!.contains('Approved') ? Colors.green.shade100 : Colors.red.shade100,
                          ),
                  ),
                );
              },
            ),

            // Tab 4: Profit Analytics & Auto Approve Controls
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Card(
                    color: Colors.blue.shade50,
                    child: SwitchListTile(
                      title: const Text('Auto-Approve Deposit Requests', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(autoApproveDeposits
                          ? 'Deposits are AUTOMATICALLY Approved'
                          : 'Deposits require MANUAL Admin Approval'),
                      value: autoApproveDeposits,
                      activeColor: Colors.deepOrange,
                      onChanged: (bool value) {
                        setState(() {
                          autoApproveDeposits = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    color: Colors.green.shade50,
                    child: ListTile(
                      title: const Text('Total Revenue Collected'),
                      trailing: Text('₹$totalRevenueCollected', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                    ),
                  ),
                  Card(
                    color: Colors.red.shade50,
                    child: ListTile(
                      title: const Text('Total Withdrawals Approved'),
                      trailing: Text('₹$totalPrizeDistributed', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                    ),
                  ),
                  const Divider(height: 30),
                  Card(
                    color: Colors.black,
                    child: ListTile(
                      title: const Text('Net Admin Profit', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      trailing: Text('₹$netProfit', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow)),
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
   
