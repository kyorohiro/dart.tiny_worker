library tiny_worker_webdev;

import 'dart:async';
import 'dart:js' as js;

import 'tiny_worker.dart' as base;
import 'dart:html' as html;

import 'package:js/js.dart' as pjs;
import 'package:js/js_util.dart' as js_util;


// Masked type: ServiceWorkerGlobalScope
@pjs.JS('self')
external dynamic get globalScopeSelf;
void jsSendMessage(dynamic m) {
  js.context.callMethod('postMessage',m);
}

Stream<T> callbackToStream<J, T>(
    dynamic object, String name, T Function(J jsValue) unwrapValue) {
  var controller = StreamController<T>.broadcast(sync: true);
  js_util.setProperty(object, name, js.allowInterop((J event) {
    controller.add(unwrapValue(event));
  }));
  return controller.stream;
}


class Worker implements base.Worker {
  StreamController<dynamic> _outputController;
  Worker(){
    _outputController = StreamController();
    callbackToStream(globalScopeSelf, 'onmessage', (html.MessageEvent e)  {
      _outputController.add(js_util.getProperty(e, 'data'));
    });
  }
  @override
  Stream onReceive() => _outputController.stream;

  @override
  void sendMessage(message) {
    jsSendMessage(message);
  }  
}

class WorkerController implements base.WorkerController{
  html.Worker _worker;
  StreamController<dynamic> _outputController;

  static Future<WorkerController> spawn(String path) async  {
    var controller = WorkerController();
    controller._outputController = StreamController();
    path = (path.endsWith('.dart')? path+'.js': path);
    controller._worker = html.Worker(path);
    controller._worker.onMessage.listen((event) {
      controller._outputController.add(event.data);
    });
    return controller;
  }

  @override
  Future waitByInitialized() {
  }

  @override
  void sendMessage(dynamic message) {
    _worker.postMessage(message);
  }

  @override
  Stream<dynamic> onReceive() {
    return _outputController.stream;
  }

  @override
  void kill() {
    _worker.terminate();
  }
}