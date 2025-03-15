import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/updateForm.dart';

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
              color: Colors.green[900],
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
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(content),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: Colors.green[800])),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: StreamBuilder(
        stream: postCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("เกิดข้อผิดพลาด: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("ไม่มีข้อมูล"));
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
                  startActionPane: ActionPane(
                    motion: DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.blue,
                        icon: Icons.share,
                        label: 'แชร์',
                      ),
                    ],
                  ),
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
                      postIndex['Name'] ?? 'No Name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    subtitle: Text(postIndex['Topic'] ?? 'Unknown Topic'),
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
                      String title = postIndex['Name'] ?? 'No Name';
                      String topic = postIndex['Topic'] ?? 'No Topic';
                      String content =
                          postIndex['Content'] ?? 'No Content Available';
                      showContentPopup(context, title, topic, content);
                    },
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
