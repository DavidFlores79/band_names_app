import 'package:band_names_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusScreen extends StatelessWidget {
  static const routeName = 'status';

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Names'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketService.serverStatus}'),
            MaterialButton(
              child: const Text('Hola Mundo!'),
              onPressed: () => socketService.emitMessage('Hola mundo!!'),
            )
          ],
        ),
      ),
    );
  }
}
