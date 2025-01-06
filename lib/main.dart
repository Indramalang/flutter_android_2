import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'kode1.dart';
import 'kode_Listcheckbox_1.dart';
import 'calculator.dart';
import 'stopwatch_page.dart';
import 'timer.dart';
import 'dart:math';

void main() async {
  await Hive.initFlutter(); // Inisialisasi Hive
  await Hive.openBox('userBox');
  await Hive.openBox('todoBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APlikasiku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nameController = TextEditingController();
  late Box userBox;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    userBox = Hive.box('userBox');
  }

  void _authenticateUser() async {
    // Tambahkan async karena ada delay
    setState(() {
      _isLoading = true; // Tampilkan indikator loading
    });

    await Future.delayed(const Duration(milliseconds: 500)); // Simulasi proses

    final enteredName = _nameController.text.trim();
    final savedName = userBox.get('username');

    if (savedName == null) {
      // Registrasi: Simpan nama baru
      userBox.put('username', enteredName);
      _showMessage('Registrasi berhasil! 🎉');
      _navigateToHomePage();
    } else if (savedName == enteredName) {
      // Login: Nama cocok
      _showMessage('Login berhasil! Selamat datang kembali! 👋');
      _navigateToHomePage();
    } else {
      // Nama tidak cocok
      _showMessage('Nama tidak cocok, silakan coba lagi. 🤔');
    }

    setState(() {
      _isLoading = false; // Sembunyikan indikator loading
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _navigateToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const MyHomePage(title: 'Aplikasiku'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // Warna AppBar
        title: const Text('Autentikasi Pengguna',
            style: TextStyle(color: Colors.white)), // Warna teks AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0), // Padding diperbesar
          child: Card(
            // Bungkus dengan Card
            elevation: 4, // Tambahkan bayangan
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)), // Bentuk sudut Card
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Padding di dalam Card
              child: Column(
                mainAxisSize: MainAxisSize
                    .min, // Agar Column tidak memenuhi seluruh layar
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Masukkan Nama Anda:',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold), // Gaya teks
                  ),
                  const SizedBox(height: 24), // Jarak yang lebih besar
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'Nama Anda',
                      labelText: 'Nama Pengguna', // Tambahkan label
                      prefixIcon: const Icon(Icons.person), // Tambahkan ikon
                    ),
                  ),
                  const SizedBox(height: 32), // Jarak yang lebih besar
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _authenticateUser, // Menonaktifkan tombol saat loading
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16), // Ukuran tombol
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8)), // Bentuk tombol
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator() // Indikator loading
                        : const Text('Lanjutkan'),
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _dailyQuotes = [
    "Kegagalan adalah bumbu yang memberi rasa pada kesuksesan.",
    "Lakukan dengan sepenuh hati, maka hasil tidak akan mengkhianati.",
    "Masa depan dimulai hari ini, bukan besok.",
    "Teruslah belajar, karena hidup tak pernah berhenti mengajarkan.",
    "Setiap kesulitan pasti ada kemudahan.",
    "Keberanian adalah kunci untuk membuka semua pintu.",
    "Saat kamu merasa lelah, ingatlah bahwa setiap langkahmu adalah bagian dari perjuangan menuju impianmu."
    // Kamu bisa tambahkan kutipan lain di sini
  ];

  String _currentQuote = "";

  @override
  void initState() {
    super.initState();
    _generateRandomQuote();
  }

  void _generateRandomQuote() {
    final random = Random();
    final randomIndex = random.nextInt(_dailyQuotes.length);
    setState(() {
      _currentQuote = _dailyQuotes[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box('userBox');
    final savedName = userBox.get('username');

    if (savedName == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AuthPage()),
        );
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary, // Warna AppBar
        title: Text(widget.title,
            style: const TextStyle(color: Colors.white)), // Warna teks AppBar
        elevation: 2, // Efek bayangan
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              // Menggunakan UserAccountsDrawerHeader
              accountName: Text(savedName), // Menampilkan nama pengguna
              accountEmail: const Text(""), // Bisa diisi email jika ada
              currentAccountPicture: const CircleAvatar(
                // Contoh avatar
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              selected: true, // Menandakan halaman sedang aktif
              selectedColor: Theme.of(context)
                  .colorScheme
                  .secondaryContainer, // Warna indikator
              onTap: () {
                Navigator.pop(context); // Menutup drawer
              },
            ),
            const Divider(), // Pemisah antar menu
            ListTile(
              leading: const Icon(Icons.navigate_next),
              title: const Text('Counter Tasbih'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MySecondPage(
                            title: 'Counter Tasbih',
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.checklist),
              title: const Text('Todo List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListCheckbox(
                            title: 'Todo List',
                          )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Kalkulator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalculatorScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer_sharp),
              title: const Text('Stopwatch'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StopwatchPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Timer'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TimerPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                // Bungkus kutipan dengan Card
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Kutipan Hari Ini:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .primary), // Warna judul
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentQuote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic), // Gaya teks kutipan
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Selamat Datang di Aplikasi Android V0.0, $savedName!', // Pesan selamat datang personal
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _generateRandomQuote,
        tooltip: 'Muat Kutipan Baru',
        backgroundColor: Theme.of(context).colorScheme.secondary, // Warna FAB
        child: const Icon(Icons.refresh, color: Colors.white), // Warna ikon
      ),
    );
  }
}
