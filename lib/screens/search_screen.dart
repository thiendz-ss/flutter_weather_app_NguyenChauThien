import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Search City")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------------------
            // Search Box
            // --------------------------
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Search city...",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      provider.fetchByCity(_controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // --------------------------
            // SEARCH HISTORY
            // --------------------------
            if (provider.searchHistory.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Searches",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      provider.searchHistory.clear();
                      provider.storageService.saveSearchHistory([]);
                      provider.notifyListeners();
                    },
                    child: const Text("Clear"),
                  )
                ],
              ),

            if (provider.searchHistory.isNotEmpty)
              Expanded(
                child: ListView(
                  children: [
                    ...provider.searchHistory.map((city) {
                      return ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(city),
                        onTap: () {
                          provider.fetchByCity(city);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),

                    const SizedBox(height: 20),

                    // --------------------------
                    // FAVORITE CITIES
                    // --------------------------
                    const Text(
                      "Favorite Cities",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    ...provider.favoriteCities.map((c) {
                      return ListTile(
                        title: Text(c),
                        trailing: IconButton(
                          icon:
                          const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => provider.removeFavorite(c),
                        ),
                        onTap: () {
                          provider.fetchByCity(c);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),

            // --------------------------
            // Nếu không có history
            // --------------------------
            if (provider.searchHistory.isEmpty)
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      "Favorite Cities",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),

                    ...provider.favoriteCities.map((c) {
                      return ListTile(
                        title: Text(c),
                        trailing: IconButton(
                          icon:
                          const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => provider.removeFavorite(c),
                        ),
                        onTap: () {
                          provider.fetchByCity(c);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
