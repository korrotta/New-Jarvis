import 'package:flutter/material.dart';
import 'package:newjarvis/models/AI_Model.dart';

class AiModelSelectionSheet extends StatelessWidget {
  final List<AIModel> aiModels;
  final List<String> filters;
  final int selectedIndex;

  const AiModelSelectionSheet({
    super.key,
    required this.aiModels,
    required this.filters,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Title and close button
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Bots',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_outlined),
                  color: Theme.of(context).colorScheme.inversePrimary,
                  iconSize: 24,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Colors.purple,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Colors.purple,
                  ),
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                prefixIcon: Icon(
                  Icons.search_outlined,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ),

          // Filter tabs
          StatefulBuilder(
            builder: (context, setState) {
              int selectedIndex = 0;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    bool isSelected = index == selectedIndex;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            filters[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // AI Model list
          Expanded(
            child: ListView.builder(
              itemCount: aiModels.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),

                  // AI Model card
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // AI Model icon
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Image.asset(
                            aiModels[index].icon,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      // AI Model name and description
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Wrap(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    aiModels[index].name,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),

                              // AI Model selected indicator
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: Icon(
                                  Icons.check_outlined,
                                  size: 16,
                                  // Purple if selected, transparent otherwise
                                  color: selectedIndex == index
                                      ? Colors.purple
                                      : Colors.transparent,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // AI Model pin
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: const Icon(
                          Icons.push_pin_rounded,
                          size: 18,
                          color: Colors.purple,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
