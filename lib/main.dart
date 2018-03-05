import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TEL',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      home: new HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {

  final _favorites = new Set<String>();
  Map<String, dynamic> data;

  getTelData() async {
    var httpClient = new HttpClient();
    var uri = new Uri.http(
        'techxlab.org',
        'pages.json'
    );
    try {
      var request = await httpClient.getUrl(uri);
      var response = await request.close();
      if (response.statusCode == HttpStatus.OK) {
        var responseBody = await response.transform(UTF8.decoder).join();
        data = JSON.decode(responseBody);
      } else {
        print('Couldn\'t retrieve data, status: ${response.statusCode}');
      }
    } catch (exception) {
      print(exception);
    }
  }

  Widget _buildRow(Map<String, dynamic> solution) {
    final isFavorite = _favorites.contains(solution['name']);
    return new ListTile(
      title: new Text(
          solution['name'],
          style: new TextStyle(fontSize: 18.0)
      ),
      leading: new Image.asset(
        solution['image'].toString().replaceAll('ast/', 'images/'),
        width: 200.0,
        height: 48.0,
      ),
      trailing: new IconButton(
        icon: isFavorite ? new Icon(Icons.favorite) : new Icon(
            Icons.favorite_border),
        color: isFavorite ? Colors.red : null,
        onPressed: () {
          setState(() {
            if (isFavorite) {
              _favorites.remove(solution['name']);
            } else {
              _favorites.add(solution['name']);
            }
          });
        },
      ),
      onTap: _favoriesPage,
    );
  }

  /**
   * Creates a Map of the solutions by category, used later for sorting and filtering.
   */
  Widget _buildListView() {
    List<Widget> solutionListItems = new List();
    Map<String, List<Map<String, dynamic>>> solutionsByType = new Map<
        String,
        List<Map<String, dynamic>>>();

    if (data != null) {
      for (Map<String, dynamic> a in data['Solutions']) {
        if (a.containsKey('publish') && a['publish'].contains('tel')) {
          solutionListItems.add(_buildRow(a));
          solutionListItems.add(new Divider());
          if (a['category'] != null || a['category'] != 'null') {
            if (a['category'] is List<String>) {
              for (String s in a['category']) {
                if (solutionsByType[s] == null) {
                  solutionsByType.putIfAbsent(
                      s, () => new List<Map<String, dynamic>>());
                }
                solutionsByType[s].add(a);
              }
            } else {
              if (solutionsByType['category'] == null) {
                solutionsByType.putIfAbsent(
                    solutionsByType['category'].toString(), () =>
                new List<Map<String, dynamic>>());
              }
              solutionsByType[solutionsByType['category'].toString()].add(a);
            }
          }
        }
      }

      print(solutionsByType['water']);
      return new ListView(
        children: solutionListItems,
      );
    }

    return new ListView();
  }

  Widget _buildDrawer() {
    var headerText = new Text('Header');

    var header = new DrawerHeader(child: headerText,);

    var allSolutions = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('All Solutions'),
    );

    var favorites = new ListTile(
      leading: new Icon(Icons.favorite),
      title: new Text('Favorites'),
    );

    var agricultureTools = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Agriculture & Tools'),
    );

    var energyCooking = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Energy and Cooking'),
    );

    var healthMedical = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Health & Medical Care'),
    );

    var educationConnectivity = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Education & Connectivity'),
    );

    var housingTransport = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Housing & Transport'),
    );

    var waterSanitiation = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Water & Sanitation'),
    );

    var additionalSolutions = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('Additional Solutions'),
    );

    var aboutUs = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('About Us'),
    );

    var children = [
      header,
      allSolutions,
      favorites,
      agricultureTools,
      energyCooking,
      healthMedical,
      educationConnectivity,
      housingTransport,
      waterSanitiation,
      additionalSolutions,
      aboutUs
    ];

    var listView = new ListView(
      children: children
    );

    return new Drawer(child: listView);
  }


  void _favoriesPage() {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              final tiles = _favorites.map(
                      (pair) {
                    final alreadySaved = _favorites.contains(pair);
                    return new ListTile(
                        title: new Text(
                            pair
                        ),
                        trailing: new Icon(
                          alreadySaved ? Icons.favorite : Icons
                              .favorite_border,
                          color: alreadySaved ? Colors.red : null,
                        ),
                        onTap: () {
                          setState(() {
                            if (alreadySaved) {
                              _favorites.remove(pair);
                            } else {
                              _favorites.add(pair);
                            }
                          });
                        }
                    );
                  }
              );

              final divided = ListTile.divideTiles(
                  context: context,
                  tiles: tiles).toList();
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text('Favorites'),
                ),
                body: new ListView(children: divided),
              );
            }));
  }

  Widget buildApp(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('TEL'),
        actions: <Widget>[new IconButton(icon: new Icon(Icons.list),
            tooltip: 'Favorites',
            onPressed: _favoriesPage)
        ],
      ),
      body: _buildListView(),

      drawer: _buildDrawer(),
    );
  }

  @override
  Widget build(BuildContext context) {
    getTelData();
    return buildApp(context);
  }
}