import 'package:flutter/material.dart';

class TarjetaPersonalizada extends StatelessWidget {
  const TarjetaPersonalizada({
    Key? key,
    required this.name,
    required this.photoUrl,
    required this.description,
  }) : super(key: key);

  final String name;
  final String photoUrl;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      //shadowColor: Colors.orange,
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
                  image: NetworkImage(photoUrl),
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
                      name,
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
              description,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
