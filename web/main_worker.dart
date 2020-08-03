import 'dart:html' as html;

main() async {
  if(html.Worker.supported) {
      var myWorker = new html.Worker("ww.dart.js");
      myWorker.onMessage.listen((event) {
        print("main:receive: ${event.data}");
      });
      myWorker.postMessage("Hello!!");
  } else {
    print('Your browser doesn\'t support web workers.');
  }
}

