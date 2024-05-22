import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class MyPhysicalKeyExample extends StatefulWidget {
  const MyPhysicalKeyExample({Key? key}) : super(key: key);

  @override
  State<MyPhysicalKeyExample> createState() => _MyPhysicalKeyExampleState();
}

class _MyPhysicalKeyExampleState extends State<MyPhysicalKeyExample> {
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<String> _enteredNumbersNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    // Request focus when the widget is first initialized
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _enteredNumbersNotifier.dispose();
    super.dispose();
  }


  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    // Check if the event is a RawKeyDownEvent
    final logicalKey = event.logicalKey;
    // Check if the key is a numeric key and the entered numbers length is less than 6
    if (RegExp('[0-9]').hasMatch(logicalKey.keyLabel!) &&
        _enteredNumbersNotifier.value.length < 6) {
      // Append numeric keys to the entered numbers
      _enteredNumbersNotifier.value += logicalKey.keyLabel!;
    }
    return KeyEventResult.handled;
  }
  void _clearEnteredNumbers() {
    _enteredNumbersNotifier.value = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: DefaultTextStyle(
        style:const TextStyle(fontSize: 16,color: Colors.red),
        child: Focus(
          focusNode: _focusNode,
          onKeyEvent: (node, event) => _handleKeyEvent(node, event),

          // onKey: _handleKeyEvent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListenableBuilder(
                listenable: _enteredNumbersNotifier,
                builder: (context, enteredNumbers) {
                  return Text(
                    'Entered Numbers: ${_enteredNumbersNotifier.value.padRight(6, ' ')}',
                    textAlign: TextAlign.center,
                  );
                },
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _clearEnteredNumbers,
                child: Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () {
                  print(_enteredNumbersNotifier.value.padRight(6, ' '));
                  print(Platform.isWindows);
                },
                child: Text('Print'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
