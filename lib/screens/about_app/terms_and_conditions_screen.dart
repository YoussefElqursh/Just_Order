import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  TermsAndConditionsScreenState createState() =>
      TermsAndConditionsScreenState();
}

class TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late List<String> sections;
  late Map<String, String> sectionContent;
  Map<String, bool> expandedSections = {};

  @override
  Widget build(BuildContext context) {
    final List<String> sections = [
      AppLocalizations.of(context)!.introduction,
      AppLocalizations.of(context)!.use_of_the_app,
      AppLocalizations.of(context)!.account_creation_and_usage,
      AppLocalizations.of(context)!.ordering_and_delivery,
      AppLocalizations.of(context)!.payments,
      AppLocalizations.of(context)!.order_cancellations,
      AppLocalizations.of(context)!.returns_and_refunds,
      AppLocalizations.of(context)!.intellectual_property,
      AppLocalizations.of(context)!.data_privacy_and_security,
      AppLocalizations.of(context)!.disclaimer_of_warranties,
      AppLocalizations.of(context)!.limitation_of_liability,
      AppLocalizations.of(context)!.indemnification,
      AppLocalizations.of(context)!.governing_law_and_jurisdiction,
      AppLocalizations.of(context)!.dispute_resolution,
      AppLocalizations.of(context)!.severability,
      AppLocalizations.of(context)!.accessibility,
      AppLocalizations.of(context)!.changes_to_these_terms,
      AppLocalizations.of(context)!.contact_us,
      AppLocalizations.of(context)!.entire_agreement,
      AppLocalizations.of(context)!.language,
    ];

    final Map<String, String> sectionContent = {
      AppLocalizations.of(context)!.introduction:
          '${AppLocalizations.of(context)!.terms_intro1}\n\n${AppLocalizations.of(context)!.terms_intro2}',
      AppLocalizations.of(context)!.use_of_the_app:
          "${AppLocalizations.of(context)!.the_app_allows_you_to_browse_restaurants_and_their_menus} * ${AppLocalizations.of(context)!.place_food_orders_from_participating_restaurants} * ${AppLocalizations.of(context)!.track_the_status_of_your_orders} * ${AppLocalizations.of(context)!.make_payments_for_your_orders_through_the_app} * ${AppLocalizations.of(context)!.communicate_with_restaurant_staff_and_delivery_drivers} * ${AppLocalizations.of(context)!.access_and_utilize_other_features_and_functionalities_as_made_available_by_just_on_time_from_time_to_time}\n\n${AppLocalizations.of(context)!.you_are_responsible_for_maintaining_the_confidentiality_of_your_account_information_and_for_restricting_access_to_your_computer_or_device}, ${AppLocalizations.of(context)!.you_agree_to_accept_responsibility_for_all_activities_that_occur_under_your_account_or_password}.\n\n${AppLocalizations.of(context)!.you_agree_to_use_the_app_only_for_lawful_purposes_and_in_accordance_with_these_terms}. ${AppLocalizations.of(context)!.you_may_not_use_the_app_for_any_illegal_or_unauthorized_purpose}. ${AppLocalizations.of(context)!.including_without_limitation}\n * ${AppLocalizations.of(context)!.you_may_not_transmit_any_viruses_or_other_harmful_computer_code}\n * ${AppLocalizations.of(context)!.you_may_not_interfere_with_or_disrupt_the_integrity_or_performance_of_the_app}\n * ${AppLocalizations.of(context)!.you_may_not_impersonate_any_person_or_entity}\n * ${AppLocalizations.of(context)!.you_may_not_collect_or_store_personal_data_about_other_users}\n * ${AppLocalizations.of(context)!.you_may_not_violate_any_applicable_laws_or_regulations}\n * ${AppLocalizations.of(context)!.you_may_not_engage_in_any_activity_that_is_fraudulent_deceptive_or_misleading}\n * ${AppLocalizations.of(context)!.you_may_not_use_any_automated_scripts_bots_or_other_means_to_access_or_interact_with_the_app_without_our_express_written_consent}",
      AppLocalizations.of(context)!.account_creation_and_usage:
          "${AppLocalizations.of(context)!.to_use_certain_features_of_the_app_you_may_be_required_to_create_a_user_account}\n\n${AppLocalizations.of(context)!.you_must_provide_accurate_and_complete_information_during_account_registration}\n\n${AppLocalizations.of(context)!.you_are_responsible_for_updating_your_account_information_to_keep_it_accurate_and_current}\n\n${AppLocalizations.of(context)!.you_may_deactivate_or_delete_your_account_at_any_time_by_following_the_instructions_within_the_app_or_by_contacting_just_on_time_customer_support}\n\n${AppLocalizations.of(context)!.just_on_time_reserves_the_right_to_suspend_or_terminate_your_account_at_any_time_for_any_reason_including_but_not_limited_to_violation_of_these_terms_suspicious_activity_or_inactivity}",
      AppLocalizations.of(context)!.ordering_and_delivery:
          "${AppLocalizations.of(context)!.all_orders_placed_through_the_app_are_subject_to_availability_and_acceptance_by_the_restaurant}\n\n${AppLocalizations.of(context)!.delivery_times_are_estimates_only_and_may_vary_due_to_factors_such_as_traffic_weather_and_restaurant_order_volume}\n\n${AppLocalizations.of(context)!.just_on_time_is_not_responsible_for_any_delays_or_cancellations_caused_by_factors_beyond_our_reasonable_control}\n\n${AppLocalizations.of(context)!.these_factors_include_restaurant_closures_or_delays_traffic_congestion_or_accidents_severe_weather_conditions_acts_of_god_power_outages_political_instability_pandemics_and_government_regulations_or_restrictions}\n\n${AppLocalizations.of(context)!.you_are_responsible_for_providing_accurate_and_complete_delivery_information}\n${AppLocalizations.of(context)!.just_on_time_is_not_liable_for_any_incorrect_or_incomplete_delivery_information_provided_by_you}\n\n${AppLocalizations.of(context)!.you_may_be_required_to_be_present_at_the_designated_delivery_address_to_receive_your_order}",
      AppLocalizations.of(context)!.payments:
          "${AppLocalizations.of(context)!.you_can_make_payments_for_your_orders_through_various_methods_offered_within_the_app_such_as_credit_card_debit_card_cash_on_delivery_cod_and_mobile_wallets}\n\n${AppLocalizations.of(context)!.all_prices_displayed_within_the_app_are_in_egyptian_pounds_egp_and_include_applicable_taxes}\n\n${AppLocalizations.of(context)!.you_are_responsible_for_ensuring_that_you_have_sufficient_funds_available_in_your_chosen_payment_method}\n\n${AppLocalizations.of(context)!.for_cod_orders_you_must_have_the_exact_amount_in_cash_ready_for_the_delivery_driver}\n\n${AppLocalizations.of(context)!.refunds_if_applicable_will_be_processed_to_the_original_payment_method_used_for_the_order}",
      AppLocalizations.of(context)!.order_cancellations:
          "${AppLocalizations.of(context)!.you_may_cancel_your_order_at_any_time_before_it_is_accepted_by_the_restaurant}\n\n${AppLocalizations.of(context)!.if_you_cancel_your_order_after_it_has_been_accepted_by_the_restaurant_you_may_be_subject_to_cancellation_fees_as_determined_by_the_restaurant}",
      AppLocalizations.of(context)!.returns_and_refunds:
          "${AppLocalizations.of(context)!.returns_and_refunds}\n\n${AppLocalizations.of(context)!.if_your_order_arrives_late_incorrect_or_damaged_please_contact_just_on_time_customer_support_immediately}\n\n${AppLocalizations.of(context)!.just_on_time_will_use_reasonable_efforts_to_resolve_any_order_issues}",
      AppLocalizations.of(context)!.intellectual_property:
          "${AppLocalizations.of(context)!.the_app_and_all_of_its_content_including_but_not_limited_to_text_graphics_logos_images_and_software_are_protected_by_copyright_trademark_and_other_intellectual_property_laws}\n\n${AppLocalizations.of(context)!.you_may_not_use_reproduce_distribute_modify_or_create_derivative_works_of_any_of_the_apps_content_without_our_prior_written_consent}\n\n${AppLocalizations.of(context)!.just_on_time_respects_the_intellectual_property_rights_of_others}\n${AppLocalizations.of(context)!.if_you_believe_that_your_intellectual_property_rights_have_been_infringed_please_contact_us}",
      AppLocalizations.of(context)!.data_privacy_and_security:
          AppLocalizations.of(context)!.please_refer_to_our_separate_data_privacy_policy_for_information_on_how_we_collect_use_and_protect_your_personal_data,
      AppLocalizations.of(context)!.disclaimer_of_warranties:
          "${AppLocalizations.of(context)!.the_app_and_all_services_provided_by_just_on_time_are_provided_as_is_and_as_available_without_warranty_of_any_kind_express_or_implied}\n\n${AppLocalizations.of(context)!.just_on_time_does_not_warrant_that_the_app_will_be_uninterrupted_or_error_free_that_defects_will_be_corrected_or_that_the_app_or_the_server_that_makes_it_available_are_free_of_viruses_or_other_harmful_components}\n\n${AppLocalizations.of(context)!.just_on_time_disclaims_any_liability_for_the_services_provided_by_third_parties_including_but_not_limited_to_restaurants_and_delivery_drivers}",
      AppLocalizations.of(context)!.limitation_of_liability:
          "${AppLocalizations.of(context)!.in_no_event_shall_just_on_time_be_liable_for_any_indirect_incidental_special_consequential_or_punitive_damages}\n\n${AppLocalizations.of(context)!.this_includes_without_limitation_loss_of_profits_data_use_goodwill_or_other_intangible_losses_resulting_from_i_the_use_of_or_the_inability_to_use_the_app_ii_the_cost_of_procurement_of_substitute_goods_or_services_or_iii_unauthorized_access_to_or_alteration_of_your_transmissions_or_data}\n\n${AppLocalizations.of(context)!.this_limitation_of_liability_shall_apply_to_the_fullest_extent_permitted_by_applicable_law}",
      AppLocalizations.of(context)!.indemnification:
          AppLocalizations.of(context)!.you_agree_to_indemnify_and_hold_harmless_just_on_time_and_its_affiliates_officers_directors_employees_agents_and_licensors_from_any_and_all_claims_losses_damages_liabilities_costs_and_expenses_arising_out_of_or_related_to_your_use_of_the_app_your_violation_of_these_terms_or_your_infringement_of_any_third_party_rights,
      AppLocalizations.of(context)!.governing_law_and_jurisdiction:
          "${AppLocalizations.of(context)!.these_terms_shall_be_governed_by_and_construed_in_accordance_with_the_laws_of_the_arab_republic_of_egypt_without_giving_effect_to_any_principles_of_conflicts_of_law}\n\n${AppLocalizations.of(context)!.any_dispute_arising_out_of_or_relating_to_these_terms_shall_be_subject_to_the_exclusive_jurisdiction_of_the_courts_of_the_arab_republic_of_egypt}",
      AppLocalizations.of(context)!.dispute_resolution:
          "${AppLocalizations.of(context)!.before_initiating_any_legal_proceedings_the_parties_agree_to_attempt_to_resolve_any_dispute_through_good_faith_negotiations}\n\n${AppLocalizations.of(context)!.if_the_parties_are_unable_to_resolve_the_dispute_through_negotiation_they_may_consider_alternative_dispute_resolution_methods_such_as_mediation_or_arbitration_before_resorting_to_litigation}",
      AppLocalizations.of(context)!.severability:
          "${AppLocalizations.of(context)!.if_any_provision_of_these_terms_is_held_to_be_invalid_or_unenforceable_such_provision_shall_be_struck_and_the_remaining_provisions_shall_be_enforced}\n\n${AppLocalizations.of(context)!.if_a_provision_is_found_to_be_invalid_the_parties_shall_negotiate_in_good_faith_to_replace_such_provision_with_a_valid_provision_that_comes_closest_to_reflecting_the_original_intention_of_the_parties}",
      AppLocalizations.of(context)!.accessibility:
          "${AppLocalizations.of(context)!.just_on_time_is_committed_to_making_the_app_accessible_to_users_with_disabilities}\n\n${AppLocalizations.of(context)!.we_are_continuously_working_to_improve_the_accessibility_of_the_app_for_all_users}",
      AppLocalizations.of(context)!.changes_to_these_terms:
          "${AppLocalizations.of(context)!.just_on_time_may_update_these_terms_from_time_to_time}\n\n${AppLocalizations.of(context)!.we_will_notify_you_of_any_changes_by_posting_the_revised_terms_on_the_app_and_or_by_sending_you_an_email_notification}\n\n${AppLocalizations.of(context)!.your_continued_use_of_the_app_after_the_effective_date_of_any_such_changes_constitutes_your_acceptance_of_the_revised_terms}",
      AppLocalizations.of(context)!.contact_us:
          "${AppLocalizations.of(context)!.if_you_have_any_questions_about_these_terms_please_contact_us_at}\njustorder@justorder-eg.com",
      AppLocalizations.of(context)!.entire_agreement:
          AppLocalizations.of(context)!.entire_agreement_,
      AppLocalizations.of(context)!.language:
          AppLocalizations.of(context)!.about_language_,
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
          AppLocalizations.of(context)!.terms_conditions,
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
        child: Container( // Set the body background color to white
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
                  ), // Space between the icon and text
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
                        : const Color(
                            0xFFB0B0B0), // Icon color when expanded/collapsed
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
