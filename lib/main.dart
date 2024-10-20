import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/product_provider.dart';
import './screens/home_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
import './screens/cart_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDGEmiAamRphZxO5wI_4zaEVReq0tiGoSU",
      authDomain: "newsample-5c41c.firebaseapp.com",
      projectId: "newsample-5c41c",
      storageBucket: "newsample-5c41c.appspot.com",
      messagingSenderId: "217938412238",
      appId: "1:217938412238:web:389ea1a3fa5ecdc312c69f",
      measurementId: "G-7YB5YDQVD1",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ProductProvider()),
      ],
      child: MaterialApp(
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => auth.isAuth ? HomeScreen() : LoginScreen(),
        ),
        routes: {
          CartScreen.routeName: (ctx) => CartScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          SignupScreen.routeName: (ctx) => SignupScreen(),
        },
      ),
    );
  }
}
