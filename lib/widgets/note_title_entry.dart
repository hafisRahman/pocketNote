import 'package:flutter/material.dart';
import 'package:pocket_note/constants.dart';

class NoteTitleEntry extends StatelessWidget {
    final _textFieldController;
    

    const NoteTitleEntry(this._textFieldController, {super.key});

    @override
    Widget build(BuildContext context) {
        return TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
                counter: null,
                counterText: "",
                hintText: 'Title',
                hintStyle: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                ),
            ),
            maxLength: 31,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                height: 1.5,
                color: Color(c1),
            ),
            textCapitalization: TextCapitalization.words,
        );
    }   
}