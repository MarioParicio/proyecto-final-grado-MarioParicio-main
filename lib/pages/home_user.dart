

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter_proyecto_segunda_evaluacion/imports.dart';

import '../service/bocadillo_service.dart';
import '../widget/tarjeta_personalizada_user.dart';


final ZoomDrawerController z = ZoomDrawerController();
//String nombre de la coleccion de la base de datos
final String COLLECTION_NAME = "bocadillos";

 FirebaseAuth _auth = FirebaseAuth.instance;
//Usuario
User? user = _auth.currentUser;
//Datos del usuario to String, relevantes para mostrar en el perfil
 String? photoURL = user?.photoURL.toString();
 String? name = user?.displayName.toString();
 String? email = user?.email.toString();
 String? uid = user?.uid.toString();
final String? phoneNumber = user?.phoneNumber.toString();
final LatLng? cafeteria = LatLng(37.7749, -122.4194);
final ImagePicker _picker = ImagePicker();

class HomeUser extends StatefulWidget {
   HomeUser({Key? key}) : super(key: key);

  //cargar la lista de bocadillos

  @override
  State<HomeUser> createState() => _HomeUserState();
}
void _refreshPage(BuildContext context) {
  Navigator.of(context).pop();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeUser()));
}

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {

        print("construir");
          setState(() {
      _auth = FirebaseAuth.instance;
      user = _auth.currentUser;
      email = user?.email.toString();
      name = user?.displayName.toString();
      photoURL = user?.photoURL.toString();
      

    });


 
    try {
      
    } catch (e) {
      
    }
    return ZoomDrawer(
      controller: z,
      borderRadius: 24,
      style: DrawerStyle.defaultStyle,
      // showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      duration: const Duration(milliseconds: 500),
      // angle: 0.0,
      menuBackgroundColor: Colors.orange.shade200,
      mainScreen: const Body(),
      menuScreen: Theme(
        data: ThemeData.dark(),
        child: Scaffold(
          backgroundColor: Colors.orange.shade200,
          body: Padding(
            padding: EdgeInsets.only(left: 25),
            child: Center(
              child: TextButton(
                onPressed: () {
                  final navigator = Navigator.of(
                    context,
                  );
                  z.close?.call()?.then(
                        (value) => navigator.push(
                          MaterialPageRoute(
                            builder: (_) => TestPage(),
                          ),
                        ),
                      );
                },
                child: SizedBox(
                  //Adaptada al contenido
                  width: 500,
                  height: 250,
                  //Color

                  child: Center(
  child: Card(
    //Color secundario
    color: MyTheme.getTheme().primaryColor,
    child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            backgroundImage: NetworkImage(photoURL ?? ""),
            radius: 50,
            child: photoURL == "null"
              ? Icon(Icons.person, size: 50, color: Colors.white)
              : null,
          ),
          SizedBox(height: 20),
          Text(name ?? "Guess", style: TextStyle(fontSize: 20)),
          Text(email ?? "", style: TextStyle(fontSize: 14)),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              

              
              
              GoogleSignIn().signOut();

              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            //Color secundario
            color: MyTheme.getTheme().colorScheme.secondary,
            iconSize: 30,
          ),
        ],
      ),
    ),
  ),
),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 100),
    value: -1.0,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: TwoPanels(
        controller: controller,
      ),
    );
  }
}

class TwoPanels extends StatefulWidget {
  final AnimationController controller;

  const TwoPanels({Key? key, required this.controller}) : super(key: key);

  @override
  _TwoPanelsState createState() => _TwoPanelsState();
}

class _TwoPanelsState extends State<TwoPanels> with TickerProviderStateMixin {
  List<Bocadillo> _bocadillos = [];
  @override
  void initState() {
    super.initState();
    BocadilloService.fetchBocadillos().then((bocadillos) {
      setState(() {
        _bocadillos = bocadillos;
      });
    });
  }



  static const _headerHeight = 32.0;
  late TabController tabController = TabController(length: 2, vsync: this);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..addListener(() {
      print("SlideValue: ${_controller.value} - ${_controller.status}");
    });
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final _height = constraints.biggest.height;
    final _backPanelHeight = _height - _headerHeight;
    const _frontPanelHeight = -_headerHeight;

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        0.0,
        _backPanelHeight,
        0.0,
        _frontPanelHeight,
      ),
      end: const RelativeRect.fromLTRB(0.0, 100, 0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    tabController.dispose();
    super.dispose();
  }
  void showItemDialogCreate() {
    // 2 - Los EditController necesitan sus controladores asociados

    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _photoUrlController = TextEditingController();
    // 1 - Llamamos a showDialog para abrir una ventana emergente
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    SizedBox(
                        width: 70, child: Icon(Icons.data_object_outlined)),
                    SizedBox(
                        child: Text('Añadir Producto',
                            style: TextStyle(fontSize: 20)))
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Nombre'),
                  controller: _nameController,
                ),
                TextField(
                  decoration: const InputDecoration(
                      labelText: 'Descripción del producto'),
                  controller: _descriptionController,
                ),
                //Boton seleccionar imagen
                ElevatedButton(
                    onPressed: () async {
                      final XFile? pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                          maxWidth: 150);
                      if (pickedFile != null) {
                        _photoUrlController.text =  await BocadilloService.savePhoto(pickedFile);
                      }
                    },
                    child: const Text('Seleccionar imagen')),
                
                TextButton(
                    onPressed: ()async {
                      if(_nameController.text == "" || _descriptionController.text == "" || _photoUrlController.text == ""){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rellena todos los campos'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      print("Añadiendo bocadillo" + _nameController.text);
                      
                          

                      
                      
                    },
                    child:
                        const Text('Añadir', style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    //Usa la función asincrona FetchBocadillos
    //para cargar la lista de bocadillos


    final ThemeData theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: const Text("Bocateria Barea (User)"),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                z.toggle!();
              },
            ),
            bottom: TabBar(
              controller: tabController,
              tabs:  [
                Tab(
                  icon: Icon(Icons.home_filled),
                  text: COLLECTION_NAME,
                  
                ),
                Tab(
                  icon: Icon(Icons.map),
                  text: 'Ubicación',
                ),
                
              ],
            ),
          ),
         
          body: TabBarView(
            controller: tabController,
            children: [
              Container(
                child: Stack(
                  children: [ListView.builder(
                      itemCount: _bocadillos.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  BocadilloService.eliminarBocadillo(_bocadillos[index].uid!);
                                  _refreshPage(context);
                                  // Muestro un Snackbar diciendo que el producto se ha eliminado
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.redAccent,
                                          content: Text(
                                              'Se ha eliminado el producto correctamente')));
                                },
                                backgroundColor: const Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              showItemDialogUpdate(
                                _bocadillos[index].uid,
                                _bocadillos[index].name,
                                _bocadillos[index].description,
                                _bocadillos[index].photoUrl,
                              );
                            },
                            child: TarjetaPersonalizadaUser(
                              description: _bocadillos[index].description,
                              photoUrl: _bocadillos[index].photoUrl,
                              name: _bocadillos[index].name,
                            ),
                          ),
                        );
                      }
                      
                      ),
                      Positioned(
            bottom: 16.0,
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                showItemDialogCreate();
                
              },
              child: Icon(Icons.add),
            ),
          ),
                  ],
                ),
                 
                    
              ),
              
              Container(
                height: 400,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(40.32680728282516, -1.0983658306830777), 
          zoom: 13.0,
          
        ),
        children: [
      TileLayer(
        urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        subdomains: ['a', 'b', 'c']
      ),
      MarkerLayer(
        markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(40.32680728282516, -1.0983658306830777),
            builder: (ctx) =>
            Container(
              child: IconButton(
                icon: Icon(Icons.location_on),
                color: Colors.red,
                iconSize: 45.0,
                onPressed: () {
                  //Mostrar información de la ubicación
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: const [
                                  SizedBox(
                                      width: 70, child: Icon(Icons.data_object_outlined)),
                                  SizedBox(
                                      child: Text('Ubicación',
                                          style: TextStyle(fontSize: 20)))
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text('Cafeteria Segundo de Chomón'),
                              Text('Horario: 10:00 - 14:00 y 17:00 - 21:00'),
                              Text('Teléfono: 976 123 456'),
                              Text('Email: elmanolo@gmail.com '), 
                              ],
                              ),
                              ),
                              ); 
                              }
                              );

                  
                },
              ),
            ),
          ),
        ],
      ),
    ],
        ),
    ),
              
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: bothPanels,
    );
  }


  void showItemDialogUpdate(uid, name, description, photoUrl) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();
    TextEditingController _photoUrlController = TextEditingController();
    TextEditingController _uidController = TextEditingController();
    _nameController.text = name;
    _descriptionController.text = description;
    _photoUrlController.text = photoUrl;
    _uidController.text = uid;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Actualizar Bocadillo"),
            content: Container(
              height: 300,
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Descripción",
                    ),
                  ),
                  SizedBox(height: 10),

                  
                  Image.network(_photoUrlController.text, height: 100,
                  
                 ),
                   ElevatedButton(
                    onPressed: () async {
                      final XFile? pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality: 50,
                          );
                      if (pickedFile != null) {
                        
                        final newPhotoUrl =
                      await BocadilloService.savePhoto(pickedFile);
                      showItemDialogUpdate(
                        _uidController.text,
                        _nameController.text,
                        _descriptionController.text,
                        newPhotoUrl,);
                      
                  
                      }
                    },
                    child: const Text('Cambiar imagen'))
                ],
              ),
            ),
         

            actions: [
              TextButton(
                onPressed: () async{
                  if(_nameController.text == "" || _descriptionController.text == "" || _photoUrlController.text == ""){
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Rellena todos los campos'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                  
                  
                      
                  
                  _refreshPage(context);
                },
                child: Text("Actualizar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
            ],
          );
        });
  }
}

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Test Page !"),
      ),
    );
  }
}
