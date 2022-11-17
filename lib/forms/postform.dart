import 'package:social_app/services/database.dart';
import 'package:social_app/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/loading.dart';

class PostForm extends StatefulWidget {
  const PostForm({
    Key? key,
  }) : super(key: key);
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  var loading = false;
  var message = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final DatabaseService db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: message,
                showCursor: true,
                minLines: 4,
                maxLines: 10,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Message to Fans',
                    hintText: 'Enter the message for your fans to see.'),
              ),
              verticalSpaceSmall,
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      loading = true;
                      postMessage();
                    });
                  },
                  child: const Text("Post Message")),
              verticalSpaceLarge
            ],
          );
  }

  void postMessage() async {
    var post = message.text.trim();
    if (post.isNotEmpty) {
      User user = auth.currentUser!;
      await db.addPost(user.uid, post, user.displayName!);
      // ignore: use_build_context_synchronously
      snackBar(context, "Message successfully added.");
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      snackBar(context, "Message not formatted properly.");
      setState(() {
        loading = false;
      });
    }
  }
}
