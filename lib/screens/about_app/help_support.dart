import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'contact_us_screen.dart';
import 'faq_screen.dart';
import 'report_issue_screen.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  late final List<String> filters;
  String selectedFilter = 'All'; // Default

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final loc = AppLocalizations.of(context)!;
    filters = [
      loc.all,
      loc.general,
      loc.using_the_app,
      loc.account_,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(loc),
        body: TabBarView(
          children: [
            FAQSection(selectedFilter: selectedFilter),
            const ContactUsScreen(),
            const ReportIssueScreen(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(AppLocalizations loc) {
    return AppBar(
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          top: 10.0,
          bottom: 10.0,
        ),
        child: Container(
          width: 34,
          height: 34,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFFF4F4F4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 18,
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        loc.help_support,
        style: const TextStyle(
          color: Color(0xFF090909) /* Black */,
          fontSize: 14,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
        ),
      ),
      bottom: TabBar(
        labelColor: const Color(0xFFE02C45),
        unselectedLabelColor: const Color(0xFF898888),
        indicatorColor: const Color(0xFFE02C45),
        tabs: [
          Tab(text: loc.faq),
          Tab(text: loc.contact_us),
          Tab(text: loc.report_issue),
        ],
      ),
    );
  }
}
