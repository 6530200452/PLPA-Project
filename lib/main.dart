import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import './Logins/login_screen.dart';
import './Logins/registor_screen.dart';
import './pages/home.dart';
import './pages/favorite.dart';
import './pages/person.dart';
import './services/addForm.dart';
import './pages/search_screen.dart';

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
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: Colors.green[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.greenAccent,
            titleTextStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
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
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
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
        title: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Center(child: Text('App Notes!')),
        ),
        backgroundColor: Colors.lightGreen,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(context: context, delegate: SearchScreen());
            },
          ),
        ],
      ),
      body: mobileScreens[screenIndex],
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addForm()),
                ).then((_) {
                  setState(() {
                    screenIndex = 0;
                  });
                });
              },
              shape: CircleBorder(),
              backgroundColor: Colors.green[700],
              child: Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.white,
        currentIndex: screenIndex,
        onTap: (index) {
          setState(() {
            screenIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
