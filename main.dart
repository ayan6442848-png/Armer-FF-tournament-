import 'dart:math';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

void main() {
  runApp(const TournamentApp());
}

class TournamentApp extends StatelessWidget {
  const TournamentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FF Tour',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: const Color(0xFFFF9900),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF9900),
          surface: Color(0xFF1A1A1A),
        ),
      ),
      home: const AuthScreen(),
    );
  }
}

// ==========================================
// 1. AUTHENTICATION (LOGIN & CREATE ACCOUNT)
// ==========================================
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, size: 80, color: Color(0xFFFF9900)),
                  const SizedBox(height: 10),
                  const Text("FF TOUR", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Text("PLAY • COMPETE • WIN", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 40),
                  
                  if (!isLogin) ...[
                    _buildTextField("Full Name", Icons.person),
                    const SizedBox(height: 16),
                  ],
                  _buildTextField("Mobile / Email", Icons.email),
                  const SizedBox(height: 16),
                  _buildTextField("Password", Icons.lock, obscure: true),
                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9900),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainDashboard()),
                        );
                      },
                      child: Text(
                        isLogin ? "LOGIN" : "CREATE ACCOUNT",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => isLogin = !isLogin),
                    child: Text(
                      isLogin ? "Don't have an account? Register" : "Already have an account? Login",
                      style: const TextStyle(color: Color(0xFFFF9900)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFFF9900)),
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}

// ==========================================
// 2. MAIN DASHBOARD & NAVIGATION
// ==========================================
class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  double walletBalance = 1250.00;

  final List<Map<String, dynamic>> transactions = [
    {"type": "Deposit", "amount": 500.0, "date": "Today, 2:14 PM", "status": "Success", "isCredit": true},
    {"type": "Tournament Entry", "amount": 100.0, "date": "21 Nov, 8:11 PM", "status": "Success", "isCredit": false},
    {"type": "Deposit", "amount": 1000.0, "date": "20 Nov, 6:33 PM", "status": "Success", "isCredit": true},
  ];

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeTab(balance: walletBalance),
      const TournamentsTab(),
      WalletTab(
        balance: walletBalance,
        transactions: transactions,
        onDeposit: (amt) {
          setState(() {
            walletBalance += amt;
            transactions.insert(0, {
              "type": "Deposit via QR",
              "amount": amt,
              "date": "Just Now",
              "status": "Success",
              "isCredit": true
            });
          });
        },
        onWithdraw: (amt) {
          if (walletBalance >= amt) {
            setState(() {
              walletBalance -= amt;
              transactions.insert(0, {
                "type": "Withdrawal",
                "amount": amt,
                "date": "Just Now",
                "status": "Processing",
                "isCredit": false
              });
            });
          }
        },
      ),
      const Center(child: Text("Leaderboard Page")),
      const Center(child: Text("Profile Page")),
    ];

    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF1A1A1A),
        selectedItemColor: const Color(0xFFFF9900),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports), label: 'Tournaments'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ==========================================
// 3. HOME TAB
// ==========================================
class HomeTab extends StatelessWidget {
  final double balance;
  const HomeTab({super.key, required this.balance});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.emoji_events, color: Color(0xFFFF9900)),
                    SizedBox(width: 8),
                    Text("FF Tour", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
              ],
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAlignment.start,
                    children: [
                      const Text("Wallet Balance", style: TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("₹ ${balance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9900)),
                    onPressed: () {},
                    child: const Text("+ Add", style: TextStyle(color: Colors.black)),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            const Text("Featured Tournaments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildMatchCard("ELITE WARRIORS CUP", "₹ 50,000", "₹ 50", "Squad"),
            _buildMatchCard("ROOKIE CUP", "₹ 1,000", "₹ 10", "Solo"),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(String title, String prize, String entry, String mode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.blue.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: Text(mode, style: const TextStyle(color: Colors.blue, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Prize Pool: $prize", style: const TextStyle(color: Color(0xFFFF9900))),
              Text("Entry Fee: $entry", style: const TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

class TournamentsTab extends StatelessWidget {
  const TournamentsTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Tournaments List"));
}

// ==========================================
// 4. WALLET, DEPOSIT, WITHDRAW & HISTORY
// ==========================================
class WalletTab extends StatelessWidget {
  final double balance;
  final List<Map<String, dynamic>> transactions;
  final Function(double) onDeposit;
  final Function(double) onWithdraw;

  const WalletTab({
    super.key,
    required this.balance,
    required this.transactions,
    required this.onDeposit,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAlignment.start,
          children: [
            const Text("Wallet", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text("Wallet Balance", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text("₹ ${balance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9900), padding: const EdgeInsets.all(12)),
                          icon: const Icon(Icons.add, color: Colors.black),
                          label: const Text("Deposit", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          onPressed: () => _showDepositModal(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFF9900)),
                            padding: const EdgeInsets.all(12),
                          ),
                          icon: const Icon(Icons.arrow_upward, color: Color(0xFFFF9900)),
                          label: const Text("Withdraw", style: TextStyle(color: Color(0xFFFF9900), fontWeight: FontWeight.bold)),
                          onPressed: () => _showWithdrawModal(context),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            const Text("Recent Transactions / History", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final item = transactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Icon(
                        item["isCredit"] ? Icons.add_circle : Icons.remove_circle,
                        color: item["isCredit"] ? Colors.green : Colors.red,
                      ),
                      title: Text(item["type"], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item["date"], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAlignment.end,
                        children: [
                          Text(
                            "${item["isCredit"] ? "+" : "-"} ₹${item["amount"]}",
                            style: TextStyle(
                              color: item["isCredit"] ? Colors.green : Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(item["status"], style: const TextStyle(color: Colors.grey, fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showDepositModal(BuildContext context) {
    final TextEditingController amountController = TextEditingController(text: "100");

    final List<Map<String, String>> gateways = [
      {"name": "Gateway Alpha (Paytm UPI)", "upi": "merchantA@paytm"},
      {"name": "Gateway Beta (PhonePe)", "upi": "merchantB@ybl"},
      {"name": "Gateway Gamma (GPay)", "upi": "merchantC@okaxis"},
    ];
    
    final selectedGateway = gateways[Random().nextInt(gateways.length)];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            String upiUrl = "upi://pay?pa=${selectedGateway['upi']}&pn=FFTour&am=${amountController.text}&cu=INR";

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20, left: 20, right: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Deposit Money - ${selectedGateway['name']}", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF9900))),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Enter Amount (₹)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        upiUrl = "upi://pay?pa=${selectedGateway['upi']}&pn=$val&am=$val&cu=INR";
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: QrImageView(
                      data: upiUrl,
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text("Scan with any UPI App to Pay", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  const SizedBox(height: 20),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9900),
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      double val = double.tryParse(amountController.text) ?? 0;
                      if (val > 0) {
                        onDeposit(val);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("I HAVE PAID", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showWithdrawModal(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController upiController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          pad