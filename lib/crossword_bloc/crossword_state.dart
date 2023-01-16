part of 'crossword_bloc.dart';

@immutable
abstract class CrosswordState {}

class CrosswordInitial extends CrosswordState {}

class CrosswordsLoadedState extends CrosswordState {
  final List<CrosswordDocModel> crosswords;

  CrosswordsLoadedState(this.crosswords);
}

class CrosswordLoadingState extends CrosswordState {}
