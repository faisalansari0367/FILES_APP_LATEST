import 'dart:async';
import 'dart:isolate';

class Worker {
  Worker() {
    _start();
  }

  Isolate _isolate;
  SendPort childSendPort;
  final _isReady = Completer<void>();
  Future<void> get isReady => _isReady.future;

  Future<void> _start() async {
    final ReceivePort receivePort = ReceivePort();
    final ReceivePort errorPort = ReceivePort();

    _isolate = await Isolate.spawn(workerIsolate, receivePort.sendPort,
        onError: errorPort.sendPort);
    errorPort.listen(print);
    childSendPort = await receivePort.first;
    _isReady.complete();
  }

  static workerIsolate(SendPort mainSendPort) async {
    ReceivePort childReceivePort = ReceivePort();
    mainSendPort.send(childReceivePort.sendPort);

    await for (var message in childReceivePort) {
      SendPort replyPort = message[1];

      try {
        var data = message[0];
        final bool isStream = data['isStream'];
        final Function function = data['fun'];
        final args = data['args'];
        if (isStream) {
          var stream = function(args);
          stream.listen((event) {
            replyPort.send(event);
          }, onDone: () {
            print('done');
            replyPort.send('done');
          });
        } else {
          final result = await function(args);
          replyPort.send(result);
        }
      } catch (e) {
        // if (e is StackTrace) print(e.toString());
        // if (e is StackTrace) replyPort.send(e.toString());
        replyPort.send(e);
        // replyPort.
      }
    }
  }

  Future<dynamic> doWork(Function function, args, {isStream: false}) async {
    await isReady;
    final ReceivePort responsePort = ReceivePort();
    final Map map = {'fun': function, "args": args, "isStream": isStream};
    childSendPort.send([map, responsePort.sendPort]);
    // responsePort.listen((message) { }, on)
    var response = await responsePort.first;

    if (response is Exception) {
      throw response;
    } else if (response is StackTrace) {
      return response;
    } else {
      return response;
    }
  }

  Future<dynamic> doOperation(Function function, args, {isStream: true}) async {
    await isReady;
    final ReceivePort responsePort = ReceivePort();
    final Map map = {'fun': function, "args": args, "isStream": isStream};
    childSendPort.send([map, responsePort.sendPort]);
    return responsePort;
  }

  void stop() {
    _isolate.kill();
  }
}
