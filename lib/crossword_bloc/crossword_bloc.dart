import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../models/crossword_description_model.dart';

part 'crossword_event.dart';
part 'crossword_state.dart';

class CrosswordBloc extends Bloc<CrosswordEvent, CrosswordState> {
  CrosswordBloc() : super(CrosswordInitial()) {
    on<GetCrosswordsEvent>(_onGetCrosswords);
  }

  _onGetCrosswords(GetCrosswordsEvent event, Emitter<CrosswordState> emit) async {
    // emit(CrosswordLoadingState());
      List<CrosswordDocModel> allCrosswords = [];
       await FirebaseFirestore.instance.collection('crosswords').doc().get().then((value) {
         FirebaseFirestore.instance.collection('crosswords').snapshots()
             .listen((snapshot) {
           for (var element in snapshot.docs) {
             allCrosswords.add(CrosswordDocModel(uid: element.data()['uid'], title: element.data()['title']));
           }
         });
         print(allCrosswords);
         emit(CrosswordsLoadedState(allCrosswords));
      });





  }
}
