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
      trailing: new Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (isFavorite) {
            _favorites.remove(solution['name']);
          } else {
            _favorites.add(solution['name']);
          }
        });
      },

    );
  }

  Widget _buildListView() {
    List<Widget> solutionListItems = new List();

    if (data != null) {
      for (Map<String, dynamic> a in data['Solutions']) {
        if (a.containsKey('publish') && a['publish'].contains('tel')) {
          solutionListItems.add(_buildRow(a));
          solutionListItems.add(new Divider());
        }
      }
      return new ListView(
        children: solutionListItems,
      );
    }

    return new ListView();
  }

    Widget _buildDrawer() {
      List<Widget> solutionListItems = new List();

      if (data != null) {
        solutionListItems.add(
            new ListTile(
              title: new Text('Favorites'),
              leading: new Icon(Icons.favorite, color: Colors.red,),
            )
        );
      }

      return new ListView(children: solutionListItems);
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

//        drawer: _buildDrawer(),
        );
    }

    @override
    Widget build(BuildContext context) {
      getTelData();
      return buildApp(context);
    }
  }