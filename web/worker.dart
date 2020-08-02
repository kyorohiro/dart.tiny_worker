import 'dart:async';

import 'package:info.kyorohiro.dart.tiny_worker/tiny_worker_webdev.dart' as tw;
import 'package:js/js.dart';
import 'package:js/js_util.dart' as js_util;


// Masked type: ServiceWorkerGlobalScope
@JS('self')
external dynamic get globalScopeSelf;

Stream<T> callbackToStream<J, T>(
    dynamic object, String name, T unwrapValue(J jsValue)) {
  // ignore: close_sinks
  StreamController<T> controller = new StreamController.broadcast(sync: true);
  js_util.setProperty(object, name, allowInterop((J event) {
    controller.add(unwrapValue(event));
  }));
  return controller.stream;
}


void main() {
  print('Worker created');
  var worker = tw.Worker();
  worker.onReceive().listen((event) {
    print('worker: onMessage ${event}');
  });
/*
  callbackToStream(globalScopeSelf, "onmessage", (e)  {
    print('worker: onMessage ${e}');
  });
  
*/
}