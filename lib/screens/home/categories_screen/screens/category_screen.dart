import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/layouts/main_layout.dart';
import 'package:just_order/repository/category_repository.dart';
import 'package:just_order/screens/home/categories_screen/logic/category_cubit.dart';
import 'package:just_order/screens/home/categories_screen/screens/widget/category_widget.dart';
import 'package:just_order/core/theme/colors.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  static const String routeName = 'CategoryScreenRoute';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (_) => CategoryCubit(CategoryRepository())..fetchCategories(),
        child: const CategoryScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final themeState = themeCubit.state;

    PreferredSize searchBar() {
      return PreferredSize(
        preferredSize: Size(MediaQuery.sizeOf(context).width, 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 5),
          child: SizedBox(
            height: 38,
            child: TextField(
              onChanged: (query) =>
                  context.read<CategoryCubit>().searchCategory(query),
              decoration: InputDecoration(
                hintText: "Search categories...",
                hintStyle: const TextStyle(fontSize: 13),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: themeState.themeMode == ThemeMode.light
                    ? Colors.grey[200]
                    : Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Categories",
          style: TextStyle(
            color: themeState.themeMode == ThemeMode.light
                ? Colors.black
                : Colors.white,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainLayout(pageNumber: 0),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
            ),
          ),
        ),
        bottom: searchBar(),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.primaryColor),
            );
          } else if (state is CategoryLoaded) {
            if (state.categories.isEmpty) {
              return const Center(child: Text("No categories found."));
            }
            return GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                childAspectRatio: 0.95,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index]!;
                return buildCategoryWidget(category, themeState, context);
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text("Error: ${state.message}"));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}