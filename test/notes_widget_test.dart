import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:note_taking_tdd/cubit/notes_cubit.dart';
import 'package:note_taking_tdd/model/note.dart';
import 'package:note_taking_tdd/new_notes_page.dart';
import 'package:note_taking_tdd/notes_page.dart';

void main(){
  
  group('Notes Page', (){
    // _pumpTestWidgets(WidgetTester tester, NotesCubit cubit) => tester.pumpWidget(
    //   MaterialApp(
    //     home: NotesPage(
    //       title : 'Home',
    //       notesCubit : cubit
    //     ),
    //   )
    // );
    
    testWidgets('empty state', (WidgetTester tester) async {

      await tester.pumpWidget( MaterialApp(
        home: NotesPage(
            title : 'Home',
            notesCubit : NotesCubit()
        ),
      ));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);

    });

    testWidgets('update the list when a Note is added', (WidgetTester tester) async{

      var cubit = NotesCubit();
      await tester.pumpWidget( MaterialApp(
        home: NotesPage(
            title : 'Home',
            notesCubit : cubit
        ),
      ));

      var expectedTitle = 'Note Title';
      var expectedBody = 'Note Body';
      
      cubit.createNote(expectedTitle, expectedBody);
      cubit.createNote('another title', 'another body');
      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text(expectedTitle), findsOneWidget);
      expect(find.text(expectedBody), findsOneWidget);

    });

    testWidgets('Navigate to new Note page', (WidgetTester tester) async{

      var cubit = NotesCubit();
      await tester.pumpWidget( MaterialApp(
        home: NotesPage(
            title : 'Home',
            notesCubit : cubit
        ),
      ));
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(NewNotePage), findsOneWidget);
    });
  });

  testWidgets('empty state of Note creation', (WidgetTester tester) async{
    var cubit = NotesCubit();

    await tester.pumpWidget(MaterialApp(
      home: NewNotePage(
        // title: 'Home',
        notesCubit: cubit,
      ),
    ));

    expect(find.text('Enter Your Text Here...'), findsOneWidget);
    expect(find.text('Enter Title'), findsOneWidget);
    var widgetFinder = find.widgetWithIcon(IconButton, Icons.delete);
    var deleteButton = widgetFinder.evaluate().single.widget as IconButton;
    expect(deleteButton.onPressed, isNull);
  });

  testWidgets('Note Creation', (WidgetTester tester) async{
    var cubit = NotesCubit();

    await tester.pumpWidget(MaterialApp(
      home: NewNotePage(
        notesCubit: cubit,
      ),
    ));

    await tester.enterText(find.byKey(ValueKey('title')), 'Hi');
    await tester.enterText(find.byKey(ValueKey('body')), 'There');
    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();
    
    expect(cubit.state.notes, isNotEmpty);
    var note = cubit.state.notes.first;
    expect(note.title, 'Hi');
    expect(note.body, 'There');
    expect(find.byType(NewNotePage), findsNothing);
  });

  testWidgets('navigate to new note page in edit mode', (WidgetTester tester) async{

    var cubit = NotesCubit();

    await tester.pumpWidget(MaterialApp(
      home: NotesPage(
        notesCubit: cubit,
      ),
    ));

    var expectedTitle = 'note title';
    var expectedBody = 'note body';

    cubit.createNote(expectedTitle, expectedBody);
    await tester.pump();
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    
    expect(find.byType(NewNotePage), findsOneWidget);
    expect(find.text(expectedTitle), findsOneWidget);
    expect(find.text(expectedBody), findsOneWidget);

  });

  testWidgets('create note in edit mode', (WidgetTester tester) async{

    var cubit = NotesCubit();
    var note = Note(1, 'my title', 'my body');

    await tester.pumpWidget(MaterialApp(
      home: NewNotePage(
        notesCubit: cubit,
        note: note
      ),
    ));
    
    expect(find.text(note.title), findsOneWidget);
    expect(find.text(note.body), findsOneWidget);
    var widgetFinder = find.widgetWithIcon(IconButton, Icons.delete);
    var deleteButton = widgetFinder.evaluate().single.widget as IconButton;
    expect(deleteButton.onPressed, isNotNull);
  });

  testWidgets('edit Note', (WidgetTester tester) async{
    var cubit = NotesCubit()..createNote('my title', 'my body');

    await tester.pumpWidget(MaterialApp(
      home: NewNotePage(
          notesCubit: cubit,
          note: cubit.state.notes.first
      ),
    ));

    await tester.enterText(find.byKey(ValueKey('title')), 'hi');
    await tester.enterText(find.byKey(ValueKey('body')), 'there');
    await tester.tap(find.byType(RaisedButton));
    await tester.pumpAndSettle();

    expect(cubit.state.notes, isNotEmpty);
    var note = cubit.state.notes.first;
    expect(note.title, 'hi');
    expect(note.body, 'there');
    expect(find.byType(NewNotePage), findsNothing);
  });

  testWidgets('delete a note', (WidgetTester tester) async{

    var cubit = NotesCubit()..createNote('my title', 'my body');

    await tester.pumpWidget(MaterialApp(
      home: NewNotePage(
          notesCubit: cubit,
          note: cubit.state.notes.first
      ),
    ));

    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(cubit.state.notes, isEmpty);
    expect(find.byType(NewNotePage), findsNothing);
  });
}