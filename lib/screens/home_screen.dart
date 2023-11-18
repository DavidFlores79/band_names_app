import 'dart:io';

import 'package:band_names_app/models/bands.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Band Names'),
        centerTitle: true,
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
                onPressed: () => saveNewBand(textController.text),
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
                onPressed: () => saveNewBand(textController.text),
              )
            ],
          );
        },
      );
    }
  }

  saveNewBand(String text) {
    print(text);
    bands.add(
      Band(
        id: DateTime.now().toString(),
        name: text,
        votes: 0,
      ),
    );
    setState(() {});
    Navigator.pop(context);
  }
}

class BandCard extends StatelessWidget {
  const BandCard({
    super.key,
    required this.band,
  });

  final Band band;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(direction);
        print(band.name);
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
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }
}
