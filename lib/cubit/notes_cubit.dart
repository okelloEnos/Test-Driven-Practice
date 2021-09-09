import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_tdd/model/note.dart';

class NotesState{
  final UnmodifiableListView notes;
  NotesState(this.notes);
}

class NotesCubit extends Cubit<NotesState>{

  List _notes = [];
  int autoIncrementedId = 0;

  NotesCubit() : super(NotesState(UnmodifiableListView([])));

  void createNote(String title, String body){
    _notes.add(Note(++autoIncrementedId, title, body));
    emit(NotesState(UnmodifiableListView(_notes)));
  }

  void deleteNote(int id){
    _notes = _notes.where((element) => element.id != id).toList();
    emit(NotesState(UnmodifiableListView(_notes)));
  }

  void updateNote(int id, String title, String body){
    var notesIndex = _notes.indexWhere((element) => element.id == id);
    _notes.replaceRange(notesIndex, notesIndex + 1, [Note(id, title, body)]);
    emit(NotesState(UnmodifiableListView(_notes)));
  }
}