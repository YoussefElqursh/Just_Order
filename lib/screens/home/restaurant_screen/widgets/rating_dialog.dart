import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/localization_i18n_arb/app_localizations.dart';

/// Shows a 5-star rating dialog for [restaurantName] and returns the
/// chosen rating via [onSubmit]. The dialog owns its own transient
/// "which star is tapped" state; it does not know about persistence.
Future<void> showRatingDialog({
  required BuildContext context,
  required String restaurantName,
  required double initialRating,
  required ThemeState state,
  required ValueChanged<double> onSubmit,
}) {
  return showDialog(
    context: context,
    builder: (context) => RatingDialog(
      restaurantName: restaurantName,
      initialRating: initialRating,
      state: state,
      onSubmit: onSubmit,
    ),
  );
}

class RatingDialog extends StatefulWidget {
  final String restaurantName;
  final double initialRating;
  final ThemeState state;
  final ValueChanged<double> onSubmit;

  const RatingDialog({
    super.key,
    required this.restaurantName,
    required this.initialRating,
    required this.state,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  late double _tempRating = widget.initialRating;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.state.themeMode == ThemeMode.light ? Colors.white : Colors.black,
      title: Text('Rate ${widget.restaurantName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('How would you rate your experience?'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => setState(() => _tempRating = index + 1.0),
                child: Icon(
                  index < _tempRating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 30,
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            '${_tempRating.toStringAsFixed(1)}/5.0',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.onSubmit(_tempRating);
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.submit),
        ),
      ],
    );
  }
}
