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
      child: Tooltip(
        message: 'Select a type',
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                child: Text(
                  item,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? item) {
              widget.onSelected!(item);
              setState(() {
                _selectedItem = 'Type: $item';
              });
            },
            value: _selectedItem,
            underline: Container(),
            icon: const Icon(CupertinoIcons.chevron_down),
            borderRadius: BorderRadius.circular(12),
            iconSize: 30,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
