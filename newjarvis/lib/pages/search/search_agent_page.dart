import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchAgent extends StatefulWidget {
  final String searchQuery;

  const SearchAgent({Key? key, required this.searchQuery}) : super(key: key);

  @override
  _SearchAgentState createState() => _SearchAgentState();
}

class _SearchAgentState extends State<SearchAgent> {
  bool isLoadingSearch = true;
  bool isLoadingAnswer = true;
  bool gpt4Enabled = false;
  List<String> searchResults = [];
  String answerText = '';

  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate search delay
    setState(() {
      isLoadingSearch = false;
      searchResults = [
        'Computer science definition',
        'Latest trends in computer science',
        'Top careers in computer science',
        'How to get started in computer science?',
      ];
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulate answer delay
    setState(() {
      isLoadingAnswer = false;
      answerText =
          'Computer science is the study of computers and computational systems. It includes both theoretical and practical aspects, such as AI, data science, and software development.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchQuery),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(10.0),
              children: [
                buildSearchSection(), // Section 1: Search results
                const SizedBox(height: 20),
                buildAnswerSection(), // Section 2: Answer
              ],
            ),
          ),
          buildBottomControlsWithSearchBox(), // Bottom search input with controls
        ],
      ),
    );
  }

  Widget buildSearchSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search Results',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        isLoadingSearch ? buildSkeletonLoader() : buildSearchResults(),
      ],
    );
  }

  Widget buildAnswerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Answer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        isLoadingAnswer
            ? buildSkeletonLoader()
            : Text(
                answerText,
                style: const TextStyle(fontSize: 16),
              ),
      ],
    );
  }

  Widget buildSkeletonLoader() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: double.infinity,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
            ),
            Container(
              height: 15,
              width: double.infinity,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.only(bottom: 20.0),
            ),
          ],
        );
      },
    );
  }

  Widget buildSearchResults() {
    return Column(
      children: searchResults.map((result) {
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(result),
        );
      }).toList(),
    );
  }

  Widget buildBottomControlsWithSearchBox() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
          // color: Colors.grey.shade200,
          // border: const Border(
          //   top: BorderSide(color: Colors.grey, width: 0.5),
          // ),
          ),
      child: Column(
        children: [
          // Row with Share Button and Other Buttons at the End
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.grey),
                onPressed: () {
                  // Handle share functionality
                },
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.history, color: Colors.grey),
                    onPressed: () {
                      // Handle history functionality
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        isLoadingSearch = true;
                        searchResults.clear();
                        _fetchData();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Search Input with Rounded Borders
          Container(
            height: 200, // Box height
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align input row to the bottom
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.grey),
                      onPressed: () {
                        // Handle voice input
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        decoration: const InputDecoration(
                          hintText: 'Ask anything...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        print('User input: ${_inputController.text}');
                        _inputController.clear();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // GPT-4 Toggle Switch
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'GPT-4 Mode',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Transform.scale(
                scale: 1.2,
                child: CupertinoSwitch(
                  value: gpt4Enabled,
                  onChanged: (value) {
                    setState(() {
                      gpt4Enabled = value;
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
}
