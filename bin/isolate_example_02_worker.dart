import 'dart:isolate' as iso;

Future main() async {
  var receivePort = iso.ReceivePort();
  iso.Isolate.spawn(workerMain, receivePort.sendPort);

  receivePort.listen((message) {
    print("host: ${message}");
  });
}

workerMain(sendPort) async { 
    for(var message in ["01","02","03"]) {
        (sendPort as iso.SendPort).send(message);
        await Future.delayed(Duration(seconds: 1));
    }
}
