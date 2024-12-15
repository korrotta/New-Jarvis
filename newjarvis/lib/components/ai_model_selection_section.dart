import 'package:flutter/material.dart';
import 'package:newjarvis/models/ai_model.dart';
import 'package:newjarvis/components/ai_model_selection_sheet.dart';

class AiModelSelectionSection extends StatelessWidget {
  final String selectedModel;
  final List<AIModel> aiModels;
  final List<String> filters;
  const AiModelSelectionSection({
    super.key,
    required this.selectedModel,
    required this.aiModels,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.horizontal,
      runAlignment: WrapAlignment.start,
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.start,
      children: [
        // AI Model Selection
        GestureDetector(
          onTap: () => _showModelBottomSheet(
            context,
            selectedModel,
            aiModels,
            filters,
            0,
          ),
          child: Container(
            height: 40,
            width: 110,
            padding: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/icon.png',
                  fit: BoxFit.scaleDown,
                  width: 25,
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    selectedModel,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 12,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ],
            ),
          ),
        ),

        // Icons
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.import_contacts_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.description_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.cut_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          color: Theme.of(context).colorScheme.primary,
          height: 35,
          width: 2,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.tune_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Icon(
            Icons.history_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 3),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14),
            child: Icon(
              Icons.add_comment_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
      ],
    );
  }
}

void _showModelBottomSheet(BuildContext context, String selectedModel,
    List<AIModel> aiModels, List<String> filters, int selectedIndex) {
  showModalBottomSheet(
    context: context,
    builder: (context) => AiModelSelectionSheet(
      aiModels: aiModels,
      filters: filters,
      selectedIndex: selectedIndex,
    ),
    isScrollControlled: true,
  );
}
