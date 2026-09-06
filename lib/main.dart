
              
     import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const TournamentApp());
}

class TournamentApp extends StatelessWidget {
  const TournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FF Esports Tournament Hub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: isLoggedIn ? const HomeScreen() : const AuthScreen(),
    );
  }
}

// Global Application State & Customer Database
String adminPin = "1818";
String adminUpiId = "ffesports@paytm";
String whatsappSupportNumber = "9289678990";
bool autoApproveDeposits = false;

// Persistent User Login State
bool isLoggedIn = false;
String currentUserId = "USER_101";
String currentUserName = "Gamer";
String currentFfUsername = "FF_ProGamer";
String currentUserPhone = "9876543210";
String currentUserPassword = "password123";
double userWalletBalance = 0.0;

int totalMatchesPlayed = 0;
int totalMatchesWon = 0;
int totalMatchesLost = 0;
int totalKills = 0;
double totalEarning = 0.0;
double totalDepositAmt = 0.0;
double totalWithdrawAmt = 0.0;

// Registered Customer Details List for Admin Panel
List<Map<String, String>> registeredCustomers = [
  {
    'appId': 'USER_101',
    'name': 'Rahul Sharma',
    'ffIgn': 'FF_ProGamer',
    'phone': '9876543210',
    'password': 'password123',
    'balance': '200.0',
    'status': 'Active',
  },
  {
    'appId': 'USER_102',
    'name': 'Aman Verma',
    'ffIgn': 'SniperGod99',
    'phone': '9123456789',
    'password': 'aman@pass12',
    'balance': '50.0',
    'status': 'Active',
  }
];

// Active Tournaments Database
List<Map<String, dynamic>> tournamentMatches = [
  {
    'id': 'M201',
    'title': 'Bermuda Grand Battle',
    'matchType': 'Solo',
    'fee': 30.0,
    'booyahPrize': 500.0,
    'perKillPrize': 20.0,
    'time': '08:00 PM Today',
    'totalSlots': 48,
    'thumbnail': 'https://img.freepik.com/free-vector/gaming-banner-template-with-red-character_23-2148782488.jpg',
    'instructions': '1. Emotes allowed in match.\n2. No hacking, macro, or config files.\n3. Room ID & Password will be available 15 minutes before match.',
    'roomId': '998877',
    'roomPassword': '123',
    'bookedSlots': <int, String>{
      1: 'SniperGod99',
      3: 'ProKing_FF',
      5: 'Rahul_OP',
    },
  },
];

List<Map<String, dynamic>> myJoinedMatches = [];

// Complete Tournament Results Database
List<Map<String, dynamic>> completedMatchResults = [
  {
    'matchTitle': 'Kalahari Solo Championship',
    'date': '05 Sep 2026',
    'results': [
      {'rank': '#1 (Booyah)', 'player': 'FF_ProGamer', 'kills': 9, 'winning': '₹680'},
      {'rank': '#2 Runner', 'player': 'SniperGod99', 'kills': 5, 'winning': '₹100'},
      {'rank': '#3 Third', 'player': 'Rahul_OP', 'kills': 4, 'winning': '₹80'},
      {'rank': '#4 Rank', 'player': 'DeadlyRider', 'kills': 2, 'winning': '₹40'},
      {'rank': '#5 Rank', 'player': 'GamerGirl_FF', 'kills': 1, 'winning': '₹20'},
      {'rank': '#6 Rank', 'player': 'ViperX', 'kills': 0, 'winning': '₹0'},
    ]
  }
];

// Transaction Logs
List<Map<String, String>> transactionHistory = [];

double totalRevenueCollected = 0.0;
double totalPrizeDistributed = 0.0;

// LOGIN & OTP VERIFICATION SCREEN
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;
  bool otpSent = false;

  final _nameController = TextEditingController();
  final _ffNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _otpController = TextEditingController();

  void _sendOtp() {
    if (_phoneController.text.trim().length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid 10-digit Mobile Number!')),
      );
      return;
    }
    setState(() {
      otpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP sent successfully to your mobile number! (Use OTP: 1234)'), backgroundColor: Colors.green),
    );
  }

  void _submitAuth() {
    if (_ffNameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields!')),
      );
      return;
    }

    if (!isLoginMode && (!otpSent || _otpController.text.trim() != '1234')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP! Please verify with OTP: 1234'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      isLoggedIn = true;
      currentUserId = 'USER_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      currentFfUsername = _ffNameController.text.trim();
      currentUserName = _nameController.text.trim().isEmpty ? currentFfUsername : _nameController.text.trim();
      currentUserPhone = _phoneController.text.trim();
      currentUserPassword = _passwordController.text.trim();

      registeredCustomers.add({
        'appId': currentUserId,
        'name': currentUserName,
        'ffIgn': currentFfUsername,
        'phone': currentUserPhone,
        'password': currentUserPassword,
        'balance': userWalletBalance.toString(),
        'status': 'Active',
      });
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
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sports_esports, size: 70, color: Colors.deepOrange),
                  const SizedBox(height: 10),
                  Text(
                    isLoginMode ? 'Tournament Login' : 'Register Account & OTP',
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
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  if (!isLoginMode) ...[
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Enter OTP (1234)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _sendOtp,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                          child: Text(otpSent ? 'Resend' : 'Get OTP'),
                        ),
                      ],
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
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _submitAuth,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                      child: Text(isLoginMode ? 'LOGIN' : 'VERIFY OTP & REGISTER', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLoginMode = !isLoginMode;
                        otpSent = false;
                      });
                    },
                    child: Text(isLoginMode ? 'New Player? Create Account' : 'Already Registered? Login'),
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

// MAIN APP CONTAINER
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
        title: const Text('Admin Access Panel'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter Admin Secret PIN (1818)', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (pinController.text == adminPin) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FullAdminDashboard()),
                ).then((_) => setState(() {}));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid Admin PIN! (PIN: 1818)'), backgroundColor: Colors.red),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
            child: const Text('Login Admin'),
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
        title: const Text('FF Esports Hub', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, size: 28),
            onPressed: _openAdminLogin,
            tooltip: 'Admin Access',
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
          BottomNavigationBarItem(icon: Icon(Icons.military_tech), label: 'My Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// TOURNAMENTS LIST & DETAILED VIEW
class HomeTab extends StatefulWidget {
  final VoidCallback onJoined;
  const HomeTab({super.key, required this.onJoined});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  void _openMatchDetailsPage(Map<String, dynamic> match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetailPage(
          match: match,
          isFromMyMatches: false,
          onJoinedSuccess: widget.onJoined,
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Available Esports Tournaments', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () => _openMatchDetailsPage(match),
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.network(
                            match['thumbnail'] ?? '',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              height: 140,
                              color: Colors.deepOrange.shade100,
                              child: const Center(child: Icon(Icons.sports_esports, size: 60, color: Colors.deepOrange)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(match['title'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  Chip(
                                    label: Text(match['matchType'] ?? 'Solo', style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    backgroundColor: Colors.deepOrange,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Entry Fee: ₹${match['fee']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                                  Text('Booyah: ₹${match['booyahPrize']} | Per Kill: ₹${match['perKillPrize']}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LinearProgressIndicator(
                                value: booked.length / totalSlots,
                                backgroundColor: Colors.grey.shade200,
                                color: Colors.deepOrange,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Slots Joined: ${booked.length}/$totalSlots', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  Text('Time: ${match['time']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              )
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
        ],
      ),
    );
  }
}

// MATCH DETAIL PAGE WITH INSIDE JOINING & RESTRICTED ROOM ID
class MatchDetailPage extends StatefulWidget {
  final Map<String, dynamic> match;
  final bool isFromMyMatches;
  final VoidCallback onJoinedSuccess;

  const MatchDetailPage({
    super.key,
    required this.match,
    required this.isFromMyMatches,
    required this.onJoinedSuccess,
  });

  @override
  State<MatchDetailPage> createState() => _MatchDetailPageState();
}

class _MatchDetailPageState extends State<MatchDetailPage> {
  int? selectedSlot;
  final TextEditingController ignController = TextEditingController(text: currentFfUsername);

  void _processJoinMatch() {
    double fee = widget.match['fee'];
    Map<int, String> bookedSlots = Map<int, String>.from(widget.match['bookedSlots'] ?? {});
    String enteredIgn = ignController.text.trim();

    if (enteredIgn.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter Free Fire Game IGN!')));
      return;
    }

    if (selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select an available slot number!')));
      return;
    }

    if (userWalletBalance < fee) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insufficient Wallet Balance! Please deposit money in wallet.'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      userWalletBalance -= fee;
      totalRevenueCollected += fee;
      totalMatchesPlayed += 1;

      bookedSlots[selectedSlot!] = enteredIgn; // Corrected semicolon here
      widget.match['bookedSlots'] = bookedSlots;

      myJoinedMatches.add({
        'matchId': widget.match['id'],
        'title': widget.match['title'],
        'matchType': widget.match['matchType'],
        'time': widget.match['time'],
        'slot': selectedSlot,
        'ign': enteredIgn,
        'roomId': widget.match['roomId'],
        'roomPassword': widget.match['roomPassword'],
        'matchData': widget.match,
      });
    });

    widget.onJoinedSuccess();
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully joined match in Slot #$selectedSlot! Details in My Matches.'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<int, String> bookedSlots = Map<int, String>.from(widget.match['bookedSlots'] ?? {});
    int totalSlots = widget.match['totalSlots'] ?? 48;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.match['title'] ?? 'Match Details'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isFromMyMatches) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lock_open, color: Colors.green, size: 28),
                        SizedBox(width: 8),
                        Text('Your Match Credentials', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                      ],
                    ),
                    const Divider(),
                    SelectableText('Room ID: ${widget.match['roomId']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    SelectableText('Room Password: ${widget.match['roomPassword']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.amber.shade100,
                child: const Row(
                  children: [
                    Icon(Icons.security, color: Colors.black87),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Room ID & Password will be displayed 15 minutes before match start time ONLY to joined participants in My Matches.',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [const Text('Booyah Prize'), Text('₹${widget.match['booyahPrize']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green))]),
                    Column(children: [const Text('Per Kill'), Text('₹${widget.match['perKillPrize']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepOrange))]),
                    Column(children: [const Text('Entry Fee'), Text('₹${widget.match['fee']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue))]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Match Rules & Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text(widget.match['instructions'] ?? 'Follow official esports guidelines.'),
            const SizedBox(height: 20),

            if (!widget.isFromMyMatches) ...[
              TextField(
                controller: ignController,
                decoration: const InputDecoration(
                  labelText: 'Enter Free Fire Username (IGN)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text('Select Your Match Slot (1 to $totalSlots):', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 160,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemCount: totalSlots,
                  itemBuilder: (context, index) {
                    int slotNum = index + 1;
                    bool isBooked = bookedSlots.containsKey(slotNum);
                    bool isSelected = selectedSlot == slotNum;

                    return ChoiceChip(
                      label: Text('$slotNum', style: const TextStyle(fontSize: 10)),
                      selected: isSelected,
                      disabledColor: Colors.grey.shade300,
                      selectedColor: Colors.deepOrange,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : (isBooked ? Colors.grey : Colors.black)),
                      onSelected: isBooked
                          ? null
                          : (selected) {
                              setState(() {
                                selectedSlot = selected ? slotNum : null;
                              });
                            },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],

            const Text('Joined Contestants List:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: bookedSlots.length,
              itemBuilder: (context, idx) {
                int key = bookedSlots.keys.elementAt(idx);
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(backgroundColor: Colors.deepOrange, child: Text('$key', style: const TextStyle(color: Colors.white, fontSize: 12))),
                  title: Text(bookedSlots[key] ?? ''),
                );
              },
            ),
            const SizedBox(height: 20),
            if (!widget.isFromMyMatches)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _processJoinMatch,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
                  child: const Text('CONFIRM & JOIN MATCH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// MY MATCHES TAB (UPCOMING & COMPLETED)
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
              Tab(icon: Icon(Icons.timer), text: 'Upcoming Matches'),
              Tab(icon: Icon(Icons.emoji_events), text: 'Completed Results'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: myJoinedMatches.isEmpty
                      ? const Center(child: Text('No upcoming matches joined yet.'))
                      : ListView.builder(
                          itemCount: myJoinedMatches.length,
                          itemBuilder: (context, index) {
                            final item = myJoinedMatches[index];
                            final matchData = item['matchData'] ?? item;

                            return Card(
                              color: Colors.deepOrange.shade50,
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MatchDetailPage(
                                        match: matchData,
                                        isFromMyMatches: true,
                                        onJoinedSuccess: () {},
                                      ),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${item['title']} (${item['matchType']})', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.deepOrange),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text('Time: ${item['time']} | Your Slot: #${item['slot']} | IGN: ${item['ign']}'),
                                      const Divider(),
                                      const Row(
                                        children: [
                                          Icon(Icons.touch_app, color: Colors.deepOrange, size: 20),
                                          SizedBox(width: 6),
                                          Text('Tap to View Room ID & Password', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: completedMatchResults.isEmpty
                      ? const Center(child: Text('No completed match results.'))
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
                                subtitle: Text('Date: ${matchRes['date']} | Total Players: ${resultsList.length}'),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Table(
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

// PROFESSIONAL WALLET & TIMER EXPIRING QR SCANNER
class WalletTab extends StatefulWidget {
  const WalletTab({super.key});

  @override
  State<WalletTab> createState() => _WalletTabState();
}

class _WalletTabState extends State<WalletTab> {
  void _openDepositDialog() {
    TextEditingController amountController = TextEditingController(text: '100');
    TextEditingController utrController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return DynamicQrDepositDialog(
              amountController: amountController,
              utrController: utrController,
              onSubmitted: (amt, utr) {
                setState(() {
                  transactionHistory.add({
                    'type': 'Deposit',
                    'amount': amt,
                    'status': autoApproveDeposits ? 'Approved' : 'Pending',
                    'date': '06 Sep 2026',
                    'txnId': utr,
                  });
                  if (autoApproveDeposits) {
                    userWalletBalance += double.tryParse(amt) ?? 0;
                    totalDepositAmt += double.tryParse(amt) ?? 0;
                  }
                });
              },
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
        title: const Text('Withdraw Wallet Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: upiController,
              decoration: const InputDecoration(labelText: 'Valid UPI ID (e.g. user@paytm)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              double reqAmt = double.tryParse(amountController.text) ?? 0;
              String upi = upiController.text.trim();

              if (!upi.contains('@') || upi.length < 5) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid UPI ID!'), backgroundColor: Colors.red));
                return;
              }

              if (reqAmt > 0 && reqAmt <= userWalletBalance) {
                setState(() {
                  transactionHistory.add({
                    'type': 'Withdrawal',
                    'amount': amountController.text,
                    'status': 'Pending',
                    'date': '06 Sep 2026',
                    'txnId': upi,
                  });
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Withdrawal request sent to Admin!')));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient balance!')));
              }
            },
            child: const Text('Submit Withdrawal'),
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
              title: const Text('Wallet Balance'),
              subtitle: Text('₹$userWalletBalance', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openDepositDialog,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Deposit Funds'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white, padding: const EdgeInsets.all(12)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openWithdrawDialog,
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Withdraw'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, padding: const EdgeInsets.all(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
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
                    backgroundColor: tx['status'] == 'Approved' ? Colors.green.shade100 : Colors.orange.shade100,
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

// 15 MINUTES EXPIRING PROFESSIONAL QR DIALOG
class DynamicQrDepositDialog extends StatefulWidget {
  final TextEditingController amountController;
  final TextEditingController utrController;
  final Function(String amt, String utr) onSubmitted;

  const DynamicQrDepositDialog({
    super.key,
    required this.amountController,
    required this.utrController,
    required this.onSubmitted,
  });

  @override
  State<DynamicQrDepositDialog> createState() => _DynamicQrDepositDialogState();
}

class _DynamicQrDepositDialogState extends State<DynamicQrDepositDialog> {
  int _secondsRemaining = 900;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isExpired = _secondsRemaining <= 0;
    double amtVal = double.tryParse(widget.amountController.text) ?? 100;
    String upiUrl = "upi://pay?pa=$adminUpiId&pn=FFEsports&am=$amtVal&cu=INR";
    String qrImageUrl = "https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=${Uri.encodeComponent(upiUrl)}&choe=UTF-8";

    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;

    return AlertDialog(
      title: const Text('Deposit Money via Dynamic QR'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: widget.amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Deposit Amount (₹)'),
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 10),
            Text(
              isExpired ? 'QR Code Expired!' : 'QR Expires in: ${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
              style: TextStyle(fontWeight: FontWeight.bold, color: isExpired ? Colors.red : Colors.deepOrange),
            ),
            const SizedBox(height: 10),
            isExpired
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _secondsRemaining = 900;
                        _startTimer();
                      });
                    },
                    child: const Text('Regenerate Scanner'),
                  )
                : Column(
                    children: [
                      Image.network(qrImageUrl, width: 160, height: 160),
                      SelectableText('UPI ID: $adminUpiId', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      const SizedBox(height: 10),
                      const Text('Pay with UPI Apps:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(icon: const Icon(Icons.account_balance_wallet, color: Colors.blue), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.payment, color: Colors.purple), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.send, color: Colors.teal), onPressed: () {}),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.deepOrange),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment Link Copied to Share!')));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(height: 10),
            TextField(
              controller: widget.utrController,
              decoration: const InputDecoration(
                labelText: 'Enter 12-Digit Real UTR Number',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: isExpired
              ? null
              : () {
                  String utr = widget.utrController.text.trim();
                  if (utr.length < 10 || !RegExp(r'^[0-9]+$').hasMatch(utr)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid UTR Number! Enter valid numeric 12-digit UTR.'), backgroundColor: Colors.red),
                    );
                    return;
                  }
                  widget.onSubmitted(widget.amountController.text, utr);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deposit Request Submitted!'), backgroundColor: Colors.green));
                },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange, foregroundColor: Colors.white),
          child: const Text('Submit Deposit'),
        )
      ],
    );
  }
}

// PROFILE TAB
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Card(
            color: Colors.deepOrange.shade50,
            child: ListTile(
              leading: const CircleAvatar(radius: 28, backgroundColor: Colors.deepOrange, child: Icon(Icons.person, color: Colors.white)),
              title: Text(currentUserName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('App ID: $currentUserId\nIGN: $currentFfUsername | Phone: $currentUserPhone'),
            ),
          ),
          const SizedBox(height: 16),
          Card(child: ListTile(title: const Text('Matches Played'), trailing: Text('$totalMatchesPlayed', style: const TextStyle(fontWeight: FontWeight.bold)))),
          Card(child: ListTile(title: const Text('Total Earnings'), trailing: Text('₹$totalEarning', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)))),
        ],
      ),
    );
  }
}

// SETTINGS TAB
class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.support_agent, color: Colors.green),
              title: const Text('WhatsApp Customer Support'),
              subtitle: Text('+91 $whatsappSupportNumber'),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.red.shade50,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout Account', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () {
                isLoggedIn = false;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              },
            ),
          )
        ],
      ),
    );
  }
}

// MASTER ADMIN DASHBOARD
class FullAdminDashboard extends StatefulWidget {
  const FullAdminDashboard({super.key});

  @override
  State<FullAdminDashboard> createState() => _FullAdminDashboardState();
}

class _FullAdminDashboardState extends State<FullAdminDashboard> {
  final _titleController = TextEditingController();
  final _feeController = TextEditingController();
  final _booyahController = TextEditingController();
  final _perKillController = TextEditingController();
  final _timeController = TextEditingController();
  final _thumbController = TextEditingController();

  void _addNewMatch() {
    if (_titleController.text.isNotEmpty && _feeController.text.isNotEmpty) {
      setState(() {
        tournamentMatches.add({
          'id': 'M${DateTime.now().millisecondsSinceEpoch}',
          'title': _titleController.text,
          'matchType': 'Solo',
          'fee': double.tryParse(_feeController.text) ?? 0.0,
          'booyahPrize': double.tryParse(_booyahController.text) ?? 0.0,
          'perKillPrize': double.tryParse(_perKillController.text) ?? 0.0,
          'time': _timeController.text.isEmpty ? '08:00 PM' : _timeController.text,
          'totalSlots': 48,
          'thumbnail': _thumbController.text.isEmpty ? 'https://img.freepik.com/free-vector/gaming-banner-template-with-red-character_23-2148782488.jpg' : _thumbController.text,
          'instructions': 'Official tournament rules apply.',
          'roomId': '9900',
          'roomPassword': '123',
          'bookedSlots': <int, String>{},
        });
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Master Dashboard'),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'Customer Details'),
              Tab(icon: Icon(Icons.add), text: 'Create Match'),
              Tab(icon: Icon(Icons.payment), text: 'Transactions'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView.builder(
              itemCount: registeredCustomers.length,
              itemBuilder: (context, index) {
                final cust = registeredCustomers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('${cust['name']} (IGN: ${cust['ffIgn']})'),
                    subtitle: Text('App ID: ${cust['appId']} | Password: ${cust['password']}\nPhone: ${cust['phone']} | Balance: ₹${cust['balance']}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Match Title')),
                  TextField(controller: _feeController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Entry Fee (₹)')),
                  TextField(controller: _booyahController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Booyah Prize (₹)')),
                  TextField(controller: _perKillController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Per Kill Prize (₹)')),
                  TextField(controller: _timeController, decoration: const InputDecoration(labelText: 'Match Time')),
                  TextField(controller: _thumbController, decoration: const InputDecoration(labelText: 'Thumbnail Image URL')),
                  const SizedBox(height: 20),
                  ElevatedButton(onPressed: _addNewMatch, child: const Text('Publish Match')),
                ],
              ),
            ),
            ListView.builder(
              itemCount: transactionHistory.length,
              itemBuilder: (context, index) {
                final tx = transactionHistory[index];
                return ListTile(
                  title: Text('${tx['type']} - ₹${tx['amount']}'),
                  subtitle: Text('Ref: ${tx['txnId']}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        tx['status'] = 'Approved';
                      });
                    },
                    child: Text(tx['status'] ?? 'Approve'),
                  ),
                );
              },
            ),
            Center(
              child: Text('Admin Control Panel Active (PIN: $adminPin)'),
            )
          ],
        ),
      ),
    );
  }
}

