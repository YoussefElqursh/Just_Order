import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/shared/widget/shimmer_widget.dart';

class RestaurantShimmer extends StatelessWidget {
  const RestaurantShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeCubit>().state;
    final isLight = themeState.themeMode == ThemeMode.light;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header shimmer
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  margin: const EdgeInsets.only(top: 30.0),
                  color: isLight ? Colors.white : Colors.black,
                  child: const ShimmerLoading.rectangular(height: 250),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 50.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerLoading.rectangular(
                          width: 34,
                          height: 34,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const Spacer(),
                        ShimmerLoading.rectangular(
                          width: 34,
                          height: 34,
                          shapeBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Restaurant info shimmer
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ShimmerLoading.rectangular(
                          height: 24,
                          width: 150,
                        ),
                      ),
                      ShimmerLoading.rectangular(
                        height: 16,
                        width: 80,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ShimmerLoading.rectangular(
                    height: 16,
                    width: 200,
                  ),
                  SizedBox(height: 16),
                  ShimmerLoading.rectangular(
                    height: 40,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            // Tab bar shimmer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    5,
                    (index) => const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: ShimmerLoading.rectangular(
                        height: 30,
                        width: 80,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Tab content shimmer
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoading.rectangular(
                        height: 120,
                        width: double.infinity,
                      ),
                      SizedBox(height: 8),
                      ShimmerLoading.rectangular(
                        height: 16,
                        width: 100,
                      ),
                      SizedBox(height: 4),
                      ShimmerLoading.rectangular(
                        height: 14,
                        width: 60,
                      ),
                      SizedBox(height: 8),
                      ShimmerLoading.rectangular(
                        height: 16,
                        width: 80,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Cart button shimmer
      floatingActionButton: const ShimmerLoading.circular(
        width: 56,
        height: 56,
      ),
    );
  }
}
