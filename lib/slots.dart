import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Slot extends StatefulWidget {
  final List slots;
  const Slot({Key key, this.slots}) : super(key: key);

  @override
  _SlotState createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Available Slots'),
            Opacity(
              opacity: 0,
              child: Container(
                  padding: EdgeInsets.symmetric(), child: Icon(Icons.ac_unit)),
            )
          ],
        ),
        actions: <Widget>[
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(),
              child: Icon(Icons.save_alt),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
            itemCount: widget.slots.length,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10),
                height: 270,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Center ID: ' +
                          widget.slots[index]['center_id'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Hospital Name: ' +
                          widget.slots[index]['name'].toString(),
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Address: ' + widget.slots[index]['address'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    Divider(),
                    Text(
                      'Vaccine Name: ' +
                          widget.slots[index]['vaccine'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Fee Type: ' + widget.slots[index]['fee_type'].toString(),
                      style: TextStyle(fontSize: 18),
                    ),
                    Text('Slots: ' + widget.slots[index]['slots'].toString(),
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
