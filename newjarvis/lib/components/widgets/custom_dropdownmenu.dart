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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedItem,
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
          onChanged: (String? newValue) {
            setState(() {
              _selectedItem = newValue;
            });
            if (widget.onSelected != null) {
              widget.onSelected!(newValue);
            }
          },
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
