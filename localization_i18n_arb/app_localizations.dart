import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization_i18n_arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @home_.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_;

  /// No description provided for @orders_.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders_;

  /// No description provided for @account_.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account_;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World'**
  String get helloWorld;

  /// No description provided for @multiLanguage.
  ///
  /// In en, this message translates to:
  /// **'Multi Language'**
  String get multiLanguage;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @password_must_not_be_empty.
  ///
  /// In en, this message translates to:
  /// **'Password must not be empty'**
  String get password_must_not_be_empty;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get user;

  /// No description provided for @invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalid_credentials;

  /// No description provided for @an_error_occurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred:'**
  String get an_error_occurred;

  /// No description provided for @google_sign_in_aborted.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in aborted'**
  String get google_sign_in_aborted;

  /// No description provided for @google_sign_in_failed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get google_sign_in_failed;

  /// No description provided for @no_name_provided.
  ///
  /// In en, this message translates to:
  /// **'No Name Provided'**
  String get no_name_provided;

  /// No description provided for @invalid_email_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalid_email_format;

  /// No description provided for @password_must_be_at_least_8_characters_long.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters long'**
  String get password_must_be_at_least_8_characters_long;

  /// No description provided for @invalid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalid_phone_number;

  /// No description provided for @no_internet_connection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get no_internet_connection;

  /// No description provided for @user_with_this_email_already_exists.
  ///
  /// In en, this message translates to:
  /// **'User with this email already exists.'**
  String get user_with_this_email_already_exists;

  /// No description provided for @scan_order.
  ///
  /// In en, this message translates to:
  /// **'Scan Order'**
  String get scan_order;

  /// No description provided for @scan_qr_code_of_the_table.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code of the table'**
  String get scan_qr_code_of_the_table;

  /// No description provided for @camera_permission_is_required_to_scan_qr_codes.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required to scan QR codes. You can\'t continue without this permission'**
  String get camera_permission_is_required_to_scan_qr_codes;

  /// No description provided for @open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get open_settings;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @change_location.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get change_location;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @theme_mode.
  ///
  /// In en, this message translates to:
  /// **'Theme Mode'**
  String get theme_mode;

  /// No description provided for @language_.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language_;

  /// No description provided for @current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get current_password;

  /// No description provided for @please_enter_a_valid_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid Password'**
  String get please_enter_a_valid_password;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @new_password_cannot_be_the_same_as_current_password.
  ///
  /// In en, this message translates to:
  /// **'New Password cannot be the same as Current Password'**
  String get new_password_cannot_be_the_same_as_current_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @please_enter_a_confirm_password_as_new_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter a Confirm Password as New Password'**
  String get please_enter_a_confirm_password_as_new_password;

  /// No description provided for @password_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully.'**
  String get password_updated_successfully;

  /// No description provided for @authentication_failed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed.'**
  String get authentication_failed;

  /// No description provided for @user_with_this_email_not_exists.
  ///
  /// In en, this message translates to:
  /// **'User with this email not exists.'**
  String get user_with_this_email_not_exists;

  /// No description provided for @user_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully.'**
  String get user_updated_successfully;

  /// No description provided for @user_update_failed.
  ///
  /// In en, this message translates to:
  /// **'User update failed.'**
  String get user_update_failed;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @no_history_orders.
  ///
  /// In en, this message translates to:
  /// **'No History Orders'**
  String get no_history_orders;

  /// No description provided for @personal_information.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personal_information;

  /// No description provided for @my_profile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get my_profile;

  /// No description provided for @account_management.
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get account_management;

  /// No description provided for @order_history.
  ///
  /// In en, this message translates to:
  /// **'Order history'**
  String get order_history;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @about_app.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get about_app;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get log_out;

  /// No description provided for @no_changes_to_save.
  ///
  /// In en, this message translates to:
  /// **'No changes to save.'**
  String get no_changes_to_save;

  /// No description provided for @profile_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profile_updated_successfully;

  /// No description provided for @save_profile.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get save_profile;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @user_name.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get user_name;

  /// No description provided for @please_enter_valid_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid name'**
  String get please_enter_valid_name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @please_enter_a_valid_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get please_enter_a_valid_phone_number;

  /// No description provided for @please_enter_a_valid_11_digit_phone_number.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 11-digit phone number'**
  String get please_enter_a_valid_11_digit_phone_number;

  /// No description provided for @invalid_first_name.
  ///
  /// In en, this message translates to:
  /// **'Invalid First Name'**
  String get invalid_first_name;

  /// No description provided for @invalid_last_name.
  ///
  /// In en, this message translates to:
  /// **'Invalid Last Name'**
  String get invalid_last_name;

  /// No description provided for @my_cart.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get my_cart;

  /// No description provided for @restaurant_name.
  ///
  /// In en, this message translates to:
  /// **'Restaurant Name'**
  String get restaurant_name;

  /// No description provided for @any_items_found_in_anothe_cart_is_saved.
  ///
  /// In en, this message translates to:
  /// **'Any items found in another cart is saved'**
  String get any_items_found_in_anothe_cart_is_saved;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @remove_all.
  ///
  /// In en, this message translates to:
  /// **'Remove All'**
  String get remove_all;

  /// No description provided for @payment_summary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get payment_summary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @delivery_fee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get delivery_fee;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @service_fees.
  ///
  /// In en, this message translates to:
  /// **'Service Fees'**
  String get service_fees;

  /// No description provided for @egp_10_00.
  ///
  /// In en, this message translates to:
  /// **'EGP 10.00'**
  String get egp_10_00;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @your_cart_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get your_cart_is_empty;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @delivering_to.
  ///
  /// In en, this message translates to:
  /// **'DeliveringTo'**
  String get delivering_to;

  /// No description provided for @table.
  ///
  /// In en, this message translates to:
  /// **'Table'**
  String get table;

  /// No description provided for @all_restaurants.
  ///
  /// In en, this message translates to:
  /// **'All Restaurants'**
  String get all_restaurants;

  /// No description provided for @popular_today.
  ///
  /// In en, this message translates to:
  /// **'Popular Today'**
  String get popular_today;

  /// No description provided for @table_location.
  ///
  /// In en, this message translates to:
  /// **'Table Location'**
  String get table_location;

  /// No description provided for @club_name.
  ///
  /// In en, this message translates to:
  /// **'Club Name'**
  String get club_name;

  /// No description provided for @al_ahly_club.
  ///
  /// In en, this message translates to:
  /// **'Al Ahly Club'**
  String get al_ahly_club;

  /// No description provided for @table_code.
  ///
  /// In en, this message translates to:
  /// **'Table Code'**
  String get table_code;

  /// No description provided for @change_table.
  ///
  /// In en, this message translates to:
  /// **'Change Table'**
  String get change_table;

  /// No description provided for @pizza_size.
  ///
  /// In en, this message translates to:
  /// **'Pizza Size'**
  String get pizza_size;

  /// No description provided for @choose_1_option.
  ///
  /// In en, this message translates to:
  /// **'Choose 1 option'**
  String get choose_1_option;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @extras.
  ///
  /// In en, this message translates to:
  /// **'Extras'**
  String get extras;

  /// No description provided for @choose_up_to_1_option.
  ///
  /// In en, this message translates to:
  /// **'Choose up to 1 option'**
  String get choose_up_to_1_option;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @plus_egp.
  ///
  /// In en, this message translates to:
  /// **'+EGP'**
  String get plus_egp;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @quantity_order.
  ///
  /// In en, this message translates to:
  /// **'Quantity Order'**
  String get quantity_order;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart;

  /// No description provided for @egp_0_00.
  ///
  /// In en, this message translates to:
  /// **'EGP 0.00'**
  String get egp_0_00;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @up_to_40_percent_off.
  ///
  /// In en, this message translates to:
  /// **'Up to 40% off'**
  String get up_to_40_percent_off;

  /// No description provided for @pizza.
  ///
  /// In en, this message translates to:
  /// **'Pizza'**
  String get pizza;

  /// No description provided for @crepes.
  ///
  /// In en, this message translates to:
  /// **'Crepes'**
  String get crepes;

  /// No description provided for @pies.
  ///
  /// In en, this message translates to:
  /// **'Pies'**
  String get pies;

  /// No description provided for @beverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get beverages;

  /// No description provided for @ratings_30265.
  ///
  /// In en, this message translates to:
  /// **'(30,265 Ratings)'**
  String get ratings_30265;

  /// No description provided for @pizza_pies_crepes.
  ///
  /// In en, this message translates to:
  /// **'Pizza, Pies, Crepes'**
  String get pizza_pies_crepes;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @sign_in_to_your_account.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your Account'**
  String get sign_in_to_your_account;

  /// No description provided for @enter_your_email_and_password_to_login.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and password to Login'**
  String get enter_your_email_and_password_to_login;

  /// No description provided for @continue_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continue_with_google;

  /// No description provided for @or_login_with.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get or_login_with;

  /// No description provided for @please_enter_your_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get please_enter_your_email;

  /// No description provided for @please_enter_your_password.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get please_enter_your_password;

  /// No description provided for @password_must_be_at_least_6_characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get password_must_be_at_least_6_characters;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forget_password;

  /// No description provided for @login_sucessful.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get login_sucessful;

  /// No description provided for @invalid_email_or_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalid_email_or_password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @dont_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dont_have_an_account;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign_up;

  /// No description provided for @order_iD.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get order_iD;

  /// No description provided for @general_details.
  ///
  /// In en, this message translates to:
  /// **'General Details'**
  String get general_details;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @order_status.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get order_status;

  /// No description provided for @order_qr_code.
  ///
  /// In en, this message translates to:
  /// **'Order QR CODE'**
  String get order_qr_code;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @pending_orders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get pending_orders;

  /// No description provided for @no_pending_orders.
  ///
  /// In en, this message translates to:
  /// **'No Pending Orders'**
  String get no_pending_orders;

  /// No description provided for @preparing_orders.
  ///
  /// In en, this message translates to:
  /// **'Preparing Orders'**
  String get preparing_orders;

  /// No description provided for @no_preparing_orders.
  ///
  /// In en, this message translates to:
  /// **'No Preparing Orders'**
  String get no_preparing_orders;

  /// No description provided for @on_way_orders.
  ///
  /// In en, this message translates to:
  /// **'On Way Orders'**
  String get on_way_orders;

  /// No description provided for @no_on_way_orders.
  ///
  /// In en, this message translates to:
  /// **'No On Way Orders'**
  String get no_on_way_orders;

  /// No description provided for @delivered_orders.
  ///
  /// In en, this message translates to:
  /// **'Delivered Orders'**
  String get delivered_orders;

  /// No description provided for @no_delivered_orders.
  ///
  /// In en, this message translates to:
  /// **'No Delivered Orders'**
  String get no_delivered_orders;

  /// No description provided for @declined_orders.
  ///
  /// In en, this message translates to:
  /// **'Declined Orders'**
  String get declined_orders;

  /// No description provided for @no_declined_orders.
  ///
  /// In en, this message translates to:
  /// **'No Declined Orders'**
  String get no_declined_orders;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'order'**
  String get order;

  /// No description provided for @cart_items.
  ///
  /// In en, this message translates to:
  /// **'Cart Items'**
  String get cart_items;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @bon_appetit.
  ///
  /// In en, this message translates to:
  /// **'Bon Appétit!'**
  String get bon_appetit;

  /// No description provided for @order_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmed!'**
  String get order_confirmed;

  /// No description provided for @service_fee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get service_fee;

  /// No description provided for @payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get payment_method;

  /// No description provided for @order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get order_summary;

  /// No description provided for @client_secret.
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get client_secret;

  /// No description provided for @confirm_order.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirm_order;

  /// No description provided for @add_card.
  ///
  /// In en, this message translates to:
  /// **'Add Card'**
  String get add_card;

  /// No description provided for @cardholder_name.
  ///
  /// In en, this message translates to:
  /// **'Cardholder Name'**
  String get cardholder_name;

  /// No description provided for @card_number.
  ///
  /// In en, this message translates to:
  /// **'Card Number'**
  String get card_number;

  /// No description provided for @expiration.
  ///
  /// In en, this message translates to:
  /// **'Expire Date'**
  String get expiration;

  /// No description provided for @security_code.
  ///
  /// In en, this message translates to:
  /// **'Security Code (CCV)'**
  String get security_code;

  /// No description provided for @card_saving.
  ///
  /// In en, this message translates to:
  /// **'Save this card for faster payments'**
  String get card_saving;

  /// No description provided for @continue_.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_;

  /// No description provided for @cedit_debit_card.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get cedit_debit_card;

  /// No description provided for @cash_on_delivery.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cash_on_delivery;

  /// No description provided for @secretClient.
  ///
  /// In en, this message translates to:
  /// **'Secret Client'**
  String get secretClient;

  /// No description provided for @cartItems.
  ///
  /// In en, this message translates to:
  /// **'Cart Items'**
  String get cartItems;

  /// No description provided for @sign_up_process_succeeded.
  ///
  /// In en, this message translates to:
  /// **'Sign up process succeeded'**
  String get sign_up_process_succeeded;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @please_enter_valid_first_name.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid first name'**
  String get please_enter_valid_first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @please_enter_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email'**
  String get please_enter_valid_email;

  /// No description provided for @already_have_an_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get already_have_an_account;

  /// No description provided for @log_in.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get log_in;

  /// No description provided for @please_check_your_internet_connection_and_try_again.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get please_check_your_internet_connection_and_try_again;

  /// No description provided for @help_support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get help_support;

  /// No description provided for @powered_by_just_order.
  ///
  /// In en, this message translates to:
  /// **'Powered by Just Order © 2025.'**
  String get powered_by_just_order;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @last_update.
  ///
  /// In en, this message translates to:
  /// **'Last updated: January 24, 2025'**
  String get last_update;

  /// No description provided for @terms_conditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_conditions;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @terms_intro1.
  ///
  /// In en, this message translates to:
  /// **'These Terms and Conditions (\'Terms\') govern your use of the Just Order mobile application (the \'App\') and any related services provided by Just on Time (\'Just on Time,\' \'we,\' \'us,\' or \'our\').'**
  String get terms_intro1;

  /// No description provided for @terms_intro2.
  ///
  /// In en, this message translates to:
  /// **'-By accessing or using the App, you (\'user,\'\'you,\' or \'your\') agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.'**
  String get terms_intro2;

  /// No description provided for @use_of_the_app.
  ///
  /// In en, this message translates to:
  /// **'Use of the App'**
  String get use_of_the_app;

  /// No description provided for @account_creation_and_usage.
  ///
  /// In en, this message translates to:
  /// **'Account Creation and Usage'**
  String get account_creation_and_usage;

  /// No description provided for @ordering_and_delivery.
  ///
  /// In en, this message translates to:
  /// **'Ordering and Delivery'**
  String get ordering_and_delivery;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get payments;

  /// No description provided for @order_cancellations.
  ///
  /// In en, this message translates to:
  /// **'Order Cancellations'**
  String get order_cancellations;

  /// No description provided for @returns_and_refunds.
  ///
  /// In en, this message translates to:
  /// **'Returns and Refunds:'**
  String get returns_and_refunds;

  /// No description provided for @intellectual_property.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get intellectual_property;

  /// No description provided for @data_privacy_and_security.
  ///
  /// In en, this message translates to:
  /// **'Data Privacy and Security'**
  String get data_privacy_and_security;

  /// No description provided for @disclaimer_of_warranties.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer of Warranties'**
  String get disclaimer_of_warranties;

  /// No description provided for @limitation_of_liability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get limitation_of_liability;

  /// No description provided for @indemnification.
  ///
  /// In en, this message translates to:
  /// **'Indemnification'**
  String get indemnification;

  /// No description provided for @governing_law_and_jurisdiction.
  ///
  /// In en, this message translates to:
  /// **'Governing Law and Jurisdiction'**
  String get governing_law_and_jurisdiction;

  /// No description provided for @dispute_resolution.
  ///
  /// In en, this message translates to:
  /// **'Dispute Resolution'**
  String get dispute_resolution;

  /// No description provided for @severability.
  ///
  /// In en, this message translates to:
  /// **'Severability'**
  String get severability;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @changes_to_these_terms.
  ///
  /// In en, this message translates to:
  /// **'Changes to these Terms'**
  String get changes_to_these_terms;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @entire_agreement.
  ///
  /// In en, this message translates to:
  /// **'Entire Agreement'**
  String get entire_agreement;

  /// No description provided for @the_app_allows_you_to_browse_restaurants_and_their_menus.
  ///
  /// In en, this message translates to:
  /// **'The App allows you to browse restaurants and their menus.'**
  String get the_app_allows_you_to_browse_restaurants_and_their_menus;

  /// No description provided for @place_food_orders_from_participating_restaurants.
  ///
  /// In en, this message translates to:
  /// **'Place food orders from participating restaurants.'**
  String get place_food_orders_from_participating_restaurants;

  /// No description provided for @track_the_status_of_your_orders.
  ///
  /// In en, this message translates to:
  /// **'Track the status of your orders.'**
  String get track_the_status_of_your_orders;

  /// No description provided for @make_payments_for_your_orders_through_the_app.
  ///
  /// In en, this message translates to:
  /// **'Make payments for your orders through the App.'**
  String get make_payments_for_your_orders_through_the_app;

  /// No description provided for @communicate_with_restaurant_staff_and_delivery_drivers.
  ///
  /// In en, this message translates to:
  /// **'Communicate with restaurant staff and delivery drivers.'**
  String get communicate_with_restaurant_staff_and_delivery_drivers;

  /// No description provided for @access_and_utilize_other_features_and_functionalities_as_made_available_by_just_on_time_from_time_to_time.
  ///
  /// In en, this message translates to:
  /// **'Access and utilize other features and functionalities as made available by Just on Time from time to time.'**
  String
  get access_and_utilize_other_features_and_functionalities_as_made_available_by_just_on_time_from_time_to_time;

  /// No description provided for @you_are_responsible_for_maintaining_the_confidentiality_of_your_account_information_and_for_restricting_access_to_your_computer_or_device.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account information and for restricting access to your computer or device.'**
  String
  get you_are_responsible_for_maintaining_the_confidentiality_of_your_account_information_and_for_restricting_access_to_your_computer_or_device;

  /// No description provided for @you_agree_to_accept_responsibility_for_all_activities_that_occur_under_your_account_or_password.
  ///
  /// In en, this message translates to:
  /// **'You agree to accept responsibility for all activities that occur under your account or password.'**
  String
  get you_agree_to_accept_responsibility_for_all_activities_that_occur_under_your_account_or_password;

  /// No description provided for @you_agree_to_use_the_app_only_for_lawful_purposes_and_in_accordance_with_these_terms.
  ///
  /// In en, this message translates to:
  /// **'You agree to use the App only for lawful purposes and in accordance with these Terms.'**
  String
  get you_agree_to_use_the_app_only_for_lawful_purposes_and_in_accordance_with_these_terms;

  /// No description provided for @you_may_not_use_the_app_for_any_illegal_or_unauthorized_purpose.
  ///
  /// In en, this message translates to:
  /// **'You may not use the App for any illegal or unauthorized purpose.'**
  String get you_may_not_use_the_app_for_any_illegal_or_unauthorized_purpose;

  /// No description provided for @including_without_limitation.
  ///
  /// In en, this message translates to:
  /// **'including without limitation:'**
  String get including_without_limitation;

  /// No description provided for @you_may_not_transmit_any_viruses_or_other_harmful_computer_code.
  ///
  /// In en, this message translates to:
  /// **'You may not transmit any viruses or other harmful computer code.'**
  String get you_may_not_transmit_any_viruses_or_other_harmful_computer_code;

  /// No description provided for @you_may_not_interfere_with_or_disrupt_the_integrity_or_performance_of_the_app.
  ///
  /// In en, this message translates to:
  /// **'You may not interfere with or disrupt the integrity or performance of the App.'**
  String
  get you_may_not_interfere_with_or_disrupt_the_integrity_or_performance_of_the_app;

  /// No description provided for @you_may_not_impersonate_any_person_or_entity.
  ///
  /// In en, this message translates to:
  /// **'You may not impersonate any person or entity.'**
  String get you_may_not_impersonate_any_person_or_entity;

  /// No description provided for @you_may_not_collect_or_store_personal_data_about_other_users.
  ///
  /// In en, this message translates to:
  /// **'You may not collect or store personal data about other users.'**
  String get you_may_not_collect_or_store_personal_data_about_other_users;

  /// No description provided for @you_may_not_violate_any_applicable_laws_or_regulations.
  ///
  /// In en, this message translates to:
  /// **'You may not violate any applicable laws or regulations.'**
  String get you_may_not_violate_any_applicable_laws_or_regulations;

  /// No description provided for @you_may_not_engage_in_any_activity_that_is_fraudulent_deceptive_or_misleading.
  ///
  /// In en, this message translates to:
  /// **'You may not engage in any activity that is fraudulent, deceptive, or misleading.'**
  String
  get you_may_not_engage_in_any_activity_that_is_fraudulent_deceptive_or_misleading;

  /// No description provided for @you_may_not_use_any_automated_scripts_bots_or_other_means_to_access_or_interact_with_the_app_without_our_express_written_consent.
  ///
  /// In en, this message translates to:
  /// **'You may not use any automated scripts, bots, or other means to access or interact with the App without our express written consent.'**
  String
  get you_may_not_use_any_automated_scripts_bots_or_other_means_to_access_or_interact_with_the_app_without_our_express_written_consent;

  /// No description provided for @to_use_certain_features_of_the_app_you_may_be_required_to_create_a_user_account.
  ///
  /// In en, this message translates to:
  /// **'To use certain features of the App, you may be required to create a user account.'**
  String
  get to_use_certain_features_of_the_app_you_may_be_required_to_create_a_user_account;

  /// No description provided for @you_must_provide_accurate_and_complete_information_during_account_registration.
  ///
  /// In en, this message translates to:
  /// **'You must provide accurate and complete information during account registration.'**
  String
  get you_must_provide_accurate_and_complete_information_during_account_registration;

  /// No description provided for @you_are_responsible_for_updating_your_account_information_to_keep_it_accurate_and_current.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for updating your account information to keep it accurate and current.'**
  String
  get you_are_responsible_for_updating_your_account_information_to_keep_it_accurate_and_current;

  /// No description provided for @you_may_deactivate_or_delete_your_account_at_any_time_by_following_the_instructions_within_the_app_or_by_contacting_just_on_time_customer_support.
  ///
  /// In en, this message translates to:
  /// **'You may deactivate or delete your account at any time by following the instructions within the App or by contacting Just on Time customer support.'**
  String
  get you_may_deactivate_or_delete_your_account_at_any_time_by_following_the_instructions_within_the_app_or_by_contacting_just_on_time_customer_support;

  /// No description provided for @just_on_time_reserves_the_right_to_suspend_or_terminate_your_account_at_any_time_for_any_reason_including_but_not_limited_to_violation_of_these_terms_suspicious_activity_or_inactivity.
  ///
  /// In en, this message translates to:
  /// **'Just on Time reserves the right to suspend or terminate your account at any time for any reason, including but not limited to violation of these Terms, suspicious activity, or inactivity.'**
  String
  get just_on_time_reserves_the_right_to_suspend_or_terminate_your_account_at_any_time_for_any_reason_including_but_not_limited_to_violation_of_these_terms_suspicious_activity_or_inactivity;

  /// No description provided for @all_orders_placed_through_the_app_are_subject_to_availability_and_acceptance_by_the_restaurant.
  ///
  /// In en, this message translates to:
  /// **'All orders placed through the App are subject to availability and acceptance by the restaurant.'**
  String
  get all_orders_placed_through_the_app_are_subject_to_availability_and_acceptance_by_the_restaurant;

  /// No description provided for @delivery_times_are_estimates_only_and_may_vary_due_to_factors_such_as_traffic_weather_and_restaurant_order_volume.
  ///
  /// In en, this message translates to:
  /// **'Delivery times are estimates only and may vary depending on factors such as traffic, weather, and restaurant order volume.'**
  String
  get delivery_times_are_estimates_only_and_may_vary_due_to_factors_such_as_traffic_weather_and_restaurant_order_volume;

  /// No description provided for @just_on_time_is_not_responsible_for_any_delays_or_cancellations_caused_by_factors_beyond_our_reasonable_control.
  ///
  /// In en, this message translates to:
  /// **'Just on Time is not responsible for any delays or cancellations caused by factors beyond our reasonable control.'**
  String
  get just_on_time_is_not_responsible_for_any_delays_or_cancellations_caused_by_factors_beyond_our_reasonable_control;

  /// No description provided for @these_factors_include_restaurant_closures_or_delays_traffic_congestion_or_accidents_severe_weather_conditions_acts_of_god_power_outages_political_instability_pandemics_and_government_regulations_or_restrictions.
  ///
  /// In en, this message translates to:
  /// **'These factors include restaurant closures or delays, traffic congestion or accidents, severe weather conditions, acts of God, power outages, political instability, pandemics, and government regulations or restrictions.'**
  String
  get these_factors_include_restaurant_closures_or_delays_traffic_congestion_or_accidents_severe_weather_conditions_acts_of_god_power_outages_political_instability_pandemics_and_government_regulations_or_restrictions;

  /// No description provided for @you_are_responsible_for_providing_accurate_and_complete_delivery_information.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for providing accurate and complete delivery information.'**
  String
  get you_are_responsible_for_providing_accurate_and_complete_delivery_information;

  /// No description provided for @just_on_time_is_not_liable_for_any_incorrect_or_incomplete_delivery_information_provided_by_you.
  ///
  /// In en, this message translates to:
  /// **'Just on Time is not liable for any incorrect or incomplete delivery information provided by you.'**
  String
  get just_on_time_is_not_liable_for_any_incorrect_or_incomplete_delivery_information_provided_by_you;

  /// No description provided for @you_may_be_required_to_be_present_at_the_designated_delivery_address_to_receive_your_order.
  ///
  /// In en, this message translates to:
  /// **'You may be required to be present at the designated delivery address to receive your order.'**
  String
  get you_may_be_required_to_be_present_at_the_designated_delivery_address_to_receive_your_order;

  /// No description provided for @you_can_make_payments_for_your_orders_through_various_methods_offered_within_the_app_such_as_credit_card_debit_card_cash_on_delivery_cod_and_mobile_wallets.
  ///
  /// In en, this message translates to:
  /// **'You can make payments for your orders through various methods offered within the App, such as credit card, debit card, cash on delivery (COD), and mobile wallets.'**
  String
  get you_can_make_payments_for_your_orders_through_various_methods_offered_within_the_app_such_as_credit_card_debit_card_cash_on_delivery_cod_and_mobile_wallets;

  /// No description provided for @all_prices_displayed_within_the_app_are_in_egyptian_pounds_egp_and_include_applicable_taxes.
  ///
  /// In en, this message translates to:
  /// **'All prices displayed within the App are in Egyptian Pounds (EGP) and include applicable taxes.'**
  String
  get all_prices_displayed_within_the_app_are_in_egyptian_pounds_egp_and_include_applicable_taxes;

  /// No description provided for @you_are_responsible_for_ensuring_that_you_have_sufficient_funds_available_in_your_chosen_payment_method.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for ensuring that you have sufficient funds available in your chosen payment method.'**
  String
  get you_are_responsible_for_ensuring_that_you_have_sufficient_funds_available_in_your_chosen_payment_method;

  /// No description provided for @for_cod_orders_you_must_have_the_exact_amount_in_cash_ready_for_the_delivery_driver.
  ///
  /// In en, this message translates to:
  /// **'For COD orders, you must have the exact amount in cash ready for the delivery driver.'**
  String
  get for_cod_orders_you_must_have_the_exact_amount_in_cash_ready_for_the_delivery_driver;

  /// No description provided for @refunds_if_applicable_will_be_processed_to_the_original_payment_method_used_for_the_order.
  ///
  /// In en, this message translates to:
  /// **'Refunds, if applicable, will be processed to the original payment method used for the order.'**
  String
  get refunds_if_applicable_will_be_processed_to_the_original_payment_method_used_for_the_order;

  /// No description provided for @you_may_cancel_your_order_at_any_time_before_it_is_accepted_by_the_restaurant.
  ///
  /// In en, this message translates to:
  /// **'You may cancel your order at any time before it is accepted by the restaurant.'**
  String
  get you_may_cancel_your_order_at_any_time_before_it_is_accepted_by_the_restaurant;

  /// No description provided for @if_you_cancel_your_order_after_it_has_been_accepted_by_the_restaurant_you_may_be_subject_to_cancellation_fees_as_determined_by_the_restaurant.
  ///
  /// In en, this message translates to:
  /// **'If you cancel your order after it has been accepted by the restaurant, you may be subject to cancellation fees as determined by the restaurant.'**
  String
  get if_you_cancel_your_order_after_it_has_been_accepted_by_the_restaurant_you_may_be_subject_to_cancellation_fees_as_determined_by_the_restaurant;

  /// No description provided for @if_your_order_arrives_late_incorrect_or_damaged_please_contact_just_on_time_customer_support_immediately.
  ///
  /// In en, this message translates to:
  /// **' If your order arrives late, incorrect, or damaged, please contact Just on Time customer support immediately.'**
  String
  get if_your_order_arrives_late_incorrect_or_damaged_please_contact_just_on_time_customer_support_immediately;

  /// No description provided for @just_on_time_will_use_reasonable_efforts_to_resolve_any_order_issues.
  ///
  /// In en, this message translates to:
  /// **'Just on Time will use reasonable efforts to resolve any order issues.'**
  String
  get just_on_time_will_use_reasonable_efforts_to_resolve_any_order_issues;

  /// No description provided for @the_app_and_all_of_its_content_including_but_not_limited_to_text_graphics_logos_images_and_software_are_protected_by_copyright_trademark_and_other_intellectual_property_laws.
  ///
  /// In en, this message translates to:
  /// **'The App and all of its content, including but not limited to text, graphics, logos, images, and software, are protected by copyright, trademark, and other intellectual property laws.'**
  String
  get the_app_and_all_of_its_content_including_but_not_limited_to_text_graphics_logos_images_and_software_are_protected_by_copyright_trademark_and_other_intellectual_property_laws;

  /// No description provided for @you_may_not_use_reproduce_distribute_modify_or_create_derivative_works_of_any_of_the_apps_content_without_our_prior_written_consent.
  ///
  /// In en, this message translates to:
  /// **'You may not use, reproduce, distribute, modify, or create derivative works of any of the App\'s content without our prior written consent.'**
  String
  get you_may_not_use_reproduce_distribute_modify_or_create_derivative_works_of_any_of_the_apps_content_without_our_prior_written_consent;

  /// No description provided for @just_on_time_respects_the_intellectual_property_rights_of_others.
  ///
  /// In en, this message translates to:
  /// **'Just on Time respects the intellectual property rights of others.'**
  String get just_on_time_respects_the_intellectual_property_rights_of_others;

  /// No description provided for @if_you_believe_that_your_intellectual_property_rights_have_been_infringed_please_contact_us.
  ///
  /// In en, this message translates to:
  /// **'If you believe that your intellectual property rights have been infringed, please contact us.'**
  String
  get if_you_believe_that_your_intellectual_property_rights_have_been_infringed_please_contact_us;

  /// No description provided for @please_refer_to_our_separate_data_privacy_policy_for_information_on_how_we_collect_use_and_protect_your_personal_data.
  ///
  /// In en, this message translates to:
  /// **'Please refer to our separate Data Privacy Policy for information on how we collect, use, and protect your personal data.'**
  String
  get please_refer_to_our_separate_data_privacy_policy_for_information_on_how_we_collect_use_and_protect_your_personal_data;

  /// No description provided for @the_app_and_all_services_provided_by_just_on_time_are_provided_as_is_and_as_available_without_warranty_of_any_kind_express_or_implied.
  ///
  /// In en, this message translates to:
  /// **'The app and all services provided by Just on Time are provided \'as is\' and \'as available\' without warranty of any kind, express or implied.'**
  String
  get the_app_and_all_services_provided_by_just_on_time_are_provided_as_is_and_as_available_without_warranty_of_any_kind_express_or_implied;

  /// No description provided for @just_on_time_does_not_warrant_that_the_app_will_be_uninterrupted_or_error_free_that_defects_will_be_corrected_or_that_the_app_or_the_server_that_makes_it_available_are_free_of_viruses_or_other_harmful_components.
  ///
  /// In en, this message translates to:
  /// **'Just on Time does not warrant that the app will be uninterrupted or error-free, that defects will be corrected, or that the app or the server that makes it available are free of viruses or other harmful components.'**
  String
  get just_on_time_does_not_warrant_that_the_app_will_be_uninterrupted_or_error_free_that_defects_will_be_corrected_or_that_the_app_or_the_server_that_makes_it_available_are_free_of_viruses_or_other_harmful_components;

  /// No description provided for @just_on_time_disclaims_any_liability_for_the_services_provided_by_third_parties_including_but_not_limited_to_restaurants_and_delivery_drivers.
  ///
  /// In en, this message translates to:
  /// **'Just on Time disclaims any liability for the services provided by third parties, including but not limited to restaurants and delivery drivers.'**
  String
  get just_on_time_disclaims_any_liability_for_the_services_provided_by_third_parties_including_but_not_limited_to_restaurants_and_delivery_drivers;

  /// No description provided for @in_no_event_shall_just_on_time_be_liable_for_any_indirect_incidental_special_consequential_or_punitive_damages.
  ///
  /// In en, this message translates to:
  /// **'In no event shall Just on Time be liable for any indirect, incidental, special, consequential, or punitive damages.'**
  String
  get in_no_event_shall_just_on_time_be_liable_for_any_indirect_incidental_special_consequential_or_punitive_damages;

  /// No description provided for @this_includes_without_limitation_loss_of_profits_data_use_goodwill_or_other_intangible_losses_resulting_from_i_the_use_of_or_the_inability_to_use_the_app_ii_the_cost_of_procurement_of_substitute_goods_or_services_or_iii_unauthorized_access_to_or_alteration_of_your_transmissions_or_data.
  ///
  /// In en, this message translates to:
  /// **'This includes without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from (i) the use of or the inability to use the app, (ii) the cost of procurement of substitute goods or services, or (iii) unauthorized access to or alteration of your transmissions or data.'**
  String
  get this_includes_without_limitation_loss_of_profits_data_use_goodwill_or_other_intangible_losses_resulting_from_i_the_use_of_or_the_inability_to_use_the_app_ii_the_cost_of_procurement_of_substitute_goods_or_services_or_iii_unauthorized_access_to_or_alteration_of_your_transmissions_or_data;

  /// No description provided for @this_limitation_of_liability_shall_apply_to_the_fullest_extent_permitted_by_applicable_law.
  ///
  /// In en, this message translates to:
  /// **'This limitation of liability shall apply to the fullest extent permitted by applicable law.'**
  String
  get this_limitation_of_liability_shall_apply_to_the_fullest_extent_permitted_by_applicable_law;

  /// No description provided for @you_agree_to_indemnify_and_hold_harmless_just_on_time_and_its_affiliates_officers_directors_employees_agents_and_licensors_from_any_and_all_claims_losses_damages_liabilities_costs_and_expenses_arising_out_of_or_related_to_your_use_of_the_app_your_violation_of_these_terms_or_your_infringement_of_any_third_party_rights.
  ///
  /// In en, this message translates to:
  /// **'You agree to indemnify and hold harmless Just on Time and its affiliates, officers, directors, employees, agents, and licensors from any and all claims, losses, damages, liabilities, costs, and expenses arising out of or related to your use of the App, your violation of these Terms, or your infringement of any third-party rights.'**
  String
  get you_agree_to_indemnify_and_hold_harmless_just_on_time_and_its_affiliates_officers_directors_employees_agents_and_licensors_from_any_and_all_claims_losses_damages_liabilities_costs_and_expenses_arising_out_of_or_related_to_your_use_of_the_app_your_violation_of_these_terms_or_your_infringement_of_any_third_party_rights;

  /// No description provided for @these_terms_shall_be_governed_by_and_construed_in_accordance_with_the_laws_of_the_arab_republic_of_egypt_without_giving_effect_to_any_principles_of_conflicts_of_law.
  ///
  /// In en, this message translates to:
  /// **'These Terms shall be governed by and construed in accordance with the laws of the Arab Republic of Egypt, without giving effect to any principles of conflicts of law.'**
  String
  get these_terms_shall_be_governed_by_and_construed_in_accordance_with_the_laws_of_the_arab_republic_of_egypt_without_giving_effect_to_any_principles_of_conflicts_of_law;

  /// No description provided for @any_dispute_arising_out_of_or_relating_to_these_terms_shall_be_subject_to_the_exclusive_jurisdiction_of_the_courts_of_the_arab_republic_of_egypt.
  ///
  /// In en, this message translates to:
  /// **'Any dispute arising out of or relating to these Terms shall be subject to the exclusive jurisdiction of the courts of the Arab Republic of Egypt.'**
  String
  get any_dispute_arising_out_of_or_relating_to_these_terms_shall_be_subject_to_the_exclusive_jurisdiction_of_the_courts_of_the_arab_republic_of_egypt;

  /// No description provided for @before_initiating_any_legal_proceedings_the_parties_agree_to_attempt_to_resolve_any_dispute_through_good_faith_negotiations.
  ///
  /// In en, this message translates to:
  /// **'Before initiating any legal proceedings, the parties agree to attempt to resolve any dispute through good faith negotiations.'**
  String
  get before_initiating_any_legal_proceedings_the_parties_agree_to_attempt_to_resolve_any_dispute_through_good_faith_negotiations;

  /// No description provided for @if_the_parties_are_unable_to_resolve_the_dispute_through_negotiation_they_may_consider_alternative_dispute_resolution_methods_such_as_mediation_or_arbitration_before_resorting_to_litigation.
  ///
  /// In en, this message translates to:
  /// **'If the parties are unable to resolve the dispute through negotiation, they may consider alternative dispute resolution methods, such as mediation or arbitration, before resorting to litigation.'**
  String
  get if_the_parties_are_unable_to_resolve_the_dispute_through_negotiation_they_may_consider_alternative_dispute_resolution_methods_such_as_mediation_or_arbitration_before_resorting_to_litigation;

  /// No description provided for @if_any_provision_of_these_terms_is_held_to_be_invalid_or_unenforceable_such_provision_shall_be_struck_and_the_remaining_provisions_shall_be_enforced.
  ///
  /// In en, this message translates to:
  /// **'If any provision of these Terms is held to be invalid or unenforceable, such provision shall be struck and the remaining provisions shall be enforced.'**
  String
  get if_any_provision_of_these_terms_is_held_to_be_invalid_or_unenforceable_such_provision_shall_be_struck_and_the_remaining_provisions_shall_be_enforced;

  /// No description provided for @if_a_provision_is_found_to_be_invalid_the_parties_shall_negotiate_in_good_faith_to_replace_such_provision_with_a_valid_provision_that_comes_closest_to_reflecting_the_original_intention_of_the_parties.
  ///
  /// In en, this message translates to:
  /// **'If a provision is found to be invalid, the parties shall negotiate in good faith to replace such provision with a valid provision that comes closest to reflecting the original intention of the parties.'**
  String
  get if_a_provision_is_found_to_be_invalid_the_parties_shall_negotiate_in_good_faith_to_replace_such_provision_with_a_valid_provision_that_comes_closest_to_reflecting_the_original_intention_of_the_parties;

  /// No description provided for @just_on_time_is_committed_to_making_the_app_accessible_to_users_with_disabilities.
  ///
  /// In en, this message translates to:
  /// **'Just on Time is committed to making the App accessible to users with disabilities.'**
  String
  get just_on_time_is_committed_to_making_the_app_accessible_to_users_with_disabilities;

  /// No description provided for @we_are_continuously_working_to_improve_the_accessibility_of_the_app_for_all_users.
  ///
  /// In en, this message translates to:
  /// **'We are continuously working to improve the accessibility of the App for all users.'**
  String
  get we_are_continuously_working_to_improve_the_accessibility_of_the_app_for_all_users;

  /// No description provided for @just_on_time_may_update_these_terms_from_time_to_time.
  ///
  /// In en, this message translates to:
  /// **'Just on Time may update these Terms from time to time.'**
  String get just_on_time_may_update_these_terms_from_time_to_time;

  /// No description provided for @we_will_notify_you_of_any_changes_by_posting_the_revised_terms_on_the_app_and_or_by_sending_you_an_email_notification.
  ///
  /// In en, this message translates to:
  /// **'We will notify you of any changes by posting the revised Terms on the App and/or by sending you an email notification.'**
  String
  get we_will_notify_you_of_any_changes_by_posting_the_revised_terms_on_the_app_and_or_by_sending_you_an_email_notification;

  /// No description provided for @your_continued_use_of_the_app_after_the_effective_date_of_any_such_changes_constitutes_your_acceptance_of_the_revised_terms.
  ///
  /// In en, this message translates to:
  /// **'Your continued use of the App after the effective date of any such changes constitutes your acceptance of the revised Terms.'**
  String
  get your_continued_use_of_the_app_after_the_effective_date_of_any_such_changes_constitutes_your_acceptance_of_the_revised_terms;

  /// No description provided for @if_you_have_any_questions_about_these_terms_please_contact_us_at.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms Please contact us at:'**
  String get if_you_have_any_questions_about_these_terms_please_contact_us_at;

  /// No description provided for @entire_agreement_.
  ///
  /// In en, this message translates to:
  /// **'-These Terms constitute the entire agreement between you and Just on Time with respect to your use of the App and supersede all prior or contemporaneous communications, representations, and understandings, whether oral or written.'**
  String get entire_agreement_;

  /// No description provided for @about_language_.
  ///
  /// In en, this message translates to:
  /// **'-These Terms are available in English and [insert other languages, if applicable]. The English version shall prevail in case of any discrepancy between the English version and any translated version.'**
  String get about_language_;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Policy'**
  String get privacy_policy;

  /// No description provided for @information_we_collect.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get information_we_collect;

  /// No description provided for @we_may_collect_the_following_types_of_personal_data.
  ///
  /// In en, this message translates to:
  /// **'We may collect the following types of personal data:'**
  String get we_may_collect_the_following_types_of_personal_data;

  /// No description provided for @account_information.
  ///
  /// In en, this message translates to:
  /// **'Account Information:'**
  String get account_information;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email_address.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get email_address;

  /// No description provided for @date_of_birth.
  ///
  /// In en, this message translates to:
  /// **'Date of birth (optional)'**
  String get date_of_birth;

  /// No description provided for @delivery_addresses.
  ///
  /// In en, this message translates to:
  /// **'Delivery addresses'**
  String get delivery_addresses;

  /// No description provided for @payment_information.
  ///
  /// In en, this message translates to:
  /// **'Payment information (credit/debit card details, mobile wallet information)'**
  String get payment_information;

  /// No description provided for @order_information.
  ///
  /// In en, this message translates to:
  /// **'Order Information:'**
  String get order_information;

  /// No description provided for @order_details.
  ///
  /// In en, this message translates to:
  /// **'Order details (items ordered, delivery instructions, special requests)'**
  String get order_details;

  /// No description provided for @location_data.
  ///
  /// In en, this message translates to:
  /// **'Location Data:'**
  String get location_data;

  /// No description provided for @approximate_location.
  ///
  /// In en, this message translates to:
  /// **'Approximate location (for delivery purposes)'**
  String get approximate_location;

  /// No description provided for @gps_location.
  ///
  /// In en, this message translates to:
  /// **'GPS location (if enabled by you)'**
  String get gps_location;

  /// No description provided for @usage_data.
  ///
  /// In en, this message translates to:
  /// **'Usage Data:'**
  String get usage_data;

  /// No description provided for @app_interactions.
  ///
  /// In en, this message translates to:
  /// **'Information about your interactions with the App (e.g., browsing history, search queries, time spent in the app)'**
  String get app_interactions;

  /// No description provided for @device_information.
  ///
  /// In en, this message translates to:
  /// **'Device Information:'**
  String get device_information;

  /// No description provided for @device_type_and_os.
  ///
  /// In en, this message translates to:
  /// **'Device type and operating system'**
  String get device_type_and_os;

  /// No description provided for @unique_device_identifiers.
  ///
  /// In en, this message translates to:
  /// **'Unique device identifiers (e.g., device ID, advertising ID)'**
  String get unique_device_identifiers;

  /// No description provided for @contact_information.
  ///
  /// In en, this message translates to:
  /// **'Contact Information:'**
  String get contact_information;

  /// No description provided for @contact_us_details.
  ///
  /// In en, this message translates to:
  /// **'If you choose to contact us, we may collect your name, phone number, email address, and the content of your communication.'**
  String get contact_us_details;

  /// No description provided for @how_we_collect_information.
  ///
  /// In en, this message translates to:
  /// **'How We Collect Information'**
  String get how_we_collect_information;

  /// No description provided for @how_we_use_your_information.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get how_we_use_your_information;

  /// No description provided for @data_sharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get data_sharing;

  /// No description provided for @data_security.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get data_security;

  /// No description provided for @your_rights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get your_rights;

  /// No description provided for @children_privacy.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get children_privacy;

  /// No description provided for @cross_border_data_transfers.
  ///
  /// In en, this message translates to:
  /// **'Cross-Border Data Transfers'**
  String get cross_border_data_transfers;

  /// No description provided for @changes_to_this_policy.
  ///
  /// In en, this message translates to:
  /// **'Changes to this Policy'**
  String get changes_to_this_policy;

  /// No description provided for @we_collect_information_through_the_following_methods.
  ///
  /// In en, this message translates to:
  /// **'We collect information through the following methods:'**
  String get we_collect_information_through_the_following_methods;

  /// No description provided for @directly_from_you.
  ///
  /// In en, this message translates to:
  /// **'Directly from you: When you create an account, place an order, contact customer support, or otherwise interact with us.'**
  String get directly_from_you;

  /// No description provided for @automatically.
  ///
  /// In en, this message translates to:
  /// **'Automatically: When you use the App, we may automatically collect information about your device and how you interact with the App through technologies such as cookies, pixels, and log files.'**
  String get automatically;

  /// No description provided for @we_use_your_personal_data_for_the_following_purposes.
  ///
  /// In en, this message translates to:
  /// **'We use your personal data for the following purposes:'**
  String get we_use_your_personal_data_for_the_following_purposes;

  /// No description provided for @providing_and_improving_our_services.
  ///
  /// In en, this message translates to:
  /// **'Providing and improving our services:'**
  String get providing_and_improving_our_services;

  /// No description provided for @processing_orders.
  ///
  /// In en, this message translates to:
  /// **'Processing orders'**
  String get processing_orders;

  /// No description provided for @delivering_orders.
  ///
  /// In en, this message translates to:
  /// **'Delivering orders'**
  String get delivering_orders;

  /// No description provided for @communicating_with_you_about_your_orders.
  ///
  /// In en, this message translates to:
  /// **'Communicating with you about your orders (order confirmations, delivery updates, etc.)'**
  String get communicating_with_you_about_your_orders;

  /// No description provided for @improving_functionality_and_user_experience.
  ///
  /// In en, this message translates to:
  /// **'Improving the functionality and user experience of the App'**
  String get improving_functionality_and_user_experience;

  /// No description provided for @personalizing_your_experience.
  ///
  /// In en, this message translates to:
  /// **'Personalizing your experience (e.g., recommending restaurants and dishes based on your preferences)'**
  String get personalizing_your_experience;

  /// No description provided for @marketing_and_communication.
  ///
  /// In en, this message translates to:
  /// **'Marketing and communication:'**
  String get marketing_and_communication;

  /// No description provided for @sending_promotional_emails_and_notifications.
  ///
  /// In en, this message translates to:
  /// **'Sending you promotional emails and notifications (with your consent)'**
  String get sending_promotional_emails_and_notifications;

  /// No description provided for @providing_personalized_offers_and_promotions.
  ///
  /// In en, this message translates to:
  /// **'Providing personalized offers and promotions'**
  String get providing_personalized_offers_and_promotions;

  /// No description provided for @customer_support.
  ///
  /// In en, this message translates to:
  /// **'Customer support:'**
  String get customer_support;

  /// No description provided for @responding_to_inquiries_and_resolving_issues.
  ///
  /// In en, this message translates to:
  /// **'Responding to your inquiries and resolving issues'**
  String get responding_to_inquiries_and_resolving_issues;

  /// No description provided for @fraud_prevention_and_security.
  ///
  /// In en, this message translates to:
  /// **'Fraud prevention and security:'**
  String get fraud_prevention_and_security;

  /// No description provided for @detecting_and_preventing_fraudulent_activities.
  ///
  /// In en, this message translates to:
  /// **'Detecting and preventing fraudulent activities'**
  String get detecting_and_preventing_fraudulent_activities;

  /// No description provided for @ensuring_security_and_integrity_of_services.
  ///
  /// In en, this message translates to:
  /// **'Ensuring the security and integrity of our services'**
  String get ensuring_security_and_integrity_of_services;

  /// No description provided for @compliance_with_legal_obligations.
  ///
  /// In en, this message translates to:
  /// **'Compliance with legal obligations:'**
  String get compliance_with_legal_obligations;

  /// No description provided for @complying_with_applicable_laws.
  ///
  /// In en, this message translates to:
  /// **'Complying with applicable laws, regulations, and legal requests.'**
  String get complying_with_applicable_laws;

  /// No description provided for @we_may_share_your_personal_data_with_third_parties.
  ///
  /// In en, this message translates to:
  /// **'We may share your personal data with the following third parties:'**
  String get we_may_share_your_personal_data_with_third_parties;

  /// No description provided for @restaurants_to_fulfill_orders.
  ///
  /// In en, this message translates to:
  /// **'Restaurants: To fulfill your orders.'**
  String get restaurants_to_fulfill_orders;

  /// No description provided for @delivery_partners_to_deliver_orders.
  ///
  /// In en, this message translates to:
  /// **'Delivery partners: To deliver your orders.'**
  String get delivery_partners_to_deliver_orders;

  /// No description provided for @payment_processors_to_process_payments.
  ///
  /// In en, this message translates to:
  /// **'Payment processors: To process payments for your orders.'**
  String get payment_processors_to_process_payments;

  /// No description provided for @service_providers_to_assist_with_operations.
  ///
  /// In en, this message translates to:
  /// **'Service providers: To assist us with our business operations (e.g., customer support, marketing, analytics).'**
  String get service_providers_to_assist_with_operations;

  /// No description provided for @law_enforcement_and_regulatory_authorities.
  ///
  /// In en, this message translates to:
  /// **'Law enforcement and regulatory authorities: To comply with legal obligations.'**
  String get law_enforcement_and_regulatory_authorities;

  /// No description provided for @we_will_not_sell_or_rent_your_personal_data.
  ///
  /// In en, this message translates to:
  /// **'We will not sell or rent your personal data to third parties for marketing purposes without your explicit consent.'**
  String get we_will_not_sell_or_rent_your_personal_data;

  /// No description provided for @we_take_reasonable_measures_to_protect_data.
  ///
  /// In en, this message translates to:
  /// **'We take reasonable measures to protect your personal data from unauthorized access, use, disclosure, alteration, or destruction.'**
  String get we_take_reasonable_measures_to_protect_data;

  /// No description provided for @method_of_transmission_is_not_completely_secure.
  ///
  /// In en, this message translates to:
  /// **'However, no method of transmission over the internet or method of electronic storage is completely secure.'**
  String get method_of_transmission_is_not_completely_secure;

  /// No description provided for @security_measures_to_protect_data.
  ///
  /// In en, this message translates to:
  /// **'We employ a variety of security measures to protect your personal data, including:'**
  String get security_measures_to_protect_data;

  /// No description provided for @encryption_to_protect_sensitive_data.
  ///
  /// In en, this message translates to:
  /// **'Encryption: We use encryption technologies to protect sensitive data, such as payment information.'**
  String get encryption_to_protect_sensitive_data;

  /// No description provided for @access_controls_limited_to_authorized_personnel.
  ///
  /// In en, this message translates to:
  /// **'Access controls: We limit access to your personal data to authorized personnel on a need-to-know basis.'**
  String get access_controls_limited_to_authorized_personnel;

  /// No description provided for @regular_security_reviews.
  ///
  /// In en, this message translates to:
  /// **'Regular security reviews: We regularly review and update our security measures to address evolving threats.'**
  String get regular_security_reviews;

  /// No description provided for @under_egyptian_personal_data_protection_law.
  ///
  /// In en, this message translates to:
  /// **'Under the Egyptian Personal Data Protection Law (Law No. 155 of 2020), you have the following rights:'**
  String get under_egyptian_personal_data_protection_law;

  /// No description provided for @access_right.
  ///
  /// In en, this message translates to:
  /// **'Access: You have the right to request access to your personal data.'**
  String get access_right;

  /// No description provided for @rectification_right.
  ///
  /// In en, this message translates to:
  /// **'Rectification: You have the right to request the rectification of inaccurate or incomplete personal data.'**
  String get rectification_right;

  /// No description provided for @erasure_right.
  ///
  /// In en, this message translates to:
  /// **'Erasure: You have the right to request the erasure of your personal data under certain circumstances.'**
  String get erasure_right;

  /// No description provided for @restriction_of_processing_right.
  ///
  /// In en, this message translates to:
  /// **'Restriction of processing: You have the right to request the restriction of processing of your personal data under certain circumstances.'**
  String get restriction_of_processing_right;

  /// No description provided for @data_portability_right.
  ///
  /// In en, this message translates to:
  /// **'Data portability: You have the right to receive your personal data in a structured, commonly used, and machine-readable format and to transmit that data to another controller.'**
  String get data_portability_right;

  /// No description provided for @objection_right.
  ///
  /// In en, this message translates to:
  /// **'Objection: You have the right to object to the processing of your personal data under certain circumstances.'**
  String get objection_right;

  /// No description provided for @exercise_your_rights.
  ///
  /// In en, this message translates to:
  /// **'To exercise your rights, please contact us at [Email address].'**
  String get exercise_your_rights;

  /// No description provided for @app_not_intended_for_children_under_16.
  ///
  /// In en, this message translates to:
  /// **'The App is not intended for use by children under the age of 16.'**
  String get app_not_intended_for_children_under_16;

  /// No description provided for @no_personal_data_from_children_under_16.
  ///
  /// In en, this message translates to:
  /// **'We do not knowingly collect personal data from children under the age of 16.'**
  String get no_personal_data_from_children_under_16;

  /// No description provided for @personal_data_transfer_outside_egypt.
  ///
  /// In en, this message translates to:
  /// **'Your personal data may be transferred to and processed in countries outside of Egypt.'**
  String get personal_data_transfer_outside_egypt;

  /// No description provided for @appropriate_measures_for_data_protection.
  ///
  /// In en, this message translates to:
  /// **'We will take appropriate measures to ensure that your personal data is protected in accordance with applicable data protection laws.'**
  String get appropriate_measures_for_data_protection;

  /// No description provided for @we_may_update_this_data_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'We may update this Data Privacy Policy from time to time.'**
  String get we_may_update_this_data_privacy_policy;

  /// No description provided for @we_will_notify_you_of_changes.
  ///
  /// In en, this message translates to:
  /// **'We will notify you of any changes by posting the revised policy on the App and/or by sending you an email notification.'**
  String get we_will_notify_you_of_changes;

  /// No description provided for @contact_us_for_questions.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Data Privacy Policy, please contact us at: justorder@justorder-eg.com.'**
  String get contact_us_for_questions;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @report_issue.
  ///
  /// In en, this message translates to:
  /// **'Report Issue'**
  String get report_issue;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @using_the_app.
  ///
  /// In en, this message translates to:
  /// **'Using the App'**
  String get using_the_app;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @customer_service.
  ///
  /// In en, this message translates to:
  /// **'Customer Service'**
  String get customer_service;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @issue_type.
  ///
  /// In en, this message translates to:
  /// **'Issue Typeٍ'**
  String get issue_type;

  /// No description provided for @ordering_issue.
  ///
  /// In en, this message translates to:
  /// **'Ordering Issue'**
  String get ordering_issue;

  /// No description provided for @order_id.
  ///
  /// In en, this message translates to:
  /// **'Order Id'**
  String get order_id;

  /// No description provided for @enter_order_id.
  ///
  /// In en, this message translates to:
  /// **'Enter Order Id'**
  String get enter_order_id;

  /// No description provided for @payment_issue.
  ///
  /// In en, this message translates to:
  /// **'Payment Issue'**
  String get payment_issue;

  /// No description provided for @app_bug_technical_problem.
  ///
  /// In en, this message translates to:
  /// **'App bug technical problem'**
  String get app_bug_technical_problem;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @issue_description.
  ///
  /// In en, this message translates to:
  /// **'Issue Description'**
  String get issue_description;

  /// No description provided for @please_describe_the_issue_in_detail.
  ///
  /// In en, this message translates to:
  /// **'Please describe the issue in detail...'**
  String get please_describe_the_issue_in_detail;

  /// No description provided for @attach_screenshot_or_Photo.
  ///
  /// In en, this message translates to:
  /// **'Attach Screenshot or Photo'**
  String get attach_screenshot_or_Photo;

  /// No description provided for @max_file_size_5MB.
  ///
  /// In en, this message translates to:
  /// **'Max file size: 5MB'**
  String get max_file_size_5MB;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
