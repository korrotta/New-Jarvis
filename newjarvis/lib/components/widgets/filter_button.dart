import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final String selectedFilter;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.selectedFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = label == selectedFilter;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blueAccent
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 1.5,
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Colors.blueAccent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Theme.of(context).colorScheme.tertiary
                : Colors.blueAccent,
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class FilterBar extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterBar({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Favorite', 'Published'];

    return Wrap(
      alignment: WrapAlignment.start,
      runAlignment: WrapAlignment.start,
      runSpacing: 10,
      children: filters
          .map(
            (filter) => Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FilterButton(
                label: filter,
                selectedFilter: selectedFilter,
                onTap: () => onFilterSelected(filter),
              ),
            ),
          )
          .toList(),
    );
  }
}
