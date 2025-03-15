import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<MyAppState>(context);
    var favoriteItems = appState.favoriteItems;
    CollectionReference postCollection = FirebaseFirestore.instance.collection(
      'Post',
    );

    return Scaffold(
      backgroundColor: Colors.green[50],
      body:
          favoriteItems.isEmpty
              ? Center(
                child: Text(
                  'No favorite items',
                  style: TextStyle(fontSize: 20, color: Colors.green[900]),
                ),
              )
              : StreamBuilder(
                stream:
                    postCollection
                        .where(FieldPath.documentId, whereIn: favoriteItems)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No favorite posts found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var postIndex = snapshot.data!.docs[index];
                      Map<String, dynamic> data =
                          postIndex.data() as Map<String, dynamic>;
                      Color backgroundColor =
                          data.containsKey('BackgroundColor')
                              ? Color(data['BackgroundColor'])
                              : Colors.white;

                      return Card(
                        color: backgroundColor,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          title: Text(
                            data['Name'] ?? 'No Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                          subtitle: Text(data['Topic'] ?? 'Unknown Topic'),
                          trailing: GestureDetector(
                            onTap: () {
                              appState.toggleFavorite(postIndex.id);
                            },
                            child: Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
