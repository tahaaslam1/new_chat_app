import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class BottomWidget extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onPressed;
  const BottomWidget({
    required this.onPressed,
    required this.messageController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(34, 32, 32, 0.25),
            blurRadius: 54,
            spreadRadius: 0.0,
          )
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              focusNode: FocusNode(),
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Type something.',
                border: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return null;
                }
                return null;
              },
            ),
          ),
          Container(
            height: 48,
            width: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
              // boxShadow: Styles.elevation1,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
