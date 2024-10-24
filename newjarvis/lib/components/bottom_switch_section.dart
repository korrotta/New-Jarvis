import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomSwitchSection extends StatelessWidget {
  const BottomSwitchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Web Access Switch
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.auto_awesome_outlined,
                      size: 14,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    'Web Access',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
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
              // GPT-4 Switch
              Row(
                children: [
                  Text(
                    'GPT-4',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.6,
                    child: CupertinoSwitch(
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
            ],
          ),

          // Chat with Memo Switch
          Row(
            children: [
              Text(
                'Chat with Memo',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Transform.scale(
                scale: 0.6,
                child: CupertinoSwitch(
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
        ],
      ),
    );
  }

  void setState(Null Function() param0) {}
}
