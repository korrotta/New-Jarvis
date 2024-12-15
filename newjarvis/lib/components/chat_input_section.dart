import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatInputSection extends StatelessWidget {
  const ChatInputSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Ask me anything, press \'/\' for prompts',
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14,
                        ),
                        // Transparent border
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  CupertinoIcons.plus_slash_minus,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                Icon(
                                  CupertinoIcons.minus_slash_plus,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.alternate_email_outlined,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                // Handle @ action
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.mic_none_outlined,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                // Handle mic action
                              },
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.send_sharp,
                              color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            // Handle send action
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
