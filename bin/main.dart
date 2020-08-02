import 'package:info.kyorohiro.dart.tiny_worker/tiny_worker_native.dart' as tw;

Future<int> main(List<String> args) async {
  var controller = await tw.WorkerController.spawn('./worker.dart');

  controller.onReceive().listen((event) {
    print('worker: receive message!!');
  });  
  controller.sendMessage('Hello!!');
  return 0;
}



