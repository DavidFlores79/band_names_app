import 'package:band_names_app/models/bands.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  IO.Socket get socket => _socket;

  set socket(IO.Socket value) {
    _socket = value;
  }

  ServerStatus get serverStatus => _serverStatus;

  set serverStatus(ServerStatus value) {
    _serverStatus = value;
    notifyListeners();
  }

  SocketService() {
    print('Socket Service Inicializado!');
    _initConfig();
  }

  void _initConfig() {
    socket = IO.io('http://192.168.100.8:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('connected to Server');
      serverStatus = ServerStatus.Online;
    });
    socket.on('message', (data) => print(data));

    socket.onDisconnect((_) {
      print('Lost Server Connection!!');
      serverStatus = ServerStatus.Offline;
    });
    socket.on('fromServer', (_) => print(_));
  }

  emitMessage(String message) {
    socket.emit('flutter-message', {'type': 'Fluter', 'message': message});
  }
}
