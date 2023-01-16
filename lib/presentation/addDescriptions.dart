import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword/models/crossword_model.dart';
import 'package:flutter/material.dart';

class AddDescription extends StatefulWidget{

  final int length;
  final String uid;
  final List<int> ids;
  AddDescription({
    required this.length,
    required this.uid,
    required this.ids,
  });

  @override
  _AddDescriptionState createState() => _AddDescriptionState();


}

class _AddDescriptionState extends State<AddDescription>{


  List<TextEditingController> descriptionControllers = [];

  generateControllers(){
    for (int i = 0; i < widget.length; i++){
      descriptionControllers.add(TextEditingController());
    }

  }

  save() async {


    for (int i = 0; i < widget.length; i++){
      FirebaseFirestore.instance.collection('crosswords')
          .doc(widget.uid).collection('details').doc(widget.ids[i].toString())
          .update({
        'description': descriptionControllers[i].text
      });
    }


  }



  @override
  void initState() {
    generateControllers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
            title: Text('Добавьте описание'),
            automaticallyImplyLeading: false,
        ),

        body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Flexible(child: ListView.builder(

                  itemCount: widget.length,
                  itemBuilder: (context, index){
                    return  TextField(
                      controller: descriptionControllers[index],
                      decoration: InputDecoration(
                          hintText: 'Добавьте описание к слову ${index + 1}'
                      ),
                    );
                  }
              ),),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: (){
                      save();
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text('Сохранить и выйти')
                ),
              )
            ],
          )
        )
    );
  }
}