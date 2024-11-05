import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';


class WebSocketService {
  static final WebSocketService _instance = WebSocketService._internal();
  factory WebSocketService() => _instance;

  WebSocketChannel? _channel;
 
  final Map<String, StreamController<dynamic>> _controllers = {};

  WebSocketService._internal();

  dynamic selected = "";

  void connect(String url) {
    _channel = HtmlWebSocketChannel.connect(Uri.parse("http://localhost:8080/$url"));
    // _channel = HtmlWebSocketChannel.connect(Uri.parse("ws://localhost:60061/$url"));
    // _channel = HtmlWebSocketChannel.connect(Uri.parse("ws://187.122.102.36:60061/$url"));
    // _channel = HtmlWebSocketChannel.connect(Uri.parse("ws://191.252.3.43:60061/$url"));
    _channel!.stream.listen(
      (message) {
        final decodedMessage = jsonDecode(message);

        final tipo = decodedMessage['tipo'];
        print(tipo);
        if (_controllers.containsKey(tipo)) {
          _controllers[tipo]!.add(decodedMessage);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
      },
      onDone: () {
        print('WebSocket connection closed');
      },
    );
  }

  Stream<dynamic> getChannelStream(String channel) {
    if (!_controllers.containsKey(channel)) {
      _controllers[channel] = StreamController<dynamic>.broadcast();
    }
    return _controllers[channel]!.stream;
  }

  sendMessage(String tipo, dynamic dados) {
    final message = jsonEncode({"tipo": tipo, "dados": dados});
    _channel!.sink.add(message);
  }

  sendMessagePickingList(String tipo, dynamic dados, String? bytes) {
    final message = jsonEncode({"tipo": tipo, "dados": dados, "picking_list": bytes});
    _channel!.sink.add(message);
  }

  void selecionarLinha(String tipo, dynamic dados) {
    final message = jsonEncode({
      "tipo": tipo,
      "dados": {"linha_id": dados}
    });
    _channel!.sink.add(message);
  }

 sendItemEdit(String tipo, dynamic dados) {
  final message = jsonEncode({
    "tipo": tipo,
    "dados": jsonDecode(dados)  
  });
  _channel!.sink.add(message);  
}

  sendItemToEdit(dynamic dados) {
    selected = dados;
  }

  void disconnect() {
    _channel?.sink.close();
    _controllers.forEach((_, controller) => controller.close());
  }
}
