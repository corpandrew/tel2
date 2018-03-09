import 'dart:async';

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

  var _telData;
  final _favorites = new Set<String>();

  Future<Null> getTelData() async {
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

        setState(() {
          _telData = JSON.decode(responseBody);
        });

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
        solution['image'].toString().endsWith('.gif')
            ? 'images/e41sag8-coolbot-image-v2.jpg'
            : solution['image'].toString().replaceAll('ast/', 'images/'),
        width: 100.0,
        height: 50.0,
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
      onTap: () => solutionPage,
      subtitle: new Text(
          solution['#contact']['name'] == null
              ? ''
              : solution['#contact']['name'],
        softWrap: false,
      ),
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

    if (_telData != null) {
      for (Map<String, dynamic> a in _telData['Solutions']) {
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

      return new ListView(
        children: solutionListItems,
      );
    }

    return new ListView();
  }

  Widget _buildDrawer() {
    var headerImage = new Image.asset('images/icons/header.png');

    var header = new DrawerHeader(child: headerImage,);

    var allSolutions = new ListTile(
      leading: new Icon(Icons.archive),
      title: new Text('All Solutions'),
    );

    var favorites = new ListTile(
      leading: new Icon(Icons.favorite),
      title: new Text('Favorites'),
    );

    var agricultureTools = new ListTile(
      leading: new Image.asset(
        'images/icons/agriculture.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Agriculture & Tools'),
    );

    var energyCooking = new ListTile(
      leading: new Image.asset(
        'images/icons/energy.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Energy and Cooking'),
    );

    var healthMedical = new ListTile(
      leading: new Image.asset(
        'images/icons/medical.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Health & Medical Care'),
    );

    var educationConnectivity = new ListTile(
      leading: new Image.asset(
        'images/icons/education.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Education & Connectivity'),
    );

    var housingTransport = new ListTile(
      leading: new Image.asset(
        'images/icons/housing.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Housing & Transport'),
    );

    var waterSanitiation = new ListTile(
      leading: new Image.asset(
        'images/icons/water.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Water & Sanitation'),
    );

    var additionalSolutions = new ListTile(
      leading: new Image.asset(
        'images/icons/other.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
      title: new Text('Additional Solutions'),
    );

    var aboutUs = new ListTile(
      leading: new Image.asset(
        'images/icons/energy.png',
        width: 24.0,
        height: 24.0,
        color: Colors.grey,
      ),
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

    var listView = new ListView(children: wrapColor(children,Colors.white),);

    return new Drawer(child: listView, );
  }

  void solutionPage(Map<String, dynamic> solutionMap) {
    Navigator.of(context).push(
        new MaterialPageRoute(
            builder: (context) {
              return new Scaffold(
                appBar: new AppBar(
                  title: new Text(solutionMap['name']),
                ),
                body: new ListView(children: <Widget>[],),
              );
            }
        )
    );
  }

  List<Widget> wrapColor(List<Widget> list, Color color) {

    List<Widget> colorWidgetList = new List();

    for (Widget widget in list) {
      Widget currentWidget = new Container(child: widget, color: color,);
      colorWidgetList.add(currentWidget);
    }

    return colorWidgetList;
  }

  void _favoritesPage() {
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
            }
        )
    );
  }

  Widget buildApp(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('TEL'),
        actions: <Widget>[new IconButton(icon: new Icon(Icons.list),
            tooltip: 'Favorites',
            onPressed: _favoritesPage)
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