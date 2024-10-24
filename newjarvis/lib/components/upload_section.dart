import 'package:flutter/material.dart';

class UploadSection extends StatelessWidget {
  const UploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Background image
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 30,
              ),
              Icon(
                Icons.description_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
                size: 30,
              ),
            ],
          ),
          // Text
          Text(
            'Upload',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Click/Drag and drop here to chat',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
