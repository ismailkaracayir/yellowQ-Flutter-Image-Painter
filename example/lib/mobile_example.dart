import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_painter/image_painter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class MobileExample extends StatefulWidget {
  const MobileExample({Key? key}) : super(key: key);

  @override
  State<MobileExample> createState() => _MobileExampleState();
}

class _MobileExampleState extends State<MobileExample> {
  // Sadece beyaz renkte, opaklığı 0.3 olacak şekilde ayarlandı.
  final ImagePainterController _controller = ImagePainterController(
      color: Colors.white.withOpacity(0.5),
      strokeWidth: 40,
      mode: PaintMode.freeStyle,
      text: 'ssss');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Painter Example"),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            onPressed: saveImage,
          )
        ],
      ),
      // Renk seçme işlevi kapatıldı.
      body: ImagePainter.asset(
        "assets/sample.png",
        brushIcon: const Icon(Icons.linear_scale_sharp),
        colorIcon: const SizedBox(),
        clearAllIcon: Text(
          'sil',
        ),
        scalable: true,

        controller:
            _controller, // Eğer yazı eklemeyi de devre dışı bırakmak isterseniz burayı kaldırabilirsiniz.
      ),
    );
  }

  void saveImage() async {
    final image = await _controller.exportImage();
    final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
    final directory = (await getApplicationDocumentsDirectory()).path;
    await Directory('$directory/sample').create(recursive: true);
    final fullPath = '$directory/sample/$imageName';
    final imgFile = File('$fullPath');
    if (image != null) {
      imgFile.writeAsBytesSync(image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey[700],
          padding: const EdgeInsets.only(left: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Image Exported successfully.",
                  style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () => OpenFile.open("$fullPath"),
                child: Text(
                  "Open",
                  style: TextStyle(
                    color: Colors.blue[200],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
