import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './Logins/login_screen.dart';
import './Logins/registor_screen.dart';
import './pages/home.dart';
import './pages/favorite.dart';
import './pages/person.dart';
import './pages/search_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.yellow,
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.yellow[700],
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => MyApp(),
          '/register': (context) => RegisterScreen(),
        },
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> with ChangeNotifier {
  int screenIndex = 0;
  List<String> favoriteItems = [];

  final mobileScreens = [Home(), Favorite(), Person()];

  void toggleFavorite(String postId) {
    if (favoriteItems.contains(postId)) {
      favoriteItems.remove(postId);
    } else {
      favoriteItems.add(postId);
    }
    notifyListeners();
  }

  void showContentPopup(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow)),
          content: Text(content, style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: Colors.yellow[700])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'PLPA!',
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1.5,
        ),
      ),
  centerTitle: true,
  backgroundColor: Colors.yellow[700],
  elevation: 10,
  shadowColor: Colors.black54,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(25),
    ),
  ),
  actions: [
    Container(
      width: 35,
      height: 35,
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(Icons.search, color: Colors.black, size: 20),
        onPressed: () {
          showSearch(context: context, delegate: SearchScreen());
        },
      ),
    ),
  ],
),


      body: mobileScreens[screenIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey[900]!,
        color: Colors.yellow[700]!,
        buttonBackgroundColor: Colors.black,
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        index: screenIndex,
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        items: [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.favorite, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
        ],
      )
    );
  }
}