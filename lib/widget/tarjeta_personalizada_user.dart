import 'package:flutter/material.dart';

class TarjetaPersonalizadaUser extends StatelessWidget {
  const TarjetaPersonalizadaUser({
    Key? key,
    required this.name,
    required this.photoUrl,
    required this.description,
    required this.price,
    required this.OnPedirPressed, 
  }) : super(key: key);

  final String name;
  final String photoUrl;
  final String description;
  final double price;
  final Function( ) OnPedirPressed;

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
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      name,
                      style: const TextStyle(
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
          //Precio y boton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 5.0,
                  
                ),
                Text(
                  '${price.toStringAsFixed(2)}€',
                  //BOLD
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  //mas ancho
                  
                  
                  onPressed: () {
                    OnPedirPressed();
                  },
                  child: const Text('Pedir Bocadillo'),
                  style: ElevatedButton.styleFrom(
                    //Más ancho
                    minimumSize: const Size(150, 40),
                    //Margen derecho
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      


                    ),
                  ),
                ),
                
              ],
            ),
          ),


        ],
      ),
    );
  }
}
