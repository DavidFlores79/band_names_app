import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

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
    IO.Socket socket = IO.io('http://192.168.100.8:3001', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.onConnect((_) {
      print('connect');
      serverStatus = ServerStatus.Online;
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) {
      print('disconnect');
      serverStatus = ServerStatus.Offline;
    });
    socket.on('fromServer', (_) => print(_));
  }
}
