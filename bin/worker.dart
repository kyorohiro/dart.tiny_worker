import 'package:info.kyorohiro.dart.tiny_worker/tiny_worker_native.dart' as tw;
import 'dart:isolate' as iso;

Future<int> main(List<String> args, iso.SendPort sendPort) async {
  var worker = tw.Worker(sendPort);
  worker.onReceive().listen((event) {
    print("worker: receive message!!");
  });  

  return 0;
}


