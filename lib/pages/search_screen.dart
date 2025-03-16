import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        hintStyle: GoogleFonts.prompt(fontSize: 16, color: Colors.grey[600]),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Post')
            .where('Topic', isGreaterThanOrEqualTo: query)
            .where('Topic', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var results = snapshot.data!.docs;
          if (results.isEmpty) {
            return Center(
              child: Text(
                "No results found",
                style: GoogleFonts.prompt(fontSize: 18, color: Colors.yellow[700]),
              ),
            );
          }
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  results[index].data() as Map<String, dynamic>;

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
                child: ListTile(
                  title: Text(
                    data['Name'] ?? 'No Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['Topic'] ?? 'No Topic',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        data['Date'] ?? 'No Date',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          title: Text(
                            data['Name'] ?? 'No Name',
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      data['Topic'] ?? 'No Topic',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(data['Content'] ?? 'No Content Available'),
                              SizedBox(height: 30),
                              Center(
                                child: Text(
                                  "Rating ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Center(
                                child: (data['rating'] != null &&
                                        (data['rating'] as num) > 0)
                                    ? Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          (data['rating'] as num).toInt(),
                                          (index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 24,
                                          ),
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
                                  "Date: ${data['Date'] ?? 'No Date'}",
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
                              child: Text(
                                'Close',
                                style: TextStyle(color: Colors.yellow[800]),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
