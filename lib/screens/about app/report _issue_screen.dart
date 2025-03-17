import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:just_order/shared/style/colors.dart';

// abstract class MyButton extends StatelessWidget {
//   const MyButton({super.key});
//
//
//
//
// }

class ReportIssueScreen extends StatefulWidget {
  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  Future<void> sendRequest() async {
    final url =
        Uri.parse('https://report-problem.justorder-eg.com/report-problem');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "name": "Testing User",
          "email": "test@user.com",
          "subject": "${selectedIssueType}",
          "message": descriptionController.text,
          "topicId": 1,
          "priorityId": 2
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Request Sent Successfully");
      } else {
        print("Failed with status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error sending request: $e");
    }
  }

  String? selectedIssueType;
  TextEditingController orderIdController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<File> selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImages.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Localized issue types
    final List<String> issueTypes = [
      AppLocalizations.of(context)!.ordering_issue,
      AppLocalizations.of(context)!.payment_issue,
      AppLocalizations.of(context)!.app_bug_technical_problem,
      AppLocalizations.of(context)!.other
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                prefixIcon: Icon(Icons.search, color: Color(0xFFE02C45)),
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.issue_type,
                    style: TextStyle(
                      color: Color(0xFF090909) /* Black */,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: Color(0xFFF44336) /* Red */,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: issueTypes.map((type) {
                bool isSelected = selectedIssueType == type;
                return ChoiceChip(
                  checkmarkColor: AppColor.whiteColor,
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      selectedIssueType = selected ? type : null;
                    });
                  },
                  selectedColor: Color(0xFFE02C45),
                  backgroundColor: Color(0xFFF4F4F4),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
            if (selectedIssueType ==
                AppLocalizations.of(context)!.ordering_issue) ...[
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.order_id,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextField(
                controller: orderIdController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.enter_order_id,
                  filled: true,
                  fillColor: Color(0xFFF4F4F4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
            SizedBox(height: 16),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.issue_description,
                    style: TextStyle(
                      color: Color(0xFF090909) /* Black */,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                      color: Color(0xFFF44336) /* Red */,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5),
            TextField(
              controller: descriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!
                    .please_describe_the_issue_in_detail,
                filled: true,
                fillColor: Color(0xFFF4F4F4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            // SizedBox(height: 16),
            // Text(AppLocalizations.of(context)!.attach_screenshot_or_Photo, style: TextStyle(fontWeight: FontWeight.bold)),
            // SizedBox(height: 5),
            // Row(
            //   children: [
            //     ...selectedImages.asMap().entries.map((entry) {
            //       int index = entry.key;
            //       File image = entry.value;
            //       return Stack(
            //         alignment: Alignment.topRight,
            //         children: [
            //           Container(
            //             margin: EdgeInsets.only(right: 10),
            //             width: 70,
            //             height: 70,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(10),
            //               image: DecorationImage(
            //                 image: FileImage(image),
            //                 fit: BoxFit.cover,
            //               ),
            //             ),
            //           ),
            //           GestureDetector(
            //             onTap: () => _removeImage(index),
            //             child: CircleAvatar(
            //               backgroundColor: Colors.red,
            //               radius: 12,
            //               child: Icon(Icons.close, color: Colors.white, size: 16),
            //             ),
            //           ),
            //         ],
            //       );
            //     }).toList(),
            //     GestureDetector(
            //       onTap: _pickImage,
            //       child: Container(
            //         width: 70,
            //         height: 70,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(10),
            //           color: Color(0xFFF4F4F4),
            //         ),
            //         child: Icon(Icons.add_a_photo, color: Colors.grey),
            //       ),
            //     ),
            //   ],
            // ),
            // SizedBox(height: 5),
            // Text(AppLocalizations.of(context)!.max_file_size_5MB, style: TextStyle(color: Colors.grey, fontSize: 12)),
            // SizedBox(height: 20),
            SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await sendRequest();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE02C45),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.submit,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
