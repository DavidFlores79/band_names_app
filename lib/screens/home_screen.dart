import 'dart:io';

import 'package:band_names_app/models/bands.dart';
import 'package:band_names_app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '1', name: 'Heroes del Silencio', votes: 8),
    Band(id: '1', name: 'Bon Jovi', votes: 3),
    Band(id: '1', name: 'ACDC', votes: 15),
  ];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on(
        'active-bands',
        (payload) => {
              print('listao de bandas'),
              bands =
                  (payload as List).map((band) => Band.fromMap(band)).toList(),
              setState(() {})
            });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Names'),
        centerTitle: true,
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) {
          final band = bands[index];

          return BandCard(band: band);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBand() {
    print('New Band');

    final textController = new TextEditingController();

    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text('New Band Name'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add Band'),
                onPressed: () => saveNewBand(textController.text, context),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New Band Name'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                textColor: Colors.blue,
                child: const Text('Add'),
                onPressed: () => saveNewBand(textController.text, context),
              )
            ],
          );
        },
      );
    }
  }

  saveNewBand(String text, BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    if (text.isEmpty) return;

    final band = Band(
      id: DateTime.now().toString(),
      name: text,
      votes: 0,
    );
    bands.add(band);
    socketService.socket.emit('add-band', {
      'id': band.id,
      'name': band.name,
      'votes': band.votes,
    });
    setState(() {});
    Navigator.pop(context);
  }
}

class BandCard extends StatefulWidget {
  const BandCard({
    super.key,
    required this.band,
  });

  final Band band;

  @override
  State<BandCard> createState() => _BandCardState();
}

class _BandCardState extends State<BandCard> {
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
        print(widget.band.name);
        socketService.socket.emit('remove-band', widget.band.id);
      },
      background: Container(
        padding: const EdgeInsets.only(left: 10),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Delete Band',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      key: Key(widget.band.id),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(widget.band.name.substring(0, 2)),
        ),
        title: Text(widget.band.name),
        trailing: Text('${widget.band.votes}'),
        onTap: () {
          print(widget.band.id);
          socketService.socket.emit('vote-band', widget.band.id);
        },
      ),
    );
  }
}
