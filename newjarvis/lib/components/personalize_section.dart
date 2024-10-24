import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalizeSection extends StatelessWidget {
  const PersonalizeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.transparent,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: const Text(
            'Personalize your Monica',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text(
                'Monica will automatically use enabled skills\n'
                'Advanced skills are only available when GPT-4 is enabled.\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Basic Skills
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Basic Skills',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                textAlign: TextAlign.left,
              ),
            ),

            // Web Access ListTile
            ListTile(
              leading: const Icon(Icons.language_outlined),
              title: const Text(
                'Web Access',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
              trailing: CupertinoSwitch(
                value: false,
                onChanged: (value) {
                  setState(() {
                    value = !value;
                  });
                },
              ),
            ),

            // Advanced Skills
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Advanced Skills',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Create Image (DALL·E 3) ListTile
            ListTile(
              leading: const Icon(
                Icons.brush_outlined,
              ),
              title: const Text('Create Image (DALL·E 3)',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              trailing: CupertinoSwitch(
                value: false,
                onChanged: (value) {
                  setState(() {
                    value = !value;
                  });
                },
              ),
            ),

            // Book Calendar Events ListTile
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Book Calendar Events',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              trailing: CupertinoSwitch(
                value: false,
                onChanged: (value) {
                  setState(() {
                    value = !value;
                  });
                },
              ),
            ),

            // Learn from your chats ListTile
            ListTile(
              leading: const Icon(Icons.compost_outlined),
              title: const Text('Learn from your chats',
                  style: TextStyle(color: Colors.black, fontSize: 15)),
              trailing: CupertinoSwitch(
                value: false,
                onChanged: (value) {
                  setState(() {
                    value = !value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
