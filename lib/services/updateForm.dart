import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class updateForm extends StatefulWidget {
  @override
  State<updateForm> createState() => _updateFormState();
}

class _updateFormState extends State<updateForm> {
  CollectionReference postCollection = FirebaseFirestore.instance.collection(
    'Post',
  );

  TextEditingController topicController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late String selectedEmoji;
  late String documentId;
  bool isInitialized = false;

  List<String> emojis = ['✈️', '🏖️', '🏕️', '🏜️', '🏝️', '🏞️', '🌅', '🗼'];

  Color selectedColor = Colors.white;
  List<Color> colors = [
    Color(0xFFFFF0F5), // Lavender Blush
    Color(0xFFFFE4E1), // Misty Rose
    Color(0xFFFFDAB9), // Peach Puff
    Color(0xFFFFFACD), // Lemon Chiffon
    Color(0xFFE0FFFF), // Light Cyan
    Color(0xFFF0FFF0), // Honeydew
    Color(0xFFF5FFFA), // Mint Cream
    Color(0xFFFFF5EE), // Seashell
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final postData =
          ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;
      setState(() {
        documentId = postData.id;
        topicController.text = postData['Topic'];
        contentController.text = postData['Content'];
        selectedEmoji =
            emojis.contains(postData['Name']) ? postData['Name'] : emojis[0];
        selectedColor = Color(
          postData['BackgroundColor'] ?? Colors.white.value,
        );
        isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(200, 230, 201, 1),
        title: Text(
          'Update Post',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Post',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
            SizedBox(height: 20),

            Text(
              'Select Emotion',
              style: TextStyle(fontSize: 18, color: Colors.green[800]),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: emojis.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedEmoji = emojis[index]),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color:
                          selectedEmoji == emojis[index]
                              ? Colors.green[100]
                              : Colors.white,
                      border: Border.all(
                        color:
                            selectedEmoji == emojis[index]
                                ? Colors.green[800]!
                                : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        emojis[index],
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            Text(
              'Select Background Color',
              style: TextStyle(fontSize: 18, color: Colors.green[800]),
            ),
            SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: colors.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => selectedColor = colors[index]),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors[index],
                      border: Border.all(
                        color:
                            selectedColor == colors[index]
                                ? Colors.black
                                : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),

            TextFormField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: 'Add Topic',
                prefixIcon: Icon(Icons.person, color: Colors.green[800]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            TextFormField(
              controller: contentController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Add Content',
                prefixIcon: Icon(Icons.description, color: Colors.green[800]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  postCollection.doc(documentId).update({
                    'Name': selectedEmoji,
                    'Topic': topicController.text,
                    'Content': contentController.text,
                    'BackgroundColor': selectedColor.value,
                  });
                  Navigator.pop(context);
                },
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
