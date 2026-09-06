
          
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
    'balance': '0',
    'status': 'Active',
  },
  {
    'appId': 'USER_102',
    'name': 'Aman Verma',
    'ffIgn': 'SniperGod99',
    'phone': '9123456789',
    'password': 'aman@pass12',
    'balance': '',
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
          isFromMyMatches: false, // Standard preview: Hide Room ID/Password
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

      bookedSlots[selectedSlot!] = enteredIgn;
     
