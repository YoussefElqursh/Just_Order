import 'package:flutter/material.dart';

class FAQSection extends StatefulWidget {
  final String selectedFilter;

  FAQSection({required this.selectedFilter});

  @override
  _FAQSectionState createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'General', 'Using the App', 'Account'];

  final List<Map<String, String>> faqList = [
    {'category': 'General', 'question': 'How do I track my order?', 'answer': 'You can track your order in the orders section.'},
    {'category': 'General', 'question': 'How do I place an order?', 'answer': 'Follow the steps in the app to place an order.'},
    {'category': 'Using the App', 'question': 'How can I contact customer support?', 'answer': 'Use the Contact Us section in the app.'},
    {'category': 'Account', 'question': 'Is my personal information secure?', 'answer': 'Yes, we follow industry standards for data security.'},
    {'category': 'Using the App', 'question': 'The app is not loading properly. What should I do?', 'answer': 'Try restarting your app or checking your internet connection.'},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFaqs = selectedFilter == 'All'
        ? faqList
        : faqList.where((faq) => faq['category'] == selectedFilter).toList();

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters.map((filter) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: ChoiceChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(
                      color: selectedFilter == filter ? Color(0xFFE02C45) : Color(0xFFF4F4F4),
                      width: 1.5,
                    ),
                  ),
                  label: Text(filter, style: TextStyle(color: selectedFilter == filter ? Colors.white : Color(0xFFB0B0B0))),
                  selected: selectedFilter == filter,
                  onSelected: (selected) {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  selectedColor: Color(0xFFE02C45),
                  backgroundColor: Color(0xFFF4F4F4),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ListView(
              children: filteredFaqs.map((faq) {
                return Card(
                  color: Colors.white,
                  child: ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(faq['answer']!),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}