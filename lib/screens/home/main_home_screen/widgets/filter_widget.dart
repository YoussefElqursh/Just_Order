import 'package:flutter/material.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/core/theme/colors.dart';


void showFilterBottomSheet(BuildContext context, ThemeState themeState) {
  final isLight = themeState.themeMode == ThemeMode.light;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the sheet to size itself comfortably
    backgroundColor: isLight ? Colors.white : const Color(0xFF121212),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(24),
      ),
    ),
    builder: (context) {
      // Use StatefulBuilder so updates inside the bottom sheet animate dynamically
      double ratingValue = 4.0;
      bool freeDelivery = false;
      int selectedTimeIdx = 0; // 0: Any, 1: <15m, 2: <30m, 3: <45m

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              top: 12,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pull Handler bar bar at the top
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isLight ? Colors.grey[300] : Colors.grey[700],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sheet Header Title Line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort & Filter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isLight ? Colors.black : Colors.white,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          ratingValue = 0.0;
                          freeDelivery = false;
                          selectedTimeIdx = 0;
                        });
                      },
                      child: const Text('Clear All', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                    )
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // 1. FILTER CATEGORY: Minimum Rating Slider
                Text(
                  'Minimum Rating (${ratingValue.toStringAsFixed(1)}+ Stars)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isLight ? Colors.black87 : Colors.white),
                ),
                Slider(
                  value: ratingValue,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  activeColor: AppColor.primaryColor,
                  inactiveColor: isLight ? Colors.grey[200] : Colors.grey[800],
                  onChanged: (val) => setModalState(() => ratingValue = val),
                ),
                const SizedBox(height: 20),

                // 2. FILTER CATEGORY: Delivery Preferences Switch Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Free Delivery Only',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isLight ? Colors.black87 : Colors.white),
                        ),
                        Text(
                          'Hide restaurants with extra shipping fees',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: freeDelivery,
                      activeColor: AppColor.primaryColor,
                      onChanged: (val) => setModalState(() => freeDelivery = val),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 3. FILTER CATEGORY: Delivery Speeds Selector Row
                Text(
                  'Delivery Time',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isLight ? Colors.black87 : Colors.white),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildTimeChip('AnyTime', selectedTimeIdx == 0, () => setModalState(() => selectedTimeIdx = 0), isLight),
                    const SizedBox(width: 8),
                    _buildTimeChip('Under 15m', selectedTimeIdx == 1, () => setModalState(() => selectedTimeIdx = 1), isLight),
                    const SizedBox(width: 8),
                    _buildTimeChip('Under 30m', selectedTimeIdx == 2, () => setModalState(() => selectedTimeIdx = 2), isLight),
                  ],
                ),
                const SizedBox(height: 32),

                // Bottom Action Apply Button Box
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // TODO: Send these final values back into your Bloc/Cubit to process list queries
                      debugPrint('Applied: Rating $ratingValue, Free Delivery: $freeDelivery, Time Code: $selectedTimeIdx');
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

// Micro Helper to render selective horizontal sub chips quickly inside the bottom modal sheet
Widget _buildTimeChip(String title, bool isSelected, VoidCallback onTap, bool isLight) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryColor
              : (isLight ? Colors.grey[100] : Colors.grey[900]),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColor.primaryColor : (isLight ? Colors.grey[200]! : Colors.grey[800]!),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : (isLight ? Colors.black87 : Colors.grey[300]),
          ),
        ),
      ),
    ),
  );
}