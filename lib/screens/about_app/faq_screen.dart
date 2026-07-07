import 'package:flutter/material.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/core/theme/colors.dart';

class FAQSection extends StatefulWidget {
  final String selectedFilter;

  const FAQSection({super.key, required this.selectedFilter});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  late String _selectedFilter;

  static const Color selectedColor = Color(0xFFE02C45);
  static const Color unselectedColor = Color(0xFFF4F4F4);
  static const Color unselectedTextColor = Color(0xFFB0B0B0);

  final List<Map<String, String>> _faqList = const [
    {
      'category': 'General',
      'question': 'How do I track my order?',
      'answer': 'You can track your order in the orders section.'
    },
    {
      'category': 'General',
      'question': 'How do I place an order?',
      'answer': 'Follow the steps in the app to place an order.'
    },
    {
      'category': 'Using the App',
      'question': 'How can I contact customer support?',
      'answer': 'Use the Contact Us section in the app.'
    },
    {
      'category': 'Account',
      'question': 'Is my personal information secure?',
      'answer': 'Yes, we follow industry standards for data security.'
    },
    {
      'category': 'Using the App',
      'question': 'The app is not loading properly. What should I do?',
      'answer': 'Try restarting your app or checking your internet connection.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter =
        widget.selectedFilter.isNotEmpty ? widget.selectedFilter : 'All';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final List<Map<String, String>> filters = [
      {'key': 'All', 'label': loc.all},
      {'key': 'General', 'label': loc.general},
      {'key': 'Using the App', 'label': loc.using_the_app},
      {'key': 'Account', 'label': loc.account_},
    ];

    final filteredFaqs = _selectedFilter == 'All'
        ? _faqList
        : _faqList.where((faq) => faq['category'] == _selectedFilter).toList();

    return Column(
      children: [
        SizedBox(
          height: 70,
          child: ListView.separated(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final filter = filters[index];
              final isSelected = _selectedFilter == filter['key'];
              return ChoiceChip(
                checkmarkColor: AppColor.whiteColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                label: Text(
                  filter['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : unselectedTextColor,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: isSelected ? selectedColor : unselectedColor,
                    width: 1.5,
                  ),
                ),
                selected: isSelected,
                onSelected: (_) {
                  setState(() {
                    _selectedFilter = filter['key']!;
                  });
                },
                selectedColor: selectedColor,
                backgroundColor: unselectedColor,
              );
            },
          ),
        ),

        // AnimatedSwitcher for smooth transition between FAQ lists
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
            ) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: ScrollConfiguration(
              key: ValueKey(_selectedFilter), // important for AnimatedSwitcher
              behavior: const NoGlowScrollBehavior(),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  itemCount: filteredFaqs.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final faq = filteredFaqs[index];
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: Color(0x4CAFAFAF) /* Gray-30% */,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          iconColor: AppColor.primaryColor,
                          title: Text(
                            faq['question']!,
                            style: const TextStyle(
                              color: Color(0xFF090909) /* Black */,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              height: 1.43,
                            ),
                          ),
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Divider(
                                  height: 1,
                                  color: Color(0x4CAFAFAF),
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                faq['answer']!,
                                style: const TextStyle(
                                  color: Color(0xFF898888) /* Gray-Dark */,
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Custom ScrollBehavior to remove glow effect (optional)
class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(); // Or ClampingScrollPhysics if you want iOS-like scroll
  }
}
