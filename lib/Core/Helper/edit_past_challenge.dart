import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditChallenge extends StatelessWidget {
  const EditChallenge({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.deepPurple, backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.deepPurple, width: 1.0),
          ),
          child: const Text('Edit'),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.deepPurple, backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.deepPurple, width: 1.0),
          ),
          child: const Text('Past Challenges'),
        ),
      ],
    );
  }
}
