import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Rect rect = Rect.fromCenter(
    center: MediaQueryData.fromView(WidgetsBinding.instance.window)
        .size
        .center(Offset.zero),
    width: 200,
    height: 200,
  );

  String selectedShape = 'Circle';
  final List<String> shapes = ['Circle', 'Rectangle', 'Triangle'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shape Transform Canvas"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shapes.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () =>
                        setState(() => selectedShape = shapes[index]),
                    child: Text(shapes[index]),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                TransformableBox(
                  rect: rect,
                  clampingRect: Offset.zero & MediaQuery.sizeOf(context),
                  onChanged: (result, event) {
                    setState(() {
                      rect = result.rect;
                    });
                  },
                  contentBuilder: (context, rect, flip) {
                    return CustomPaint(
                      painter: ShapePainter(selectedShape, rect),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShapePainter extends CustomPainter {
  final String shape;
  final Rect rect;
  ShapePainter(this.shape, this.rect);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    switch (shape) {
      case 'Circle':
        canvas.drawOval(rect, paint);
        break;
      case 'Rectangle':
        canvas.drawRect(rect, paint);
        break;
      case 'Triangle':
        final path = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.left, rect.bottom)
          ..lineTo(rect.right, rect.bottom)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
