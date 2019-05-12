import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audio_cache.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
        backgroundColor: Colors.indigo,
      ),
      home: ColorGame(),
    );
  }
}

class ColorGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ColorGameState();
}

class ColorGameState extends State<ColorGame> {
  final Map<String, bool> score = {};

  final Map choices = {
    '🍏': Colors.green,
    '🍋': Colors.yellow,
    '🍓': Colors.red,
    '🍇': Colors.purple,
    '🐱': Colors.brown,
    '🍊': Colors.orange,
  };

  int seed = 0;

  AudioCache _audiocontroller = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Score ${score.length} / 6'),
        backgroundColor: Colors.pink,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            score.clear();
            seed++;
          });
        },
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: choices.keys.map((emoji) {
                        return Draggable<String>(
                          data: emoji,
                          child: Emoji(
                            emoji: score[emoji] == true ? '✔' : emoji,
                            size: 50
                          ),
                          feedback: Emoji(emoji: emoji, size: 70),
                          childWhenDragging: Emoji(emoji: '😲', size: 50),
                        );
                      }).toList()))),
          Expanded(
              flex: 7,
              child: Container(
                  margin: EdgeInsets.only(right: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: choices.keys                                                
                        .map((target) => _buildDragTarget(target))
                        .toList()                        
                          ..shuffle(Random(seed)),
                  ))),
        ],
      ),
    );
  }

  Widget _buildDragTarget(String target) {
    print(score[target]);
    return DragTarget<String>(
      builder: (BuildContext context, List<String> incoming, List reject) {
        if (score[target] == true) {
          return Container(
            color: Colors.white,
            child: Text('✔', style: TextStyle(fontSize: 35)),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[target],
            height: 80,
            width: 180,
          );
        }
      },
      onAccept: (data) {
        if (data == target) {
          setState(() {
            score[target] = true;
            seed++;
          });
          _audiocontroller.play('success.mp3');
        }else{
          _audiocontroller.play('failed.mp3');
        }
      },      
    );
  }
}

class Emoji extends StatelessWidget {
  Emoji({Key key, this.emoji, this.size}) : super(key: key);

  final String emoji;
  final double size;

  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        padding: EdgeInsets.all(10),
        child: Text(
          emoji,
          style: TextStyle(color: Colors.black, fontSize: size),
        ),
      ),
    );
  }
}
