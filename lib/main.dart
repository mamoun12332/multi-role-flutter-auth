import 'package:flutter/material.dart';

//import 'pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://cjaduyqrlkzqasckzhrn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNqYWR1eXFybGt6cWFzY2t6aHJuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE0OTk4NDUsImV4cCI6MjA2NzA3NTg0NX0.0Qf3ZojkG9YxGWox9vaDrY6UXQ1Xj7PKqMf2Jk8CzZc',
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