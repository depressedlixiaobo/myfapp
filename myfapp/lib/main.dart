import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(new MyApp());

 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      home:  new RandomWords()
    );
  }
}


class RandomWords extends StatefulWidget {
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  //样式
   final _biggerFont = const TextStyle(fontSize: 18.0);

   final _suggestions = <WordPair>[];

   final _saved = new Set<WordPair>();

  Widget _buildSuggestions(){
    return new ListView.builder(
      padding:const EdgeInsets.all(16.0),
      itemBuilder:(context,i){
        if(i.isOdd){
          return new Divider();
        }else{
           final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
      }
    );
  }
  Widget _buildRow(pair){
     final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
         color:alreadySaved ? Colors.red:null
      ),
      onTap: (){
        setState(() {
                 if(alreadySaved){
                   _saved.remove(pair);
                 }else{
                   _saved.add(pair);
                 }
                });
      },
    );
  }

  void _pushSaved() {
     Navigator.of(context).push(
    new MaterialPageRoute(
      builder: (context) {
        final tiles = _saved.map(
          (pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
          .toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );
      },
    ),
  );
  }
  @override
  Widget build(BuildContext context) {
     return new Scaffold(
       appBar: new AppBar(
         title: new Text('Startup Name Generator'),
         actions: <Widget>[
            new IconButton(icon: new Icon(Icons.list),onPressed: _pushSaved,)
         ],
       ),
       body: _buildSuggestions(),
     );
  }
}