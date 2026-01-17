import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/todo_controller.dart';

class InputCard extends StatefulWidget {
  const InputCard({
    super.key,
    required this.controller,
    required this.textController,
  });

  final TodoController controller;
  final TextEditingController textController;

  @override
  State<InputCard> createState() => _InputCardState();
}

class _InputCardState extends State<InputCard> {
  final _formKey = GlobalKey<FormState>();
  Worker? _inputWorker;

  @override
  void initState() {
    super.initState();
    // Sync text controller when input changes externally (e.g. edit, clear)
    _inputWorker = ever(widget.controller.input, (value) {
      if (widget.textController.text != value) {
        widget.textController.text = value;
        // Keep cursor at end when programmatically setting text
        widget.textController.selection = TextSelection.collapsed(
          offset: value.length,
        );
      }
    });
  }

  @override
  void dispose() {
    _inputWorker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Form(
        key: _formKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Expanded(
              child: TextFormField(
                controller: widget.textController,
                onChanged: widget.controller.onTextChanged,
                onFieldSubmitted: (value) {
                  if (value.trim().isNotEmpty) widget.controller.submit();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Add or search a task...',
                  isDense: true,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 12),
            // SizedBox(
            //   height: 45,
            //   child: Obx(() {
            //     return TextButton.icon(
            //         style: TextButton.styleFrom(
            //           backgroundColor: Theme.of(context).primaryColor,
            //           foregroundColor: Colors.white,
            //           shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //         ),
            //         onPressed: widget.controller.input.isEmpty
            //             ? null
            //             : widget.controller.submit,

            //         icon: Icon(
            //           widget.controller.editingId == null
            //               ? Icons.add
            //               : Icons.check,
            //         ),
            //         label: Text(
            //           widget.controller.editingId == null
            //               ? 'Add'
            //               : 'Update',
            //         ),
            //       );
            //   }),
            // ),
          ],
        ),
      ),
    );
  }
}
