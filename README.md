# InfinityAgeScroller

[![pub package](https://img.shields.io/pub/v/infinity_age_scroller.svg)](https://pub.dev/packages/infinity_age_scroller)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A highly customizable and smooth infinite age picker widget for Flutter that provides seamless scrolling through age values with multiple orientations.

![Image](https://github.com/user-attachments/assets/c54efcaa-a184-481c-bae2-0bcbc6a77c88)

*Experience smooth infinite scrolling with multiple orientations*

## ✨ Features

- **🔄 Infinite Scrolling**: Seamless scrolling experience without visible boundaries
- **📐 Multiple Orientations**: Vertical, horizontal, and diagonal scroll directions
- **🎨 Full Customization**: Customize colors, fonts, item sizes, and scroll curves
- **⚡ Smooth Performance**: Optimized rendering with on-demand item building
- **🎯 Precise Selection**: Real-time age selection with callback notifications
- **🎪 Unique Diagonal Modes**: Eye-catching left and right diagonal scrolling options
- **📱 Responsive Design**: Adapts to your app's theme and styling

## 🚀 Getting Started

### Installation

Add `infinity_age_scroller` to your `pubspec.yaml`:

```yaml
dependencies:
  infinity_age_scroller: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Import

```dart
import 'package:infinity_age_scroller/infinity_age_scroller.dart';
```

## 📖 Usage

### Basic Usage

The simplest way to use InfinityAgeScroller:

```dart

InfinityAgeScroller(
  onAgeSelected: (age) {
    print('Selected age: $age');
  },
  scrollDirection: ScrollDirection.vertical,
)
```

### Custom Age Range

Define your own age range:

```dart
InfinityAgeScroller(
  onAgeSelected: (age) {
    setState(() => selectedAge = age);
  },
  minAge: 18,
  maxAge: 65,
  initialAge: 25,
  scrollDirection: ScrollDirection.vertical,
)
```

### Horizontal Scroller

Create a horizontal age picker:

```dart
InfinityAgeScroller(
  onAgeSelected: (age) => updateAge(age),
  scrollDirection: ScrollDirection.horizontal,
  itemExtent: 80.0,
  selectedTextColor: Colors.blue,
  unselectedTextColor: Colors.grey.shade400,
)
```

### Diagonal Scroller (Unique!)

Create a stunning diagonal age picker:

```dart
InfinityAgeScroller(
  onAgeSelected: (age) => handleAgeSelection(age),
  scrollDirection: ScrollDirection.leftDiagonal, // or rightDiagonal
  curveOfScroll: 1.5,
  selectedTextColor: Colors.purple,
  itemExtent: 70.0,
)
```

## 📱 Platform Support

InfinityAgeScroller works seamlessly on both **iOS** and **Android** platforms:

- ✅ **iOS**: Full support with native smooth scrolling behavior
- ✅ **Android**: Optimized performance with Material Design integration
- 🎨 **Cross-platform**: Automatically adapts to platform-specific design patterns

## 🎛️ Scroll Directions

InfinityAgeScroller supports four unique scroll directions:

| Direction | Description | Use Case |
|-----------|-------------|----------|
| `ScrollDirection.vertical` | Traditional up/down scrolling | Most common, intuitive for users |
| `ScrollDirection.horizontal` | Left/right scrolling | Compact layouts, limited vertical space |
| `ScrollDirection.leftDiagonal` | Diagonal scrolling at -45° | Creative designs, unique visual appeal |
| `ScrollDirection.rightDiagonal` | Diagonal scrolling at +45° | Artistic layouts, space-saving designs |

## 🛠️ API Reference

### Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onAgeSelected` | `Function(int)` | **Required** | Callback when age is selected |
| `minAge` | `int?` | `18` | Minimum selectable age |
| `maxAge` | `int?` | `100` | Maximum selectable age |
| `initialAge` | `int?` | `25` | Initially selected age |
| `itemExtent` | `double?` | `60.0` | Height/width of each age item |
| `curveOfScroll` | `double?` | `2.0` | Controls wheel curvature (lower = more curved) |
| `selectedTextColor` | `Color?` | Theme primary | Color of selected age text |
| `unselectedTextColor` | `Color?` | `Colors.black54` | Color of unselected age text |
| `scrollDirection` | `ScrollDirection` | **Required** | Scroll orientation |

### ScrollDirection Enum

```dart
enum ScrollDirection {
  vertical,       // ↕️ Traditional vertical scrolling
  horizontal,     // ↔️ Horizontal left-right scrolling  
  leftDiagonal,   // ↖️↘️ Diagonal scrolling at -45°
  rightDiagonal,  // ↗️↙️ Diagonal scrolling at +45°
}
```

## 🎨 Customization Tips

### Color Theming
```dart
InfinityAgeScroller(
  selectedTextColor: Colors.deepPurple,
  unselectedTextColor: Colors.grey.shade300,
  // ... other parameters
)
```

### Adjust Wheel Curvature
```dart
InfinityAgeScroller(
  curveOfScroll: 1.0, // More curved wheel effect
  // or
  curveOfScroll: 4.0, // Flatter, more linear appearance
)
```

### Item Sizing
```dart
InfinityAgeScroller(
  itemExtent: 80.0, // Larger items with more spacing
  // or  
  itemExtent: 40.0, // Compact, tightly packed items
)
```

## 💡 Design Patterns

### 1. Form Integration
```dart
// Perfect for registration forms
FormField<int>(
  initialValue: 25,
  builder: (field) => InfinityAgeScroller(
    initialAge: field.value,
    onAgeSelected: field.didChange,
    scrollDirection: ScrollDirection.vertical,
  ),
)
```

### 2. Multi-Picker Layout
```dart
// Combine multiple pickers horizontally
Row(
  children: [
    Expanded(
      child: InfinityAgeScroller(
        scrollDirection: ScrollDirection.vertical,
        onAgeSelected: (age) => setState(() => age1 = age),
      ),
    ),
    Expanded(
      child: InfinityAgeScroller(
        scrollDirection: ScrollDirection.vertical,
        onAgeSelected: (age) => setState(() => age2 = age),
      ),
    ),
  ],
)
```

### 3. Themed Integration
```dart
// Automatically adapt to app theme
InfinityAgeScroller(
  selectedTextColor: Theme.of(context).primaryColor,
  unselectedTextColor: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
  scrollDirection: ScrollDirection.horizontal,
)
```

## 🏗️ Architecture

InfinityAgeScroller uses an efficient architecture that:

- **Memory Efficient**: Only renders visible items plus a small buffer
- **Truly Infinite**: Uses a large item count (100M) with modulo arithmetic
- **Smooth Scrolling**: Leverages Flutter's `ListWheelScrollView` for native performance
- **Flexible Design**: Transform-based approach enables unique orientations

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with Flutter's `ListWheelScrollView` for optimal performance
- Inspired by the need for more flexible age picker solutions
- Thanks to the Flutter community for feedback and suggestions

---

**Made with ❤️ for the Flutter community**
