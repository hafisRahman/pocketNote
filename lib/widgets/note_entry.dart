import 'package:flutter/material.dart';

class NoteEntry extends StatelessWidget {
    final _textFieldController;

    const NoteEntry(this._textFieldController, {super.key});

    @override
    Widget build(BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
                controller: _textFieldController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: null,
                style: const TextStyle(
                    fontSize: 19,
                    height: 1.5,
                ),
            ),
        );
    }
}