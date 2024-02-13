import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final void Function(bool?) onChanged;
  final bool isChecked;
  final void Function()? onClosePressed;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onChanged,
    required this.isChecked,
    this.onClosePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: isChecked,
                onChanged: onChanged,
              ),
              const Text('De acuerdo'),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: isChecked ? () {
            if (onClosePressed != null) {
              onClosePressed!();
            }
            Navigator.of(context).pop();
          } : null,
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
