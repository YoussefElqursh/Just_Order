import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/category_cubit/category_cubit.dart';
import 'package:just_order/blocs/category_cubit/category_state.dart';
import 'package:just_order/blocs/restaurant_cubit/restaurant_detail_cubit.dart';
import 'package:just_order/blocs/restaurant_cubit/restaurant_detail_state.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/models/cart_item_model.dart';
import 'package:just_order/models/restaurant_model.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/cart_provider.dart';
import 'package:just_order/repository/category_repository.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/cart_fab_button.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/rating_dialog.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/restaurant_info_section.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/restaurant_sliver_app_bar.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/restaurant_tab_bar.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/keep_alive_widget.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/filter_widget.dart';
import 'package:just_order/screens/home/restaurant_screen/widgets/restaurant_shimmer_widget.dart';

class RestaurantScreenArguments {
  final Restaurant restaurant;
  final User user;

  RestaurantScreenArguments({required this.restaurant, required this.user});
}

class RestaurantScreen extends StatelessWidget {
  final Restaurant restaurant;
  final User user;

  const RestaurantScreen({super.key, required this.restaurant, required this.user});

  static const String routeName = 'RestaurantScreenRoute';

  static Route route(Restaurant restaurant, User user) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => RestaurantScreen(restaurant: restaurant, user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => RestaurantDetailCubit(restaurant: restaurant, user: user)..initialize(),
        ),
        BlocProvider(
          create: (_) =>
              CategoryCubit(CategoryRepository())..fetchCategoriesByIds(restaurant.categoriesId),
        ),
      ],
      child: _RestaurantScreenBody(restaurant: restaurant),
    );
  }
}

class _RestaurantScreenBody extends StatefulWidget {
  final Restaurant restaurant;

  const _RestaurantScreenBody({required this.restaurant});

  @override
  State<_RestaurantScreenBody> createState() => _RestaurantScreenBodyState();
}

class _RestaurantScreenBodyState extends State<_RestaurantScreenBody>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List<String> _buildFilters(CategoryState categoryState) {
    List<String> filters = const ['Trending', 'Discounts', 'Up to 40% off'];
    categoryState.when(
      initial: () {},
      loading: () {},
      error: (_) {},
      addedSuccessfully: () {},
      success: (categories) {
        filters = [
          'Trending',
          'Discounts',
          'Up to 40% off',
          ...categories
              .where((category) => category?.categoryName != null)
              .map((category) => category!.categoryName),
        ];
      },
    );
    return filters;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final cartProvider = context.watch<CartProvider>();
    final filteredCartItems = cartProvider.items
        .where((item) => item.cartItemId.endsWith('_${widget.restaurant.restaurantId}'))
        .toList();

    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<RestaurantDetailCubit, RestaurantDetailState>(
          builder: (context, detailState) {
            if (detailState.isLoading) {
              return const RestaurantShimmer();
            }

            return BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
                final filters = _buildFilters(categoryState);
                return _RestaurantScaffold(
                  restaurant: widget.restaurant,
                  themeState: themeState,
                  detailState: detailState,
                  filters: filters,
                  filteredCartItems: filteredCartItems,
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Pure layout: tab controller, sliver app bar, tab bar, tab views and FAB.
class _RestaurantScaffold extends StatelessWidget {
  final Restaurant restaurant;
  final ThemeState themeState;
  final RestaurantDetailState detailState;
  final List<String> filters;
  final List<CartItem> filteredCartItems;

  const _RestaurantScaffold({
    required this.restaurant,
    required this.themeState,
    required this.detailState,
    required this.filters,
    required this.filteredCartItems,
  });

  void _handleRatingTap(BuildContext context) {
    final cubit = context.read<RestaurantDetailCubit>();
    showRatingDialog(
      context: context,
      restaurantName: restaurant.name,
      initialRating: detailState.rating,
      state: themeState,
      onSubmit: cubit.submitRating,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RestaurantDetailCubit>();

    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) await cubit.removeRestaurantFromPrefs();
      },
      child: DefaultTabController(
        length: filters.length,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                RestaurantSliverAppBar(
                  restaurant: restaurant,
                  state: themeState,
                  isFavorite: detailState.isFavorite,
                  onToggleFavorite: cubit.toggleFavorite,
                  infoSection: RestaurantInfoSection(
                    restaurant: restaurant,
                    state: themeState,
                    rating: detailState.rating,
                    ratingCount: detailState.ratingCount,
                    onRatingTap: () => _handleRatingTap(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      RestaurantTabBar(filters: filters, state: themeState),
                    ],
                  ),
                ),
              ];
            },
            body: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
                for (final category in filters)
                  KeepAliveWidget(
                    child: FilterWidget(
                      key: ValueKey(category),
                      items: detailState.itemsFor(category),
                      filters: category,
                      state: themeState,
                      restaurant: restaurant,
                    ),
                  ),
              ],
            ),
          ),
          floatingActionButton: CartFabButton(itemCount: filteredCartItems.length),
        ),
      ),
    );
  }
}
