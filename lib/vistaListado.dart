import 'package:flutter/material.dart';
import 'package:drift/native.dart';
import 'package:semana14_repaso_l/database/database.dart';
import 'package:drift/drift.dart' as dr;

class vistaListado extends StatefulWidget {
  const vistaListado({Key? key}) : super(key: key);

  @override
  State<vistaListado> createState() => _vistaListadoState();
}

class _vistaListadoState extends State<vistaListado> {

  @override
  Widget build(BuildContext context) {
    final database = AppDatabase(NativeDatabase.memory());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          }, icon: Icon(
            Icons.chevron_left
        ),
        ),
        title: Text('Listado de Post'),
      ),

      body: FutureBuilder<List<PosteoData>>(
        future: database.getListado(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PosteoData>? postList = snapshot.data;
            return ListView.builder(
                itemCount: postList!.length,
                itemBuilder: (context, index) {
                  PosteoData postData = postList[index];
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Icon(Icons.delete_forever),
                    ),
                    key: ValueKey<int>(postData.id),
                    onDismissed: (DismissDirection direction) async {
                      await database.eliminarPost(postData.id);
                      setState(() {
                        postList.remove(postList[index]);
                      });
                    },


                    child: Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width*1,
                        child:Row(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width*0.8,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Codigo: " +
                                        postList[index].id.toString()),
                                    Text("Title: " + postList[index].title),
                                    Text("Body: " + postList[index].body),
                                  ],
                                ),
                              ),
                            ),


                            ElevatedButton(
                                onPressed: (){
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top:Radius.circular(20),
                                        )
                                      ),
                                      context: context,
                                      builder: (context)=>
                                            buildSheet(postData,database),
                                  );

                                }, child: Text('Editar'))
                          ],
                        ),
                      ),
                    ),
                  );
                }
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: Text(''),
            );
          }
        },
      ),
    );
  }

  Widget buildSheet(PosteoData postData, AppDatabase database) =>
      Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Text('Codigo: ${postData.id}'),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: '${postData.userId}',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: '${postData.title}',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: '${postData.body}',
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: (){
                        Navigator.pop(context);
                    },
                    child: Text('Editar')),
              ],
            ),
          ),
      );

}