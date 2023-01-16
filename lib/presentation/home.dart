

import 'package:crossword/crossword_bloc/crossword_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crossword/models/crossword_model.dart';
import 'package:crossword/presentation/creationOfCrossword.dart';
import 'package:crossword/presentation/crossword.dart';
import 'package:flutter/material.dart';

import '../models/crossword_description_model.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();


}

class _HomeState extends State<Home>{



  // List<CrosswordDocModel> allCrosswords = [];
  List<String> descriptions = [];


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final crosswordsBloc = CrosswordBloc()..add(GetCrosswordsEvent());
    return BlocProvider(
        create: (context) => crosswordsBloc,

        child: Scaffold(
            appBar: AppBar(
              title: Text('Все кроссворды'),
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreationOfCrossword()));
              },
              child: Icon(Icons.add),
            ),
            body: SafeArea(
              child: BlocBuilder<CrosswordBloc, CrosswordState>(
                bloc: crosswordsBloc,
                builder: (context, state){
                  return Column(
                    children: [
                      if (state is CrosswordsLoadedState)
                          Flexible(
                          child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                              ),
                              itemCount: state.crosswords.length,
                              itemBuilder: (context, index) {
                                return Container(
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          List<CrosswordModel> fields = [];
                                          var doc = await FirebaseFirestore.instance
                                              .collection('crosswords').doc(
                                              state.crosswords[index].uid).collection(
                                              'details')
                                              .orderBy('id', descending: false).get();
                                          doc.docs.forEach((element) {
                                            if (element.data()['index'] != '') {
                                              descriptions.add(
                                                  element.data()['description']);
                                            }
                                            fields.add(CrosswordModel(
                                                id: element.data()['id'],
                                                index: element.data()['index'],
                                                isEmpty: element.data()['isEmpty'],
                                                symbol: element.data()['symbol'],
                                                description: element
                                                    .data()['description']
                                            ));
                                          });

                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) =>
                                                  Crossword(
                                                    title: state.crosswords[index]
                                                        .title,
                                                    uid: state.crosswords[index].uid,
                                                    fields: fields,
                                                    descriptions: descriptions,
                                                  )));
                                        },
                                        child: Text(
                                            'Открыть "${state.crosswords[index]
                                                .title}"'),
                                      ),
                                    )
                                );
                              }
                          ),
                      ),
                      if (state is CrosswordLoadingState)
                          Center(child: CircularProgressIndicator())
                    ],
                  );



                },
              ),
            )
        )
    );
  }
}

