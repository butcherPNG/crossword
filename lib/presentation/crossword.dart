import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword/models/crossword_model.dart';
import 'package:crossword/presentation/addDescriptions.dart';
import 'package:flutter/material.dart';

class Crossword extends StatefulWidget{
  final String title;
  final String uid;
  final List<CrosswordModel> fields;
  final List<String> descriptions;
  Crossword({
    required this.title,
    required this.uid,
    required this.fields,
    required this.descriptions
  });


  @override
  _CrosswordState createState() => _CrosswordState();


}

class _CrosswordState extends State<Crossword>{

  List<TextEditingController> controllers = [];


  List<int> ids = [];

  generateControllers(){
    for (int i = 0; i < 100; i++){
      controllers.add(TextEditingController());
    }

  }

  @override
  void initState() {
    generateControllers();
    print(widget.fields.length);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView.builder(
            itemCount: widget.descriptions.length,
            itemBuilder: (context, index){
              return DrawerHeader(
                  child: Text('Слово ${index + 1}: ${widget.descriptions[index]}')
              );
            }
        ),
      ),
        appBar: AppBar(
            title: Text('${widget.title}'),

        ),

        body: Padding(
          padding: EdgeInsets.all(30),
          child: GridView.count(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
            crossAxisCount: 10,
            children: List.generate(100, (index) {
              return widget.fields[index].isEmpty == true ? Container(
                width: 20,
                height: 20,
                color: Colors.black,
              ) :
              Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    border: Border.all(

                    )
                  ),
                  child: Center(
                      child: Stack(
                        children: [
                          TextField(
                            controller: controllers[index],
                            style: TextStyle(fontSize: 25, color: Colors.black),
                            decoration: InputDecoration(
                                hintText: '$index',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 40)
                            ),

                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Container(
                              width: 35,
                              height: 35,

                              child: Center(
                                child: Text('${widget.fields[index].index}', style: TextStyle(color: Colors.black, fontSize: 12),),
                              ),
                            ),
                          )
                        ],
                      )
                  )
              );

            }),
          ),
        ),

    );
  }
}