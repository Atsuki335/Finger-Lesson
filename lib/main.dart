import 'dart:math';
import 'package:flutter/material.dart';

// ライブラリのインポート
// main関数の定義（エントリーポイント）
// 基本のアプリ構造の定義（テーマ、タイトル)
// ゲームの主要なウィジェットの定義
// UIの構築
//丸を描画するカスタムペインターの定義

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Circles Game',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RandomCircles(),
    );
  }
}
//丸の位置が変わる。状態変化するからstateful

class RandomCircles extends StatefulWidget {
  @override
  _RandomCirclesState createState() => _RandomCirclesState();
}

//具体的なゲームの状態やロジックを管理するクラス

class _RandomCirclesState extends State<RandomCircles> {
  //Randomインスタンスの作成（dart:mathライブラリに含まれている）
  final Random _random = Random();
  //４つの丸の位置（x、y）を保持するリスト
  List<CircleData> _circles = [];

  @override
  void initState() {
    super.initState();
    _generateRandomCircles();
  }

//ランダムな位置を生成して丸を表示するための座標をリストに追加
  _generateRandomCircles() {
    _circles.clear();
    for (int i = 0; i < 4; i++) {
      Offset position;
      do {
        //四角の幅と高さ
        double x = _random.nextDouble() * 250; // 50のマージンを追加して被りを防ぐ
        double y = _random.nextDouble() * 550; //こっちも
        position = Offset(x, y);
      } while (
          _circles.any((circle) => (circle.position - position).distance < 50));
      _circles.add(CircleData(position, ' ${i + 1}'));
    }
    setState(() {});
  }

//GestureDetectorウィジェットを使って四角をタップしたときに新しいランダムな位置に
//丸を表示する処理をトリガー
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Circles Game')),
      body: Center(
        //タップに反応するウィジェット
        child: GestureDetector(
          onTapDown: (details) {
            for (int i = 0; i < _circles.length; i++) {
              if ((details.localPosition - _circles[i].position).distance <
                  25) {
                setState(() {
                  _circles.removeAt(i);
                });
                break;
              }
            }
            if (_circles.isEmpty) {
              _generateRandomCircles();
            }
          },
          child: Container(
            width: 300,
            height: 600,
            color: Colors.grey[200],
            child: CustomPaint(
              painter: CirclePainter(_circles),
            ),
          ),
        ),
      ),
    );
  }
}
//指定された位置に丸を描画するためにCustomPainterを使用
//paintメソッドではcircleOffsetsリストに基づいて丸を描画している

class CirclePainter extends CustomPainter {
  final List<CircleData> circles;
  CirclePainter(this.circles);

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()..color = Colors.blue;
    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    for (var circle in circles) {
      canvas.drawCircle(circle.position, 25, circlePaint);
      textPainter.text = TextSpan(
          text: circle.label,
          style: TextStyle(color: Colors.white, fontSize: 14));
      textPainter.layout();
      textPainter.paint(
          canvas,
          circle.position -
              Offset(textPainter.width / 2, textPainter.height / 2));
    }
  }

//再描画の制御、trueを返すとpaintメソッドが呼び出され描画内容が更新される。
//再描画が必要な時だけtrueを返すようにする
//oldDelegate 前回のCustomPainterの状態を参照し比較、再描画が必要かどうか判断される
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CircleData {
  final Offset position;
  final String label;

  CircleData(this.position, this.label);
}
