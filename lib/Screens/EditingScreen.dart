import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditingScreen extends StatefulWidget {
  String details;
  EditingScreen({required this.details, super.key});

  @override
  State<EditingScreen> createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.details;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Text"),
        actions: [
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _controller.text));
            },
            icon: Icon(Icons.copy),
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 48, 48, 48),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _controller,
            maxLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
