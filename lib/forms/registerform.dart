import 'package:file_picker/file_picker.dart';
import 'package:social_app/forms/loginform.dart';
import 'package:social_app/services/database.dart';
import 'package:social_app/storage_service.dart';
import 'package:social_app/shared.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:social_app/widgets/image_password.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  int _index = -1;
  List Images = [
    "https://cdn.pocket-lint.com/r/s/970x/assets/images/159037-cars-news-is-this-what-the-apple-car-will-look-like-image1-n1v8icryom-jpg.webp",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRLhc2QCjHIORjlVA-GFxCT-CGFgVCiNRh6g&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw-dpg2xCoEzrBm8gSc68pbrWxDXn3bCg_uQ&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpM7iD-1sBDdCzdfMQvYuyTaFihWdHpmCeBg&usqp=CAU",
    "https://cdn.pocket-lint.com/r/s/970x/assets/images/159037-cars-news-is-this-what-the-apple-car-will-look-like-image1-n1v8icryom-jpg.webp",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRLhc2QCjHIORjlVA-GFxCT-CGFgVCiNRh6g&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQw-dpg2xCoEzrBm8gSc68pbrWxDXn3bCg_uQ&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpM7iD-1sBDdCzdfMQvYuyTaFihWdHpmCeBg&usqp=CAU"
  ];

  callBack(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Positioned(
              top: 50,
              child: SizedBox(
                  height: 120,
                  width: 200,
                  child: Image.asset(
                    'assets/images/spongebob.png',
                  ))),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Social Zone",
                style: TextStyle(fontSize: 40, fontFamily: "Signatra"),
              )
            ],
          ),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 18),
            TextFormField(
              controller: _email,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Email cannot be empty";
                }
                if (!value.contains('@')) {
                  return "Email in wrong format";
                }
                return null;
              },
            ),
            fun_PasswordImages(_index, Images, callBack),
            TextFormField(
              textAlign: TextAlign.center,
              controller: _username,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'Enter the name you want your friends to see'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username cannot be empty";
                }
                return null;
              },
            ),
            OutlinedButton(
                onPressed: () {
                  setState(() {
                    loading = true;
                    register();
                  });
                },
                child: const Text("REGISTER")),
            verticalSpaceSmall,
            TextButton(
                onPressed: showLogin,
                child: const Text(
                  'Already have an account? Log in here.',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                )),
            ElevatedButton(
              onPressed: () async {
                final results = await FilePicker.platform.pickFiles(
                  allowMultiple: true,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg'],
                );

                if (results == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No file selected'),
                    ),
                  );
                  return null;
                }
                final path = results.files.single.path!;
                final fileName = results.files.single.name;

                storage
                    .uploadFile(path, fileName)
                    .then((value) => print('Done'));
              },
              child: Text('Upload File'),
            ),
            FutureBuilder(
              future: storage.listFiles(),
              builder: (BuildContext context,
                  AsyncSnapshot<firebase_storage.ListResult> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(snapshot.data!.items[index].name),
                            ),
                          );
                        },
                      ));
                }
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return CircularProgressIndicator();
                }
                return Container();
              },
            ),
            FutureBuilder(
                future: storage.downloadURL('image1.jpg'),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {}
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      !snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  return Container();
                })
          ]),
        ],
      ),
    );
  }

  Future<void> register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential registerResponse =
            await _auth.createUserWithEmailAndPassword(
                email: _email.text, password: _password.text);

        registerResponse.user!.updateDisplayName(_username.text);

        _db
            .setUser(registerResponse.user!.uid, _username.text, _email.text,
                _bio.text)
            .then((value) => snackBar(context, "User registered successfully."))
            .catchError((error) => snackBar(context, "FAILED. $error"));

        registerResponse.user!.sendEmailVerification();
        setState(() {
          loading = false;
        });
      } catch (e) {
        setState(() {
          snackBar(context, e.toString());
          loading = false;
        });
      }
    }
  }

  void showLogin() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(50.0),
              child: LogInForm(onTap: widget.onTap));
        });
  }
}
