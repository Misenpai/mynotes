import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/generic/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textEditingControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNotes(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textEditingControllerListener);
    _textEditingController.addListener(_textEditingControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNotes(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteTextIfTextIsEmpty() {
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null) {
      _notesService.deletenotes(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNotes(documentId: note.documentId, text: text);
    }
  }

  @override
  void dispose() {
    _deleteTextIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    hintText: 'Start typing your note....'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
