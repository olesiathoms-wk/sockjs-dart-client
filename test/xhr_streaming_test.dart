@TestOn('browser')
library sockjs_client.test.sockjs_client_test;

import 'dart:async';

import 'package:sockjs_client/sockjs_client.dart';
import 'package:test/test.dart';


void main() {
  group('Xhr Receiver', () {
    test('broadcasts message on chunk', () async {
      XhrReceiver xhrReceiver = XhrReceiverFactory("foo", MockMockXHRCorsObjectFactory);

      Completer msgCompleter = new Completer();
      xhrReceiver.onMessage.listen((e) {
        if (e.data == "some text") {
          msgCompleter.complete();
        }
      });

      xhrReceiver.xo.dispatch(new StatusEvent("chunk", 200, "some text\n"));
      await msgCompleter.future;
    });

    test('broadcasts message and close on finish', () async {
      XhrReceiver xhrReceiver = XhrReceiverFactory("foo", MockMockXHRCorsObjectFactory);

      Completer msgCompleter = new Completer();
      Completer closeCompleter = new Completer();

      xhrReceiver.onMessage.listen((e) {
        if (e.data == "some text") {
          msgCompleter.complete();
        }
      });
      xhrReceiver.onClose.listen((e) {
        closeCompleter.complete();
      });

      xhrReceiver.xo.dispatch(new StatusEvent("finish", 200, "some text\n"));
      await msgCompleter.future;
      await closeCompleter.future;
    });
  });
}


MockMockXHRCorsObjectFactory(String method, String baseUrl, {bool noCredentials, payload}) => new MockXHRCorsObject();
class MockXHRCorsObject extends AbstractXHRObject {
  MockXHRCorsObject();
}
