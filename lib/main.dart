import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final wordPair = new WordPair.random();
    return MaterialApp(
      title: 'Welcome to Flutter',
      //主题样式
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Welcome to Flutter'),
//        ),
//        body: new Center(
////          child: new Text('Hello World'),
////          child: new Text(wordPair.asPascalCase),
//            child: new RandomWords(),
//        ),
//      ),
    home: new RandomWords(),
    );
  }
}
class RandomWords extends StatefulWidget {
  @override
  // ignore: expected_token
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    final wordpair = new WordPair.random();
//    return new Text(wordpair.asPascalCase);
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        //当用户点击列表图标时，包含收藏夹的新路由页面入栈显示
        //某些widget属性需要单个widget（child），而其它一些属性，如action，
        // 需要一组widgets(children），用方括号[]表示
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>(); //每行添加可点击的心形图标
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该行书湖添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd) return new Divider();

          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // ...接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair) {

    //添加 alreadySaved来检查确保单词对还没有添加到收藏夹中
    final alreadySaved = _saved.contains(pair);
    
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(   
        //添加一个心形 ❤️ 图标到 ListTiles以启用收藏功能
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {   
        // 如果单词条目已经添加到收藏夹中， 再次点击它将其从收藏夹中删除。
        // 当心形❤️图标被点击时，函数调用setState()通知框架状态已经改变
        // 调用setState() 会为State对象触发build()方法，从而导致对UI的更新
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    //新页面的内容在在MaterialPageRoute的builder属性中构建，builder是一个匿名函数。
    //添加Navigator.push调用，这会使路由入栈（以后路由入栈均指推入到导航管理器的栈）
    Navigator.of(context).push(
      //添加MaterialPageRoute及其builder。 
      new MaterialPageRoute(
        builder: (context) {
          // 添加生成ListTile行的代码。
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
          // ListTile的divideTiles()方法在每个ListTile之间添加1像素的分割线。
          // 该 divided 变量持有最终的列表项。
          final divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();
          //builder返回一个Scaffold，其中包含名为“Saved Suggestions”的新路由的应用栏。 
          // 新路由的body由包含ListTiles行的ListView组成; 每行之间通过一个分隔线分隔
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
  
  
}