import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_tdd/cubit/notes_cubit.dart';

void main(){
  
  group('Notes Page', (){
    _pumpTestWidgets(WidgetTester tester, NotesCubit cubit) => tester.pumpWidget(
      MaterialApp(
        home: NotesPage(
          title : 'Home',
          notesCubit : cubit
        ),
      )
    );
  });
}