
import 'package:info.kyorohiro.dart.tiny_worker/tiny_worker_webdev.dart' as tw;

void main() {
  print('Worker created');
  var worker = tw.Worker();
  worker.onReceive().listen((data) {
    print('worker: onMessage ${data}');
    worker.sendMessage("callack: ${data}");
  });
}