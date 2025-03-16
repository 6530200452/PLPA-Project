import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
  double rating = 0.0;

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

  DateTime? selectedDate;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
          postData['BackgroundColor'] ?? Colors.yellow,
        );
        isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text(
          'Update Post',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
                color: Colors.yellow[800],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select Emotion',
              style: TextStyle(fontSize: 18, color: Colors.yellow[800]),
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
                              ? Colors.yellow[100]
                              : Colors.white,
                      border: Border.all(
                        color:
                            selectedEmoji == emojis[index]
                                ? Colors.yellow[800]!
                                : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
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
              style: TextStyle(fontSize: 18, color: Colors.yellow[800]),
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
                                ? Colors.yellow[800]!
                                : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
                'Select Date',
                style: TextStyle(fontSize: 18, color: Colors.yellow[800]),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => selectDate(context),
                child: Text(
                  selectedDate == null
                      ? 'Choose Date'
                      : 'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 20),

            TextFormField(
              controller: topicController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Add Topic',
                labelStyle: TextStyle(color: Colors.yellow[800]),
                prefixIcon: Icon(Icons.person, color: Colors.yellow[800]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            TextFormField(
              controller: contentController,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Add Content',
                labelStyle: TextStyle(color: Colors.yellow[800]),
                prefixIcon: Icon(Icons.description, color: Colors.yellow[800]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            Center(
              child: Text(
                'Rate Your Impress',
                style: TextStyle(fontSize: 18, color: Colors.yellow[800] ,fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 8),

            Center(
              child: RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder:
                    (context, _) => Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (newRating) {
                  setState(() {
                    rating = newRating;
                  });
                },
              ),
            ),

            SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  postCollection.doc(documentId).update({
                    'rating': rating,
                    'Name': selectedEmoji,
                    'Topic': topicController.text,
                    'Content': contentController.text,
                    'BackgroundColor': selectedColor.value,
                    'Date': selectedDate?.toIso8601String().split("T")[0],
                  });
                  Navigator.pop(context);
                },
                child: Text('Update',style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
