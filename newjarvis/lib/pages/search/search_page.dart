import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'search_agent_page.dart'; // Import the new SearchAgent file

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool gpt4Enabled = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchTextChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    // Optional: Reset to Discover if text is cleared
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSearchBar(),
            const SizedBox(height: 15),
            Expanded(child: buildDiscover()),
          ],
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.purple.shade300,
          width: 1.5,
        ),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.search_outlined,
                color: Colors.grey,
                size: 30,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (value) => _performSearch(value),
                  decoration: const InputDecoration(
                    hintText: 'How to raise a cat?',
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
              const SizedBox(width: 8),
              const Text(
                'GPT-4',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () => _performSearch(_searchController.text),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        _createRoute(query),
      );
    }
  }

  Route _createRoute(String query) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SearchAgent(searchQuery: query),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // End at the current position
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  Widget buildDiscover() {
    return ListView(
      children: [
        ListTile(
          leading: Image.network('https://placehold.co/300x200/png'),
          title: const Text('Samsung Galaxy Ring battery life'),
          subtitle: const Text('The Galaxy Ring stirs battery concerns.'),
        ),
        ListTile(
          leading: Image.network('https://placehold.co/300x200/png'),
          title: const Text('Sonos Era 100 smart speakers discount'),
          subtitle: const Text('Sonos Era 100 at a reduced price.'),
        ),
        ListTile(
          leading: Image.network('https://placehold.co/300x200/png'),
          title: const Text('NASA and SpaceX postpone Crew-8 mission'),
          subtitle: const Text('The launch has been postponed by NASA.'),
        ),
      ],
    );
  }
}
