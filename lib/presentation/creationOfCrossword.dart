import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword/models/crossword_model.dart';
import 'package:crossword/presentation/addDescriptions.dart';
import 'package:flutter/material.dart';

class CreationOfCrossword extends StatefulWidget{
  @override
  _CreationOfCrosswordState createState() => _CreationOfCrosswordState();


}

class _CreationOfCrosswordState extends State<CreationOfCrossword>{

  List<TextEditingController> controllers = [];
  List<TextEditingController> controllersForNums = [];
  List<CrosswordModel> descriptions = [];
  List<TextEditingController> descriptionControllers = [];
  TextEditingController titleController = TextEditingController();
  List<int> ids = [];
  generateControllers(){
    for (int i = 0; i < 100; i++){
      controllers.add(TextEditingController());
    }
    for (int j = 0; j < 100; j++){
      controllersForNums.add(TextEditingController());
    }
  }

  addDescriptions(QuerySnapshot<Map<String, dynamic>> words){

    var _list = words.docs.map((item) => CrosswordModel(
        id: item['id'],
        index: item['index'],
        isEmpty: item['isEmpty'],
        symbol: item['symbol'],
        description: item['description'])).toList();

    setState(() {
      descriptions = _list.where((element) => element.index.isNotEmpty).toList();
    });
  }

  createCrossword() async {
    var newCrossword = FirebaseFirestore.instance.collection('crosswords').doc();
    String id = newCrossword.id;
    String title;

    if (titleController.text.trim().isEmpty){
      title = 'New crossword';
    }else{
      title = titleController.text;
    }

    await newCrossword.set({
      'uid': id,
      'title': title,
    });

    for (int i = 0; i < 100; i++){
      bool fieldIsEmpty = false;
      if (controllers[i].text.trim().isEmpty){
        fieldIsEmpty = true;
      }

      if(controllersForNums[i].text.trim().isNotEmpty){
        ids.add(i);
      }
      
      FirebaseFirestore.instance.collection('crosswords').doc(id)
          .collection('details').doc(i.toString()).set({
        'id': i,
        'index': controllersForNums[i].text,
        'isEmpty': fieldIsEmpty,
        'symbol': controllers[i].text,
        'description': '',
      });
      controllers[i].clear();
      controllersForNums[i].clear();
    }
     var allWords = await FirebaseFirestore.instance.collection('crosswords').doc(id)
    .collection('details').orderBy('id', descending: true).get();

        addDescriptions(allWords);

        

    titleController.clear();

    Navigator.push(context, MaterialPageRoute(builder: (context) => AddDescription(length: descriptions.length, uid: id, ids: ids,)));

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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 500,
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Введите название кроссворда',
                      hintStyle: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    createCrossword();

                  },
                  child: Icon(Icons.save),
                )
              ],
            ),
          automaticallyImplyLeading: false,

        ),
        body: Padding(
          padding: EdgeInsets.all(30),
          child: GridView.count(
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
            crossAxisCount: 10,
            children: List.generate(100, (index) {
              return Container(
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
                                child: TextField(
                                  controller: controllersForNums[index],
                                  style: TextStyle(color: Colors.black, fontSize: 12),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  )
              );

            }),
          ),
        )
    );
  }
}