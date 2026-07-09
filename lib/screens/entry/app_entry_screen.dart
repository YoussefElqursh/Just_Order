import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/localization/language_cubit.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/storage/storage_service.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/screens/QR/select_your_place_screen.dart';
import 'package:just_order/screens/entry/widgets/action_tile_widget.dart';
import 'package:just_order/screens/login/login_screen.dart';
import 'package:just_order/shared/function/functions.dart';

class AppEntryScreen extends StatefulWidget {
  const AppEntryScreen({super.key});

  static const String routeName = 'AppEntryScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const AppEntryScreen(),
    );
  }

  @override
  State<AppEntryScreen> createState() => _AppEntryScreenState();
}

class _AppEntryScreenState extends State<AppEntryScreen> {
  final LoginRepository _loginRepository = LoginRepository();

  Future<User?> _getStoredUser() async {
    final prefs = StorageService.instance;
    final userString = prefs.getString('user');
    if (userString == null) return null;
    return User.fromJson(jsonDecode(userString));
  }

  Future<void> _continueToPlaceSelection() async {
    final prefs = StorageService.instance;
    final tableCode = prefs.getString('code');
    final timestamp = prefs.getInt('timestamp');
    final isValidTable =
        tableCode != null &&
        tableCode.isNotEmpty &&
        timestamp != null &&
        timestamp == DateTime.now().day;

    if (!mounted) return;
    navigateToWithoutBack(
      context,
      isValidTable ? MainLayout() : const SelectYourPlace(),
    );
  }

  Future<void> _logout() async {
    await _loginRepository.logout();
    if (!mounted) return;
    navigateToWithoutBack(context, const LoginScreen());
  }

  Future<void> _openLanguagePicker() async {
    final isArabic = context.read<LanguageCubit>().state.languageCode == 'ar';
    final theme = Theme.of(context);

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('English'),
                  trailing: isArabic
                      ? null
                      : const Icon(
                          Icons.check_circle,
                          color: Color(0xFFE02C45),
                        ),
                  onTap: () async {
                    await context.read<LanguageCubit>().switchToEnglish();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('العربية'),
                  trailing: isArabic
                      ? const Icon(Icons.check_circle, color: Color(0xFFE02C45))
                      : null,
                  onTap: () async {
                    await context.read<LanguageCubit>().switchToArabic();
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _onWillPop() async {
    final shouldExit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color(0xFFE02C45),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            child: const Text(
              'Exit',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return FutureBuilder<User?>(
          future: _getStoredUser(),
          builder: (context, snapshot) {
            final user = snapshot.data;
            final isLoggedIn = user != null;
            final isDark = themeState.themeMode == ThemeMode.dark;

            return PopScope(
              canPop: false,
              onPopInvoked: (didPop) async {
                if (!didPop) {
                  final shouldExit = await _onWillPop();
                  if (shouldExit && context.mounted) {
                    SystemNavigator.pop();
                  }
                }
              },
              child: Scaffold(
                backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.welcome} 👋',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : Colors.black,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isLoggedIn
                                      ? 'Continue to your table'
                                      : AppLocalizations.of(
                                          context,
                                        )!.sign_in_to_your_account,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            FilledButton.tonalIcon(
                              onPressed: _logout,
                              icon: const Icon(Icons.logout),
                              label: const Text('Logout'),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.errorContainer,
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Card(
                          elevation: 0,
                          color: isDark
                              ? const Color(0xFF1B1B1B)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white12
                                  : const Color(0xFFE7E7E7),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: const Color(0xFFE02C45),
                                  child: Text(
                                    isLoggedIn
                                        ? (user.firstName.isNotEmpty
                                              ? user.firstName[0].toUpperCase()
                                              : '?')
                                        : '?',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isLoggedIn
                                            ? '${user.firstName} ${user.lastName}'
                                                  .trim()
                                            : 'Guest',
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isLoggedIn
                                            ? user.email
                                            : 'Please login to continue',
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        ActionTile(
                          title: AppLocalizations.of(context)!.theme_mode,
                          subtitle: isDark ? 'Dark' : 'Light',
                          icon: Icons.dark_mode_outlined,
                          onTap: () => context.read<ThemeCubit>().toggleTheme(),
                        ),
                        const SizedBox(height: 12),
                        ActionTile(
                          title: AppLocalizations.of(context)!.language,
                          subtitle:
                              context
                                      .watch<LanguageCubit>()
                                      .state
                                      .languageCode ==
                                  'ar'
                              ? 'العربية'
                              : 'English',
                          icon: Icons.translate_outlined,
                          onTap: _openLanguagePicker,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: _continueToPlaceSelection,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFE02C45),
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: const Color(0xFFE02C45).withOpacity(0.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Continue to Table Selection',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 20),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
