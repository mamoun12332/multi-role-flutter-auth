import 'package:flutter/material.dart';

//import 'pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'Your Supabase URL',
    anonKey: 'Your Supabase Anon Key',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'multi_role_flutter_auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Inter', // Testing font
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(), // 
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}