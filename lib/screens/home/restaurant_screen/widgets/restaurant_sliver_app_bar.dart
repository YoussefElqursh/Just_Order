import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/theme/colors.dart';
import 'package:just_order/models/restaurant_model.dart';

/// The pinned, collapsing header for [RestaurantScreen].
///
/// Shows a large hero image + full restaurant info block when expanded,
/// and collapses down to a small avatar + name row once the user scrolls
/// past [collapseThreshold].
class RestaurantSliverAppBar extends StatefulWidget {
  final Restaurant restaurant;
  final ThemeState state;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  /// The expanded, scrollable content shown below the image when the bar
  /// is not collapsed (name, rating, delivery info, etc).
  final Widget infoSection;

  const RestaurantSliverAppBar({
    super.key,
    required this.restaurant,
    required this.state,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.infoSection,
  });

  @override
  State<RestaurantSliverAppBar> createState() => _RestaurantSliverAppBarState();
}

class _RestaurantSliverAppBarState extends State<RestaurantSliverAppBar> {
  static const double collapseThreshold = kToolbarHeight + 40;

  bool _isCollapsed = false;

  bool get _isLight => widget.state.themeMode == ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 405,
      pinned: true,
      backgroundColor: _isLight ? Colors.white : Colors.black,
      leading: _BackButton(isLight: _isLight),
      actions: [
        _FavoriteButton(
          isFavorite: widget.isFavorite,
          isLight: _isLight,
          onPressed: widget.onToggleFavorite,
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final collapsed = constraints.biggest.height <= collapseThreshold;
          if (collapsed != _isCollapsed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _isCollapsed = collapsed);
            });
          }

          return FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 8),
            title: _isCollapsed
                ? _CollapsedTitle(restaurant: widget.restaurant, isLight: _isLight)
                : null,
            background: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroImage(imageUrl: widget.restaurant.imageUrl, isLight: _isLight),
                const SizedBox(height: 20),
                widget.infoSection,
              ],
            ),
          );
        },
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final bool isLight;

  const _BackButton({required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        width: 34,
        height: 34,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: isLight ? Colors.transparent : Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: isLight ? Colors.black : Colors.white,
            size: 18,
          ),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final bool isLight;
  final VoidCallback onPressed;

  const _FavoriteButton({
    required this.isFavorite,
    required this.isLight,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: 34,
        height: 34,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: isLight ? const Color(0xFFF4F4F4) : Colors.white24,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? const Color(0xFFE02C45) : (isLight ? Colors.black : Colors.white),
            size: 18,
          ),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
      ),
    );
  }
}

class _CollapsedTitle extends StatelessWidget {
  final Restaurant restaurant;
  final bool isLight;

  const _CollapsedTitle({required this.restaurant, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: isLight ? Colors.white : Colors.white24,
          child: CachedNetworkImage(
            imageUrl: restaurant.imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator(color: AppColor.primaryColor)),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error, color: AppColor.primaryColor),
            memCacheWidth:
                (MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio)
                    .round(),
          ),
        ),
        Text(
          restaurant.name,
          style: TextStyle(
            color: isLight ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  final String? imageUrl;
  final bool isLight;

  const _HeroImage({required this.imageUrl, required this.isLight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 250,
      margin: const EdgeInsets.only(top: 30.0),
      decoration: ShapeDecoration(
        color: isLight ? Colors.white : Colors.black,
        shape: Border(
          bottom: BorderSide(
            color: isLight ? const Color(0xFFE5E5E5) : Colors.white12,
            width: 1,
          ),
        ),
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.contain,
        width: double.infinity,
        height: 250,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator(color: AppColor.primaryColor)),
        errorWidget: (context, url, error) =>
            const Icon(Icons.error, color: AppColor.primaryColor),
        memCacheWidth:
            (MediaQuery.of(context).size.width * MediaQuery.of(context).devicePixelRatio).round(),
      ),
    );
  }
}
