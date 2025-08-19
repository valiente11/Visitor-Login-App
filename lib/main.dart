import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'qr_compare_screen.dart';
import 'settings_page.dart';
import 'register_page.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'visit_form_page.dart';
import 'faq_page.dart';
import 'factory_map_page.dart';
import 'admin_panel_page.dart';
import 'face_login_page.dart';
import 'main_page.dart';




void main() {
  WidgetsFlutterBinding.ensureInitialized();  
  runApp(const SecurityApp()); //securityapp widgetini başlat
}

class SecurityApp extends StatefulWidget {
  const SecurityApp({Key? key}) : super(key: key);

  @override
  State<SecurityApp> createState() => _SecurityAppState();
}
 
class _SecurityAppState extends State<SecurityApp> {
  ThemeMode _themeMode = ThemeMode.system; //dark light mode
  bool _highContrast = false; //contrast ayarlama
  double _textScale = 1.0; //yazı tipi boyutu 

  void _toggleTheme() =>
      setState(() => _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  void _updateContrast(bool v) => setState(() => _highContrast = v);
  void _updateTextScale(double v) => setState(() => _textScale = v);

  @override
  Widget build(BuildContext context) {
    final lightScheme = _highContrast
        ? ColorScheme.highContrastLight()
        : ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final darkScheme = _highContrast
        ? ColorScheme.highContrastDark()
        : ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark);

    final lightTheme = ThemeData(
      colorScheme: lightScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.openSansTextTheme(),
    );
    final darkTheme = ThemeData(
      colorScheme: darkScheme,
      useMaterial3: true,
      textTheme: GoogleFonts.openSansTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ),
    );
    //ayarlamalardan sonra materialapp döndür
    return MaterialApp(
      title: 'Security App',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      builder: (c, child) => MediaQuery(
        data: MediaQuery.of(c).copyWith(textScaleFactor: _textScale),
        child: child!,
      ),

    //uygulamanın ilk açtığı sayfa QR
      initialRoute: '/qr-compare',
      routes: {
        '/qr-compare': (_) => const QRCompareScreen(),
        '/': (ctx) => HomeScreen(
              themeMode: _themeMode,
              onToggleTheme: _toggleTheme,
              onOpenSettings: () {
                Navigator.pop(ctx);
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => SettingsPage(
                      highContrast: _highContrast,
                      textScale: _textScale,
                      onContrastChanged: _updateContrast,
                      onTextScaleChanged: _updateTextScale,
                    ),
                  ),
                );
              },
            ),
            //sayfaların kısayolları register çağrılırsa register page açılır gibi
        '/register':    (_) => const RegisterPage(),
        '/login':       (_) => const LoginPage(),
        '/profile':     (_) => const ProfilePage(),
        '/visit_form':  (_) => const VisitFormPage(),
        '/faq':         (_) => const FAQPage(),
        '/factory_map': (_) => const FactoryMapPage(), 
        '/admin_panel': (_) => const AdminPanelPage(),
        '/face-login': (context) => const FaceLoginPage(),
          '/main':        (_) => const MainPage(),
      },
    );
  }
}
//uygulama açılınca ana ekran 
class HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onOpenSettings;

  const HomeScreen({
    Key? key,
    required this.themeMode,
    required this.onToggleTheme,
    required this.onOpenSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Security App')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: cs.primary),
              child: Text(
                'Menu',
                style: GoogleFonts.openSans(
                  color: cs.onPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                onOpenSettings();
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('FAQ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/faq');
              },
            ),
          ],
        ),
      ),
      //body için arayüz
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [cs.background.withOpacity(0.1), cs.background]
                : const [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Security App',
                    style: GoogleFonts.poppins(
                      color: cs.onBackground,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Welcome! Please choose an option below',
                    style: GoogleFonts.openSans(
                      color: cs.onBackground.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.app_registration, color: cs.primary),
                    title: Text('Register',
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.pushNamed(context, '/register'),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.login, color: cs.primary),
                    title: Text('Login',
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.pushNamed(context, '/login'),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: ListTile(
                    leading: Icon(Icons.map, color: cs.primary),
                    title: Text('Factory Layout',
                        style: GoogleFonts.openSans(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => Navigator.pushNamed(context, '/factory_map'),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onToggleTheme,
        tooltip: isDark ? 'Light Mode' : 'Dark Mode',
        child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      ),
    );
  }
}
