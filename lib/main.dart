import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:english_words/english_words.dart';

import 'simple_hash_map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple HashMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Simple HashMap'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SimpleHashMap _simpleHashMap = new SimpleHashMap();
  List<SimpleMapEntry> _buckets;

  void put(SimpleHashMap simpleHashMap, WordPair wordPair) {}

  @override
  void initState() {
    final pairs = generateWordPairs().take(5);
    for (final pair in pairs) {
      _simpleHashMap.put(pair.first, pair.second);
    }
    _buckets = _simpleHashMap.getBuckets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text("double click to delete a node"),
            ),
            Expanded(
              // For displaying linked list
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: 900,
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: ListView.builder(
                      itemCount: _buckets.length,
                      itemBuilder: (context, bucketIndex) {
                        SimpleMapEntry node = _buckets[bucketIndex];
                        String text = "";
                        int nodeCount = 0; // linked list length
                        if (node == null) {
                          nodeCount = 1;
                        } else {
                          do {
                            nodeCount++;
                            node = node.next;
                          } while (null != node);
                        }
                        int nodeIndex = 0;
                        return Container(
                          height: 32,
                          child: ListView.builder(
                            itemCount: nodeCount,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              SimpleMapEntry node = _buckets[bucketIndex];
                              if (nodeCount == 1 && node == null) {
                                return MapEntryView(false, false, "[ - ]");
                              }
                              while (index != nodeIndex) {
                                node = node.next; // todo scroll a long list occurs error
                                nodeIndex += 1;
                              }
                              text = node.key + ", " + node.value;
                              bool hasRight = (node.next != null);
                              bool hasLeft = index != 0;
                              String key = node.key;
                              return GestureDetector(
                                  onDoubleTap: () {
                                    setState(() {
                                      _simpleHashMap.remove(key);
                                      _buckets = _simpleHashMap.getBuckets();
                                    });
                                  },
                                  child: MapEntryView(hasLeft, hasRight, text));
                            },
                          ),
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _putNew,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _putNew() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController _keyController = new TextEditingController();
          TextEditingController _valueController = new TextEditingController();
          return AlertDialog(
            title: Text("Add new key-value pair"),
            content: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
                  child: TextField(
                    controller: _keyController,
                    decoration: InputDecoration(
                      hintText: "key",
                    ),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _valueController,
                    decoration: InputDecoration(
                      hintText: "value",
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("random"),
                onPressed: () {
                  setState(() {
                    var pair = generateWordPairs().take(1).elementAt(0);
                    _keyController.text = pair.first;
                    _valueController.text = pair.second;
                  });
                },
              ),
              FlatButton(
                child: Text("Add"),
                onPressed: () {
                  setState(() {
                    _simpleHashMap.put(
                        _keyController.text, _valueController.text);
                    _buckets = _simpleHashMap.getBuckets();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class MapEntryView extends StatelessWidget {
  bool hasLeft, hasNext;
  String text;

  MapEntryView(this.hasLeft, this.hasNext, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 32,
      // padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
      decoration: BoxDecoration(color: Colors.green[200], border: Border.all()),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            child: Text("$text"),
            padding: EdgeInsets.all(4.0),
          )),
          hasNext
              ? Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(border: Border(left: BorderSide())),
                  child: Center(
                      child: Text(
                    "▶",
                    style: TextStyle(fontSize: 18),
                  )))
              : Text("")
        ],
      ),
    );
  }
}
