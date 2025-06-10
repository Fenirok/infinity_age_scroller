import 'package:flutter/material.dart';
import 'package:infinity_age_scroller/infinity_age_scroller.dart';

// Import or include your InfinityAgeScroller.dart here
// For this example, we assume it's defined in the same file or properly imported.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Age Picker Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AgePickerScreen(),
    );
  }
}

class AgePickerScreen extends StatefulWidget {
  const AgePickerScreen({super.key});

  @override
  State<AgePickerScreen> createState() => _AgePickerScreenState();
}

class _AgePickerScreenState extends State<AgePickerScreen> {
  int selectedAge = 25;

  ScrollDirection currentDirection = ScrollDirection.vertical;

  // List of available scroll directions for demonstration
  final List<ScrollDirection> scrollDirections = [
    ScrollDirection.vertical,
    ScrollDirection.horizontal,
    ScrollDirection.leftDiagonal,
    ScrollDirection.rightDiagonal,
  ];

  // Get display name for scroll direction
  String getDirectionName(ScrollDirection direction) {
    switch (direction) {
      case ScrollDirection.vertical:
        return 'Vertical';
      case ScrollDirection.horizontal:
        return 'Horizontal';
      case ScrollDirection.leftDiagonal:
        return 'Left Diagonal';
      case ScrollDirection.rightDiagonal:
        return 'Right Diagonal';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.cyan,
          title: const Text('Infinity Age Scroller Demo'),
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(30),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scroll Direction:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 50,
                        children: scrollDirections.map((direction) {
                          final isSelected = direction == currentDirection;
                          return ChoiceChip(
                            label: Text(getDirectionName(direction)),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  currentDirection = direction;
                                });
                              }
                            },
                            selectedColor: Colors.blue[100],
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.blue[800]
                                  : Colors.grey[600],
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Selected Age: $selectedAge',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: InfinityAgeScroller(
                        key: ValueKey(currentDirection),
                        onAgeSelected: (age) {
                          setState(() {
                            selectedAge = age;
                          });
                        },
                        minAge: 18,
                        maxAge: 60,
                        initialAge: 25,
                        itemExtent: 60,
                        scrollDirection: currentDirection,
                        curveOfScroll: 3.0,
                        selectedTextColor: Colors.blueAccent,
                        unselectedTextColor: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
