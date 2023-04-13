import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class TarjetaPersonalizada extends StatefulWidget {
   TarjetaPersonalizada({
    Key? key,
    required this.uid,
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.price,
    required this.active,
    required this.index,
    required this.onSwitchChanged, 
  }) : super(key: key);

  final String uid;
  final String name;
  final String photoUrl;
  final String description;
  final double price;
  final bool active;
  final int index;
  final Function(int index, bool active) onSwitchChanged;

  @override
  _TarjetaPersonalizadaState createState() => _TarjetaPersonalizadaState();
}

class _TarjetaPersonalizadaState extends State<TarjetaPersonalizada> {
  bool _bocadillosActive = false;

  @override
  void initState() {
    super.initState();
    _bocadillosActive = widget.active;
  }





  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200.0,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FadeInImage(
                  image: NetworkImage(widget.photoUrl),
                  placeholder: const AssetImage('assets/placeHolderBocadillo.jpeg'),
                  fadeInDuration: const Duration(milliseconds: 300),
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              widget.description,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 10.0),
          
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Text(
              'Precio: \$${widget.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Spacer(),
                Text('Activado: '),
               Switch(
  value: _bocadillosActive,
  onChanged: (bool value) {
    setState(() {
      _bocadillosActive = value;
    });

    FirebaseFirestore.instance
        .collection('bocadillos')
        .doc(widget.uid)
        .update({'active': _bocadillosActive});

    // Call the callback function
    widget.onSwitchChanged(widget.index, _bocadillosActive);
  },
  activeColor: Colors.green,
  inactiveThumbColor: Colors.red,
  inactiveTrackColor: Colors.red.shade100,
),
              ],
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
