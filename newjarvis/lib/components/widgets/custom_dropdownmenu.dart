import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdownmenu extends StatefulWidget {
  final String? headingText;
  final List<String> dropdownItems;
  final Function(String?)? onSelected;

  const CustomDropdownmenu({
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

  @override
  void initState() {
    super.initState();
    _selectedItem =
        widget.dropdownItems.isNotEmpty ? widget.dropdownItems[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Select a type',
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: DropdownButton(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          items: widget.dropdownItems.map((String item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 16,
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
          borderRadius: BorderRadius.circular(20),
          iconSize: 20,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
