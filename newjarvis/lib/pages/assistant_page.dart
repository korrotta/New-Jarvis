import 'package:flutter/material.dart';

class AssistantPage extends StatefulWidget {
  final String? assistantId;

  const AssistantPage({super.key, this.assistantId});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  late String _assistantId;

  @override
  void initState() {
    super.initState();
    _assistantId = widget.assistantId!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_assistantId),
    );
  }
}
