
import 'package:flutter/material.dart';

void main() {
  runApp(const RentManagerApp());
}

class RentManagerApp extends StatelessWidget {
  const RentManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rent Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoginPage(),
    );
  }
}

// ================= LOGIN =================

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(
                    Icons.home_work_rounded,
                    size: 80,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Rent Manager',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Manage your houses and rent easily'),
                  const SizedBox(height: 35),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Demo version',
                    style: TextStyle(color: Colors.grey),
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

// ================= DASHBOARD =================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> houses = [
    {
      'name': 'Green View House',
      'address': 'Dhaka',
      'rooms': 8,
      'rent': 65000,
    },
    {
      'name': 'Sunrise Villa',
      'address': 'Savar',
      'rooms': 6,
      'rent': 48000,
    },
  ];

  final List<Map<String, dynamic>> tenants = [
    {
      'room': '101',
      'name': 'Rahim',
      'rent': 8000,
      'paid': true,
    },
    {
      'room': '102',
      'name': 'Karim',
      'rent': 7500,
      'paid': false,
    },
    {
      'room': '103',
      'name': 'Hasan',
      'rent': 9000,
      'paid': true,
    },
    {
      'room': '104',
      'name': 'Jamal',
      'rent': 7000,
      'paid': false,
    },
  ];

  int get totalRent {
    return tenants.fold(
      0,
      (sum, tenant) => sum + (tenant['rent'] as int),
    );
  }

  int get paidRent {
    return tenants
        .where((tenant) => tenant['paid'] == true)
        .fold(0, (sum, tenant) => sum + (tenant['rent'] as int));
  }

  int get dueRent => totalRent - paidRent;

  void addHouse() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Add New House'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'House name',
                ),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  setState(() {
                    houses.add({
                      'name': nameController.text.trim(),
                      'address': addressController.text.trim(),
                      'rooms': 0,
                      'rent': 0,
                    });
                  });
                }

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void togglePayment(int index) {
    setState(() {
      tenants[index]['paid'] = !tenants[index]['paid'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rent Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginPage(),
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: addHouse,
        icon: const Icon(Icons.add),
        label: const Text('Add House'),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          setState(() {});
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // HEADER
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Here is your rent overview',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            // SUMMARY CARDS
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total Rent',
                    value: '৳$totalRent',
                    icon: Icons.account_balance_wallet,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryCard(
                    title: 'Paid',
                    value: '৳$paidRent',
                    icon: Icons.check_circle,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Due',
                    value: '৳$dueRent',
                    icon: Icons.warning_amber_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SummaryCard(
                    title: 'Houses',
                    value: '${houses.length}',
                    icon: Icons.home_work,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // HOUSES
            const Text(
              'My Houses',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...houses.map(
              (house) => Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    child: const Icon(Icons.home),
                  ),
                  title: Text(
                    house['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${house['address']} • ${house['rooms']} rooms',
                  ),
                  trailing: Text(
                    '৳${house['rent']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // TENANTS
            const Text(
              'Rooms & Tenants',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...List.generate(
              tenants.length,
              (index) {
                final tenant = tenants[index];
                final paid = tenant['paid'] == true;

                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${tenant['room']}'),
                    ),
                    title: Text(
                      tenant['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Room ${tenant['room']} • ৳${tenant['rent']}',
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          paid
                              ? Icons.check_circle
                              : Icons.pending,
                          color: paid
                              ? Colors.green
                              : Colors.orange,
                        ),
                        Text(
                          paid ? 'Paid' : 'Due',
                          style: TextStyle(
                            fontSize: 11,
                            color: paid
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => togglePayment(index),
                  ),
                );
              },
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

// ================= SUMMARY CARD =================

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 28,
              color: Colors.indigo,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
