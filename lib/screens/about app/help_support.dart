import 'package:flutter/material.dart';
import 'contact_us_screen.dart';
import 'faq_screen.dart';
import 'report _issue_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'General', 'Using the App', 'Account'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4), // Background color for the container
                borderRadius: BorderRadius.circular(7), // Rounded corners for the container
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black), // Arrow icon color
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title:  Text(
            "Help & Support",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Color(0xFFE02C45),
            unselectedLabelColor: Color(0xFF898888),
            indicatorColor: Color(0xFFE02C45),
            tabs: [
              Tab(text: 'FAQ'),
              Tab(text: 'Contact Us'),
              Tab(text: 'Report Issue'),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: filters.map((filter) {
              //       return Padding(
              //         padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
              //         child: ChoiceChip(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(20.0),
              //             side: BorderSide(
              //               color: selectedFilter == filter ? Color(0xFFE02C45) : Color(0xFFF4F4F4), // Border color control
              //               width: 1.5,
              //             ),
              //           ),
              //           label: Text(filter, style: TextStyle(color: selectedFilter == filter ? Colors.white : Color(0xFFB0B0B0))),
              //           selected: selectedFilter == filter,
              //           onSelected: (selected) {
              //             setState(() {
              //               selectedFilter = filter;
              //             });
              //           },
              //           selectedColor: Color(0xFFE02C45),
              //             backgroundColor: Color(0xFFF4F4F4)
              //           ,
              //         ),
              //       );
              //     }).toList(),
              //   ),
              // ),
              Expanded(
                child: TabBarView(
                  children: [
                    FAQSection(selectedFilter: selectedFilter),
                    ContactUsScreen(),
                    ReportIssueScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class FAQSection extends StatefulWidget {
//   final String selectedFilter;
//
//   FAQSection({required this.selectedFilter});
//
//   @override
//   _FAQSectionState createState() => _FAQSectionState();
// }
//
// class _FAQSectionState extends State<FAQSection> {
//   String selectedFilter = 'All';
//   final List<String> filters = ['All', 'General', 'Using the App', 'Account'];
//
//   final List<Map<String, String>> faqList = [
//     {'category': 'General', 'question': 'How do I track my order?', 'answer': 'You can track your order in the orders section.'},
//     {'category': 'General', 'question': 'How do I place an order?', 'answer': 'Follow the steps in the app to place an order.'},
//     {'category': 'Using the App', 'question': 'How can I contact customer support?', 'answer': 'Use the Contact Us section in the app.'},
//     {'category': 'Account', 'question': 'Is my personal information secure?', 'answer': 'Yes, we follow industry standards for data security.'},
//     {'category': 'Using the App', 'question': 'The app is not loading properly. What should I do?', 'answer': 'Try restarting your app or checking your internet connection.'},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> filteredFaqs = selectedFilter == 'All'
//         ? faqList
//         : faqList.where((faq) => faq['category'] == selectedFilter).toList();
//
//     return Column(
//       children: [
//         SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: filters.map((filter) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                 child: ChoiceChip(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20.0),
//                     side: BorderSide(
//                       color: selectedFilter == filter ? Color(0xFFE02C45) : Color(0xFFF4F4F4),
//                       width: 1.5,
//                     ),
//                   ),
//                   label: Text(filter, style: TextStyle(color: selectedFilter == filter ? Colors.white : Color(0xFFB0B0B0))),
//                   selected: selectedFilter == filter,
//                   onSelected: (selected) {
//                     setState(() {
//                       selectedFilter = filter;
//                     });
//                   },
//                   selectedColor: Color(0xFFE02C45),
//                   backgroundColor: Color(0xFFF4F4F4),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         Expanded(
//           child: Padding(
//             padding: EdgeInsets.all(10.0),
//             child: ListView(
//               children: filteredFaqs.map((faq) {
//                 return Card(
//                   color: Colors.white,
//                   child: ExpansionTile(
//                     title: Text(
//                       faq['question']!,
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.all(10.0),
//                         child: Text(faq['answer']!),
//                       )
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }




// class ContactUsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         children: [
//           TextField(
//             decoration: InputDecoration(
//               prefixIcon: Icon(Icons.search, color: Colors.grey),
//               hintText: "Search",
//               filled: true,
//               fillColor: Color(0xFFF4F4F4),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//             ),
//           ),
//           SizedBox(height: 16),
//           Expanded(
//             child: ListView(
//               children: [
//                 ContactTile(
//                     icon: Icons.headset_mic,
//                     title: "Customer Service",
//                     url: "https://www.talabat.com/egypt"),
//                 ContactTile(
//                     icon: Icons.language,
//                     title: "Website",
//                     url: "https://www.talabat.com/egypt"),
//                 ContactTile(
//                     icon: Icons.facebook,
//                     title: "Facebook",
//                     url: "https://www.talabat.com/egypt"),
//                 ContactTile(
//                     icon: Icons.camera_alt,
//                     title: "Instagram",
//                     url: "https://www.talabat.com/egypt"),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ContactTile extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final String url;
//
//   ContactTile({required this.icon, required this.title, required this.url});
//
//   void _launchURL() async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       print("Could not launch $url");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,
//       child: ListTile(
//         leading: Icon(icon, color: Color(0xFFE02C45)),
//         title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//         onTap: _launchURL, // Open the link when tapped
//       ),
//     );
//   }
// }


