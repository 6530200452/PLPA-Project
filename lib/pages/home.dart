import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:noteapp/services/addForm_day.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/updateForm.dart';
import 'package:google_fonts/google_fonts.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference postCollection = FirebaseFirestore.instance.collection(
    'Post',
  );

  void showContentPopup(
    BuildContext context,
    String title,
    String topic,
    String content,
    double rating,
    String date, 
    
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.yellow[900],
            ),
          ),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Topic: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Expanded(
                    child: Text(
                      topic,
                      style: TextStyle(fontSize: 14, color: Colors.black87,fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Text(content),

              SizedBox(height: 30),
              Center(
                child: Text(
                  "Rating ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Center(
                child:
                    rating > 0
                        ? Row(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: List.generate(
                            rating.toInt(),
                            (index) =>
                                Icon(Icons.star, color: Colors.amber, size: 24),
                          ),
                        )
                        : Text(
                          "No Rating",
                          style: TextStyle(color: Colors.grey),
                        ),
              ),

              SizedBox(height: 10),

              Center(
                child: Text(
                "Date: $date",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontStyle: FontStyle.italic,
                ),
              ),
              ) 
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: Colors.yellow[800])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: StreamBuilder(
        stream: postCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error ${snapshot.error}",style: GoogleFonts.prompt(fontSize: 18, color: Colors.yellow[700])));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No posts available",style: GoogleFonts.prompt(fontSize: 18, color: Colors.yellow[700])));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var postIndex = snapshot.data!.docs[index];
              var appState = Provider.of<MyAppState>(context);
              bool isFavorite = appState.favoriteItems.contains(postIndex.id);

              Map<String, dynamic> data =
                  postIndex.data() as Map<String, dynamic>;
              Color backgroundColor =
                  data.containsKey('BackgroundColor')
                      ? Color(data['BackgroundColor'])
                      : Colors.white;

              return Card(
                color: backgroundColor,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => updateForm(),
                              settings: RouteSettings(arguments: postIndex),
                            ),
                          );
                        },
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                        label: 'แก้ไข',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          postCollection.doc(postIndex.id).delete();
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: 'ลบ',
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      data.containsKey('Name') ? postIndex['Name'] : 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.containsKey('Topic') ? postIndex['Topic'] : 'No Topic',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14, 
                            color: Colors.black87,
                          ) ,
                        ),
                        Text(
                          data.containsKey('Date')
                              ? postIndex['Date']
                              : 'No Date',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),

                    trailing: GestureDetector(
                      onTap: () {
                        appState.toggleFavorite(postIndex.id);
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 30,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                    onTap: () {
                      String title = data.containsKey('Name') ? postIndex['Name'] : 'No Name';
                      String topic = data.containsKey('Topic') ? postIndex['Topic'] : 'No Topic';
                      String content = data.containsKey('Content') ? postIndex['Content'] : 'No Content Available';
                      double rating = data.containsKey('rating') ? (data['rating'] as num).toDouble() : 0.0;
                      String date = data.containsKey('Date') ? postIndex['Date'] : 'No Date';
                      print("Rating from Firestore: $rating");
                      showContentPopup(context, title, topic, content, rating, date); 
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => addFormDay()),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Icon(Icons.add, color: Colors.black, size: 32),
      backgroundColor: Colors.yellow[700],
      elevation: 10,
      splashColor: Colors.orangeAccent,
    ),

    );
  }
}