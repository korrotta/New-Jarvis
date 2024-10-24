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
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // AI Model Selection
          MaterialButton(
              height: 40,
              onPressed: () {
                _showModelBottomSheet(
                  context,
                  selectedModel,
                  aiModels,
                  filters,
                  aiModels.indexWhere(
                    (element) => element.name == selectedModel,
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).colorScheme.secondary,
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/icon.png',
                    fit: BoxFit.scaleDown,
                    width: 25,
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
              )),

          // Icons
          Icon(
            Icons.import_contacts_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.add_photo_alternate_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.description_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.cut_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: VerticalDivider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1,
              width: 1,
            ),
          ),
          Icon(
            Icons.tune_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Icon(
            Icons.history_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
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
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          ),
        ],
      ),
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
