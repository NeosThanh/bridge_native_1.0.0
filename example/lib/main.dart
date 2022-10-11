import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:base_core/vn.educa.cores/utils/utils.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String keyOpenSearch = 'keyOpenSearch';
  static const String keyOpenPhoto = 'keyOpenPhoto';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Native Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? path;

  @override
  void initState() {
    super.initState();
    EventChannel stream = const EventChannel('bridgeStream');
    stream.receiveBroadcastStream().listen((onData) {
      log('receiveBroadcastStream data from NATIVE: $onData');
      if (onData == null || onData! is int && onData! is double) {
        log("Error: bridgeStream: You didn't get data!");
        return;
      }
      doNativeDataBack(onData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  _openCamera();
                },
                tooltip: 'Capture',
                child: const Icon(Icons.camera_alt),
              ),
              FloatingActionButton(
                onPressed: () {
                  _openGallery();
                },
                tooltip: 'Search',
                child: const Icon(Icons.search_sharp),
              ),
              if (path != null) Image.file(File(path!))
            ],
          ),
        ));
  }

  void _openGallery() {
    sendToNative(key: MyApp.keyOpenSearch, data: {"url": "https://www.24h.com.vn/"});
  }

  void _openCamera() async {
    sendToNative(key: MyApp.keyOpenPhoto).then((value) {
      log("_openCamera: ${value.key}");
      log("_openCamera: ${value.data}");
    });
  }

  void doNativeDataBack(onData) {
    setState(() {
      path = onData;
    });
  }
}
