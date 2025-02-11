import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'contact_us_screen.dart';
import 'faq_screen.dart';
import 'report _issue_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  @override
  _HelpSupportScreenState createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String selectedFilter = 'All'; // Default value
  List<String> filters = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (filters.isEmpty) {
      filters = [
        AppLocalizations.of(context)!.all,
        AppLocalizations.of(context)!.general,
        AppLocalizations.of(context)!.using_the_app,
        AppLocalizations.of(context)!.account_,
      ];
    }
  }

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
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(7),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          title: Text(
            AppLocalizations.of(context)!.help_support,
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
              Tab(text: AppLocalizations.of(context)!.faq),
              Tab(text: AppLocalizations.of(context)!.contact_us),
              Tab(text: AppLocalizations.of(context)!.report_issue),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    FAQSection(selectedFilter: selectedFilter), // Pass the default filter
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
