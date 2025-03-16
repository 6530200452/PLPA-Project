// import 'package:flutter/material.dart';
// import 'package:noteapp/services/addForm.dart';
// import 'package:noteapp/services/addForm_day.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CalendarPage extends StatefulWidget {
//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   DateTime _selectedDay = DateTime.now();
//   List<Map<String, dynamic>> _post = [];
//   Map<DateTime, List<dynamic>> _events = {};
//   String selectedEmoji = '😊';
//   List<String> emojis = ['✈️', '🏖️', '🏕️', '🏜️', '🏝️', '🏞️', '🌅', '🗼'];

//   @override
//   void initState() {
//     super.initState();
//     _fetchAllPosts();
//   }

//   void _fetchAllPosts() async {
//     FirebaseFirestore.instance.collection('Post').get().then((snapshot) {
//       Map<DateTime, List<dynamic>> newEvents = {};

//       for (var doc in snapshot.docs) {
//         String dateStr = doc['date']; // รับค่าวันที่จาก Firestore
//         DateTime date = DateTime.parse(dateStr); // แปลง String เป็น DateTime
//         DateTime normalizedDate = DateTime(
//           date.year,
//           date.month,
//           date.day,
//         ); // ปรับให้เป็นวันที่ (ตัดเวลาออก)

//         if (newEvents[normalizedDate] == null) {
//           newEvents[normalizedDate] = [];
//         }
//         newEvents[normalizedDate]!.add(doc.data());
//       }

//       setState(() {
//         _events = newEvents;
//       });
//     });
//   }

//   void _fetchPost(DateTime day) async {
//     String dateKey =
//         "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
//     FirebaseFirestore.instance
//         .collection('Post')
//         .where('date', isEqualTo: dateKey)
//         .get()
//         .then((snapshot) {
//           setState(() {
//             _post = snapshot.docs.map((doc) => doc.data()).toList();
//           });
//         });
//   }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = selectedDay;
//       _fetchPost(selectedDay);
//     });
//   }

//   // void _showAddPostDialog(BuildContext context) {
//   //   TextEditingController topicController = TextEditingController();
//   //   TextEditingController contentController = TextEditingController();
//   //   CollectionReference postCollection = FirebaseFirestore.instance.collection(
//   //     'Post',
//   //   );

//   //   showDialog(
//   //     context: context,
//   //     builder:
//   //         (context) => AlertDialog(
//   //           title: Text("Add Post"),
//   //           content: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               TextField(
//   //                 controller: topicController,
//   //                 decoration: InputDecoration(
//   //                   border: OutlineInputBorder(
//   //                     borderRadius: BorderRadius.circular(15),
//   //                   ),
//   //                   labelText: 'Topic'
//   //                 ),
//   //               ),

//   //               SizedBox(height: 10),

//   //               TextField(
//   //                 controller: contentController,
//   //                 decoration: InputDecoration(
//   //                   border: OutlineInputBorder(
//   //                     borderRadius: BorderRadius.circular(15)
//   //                   ),
//   //                   labelText: 'Content'
//   //                 ),
//   //               ),

//   //               SizedBox(height: 10),

//   //             ],
//   //           ),
//   //           actions: [
//   //             TextButton(
//   //               onPressed: () => Navigator.pop(context),
//   //               child: Text("Cancel"),
//   //             ),
//   //             TextButton(
//   //               onPressed: () {
//   //                 String topic =
//   //                     topicController.text.trim();
//   //                 String content = contentController.text.trim();

//   //                 if (topic.isNotEmpty) {
//   //                   _savePost(topic, content, selectedEmoji);
//   //                   Navigator.pop(context);
//   //                 } else {
//   //                   ScaffoldMessenger.of(context).showSnackBar(
//   //                     SnackBar(content: Text("Topic is required!")),
//   //                   );
//   //                 }
//   //               },
//   //               child: Text("Save"),
//   //             ),
//   //           ],
//   //         ),
//   //   );
//   // }

//   // void _savePost(String topic, String content, String priority) {
//   //   FirebaseFirestore.instance.collection('Post').add({
//   //     'topic': topic,
//   //     'content': content,
//   //     'priority': priority,
//   //     'date': _selectedDay.toIso8601String().split("T")[0]
//   //   }).then((_) {
//   //     _fetchPost(); // โหลดข้อมูลใหม่หลังบันทึก
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Center(child: Text("Calendar"))),
//       body: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2020, 1, 1),
//             lastDay: DateTime.utc(2030, 12, 31),
//             focusedDay: _selectedDay,
//             selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//             onDaySelected: _onDaySelected,
//             eventLoader: (day) {
//               DateTime normalizedDay = DateTime(day.year, day.month, day.day);
//               return _events[normalizedDay] ?? [];
//             },
//             calendarBuilders: CalendarBuilders(
//               markerBuilder: (context, date, events) {
//                 if (events.isNotEmpty) {
//                   return Positioned(
//                     bottom: 5,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.red,
//                         shape: BoxShape.circle,
//                       ),
//                       width: 7,
//                       height: 7,
//                     ),
//                   );
//                 }
//                 return null;
//               },
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _post.length,
//               itemBuilder: (context, index) {
//                 final post = _post[index];
//                 return ListTile(
//                   title: Text(post['topic']),
//                   subtitle: Text(post['content']),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),

//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => addFormDay()),
//           ).then((_) {
//             _fetchAllPosts(); // โหลดข้อมูลใหม่หลังจากบันทึก
//             setState(() {}); // รีเฟรช UI
//           });
//         },
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
//         child: Icon(Icons.add),
//         backgroundColor: Colors.amber,
//       ),
//     );
//   }
// }
