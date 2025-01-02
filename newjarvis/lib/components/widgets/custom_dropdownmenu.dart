import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownmenu extends StatefulWidget {
  String? headingText;
  List<String> dropdownItems;
  Function(String?)? onSelected;

  CustomDropdownmenu({
    super.key,
    this.headingText,
    required this.dropdownItems,
    required this.onSelected,
  });

  @override
  State<CustomDropdownmenu> createState() => _CustomDropdownmenuState();
}

class _CustomDropdownmenuState extends State<CustomDropdownmenu> {
  String? _selectedItem;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _selectedItem =
        widget.dropdownItems.isNotEmpty ? widget.dropdownItems[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: 120,
        decoration: BoxDecoration(
          border: Border.all(
            color: _isHovered
                ? Colors.blueAccent
                : Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: DropdownButton(
          items: widget.dropdownItems.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedItem == item
                      ? Colors.blue.withOpacity(0.2) // Highlight selected item
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  item,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
          onChanged: (String? item) {
            widget.onSelected!(item);
            setState(() {
              _selectedItem = item;
            });
          },
          value: _selectedItem,
          underline: Container(),
          icon: const Icon(CupertinoIcons.chevron_down),
          isExpanded: true,
          borderRadius: BorderRadius.circular(12),
          iconSize: 30,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 16,
          ),
          selectedItemBuilder: (BuildContext context) {
            return widget.dropdownItems.map((String item) {
              return Text(
                'Type: $item',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
