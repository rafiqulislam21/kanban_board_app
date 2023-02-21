import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final bool? required;
  final int? maxLines;

  const CustomTextField(
      {Key? key,
      this.hintText,
      this.controller,
      this.required = false,
      this.maxLines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        autofocus: true,
        validator: required == false
            ? null
            : (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
        decoration: InputDecoration(
            hintText: hintText ?? "Enter your input here ...",
            border: const OutlineInputBorder(),
            isDense: true,
            label: Text(hintText ?? "")),
      ),
    );
  }
}
