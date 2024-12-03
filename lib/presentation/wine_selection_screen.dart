import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/wine.dart';
import '../data/favorites_service.dart';
import '../data/wine_data_service.dart';

class WineSelectionScreen extends StatefulWidget {
  @override
  _WineSelectionScreenState createState() => _WineSelectionScreenState();
}

class _WineSelectionScreenState extends State<WineSelectionScreen> {
  List<Wine> wines = [];
  FavoritesService favoritesService = FavoritesService();
  WineDataService wineDataService = WineDataService();

  @override
  void initState() {
    super.initState();
    loadWineData();
    favoritesService.loadFavorites().then((_) {
      setState(() {});
    });
  }

  void loadWineData() {
    wineDataService.loadWineData().then((loadedWines) {
      setState(() {
        wines = loadedWines;
      });
    });
  }

  void toggleFavorite(String wineName) {
    setState(() {
      favoritesService.toggleFavorite(wineName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wine Selection'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: wines.length,
          itemBuilder: (context, index) {
            final wine = wines[index];
            final isFavorite = favoritesService.isFavorite(wine.name);

            return Card(
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 150,
                    child: Image.network(
                      wine.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          wine.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${wine.type} - ${wine.bottleSize} - ${wine.priceUsd} USD',
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${wine.criticScore}/100',
                          textAlign: TextAlign.center,
                        ),
                        GestureDetector(
                          onTap: () {
                            toggleFavorite(wine.name);
                          },
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: isFavorite ? Colors.red : Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                              child: Text(
                                'Favorite ♡',
                                style: TextStyle(fontSize: 24, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
