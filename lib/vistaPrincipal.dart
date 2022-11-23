import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:semana14_repaso_l/api/post.dart';
import 'package:semana14_repaso_l/api/service.dart';
import 'package:semana14_repaso_l/database/database.dart';
/*Librerias Drift*/
import 'package:drift/drift.dart' as dr;
import 'package:semana14_repaso_l/database/database.dart';
import 'package:semana14_repaso_l/vistaListado.dart';

class vistaPrincipal extends StatefulWidget {
  const vistaPrincipal({Key? key}) : super(key: key);

  @override
  State<vistaPrincipal> createState() => _vistaPrincipalState();
}

class _vistaPrincipalState extends State<vistaPrincipal> {

  final TextEditingController txtId=TextEditingController();
  late Future<Post> _futurePost;

  @override
  void initState() {
    super.initState();
    _futurePost=Service.listaPost();
  }

  @override
  Widget build(BuildContext context) {

    final database=AppDatabase(NativeDatabase.memory());

    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Post'),
      ),
      body: Container(
        child: FutureBuilder<Post>(
          future: _futurePost,
          builder: (context, snapshot){
            if(snapshot.hasData){
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  TextFormField(
                    controller: txtId,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText: 'Ingrese Id',
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _futurePost=Service.consultaPost(txtId.text);
                        });
                      },
                      child: Text("Realizar Consulta"),
                 ),


                  Text("Id: "+snapshot.data!.id.toString()),
                  Text("Title: "+snapshot.data!.title.toString()),
                  Text("Body: "+snapshot.data!.body.toString()),
                  ElevatedButton(
                      onPressed: (){
                        database.insertarPost(
                          PosteoCompanion(
                            id:dr.Value(snapshot.data!.id),
                            userId:dr.Value(snapshot.data!.userId),
                            title:dr.Value(snapshot.data!.title),
                            body:dr.Value(snapshot.data!.body),
                          )).then((value) {
                            Navigator.push(context,
                            MaterialPageRoute(builder:
                                (context)=>vistaListado()));
                        });
                      }, child: Text('Grabar Usuario')),
                ],  );
            }else{
              return Text('Error: ${snapshot.error}');
            }  },
        ),
      ),
    );
  }
}














