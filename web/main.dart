import 'dart:html';
import 'package:info.kyorohiro.dart.tiny_worker/tiny_worker_webdev.dart' as tw;

void main() async {
  querySelector('#output').text = 'Your Dart app is running.';
  var controller = await tw.WorkerController.spawn('./ww.dart.js');
  controller.onReceive().listen((event) {
    print('first: ${event}');
  });
  print("--1--");
  await Future.delayed(Duration(seconds: 3));
  controller.sendMessage("Hello!!");
  print("--2--");

}
