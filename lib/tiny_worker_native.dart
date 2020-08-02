import 'tiny_worker.dart' as base;
import 'dart:async';
import 'dart:ffi';
import 'dart:isolate' as iso;


class Worker implements base.Worker {
  iso.SendPort _sendPort;
  iso.ReceivePort _receivePort;
  Worker(_sendPort) {
    _receivePort = iso.ReceivePort();
    _sendPort.send(_receivePort.sendPort);
  }

  void sendMessage(dynamic message) { 
    _sendPort.send(message);
  }

  Stream<dynamic> onReceive()=> _receivePort;
}



class WorkerController implements base.WorkerController {
  bool _initialized = false;
  iso.ReceivePort _receivePort;
  iso.Isolate _isolate;
  iso.SendPort  _sendPort;
  StreamController<dynamic> _outputController;
  StreamController<dynamic> _inputController;
  Completer<Void> _initializedCompleter;
  List<dynamic> messageCache = [];
  bool get initialized => _initialized;

  static Future<WorkerController> spawn(String path) async  {
    var controller = WorkerController();
    var isolate =  await iso.Isolate.spawnUri(
        Uri.file(path), [], controller._receivePort.sendPort);
    controller._isolate = isolate;
    return controller;
  }

  Future waitByInitialized() async {
    if(initialized) {
      return;
    }
    await _initializedCompleter.future;
  }

  WorkerController() {
    _initializedCompleter = Completer();
    _outputController = StreamController();
    _inputController = StreamController();
    _receivePort = iso.ReceivePort();

    _receivePort.listen((message) {
      if(initialized) {
        _outputController.add(message);
        return;
      }
      if(message is iso.SendPort) {
        _sendPort = message;
        for(var m in messageCache) {
          _sendPort.send(m);
        }
        _initialized = true;
        _initializedCompleter.complete();
      }
    }, onError: (e){
      _outputController.addError(e);
    }); 
  }

  void sendMessage(dynamic message) { 
    if(!_initialized) {
      messageCache.add(message);
    } else {
      _inputController.add(message);
    }
  }

  Stream<dynamic> onReceive() => _outputController.stream;

  void kill() {
    _isolate.kill();
  }
}
