import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart' as di;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();          // ← THIS MUST BE HERE (before di.init)
  await di.init();
  runApp(const ECommerceApp());
}