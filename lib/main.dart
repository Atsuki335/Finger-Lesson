import 'dart:math';
import 'package:flutter/material.dart';

// ライブラリのインポート
// main関数の定義（エントリーポイント）
// 基本のアプリ構造の定義（テーマ、タイトル)
// ゲームの主要なウィジェットの定義
// UIの構築
//丸を描画するカスタムペインターの定義
//再描画の制御

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'タッチするゲーム',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
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
    double containerWidth = 300.0; // Containerの幅
    double containerHeight = 600.0; // Containerの高さ
    double circleRadius = 50.0; // 丸の半径
    _circles.clear();
    for (int i = 0; i < 4; i++) {
      Offset position;
      do {
        //丸がContainer内に収まるように調整
        double x = circleRadius +
            _random.nextDouble() * (containerWidth - 2 * circleRadius);
        double y = circleRadius +
            _random.nextDouble() * (containerHeight - 2 * circleRadius);
        position = Offset(x, y);
      } while (_circles.any((circle) =>
          (circle.position - position).distance < 2 * circleRadius));
      _circles.add(CircleData(position, ' ${i + 1}'));
    }
    setState(() {});
  }

//GestureDetectorウィジェットを使って四角をタップしたときに新しいランダムな位置に
//丸を表示する処理をトリガー
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80),
          child: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(' 鍛えたい指で押してね',
                    style: TextStyle(fontFamily: 'にくまる', fontSize: 25)),
                Icon(
                  Icons.touch_app,
                  size: 45,
                ),
              ],
            ),
          )),
      body: Center(
        //タップに反応するウィジェット
        child: GestureDetector(
          onTapDown: (details) {
            for (int i = 0; i < _circles.length; i++) {
              if ((details.localPosition - _circles[i].position).distance <
                  50) {
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
            width: 400,
            height: 700,
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
    final circlePaint = Paint()..color = Color.fromARGB(255, 122, 189, 244);
    final textPainter = TextPainter(
        textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    for (var circle in circles) {
      canvas.drawCircle(circle.position, 50, circlePaint);
      textPainter.text = TextSpan(
          text: circle.label,
          style:
              TextStyle(color: Colors.white, fontSize: 45, fontFamily: 'にくまる'));
      textPainter.layout();
      final offset = circle.position -
          Offset(textPainter.width * 0.7, textPainter.height * 0.5);

      textPainter.paint(canvas, offset
          // circle.position -
          //     Offset(textPainter.width / 2, textPainter.height / 2)
          );
    }
  }

//再描画の制御、trueを返すとpaintメソッドが呼び出され描画内容が更新される。
//再描画が必要な時だけtrueを返すようにする
//oldDelegate 前回のCustomPainterの状態を参照し比較、再描画が必要かどうか判断される
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//丸のデータを保持する
class CircleData {
  final Offset position;
  final String label;

  CircleData(this.position, this.label);
}
