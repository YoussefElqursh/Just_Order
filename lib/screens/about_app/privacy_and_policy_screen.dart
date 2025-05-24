import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  _PrivacyPolicyScreenState createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late List<String> sections; // Declare the sections variable
  late Map<String, String>
      sectionContent; // Declare the sectionContent variable
  Map<String, bool> expandedSections = {};

  @override
  Widget build(BuildContext context) {
    final List<String> sections = [
      AppLocalizations.of(context)!.information_we_collect,
      AppLocalizations.of(context)!.how_we_collect_information,
      AppLocalizations.of(context)!.how_we_use_your_information,
      AppLocalizations.of(context)!.data_sharing,
      AppLocalizations.of(context)!.data_security,
      AppLocalizations.of(context)!.your_rights,
      AppLocalizations.of(context)!.children_privacy,
      AppLocalizations.of(context)!.cross_border_data_transfers,
      AppLocalizations.of(context)!.changes_to_this_policy,
      AppLocalizations.of(context)!.contact_us,
    ];
    final Map<String, String> sectionContent = {
      AppLocalizations.of(context)!.information_we_collect:
          "${AppLocalizations.of(context)!.we_may_collect_the_following_types_of_personal_data}\n\n"
              "${AppLocalizations.of(context)!.account_information}\n"
              "- ${AppLocalizations.of(context)!.name}\n"
              "- ${AppLocalizations.of(context)!.email_address}\n"
              "- ${AppLocalizations.of(context)!.phone_number}\n"
              "- ${AppLocalizations.of(context)!.date_of_birth}\n"
              "- ${AppLocalizations.of(context)!.delivery_addresses}\n"
              "- ${AppLocalizations.of(context)!.payment_information}\n\n"
              "${AppLocalizations.of(context)!.order_information}\n"
              "- ${AppLocalizations.of(context)!.order_history}\n"
              "- ${AppLocalizations.of(context)!.order_details}\n\n"
              "${AppLocalizations.of(context)!.location_data}\n"
              "- ${AppLocalizations.of(context)!.approximate_location}\n"
              "- ${AppLocalizations.of(context)!.gps_location}\n\n"
              "${AppLocalizations.of(context)!.usage_data}\n"
              "- ${AppLocalizations.of(context)!.app_interactions}\n\n"
              "${AppLocalizations.of(context)!.device_information}\n"
              "- ${AppLocalizations.of(context)!.device_type_and_os}\n"
              "- ${AppLocalizations.of(context)!.unique_device_identifiers}\n\n"
              "${AppLocalizations.of(context)!.contact_information}\n"
              "- ${AppLocalizations.of(context)!.contact_us_details}",
      AppLocalizations.of(context)!.how_we_collect_information:
          "${AppLocalizations.of(context)!.we_collect_information_through_the_following_methods}\n\n"
              "- ${AppLocalizations.of(context)!.directly_from_you}\n\n"
              "- ${AppLocalizations.of(context)!.automatically}",
      AppLocalizations.of(context)!.how_we_use_your_information:
          "${AppLocalizations.of(context)!.we_use_your_personal_data_for_the_following_purposes}\n\n"
              "${AppLocalizations.of(context)!.providing_and_improving_our_services}\n"
              "- ${AppLocalizations.of(context)!.processing_orders}\n"
              "- ${AppLocalizations.of(context)!.delivering_orders}\n"
              "- ${AppLocalizations.of(context)!.communicating_with_you_about_your_orders}\n"
              "- ${AppLocalizations.of(context)!.improving_functionality_and_user_experience}\n"
              "- ${AppLocalizations.of(context)!.personalizing_your_experience}\n\n"
              "${AppLocalizations.of(context)!.marketing_and_communication}\n"
              "- ${AppLocalizations.of(context)!.sending_promotional_emails_and_notifications}\n"
              "- ${AppLocalizations.of(context)!.providing_personalized_offers_and_promotions}\n\n"
              "${AppLocalizations.of(context)!.customer_support}\n"
              "- ${AppLocalizations.of(context)!.responding_to_inquiries_and_resolving_issues}\n\n"
              "${AppLocalizations.of(context)!.fraud_prevention_and_security}\n"
              "- ${AppLocalizations.of(context)!.detecting_and_preventing_fraudulent_activities}\n"
              "- ${AppLocalizations.of(context)!.ensuring_security_and_integrity_of_services}\n\n"
              "${AppLocalizations.of(context)!.compliance_with_legal_obligations}\n"
              "- ${AppLocalizations.of(context)!.complying_with_applicable_laws}",
      AppLocalizations.of(context)!.data_sharing:
          "${AppLocalizations.of(context)!.we_may_share_your_personal_data_with_third_parties}\n\n"
              "- ${AppLocalizations.of(context)!.restaurants_to_fulfill_orders}\n"
              "- ${AppLocalizations.of(context)!.delivery_partners_to_deliver_orders}\n"
              "- ${AppLocalizations.of(context)!.payment_processors_to_process_payments}\n"
              "- ${AppLocalizations.of(context)!.service_providers_to_assist_with_operations}\n"
              "- ${AppLocalizations.of(context)!.law_enforcement_and_regulatory_authorities}\n\n"
              "${AppLocalizations.of(context)!.we_will_not_sell_or_rent_your_personal_data}",
      AppLocalizations.of(context)!.data_security:
          "${AppLocalizations.of(context)!.we_take_reasonable_measures_to_protect_data}\n\n"
              "${AppLocalizations.of(context)!.method_of_transmission_is_not_completely_secure}\n\n"
              "${AppLocalizations.of(context)!.security_measures_to_protect_data}\n\n"
              "- ${AppLocalizations.of(context)!.encryption_to_protect_sensitive_data}\n"
              "- ${AppLocalizations.of(context)!.access_controls_limited_to_authorized_personnel}\n"
              "- ${AppLocalizations.of(context)!.regular_security_reviews}",
      AppLocalizations.of(context)!.your_rights:
          "${AppLocalizations.of(context)!.under_egyptian_personal_data_protection_law}\n\n"
              "- **${AppLocalizations.of(context)!.access_right}**\n"
              "- **${AppLocalizations.of(context)!.rectification_right}**\n"
              "- **${AppLocalizations.of(context)!.erasure_right}**\n"
              "- **${AppLocalizations.of(context)!.restriction_of_processing_right}**\n"
              "- **${AppLocalizations.of(context)!.data_portability_right}**\n"
              "- **${AppLocalizations.of(context)!.objection_right}**\n\n"
              "${AppLocalizations.of(context)!.exercise_your_rights}",
      AppLocalizations.of(context)!.children_privacy:
          "${AppLocalizations.of(context)!.app_not_intended_for_children_under_16}\n\n"
              "${AppLocalizations.of(context)!.no_personal_data_from_children_under_16}",
      AppLocalizations.of(context)!.cross_border_data_transfers:
          "${AppLocalizations.of(context)!.personal_data_transfer_outside_egypt}\n\n"
              "${AppLocalizations.of(context)!.appropriate_measures_for_data_protection}",
      AppLocalizations.of(context)!.changes_to_this_policy:
          "${AppLocalizations.of(context)!.we_may_update_this_data_privacy_policy}\n\n"
              "${AppLocalizations.of(context)!.we_will_notify_you_of_changes}",
      AppLocalizations.of(context)!.contact_us:
          "${AppLocalizations.of(context)!.contact_us_for_questions}\n\n"
              "justorder@justorder-eg.com",
    };
    return Scaffold(
      appBar: AppBar(
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
          AppLocalizations.of(context)!.privacy_policy,
          style: const TextStyle(
            color: Color(0xFF090909) /* Black */,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Makes the entire page scrollable
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 6,
                children: [
                  Image.asset(
                    'assets/icons/timer_.png', // Path to your asset icon
                    height: 16,
                    width: 16,
                  ),
                  Text(
                    AppLocalizations.of(context)!.last_update,
                    style: const TextStyle(
                      color: Color(0xFFE02C45) /* Primary */,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Column(
                children: sections.map((sectionTitle) {
                  return _buildCustomExpandableSection(
                    title: sectionTitle,
                    content: sectionContent[sectionTitle]!,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomExpandableSection({
    required String title,
    String? content,
  }) {
    bool isExpanded = expandedSections[title] ?? false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    expandedSections[title] = !isExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    color: isExpanded ? const Color(0x0DE02C45) : const Color(0xFFF4F4F4),
                    // Background color
                    border: Border.all(
                      color: const Color(0xFFF4F4F4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    isExpanded ? Icons.remove : Icons.add,
                    size: 22,
                    color: isExpanded
                        ? const Color(0xFFE02C45)
                        : const Color(0xFFB0B0B0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF090909) /* Black */,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (isExpanded && content != null)
            Padding(
              padding: const EdgeInsets.only(
                top: 12.0,
              ),
              child: Text(
                content,
                style: const TextStyle(
                  color: Color(0xFF898888) /* Gray-Dark */,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
          const SizedBox(height: 16.0),
          const Divider(
            height: 1,
            color: Color(0x4CAFAFAF),
            thickness: 1,
          ),
          // Divider between sections
        ],
      ),
    );
  }
}
