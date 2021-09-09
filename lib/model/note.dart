import 'package:equatable/equatable.dart';

class Note extends Equatable{
  final int id;
  final String title;
  final String body;

  Note(this.id, this.title, this.body);

  @override
  // TODO: implement props
  List<Object> get props => [id, title, body];


}