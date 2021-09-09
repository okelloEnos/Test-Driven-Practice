import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_taking_tdd/cubit/notes_cubit.dart';
import 'package:note_taking_tdd/model/note.dart';
import 'package:note_taking_tdd/new_notes_page.dart';

class NotesPage extends StatelessWidget {
  final String title;
  final NotesCubit notesCubit;

  const NotesPage({Key key, this.title, this.notesCubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
          cubit: notesCubit,
          builder: (context, state){
            return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index){
              var note = state.notes[index];

              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.body),
                onTap: () => _goToNextPage(context, note: note),
              );
            });
          }),
      floatingActionButton: FloatingActionButton(onPressed: () => _goToNextPage(context),
      tooltip: 'Add',
      child: Icon(Icons.add),),
    );
  }

    _goToNextPage(BuildContext context, {Note note}) => Navigator.push(context, MaterialPageRoute(builder: (context) => NewNotePage(notesCubit: notesCubit, note: note,) ));
}
