import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_image/native_image.dart';

void main() {
  runApp(const MyApp());
}

/// [MyApp]
class MyApp extends StatefulWidget {
  /// Constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Uint8List? _imageData;

  Future<void> loadImage() async {
    final ByteData bytes =
        await rootBundle.load('assets/the_forbidden_leg.jpg');

    setState(() {
      _imageData = bytes.buffer.asUint8List();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Image Plugin example'),
        ),
        body: Center(
          child: Column(
            children: [
              if (_imageData != null) Image.memory(_imageData!),
              TextButton(
                onPressed: () => loadImage(),
                child: const Text('Reload'),
              ),
              TextButton(
                onPressed: () async {
                  if (_imageData != null) {
                    final data = await NativeImage().cropImage(
                      bytes: _imageData!,
                      width: 1,
                      height: 1,
                    );

                    setState(() {
                      _imageData = data;
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Null image data 😮'),
                    ));
                  }
                },
                child: const Text('Crop'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
