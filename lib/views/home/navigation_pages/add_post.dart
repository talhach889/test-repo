import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sayhi/model/user.dart' as model;
import 'package:sayhi/viewModel/firestore_method.dart';
import 'package:sayhi/views/state_management/user_provide.dart';
import 'package:sayhi/views/ui_logic/image_picker.dart';
import 'package:sayhi/views/ui_logic/show_snack_bar.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _post;

  final _postDescController = TextEditingController();
  bool _isLoading = false;

  void postImage(String uid, String username, String profImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _postDescController.text, _post!, uid, username, profImage);
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text(
              'Create a Post',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const [
                    Icon(
                      Icons.add_a_photo
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Capture a Moment',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List post = await pickImage(ImageSource.camera);
                  setState(() {
                    _post = post;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: const [
                    Icon(
                        Icons.image_search
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Share Memory from Gallery',
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List post = await pickImage(ImageSource.gallery);
                  setState(() {
                    _post = post;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(
                        Icons.cancel_outlined
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Cancel',
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _post = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _postDescController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvide>(context).getUser;

    return _post == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.upload, size: 36),
                  onPressed: () => _selectImage(context),
                ),
                const Text(
                  'Tap to select your post!',
                  style: TextStyle(fontSize: 24),
                )
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => clearImage(),
              ),
              title: const Text('Say Hi'),
              centerTitle: true,
              actions: [
                TextButton(
                  onPressed: () =>
                      postImage(user.uid, user.username, user.photoUrl),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10)),
                  //const Divider(),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                          radius: 26,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 20),
                        child: Text(
                          user.username,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color: Colors.grey.shade800,
                      thickness: 2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        //_postDescController///////////////////////////////////////////////////////////////
                        TextField(
                          maxLines: 2,
                          controller: _postDescController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade800)),
                              hintText: 'Tell people about your Post',
                              hintStyle: const TextStyle(
                                  color: Colors.grey, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: MemoryImage(_post!),
                                  fit: BoxFit.fitHeight,
                                  alignment: FractionalOffset.topCenter)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
