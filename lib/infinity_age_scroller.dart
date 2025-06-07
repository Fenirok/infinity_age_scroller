library infinity_age_scroller;

import 'package:flutter/material.dart';

/// Defines the available scroll directions for the InfinityAgeScroller widget.
///
/// This enum provides four different scrolling orientations:
/// - [vertical]: Traditional top-to-bottom scrolling (default)
/// - [horizontal]: Left-to-right scrolling
/// - [leftDiagonal]: Diagonal scrolling at -45 degrees
/// - [rightDiagonal]: Diagonal scrolling at +45 degrees
enum ScrollDirection {
  vertical,
  horizontal,
  leftDiagonal,
  rightDiagonal,
}

/// A highly customizable infinite age picker widget that provides smooth scrolling
/// through age values with various display orientations.
///
/// The [InfinityAgeScroller] creates an infinite scrolling list of ages that users
/// can scroll through to select their desired age. It supports multiple scroll
/// directions including vertical, horizontal, and diagonal orientations.
///
/// ## Key Features:
/// - **Infinite Scrolling**: Seamless scrolling experience without visible boundaries
/// - **Customizable Age Range**: Set minimum and maximum age limits
/// - **Multiple Orientations**: Vertical, horizontal, and diagonal scroll directions
/// - **Visual Customization**: Customize colors, fonts, and scroll curve
/// - **Smooth Selection**: Real-time age selection with callback notifications
///
/// ## Basic Usage:
/// ```dart
/// InfinityAgeScroller(
///   onAgeSelected: (age) {
///     print('Selected age: $age');
///   },
///   minAge: 18,
///   maxAge: 65,
///   initialAge: 25,
/// )
/// ```
///
/// ## Advanced Usage with Custom Styling:
/// ```dart
/// InfinityAgeScroller(
///   onAgeSelected: (age) => setState(() => selectedAge = age),
///   minAge: 16,
///   maxAge: 100,
///   initialAge: 30,
///   scrollDirection: ScrollDirection.horizontal,
///   itemExtent: 80.0,
///   curveOfScroll: 1.5,
///   selectedTextColor: Colors.blue,
///   unselectedTextColor: Colors.grey,
/// )
/// ```
class InfinityAgeScroller extends StatefulWidget {
  /// Callback function that gets triggered whenever a new age is selected.
  ///
  /// This function receives the selected age as an integer parameter.
  /// Use this callback to update your application state or perform
  /// actions based on the selected age.
  ///
  /// **Required parameter** - must be provided for the widget to function.
  ///
  /// Example:
  /// ```dart
  /// onAgeSelected: (int selectedAge) {
  ///   setState(() {
  ///     userAge = selectedAge;
  ///   });
  ///   // Additional logic here
  /// }
  /// ```
  final Function(int age) onAgeSelected;

  /// The minimum age that can be selected in the scroller.
  ///
  /// If not specified, defaults to **18**.
  /// Must be less than [maxAge] for proper functionality.
  ///
  /// Example: `minAge: 16` for applications that allow younger users.
  final int? minAge;

  /// The maximum age that can be selected in the scroller.
  ///
  /// If not specified, defaults to **100**.
  /// Must be greater than [minAge] for proper functionality.
  ///
  /// Example: `maxAge: 65` for retirement-focused applications.
  final int? maxAge;

  /// The age that will be initially selected and centered when the widget loads.
  ///
  /// If not specified, defaults to **25**.
  /// Should be within the range of [minAge] and [maxAge].
  /// If outside the range, the scroller will still function but may start
  /// at an unexpected position.
  ///
  /// Example: `initialAge: 30` to start with 30 years selected.
  final int? initialAge;

  /// The height (for vertical) or width (for horizontal) of each age item in pixels.
  ///
  /// If not specified, defaults to **60.0** pixels.
  /// This affects the spacing between age numbers and the overall size
  /// of the scroller. Larger values create more spacing, smaller values
  /// create a more compact display.
  ///
  /// Example: `itemExtent: 80.0` for larger, more spaced out age numbers.
  final double? itemExtent;

  /// Controls the curvature of the scroll wheel effect.
  ///
  /// If not specified, defaults to **2.0**.
  /// - Lower values (e.g., 1.0) create a more curved, cylindrical appearance
  /// - Higher values (e.g., 4.0) create a flatter, more linear appearance
  /// - Very low values may cause visual distortion
  ///
  /// Example: `curveOfScroll: 1.5` for a more pronounced wheel effect.
  final double? curveOfScroll;

  /// The color of the text for the currently selected age.
  ///
  /// If not specified, defaults to the current theme's primary color.
  /// The selected age will be displayed in bold with a larger font size.
  ///
  /// Example: `selectedTextColor: Colors.blue` for blue selected text.
  final Color? selectedTextColor;

  /// The color of the text for non-selected ages.
  ///
  /// If not specified, defaults to **Colors.black54** (semi-transparent black).
  /// Non-selected ages are displayed with normal font weight and smaller size.
  ///
  /// Example: `unselectedTextColor: Colors.grey.shade600` for custom grey.
  final Color? unselectedTextColor;

  /// The direction in which the age scroller will scroll.
  ///
  /// Defaults to [ScrollDirection.vertical] if not specified.
  ///
  /// Available options:
  /// - [ScrollDirection.vertical]: Standard vertical scrolling (up/down)
  /// - [ScrollDirection.horizontal]: Horizontal scrolling (left/right)
  /// - [ScrollDirection.leftDiagonal]: Diagonal scrolling at -45 degrees
  /// - [ScrollDirection.rightDiagonal]: Diagonal scrolling at +45 degrees
  ///
  /// Example: `scrollDirection: ScrollDirection.horizontal` for horizontal scrolling.
  final ScrollDirection scrollDirection;

  /// Creates an [InfinityAgeScroller] widget.
  ///
  /// The [onAgeSelected] callback is required and will be called whenever
  /// the user selects a different age.
  ///
  /// All other parameters are optional and will use sensible defaults:
  /// - minAge: 18
  /// - maxAge: 100
  /// - initialAge: 25
  /// - itemExtent: 60.0
  /// - curveOfScroll: 2.0
  /// - scrollDirection: ScrollDirection.vertical
  /// - selectedTextColor: Theme primary color
  /// - unselectedTextColor: Colors.black54
  const InfinityAgeScroller({
    super.key,
    required this.onAgeSelected,
    this.minAge,
    this.maxAge,
    this.initialAge,
    this.itemExtent,
    this.curveOfScroll,
    this.selectedTextColor,
    this.unselectedTextColor,
    required this.scrollDirection,
  });

  @override
  State<InfinityAgeScroller> createState() => _InfinityAgeScrollerState();
}

/// Private state class that manages the InfinityAgeScroller's internal logic.
///
/// This class handles the scroll controller, maintains the selected age state,
/// and builds the appropriate scroller widget based on the chosen direction.
class _InfinityAgeScrollerState extends State<InfinityAgeScroller> {
  /// Currently selected age value.
  ///
  /// This value is updated whenever the user scrolls to a different age
  /// and is used to determine which age should be highlighted.
  int? selectedAge;

  /// Controller for managing the scroll position and behavior.
  ///
  /// This controller handles the infinite scrolling logic and ensures
  /// smooth scrolling between age values.
  late FixedExtentScrollController _scrollController;

  /// Total number of items in the infinite scroller.
  ///
  /// This large number (100 million) creates the illusion of infinite scrolling
  /// by providing enough items that users will never reach the beginning or end
  /// during normal usage. The actual ages are calculated using modulo operations.
  static const int _totalItems = 100000000;

  /// Initializes the state and sets up the scroll controller.
  ///
  /// This method:
  /// 1. Sets up default values for age ranges if not provided
  /// 2. Calculates the initial scroll position to display the initial age
  /// 3. Creates and configures the FixedExtentScrollController
  ///
  /// The initial scroll position is calculated to place the initial age
  /// at the center of the scroller, taking into account the infinite
  /// scrolling mechanism.
  @override
  void initState() {
    super.initState();

    // Apply default values for any unspecified parameters
    // These defaults provide a reasonable age range for most applications
    int minAge = widget.minAge ?? 18;        // Legal adult age in most countries
    int maxAge = widget.maxAge ?? 100;       // Reasonable maximum human age
    int initialAge = widget.initialAge ?? 25; // Young adult default

    // Set the initial selected age for highlighting purposes
    selectedAge = initialAge;

    // Calculate the initial scroll position to center the initial age
    // This complex calculation ensures the initial age appears in the center
    // of the scroller when the widget first loads
    int ageRange = maxAge - minAge + 1;                    // Total number of different ages
    int targetAgeIndex = initialAge - minAge;              // Index of initial age within range
    int initialIndex = (_totalItems ~/ 2) -                // Start from middle of total items
        ((_totalItems ~/ 2) % ageRange) +                 // Align to age cycle boundary
        targetAgeIndex;                                    // Offset to target age

    // Create the scroll controller with the calculated initial position
    _scrollController = FixedExtentScrollController(initialItem: initialIndex);
  }

  /// Cleans up resources when the widget is disposed.
  ///
  /// This method disposes of the scroll controller to prevent memory leaks.
  /// Always called automatically when the widget is removed from the widget tree.
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Builds the widget based on the selected scroll direction.
  ///
  /// This method acts as a router that delegates to the appropriate builder method
  /// based on the [scrollDirection] parameter. It first extracts the age range
  /// and item extent values (applying defaults if needed), then calls the
  /// corresponding builder method.
  ///
  /// The method ensures consistent default values across all scroll directions:
  /// - minAge: 18 (if not specified)
  /// - maxAge: 100 (if not specified)
  /// - itemExtent: 60.0 (if not specified)
  ///
  /// Returns the appropriate scroller widget configured for the chosen direction.
  @override
  Widget build(BuildContext context) {
    // Extract configuration values, applying defaults for consistency
    // These values are used by all scroller implementations
    int minAge = widget.minAge ?? 18;           // Minimum selectable age
    int maxAge = widget.maxAge ?? 100;          // Maximum selectable age
    double itemExtent = widget.itemExtent ?? 60.0; // Size of each age item

    // Route to the appropriate builder method based on scroll direction
    switch (widget.scrollDirection) {
      case ScrollDirection.vertical:
        return _buildVerticalScroller(minAge, maxAge, itemExtent);
      case ScrollDirection.horizontal:
        return _buildHorizontalScroller(minAge, maxAge, itemExtent);
      case ScrollDirection.leftDiagonal:
        return _buildDiagonalScroller(minAge, maxAge, itemExtent, isLeft: true);
      case ScrollDirection.rightDiagonal:
        return _buildDiagonalScroller(minAge, maxAge, itemExtent, isLeft: false);
    }
  }

  /// Builds a vertical scroller widget (default orientation).
  ///
  /// Creates a traditional vertical age picker that scrolls up and down.
  /// This is the most common and intuitive scroll direction for age selection.
  ///
  /// **Features:**
  /// - Shows 5 ages simultaneously for better context
  /// - Selected age is highlighted with larger font and custom color
  /// - Smooth wheel-like scrolling with configurable curve
  /// - Real-time selection updates with callback notifications
  ///
  /// **Parameters:**
  /// - [minAge]: Minimum age in the range
  /// - [maxAge]: Maximum age in the range
  /// - [itemExtent]: Height of each age item
  ///
  /// **Visual Layout:**
  /// ```
  /// ┌─────────┐
  /// │   23    │  <- smaller, unselected
  /// │   24    │  <- smaller, unselected
  /// │ **25**  │  <- larger, selected (highlighted)
  /// │   26    │  <- smaller, unselected
  /// │   27    │  <- smaller, unselected
  /// └─────────┘
  /// ```
  ///
  /// Returns a [SizedBox] containing a [ListWheelScrollView] configured for vertical scrolling.
  Widget _buildVerticalScroller(int minAge, int maxAge, double itemExtent) {
    return SizedBox(
      // Set container height to show exactly 5 items for optimal UX
      // This provides good context while keeping the widget compact
      height: itemExtent * 5,
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: itemExtent,

        /// Callback triggered when user scrolls to a different age.
        ///
        /// The [index] parameter represents the position in the infinite list.
        /// We use modulo arithmetic to convert this to an actual age value
        /// within the specified range, then update the state and notify
        /// the parent widget via the callback.
        onSelectedItemChanged: (index) {
          // Convert infinite list index to actual age using modulo arithmetic
          final age = minAge + (index % (maxAge - minAge + 1));

          // Update internal state to highlight the selected age
          setState(() {
            selectedAge = age;
          });

          // Notify parent widget of the selection change
          widget.onAgeSelected(age);
        },

        // Use fixed extent physics for smooth, predictable scrolling
        // This ensures each scroll "snap" moves exactly one age value
        physics: const FixedExtentScrollPhysics(),

        // Apply the curve setting to control the wheel's visual curvature
        // Lower values create more pronounced curves, higher values are flatter
        diameterRatio: widget.curveOfScroll ?? 2.0,

        /// Custom delegate that builds age items on demand.
        ///
        /// This approach is memory-efficient as it only builds visible items
        /// plus a small buffer, rather than creating all 100 million items upfront.
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: _totalItems,

          /// Builder function that creates individual age display widgets.
          ///
          /// Called automatically by Flutter for each visible item.
          /// The [index] represents the position in the infinite list,
          /// which we convert to an actual age for display.
          builder: (context, index) {
            // Calculate the actual age from the infinite list index
            final age = minAge + (index % (maxAge - minAge + 1));

            // Determine if this age is currently selected for styling
            final isSelected = age == selectedAge;

            return Container(
              alignment: Alignment.center,
              child: Text(
                "$age",
                textAlign: TextAlign.center,
                style: isSelected
                    ? TextStyle(
                  // Selected age styling: larger and bold
                  fontSize: 45.0,
                  color: widget.selectedTextColor ??
                      Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )
                    : TextStyle(
                  // Unselected age styling: smaller and normal weight
                  fontSize: 30.0,
                  color: widget.unselectedTextColor ?? Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds a horizontal scroller widget.
  ///
  /// Creates a horizontal age picker that scrolls left and right.
  /// This orientation is useful for compact layouts or when vertical
  /// space is limited.
  ///
  /// **Implementation Details:**
  /// - Uses [RotatedBox] to transform vertical ListWheelScrollView to horizontal
  /// - Applies quarter-turn rotations (90 degrees) to achieve horizontal layout
  /// - Text is counter-rotated to maintain readability
  /// - Shows 5 ages simultaneously in horizontal arrangement
  ///
  /// **Visual Layout:**
  /// ```
  /// ┌─────────────────────────────┐
  /// │ 23  24  **25**  26  27      │
  /// └─────────────────────────────┘
  ///      ↑    ↑      ↑     ↑    ↑
  ///   smaller      selected    smaller
  /// ```
  ///
  /// **Parameters:**
  /// - [minAge]: Minimum age in the range
  /// - [maxAge]: Maximum age in the range
  /// - [itemExtent]: Width of each age item (rotated from height)
  ///
  /// Returns a [SizedBox] containing a rotated [ListWheelScrollView].
  Widget _buildHorizontalScroller(int minAge, int maxAge, double itemExtent) {
    return SizedBox(
      // Set container width to show exactly 5 items horizontally
      width: itemExtent * 5,
      child: RotatedBox(
        // Rotate the entire scroller 90 degrees clockwise
        // This transforms vertical scrolling into horizontal scrolling
        quarterTurns: 1,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: itemExtent,

          /// Selection change handler (identical to vertical scroller).
          ///
          /// Converts infinite list index to age and updates state.
          onSelectedItemChanged: (index) {
            final age = minAge + (index % (maxAge - minAge + 1));
            setState(() {
              selectedAge = age;
            });
            widget.onAgeSelected(age);
          },

          physics: const FixedExtentScrollPhysics(),
          diameterRatio: widget.curveOfScroll ?? 2.0,

          childDelegate: ListWheelChildBuilderDelegate(
            childCount: _totalItems,
            builder: (context, index) {
              final age = minAge + (index % (maxAge - minAge + 1));
              final isSelected = age == selectedAge;

              return RotatedBox(
                // Counter-rotate the text back to normal orientation
                // This ensures text remains readable despite container rotation
                quarterTurns: -1,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$age",
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? TextStyle(
                      fontSize: 45.0,
                      color: widget.selectedTextColor ??
                          Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )
                        : TextStyle(
                      fontSize: 30.0,
                      color: widget.unselectedTextColor ?? Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Builds a diagonal scroller widget.
  ///
  /// Creates a unique diagonal age picker that scrolls at a 45-degree angle.
  /// This creates a visually interesting and distinctive user interface element
  /// that can serve as a design accent or space-saving alternative.
  ///
  /// **Implementation Details:**
  /// - Uses [Transform.rotate] to rotate the entire scroller by ±45 degrees
  /// - Text is counter-rotated to maintain readability
  /// - Supports both left diagonal (-45°) and right diagonal (+45°) orientations
  /// - Shows ages in a diamond-like arrangement
  ///
  /// **Visual Layout (Left Diagonal):**
  /// ```
  ///     23
  ///   24
  /// **25**  <- selected (highlighted)
  ///   26
  ///     27
  /// ```
  ///
  /// **Parameters:**
  /// - [minAge]: Minimum age in the range
  /// - [maxAge]: Maximum age in the range
  /// - [itemExtent]: Size of each age item
  /// - [isleft]: If true, rotates left (-45°); if false, rotates right (+45°)
  ///
  /// **Use Cases:**
  /// - Creative UI designs requiring unique visual elements
  /// - Space-constrained layouts where diagonal saves space
  /// - Applications with artistic or unconventional design requirements
  ///
  /// Returns a [SizedBox] containing a rotated [ListWheelScrollView].
  Widget _buildDiagonalScroller(int minAge, int maxAge, double itemExtent, {required bool isLeft}) {
    return SizedBox(
      /// Square container to accommodate diagonal rotation
      /// Both dimensions are set to show 5 items for consistent sizing
      height: itemExtent * 5,
      width: itemExtent * 5,
      child: Transform.rotate(
        /// Rotate 45 degrees (0.785398 radians) left or right
        /// Left diagonal: -45° (counter-clockwise)
        /// Right diagonal: +45° (clockwise)
        angle: isLeft ? -0.785398 : 0.785398,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: itemExtent,

          /// Selection change handler (identical to other scrollers).
          onSelectedItemChanged: (index) {
            final age = minAge + (index % (maxAge - minAge + 1));
            setState(() {
              selectedAge = age;
            });
            widget.onAgeSelected(age);
          },

          physics: const FixedExtentScrollPhysics(),
          diameterRatio: widget.curveOfScroll ?? 2.0,

          childDelegate: ListWheelChildBuilderDelegate(
            childCount: _totalItems,
            builder: (context, index) {
              final age = minAge + (index % (maxAge - minAge + 1));
              final isSelected = age == selectedAge;

              return Transform.rotate(
                /// Counter-rotate the text to keep it upright and readable
                /// This compensates for the container's diagonal rotation
                angle: isLeft ? 0.785398 : -0.785398,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    "$age",
                    textAlign: TextAlign.center,
                    style: isSelected
                        ? TextStyle(
                      fontSize: 45.0,
                      color: widget.selectedTextColor ??
                          Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )
                        : TextStyle(
                      fontSize: 30.0,
                      color: widget.unselectedTextColor ?? Colors.black54,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}