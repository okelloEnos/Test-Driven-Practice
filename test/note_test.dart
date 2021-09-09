import 'package:note_taking_tdd/cubit/notes_cubit.dart';
import 'package:note_taking_tdd/model/note.dart';
import 'package:test/test.dart';
void main(){
 group('Notes Cubit', (){
   
  test('default is empty', (){
   var cubit = NotesCubit();
   expect(cubit.state.notes, []);
  });

  test('add Note', (){
   var title = 'title';
   var body = 'body';
   var cubit = NotesCubit();
   cubit.createNote(title, body);
   expect(cubit.state.notes.length, 1);
   expect(cubit.state.notes.first, Note(1, title, body));
  });
 });

 test('delete Note', (){
  var cubit = NotesCubit();
  cubit.createNote('title', 'body');
  cubit.createNote('anotherTitle', 'anotherBody');
  cubit.deleteNote(1);
  expect(cubit.state.notes.length, 1);
  expect(cubit.state.notes.first.id, 2);

 });

 test('update note', (){
  var cubit = NotesCubit();
  cubit.createNote('title', 'body');
  cubit.createNote('anotherTitle', 'anotherBody');
  cubit.createNote('yet another title', 'yet another body');

  var newTitle = 'Cool title';
  var newBody = 'Cool Note Body';

  cubit.updateNote(2, newTitle, newBody);
  expect(cubit.state.notes.length, 3);
  expect(cubit.state.notes[1], Note(2, newTitle, newBody));

 });
}