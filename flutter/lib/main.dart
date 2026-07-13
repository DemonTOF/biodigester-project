import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers.dart';
import 'features/monitoring/presentation/pages/monitor_page.dart';
import 'features/home/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biodigester Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0EA5E9),
          primary: const Color(0xFF0EA5E9),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [HomePage(), MonitorPage()];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(syncControllerProvider.notifier).refreshStatus();
      ref.read(syncControllerProvider.notifier).sync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.download),
            label: 'Ingestion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Monitoreo',
          ),
        ],
      ),
    );
  }
}
