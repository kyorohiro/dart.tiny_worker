import 'dart:isolate' as iso;

Future<int> main(List<String> args, iso.SendPort sendPoet) async {
  print("Start Main");
  iso.ReceivePort receivePort = iso.ReceivePort();
  receivePort.listen((message) {
    print("main:receive: ${message}");
    if(message is iso.SendPort) {
      (message as iso.SendPort).send("Hello!! Client");
    }
  });
  
  await iso.Isolate.spawnUri(new Uri.file("./isolate_example_02_worker.dart"), [], receivePort.sendPort);

  return 0;
}


