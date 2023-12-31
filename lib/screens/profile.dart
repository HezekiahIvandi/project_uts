// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:project_uts/resources/firestore_methods.dart';
import 'package:project_uts/screens/editProfile.dart';
import 'package:project_uts/screens/log_in.dart';
import 'package:project_uts/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_uts/resources/storage_methods.dart';
import 'package:project_uts/utils/colors.dart';
import 'package:project_uts/resources/auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:project_uts/model/user.dart' as model;
import 'package:project_uts/provider/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String url =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfZCGFDrC8YeednlJC3mhxPfg_s4Pg8u7-kf6dy88&s';
  Uint8List? _image;
  String _bio =
      'I am flexible, reliable and possess excellent time keeping skills. I am an enthusiastic, self-motivated, reliable, responsible and hard working person. I am a mature team worker and adaptable to all challenging situations.';
  int followers = 10;
  int following = 10;
  bool isLoading = false;
  String _username = 'username';
  String _email = 'username@gmail.com';

  @override
  initState() {
    super.initState();
    getPfp();
  }

  getPfp() async {
    var pfp = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    setState(() {
      url = pfp.data()!['photoUrl'];
      print(url);
    });
  }

  void selectImage() async {
    Uint8List? profilePic = await pickImage(ImageSource.gallery);
    String pfpUrl = await StorageMethods()
        .uploadImageToStorage('profilePics', profilePic!, false);
    setState(() {
      _image = profilePic;
    });
  }

  void signOut() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LogIn(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    if (user?.uid != null) {
      _username = user!.username;
      _bio = user.bio;
      _email = user.email;
      followers = user.followers.length;
      following = user.following.length;
      url = user.photoUrl;
    }
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: lightGreyUI,
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: mobileBackgroundColor,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                "Profile",
                style: TextStyle(
                  color: purpleUI,
                ),
              ),
            ),
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(top: 24),
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: mobileBackgroundColor,
                        boxShadow: [
                          BoxShadow(
                            color: blackUI,
                            blurRadius: 5.0, // soften the shadow
                            spreadRadius: 0.5, //extend the shadow
                            offset: Offset(
                              0.1, // Move to right 5  horizontally
                              0.1, // Move to bottom 5 Vertically
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          //circle avatar
                          Stack(
                            children: [
                              _image != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundImage: MemoryImage(_image!),
                                    )
                                  : CircleAvatar(
                                      radius: 64,
                                      backgroundImage: NetworkImage(url),
                                    ),
                              Positioned(
                                  left: 80,
                                  bottom: -10,
                                  child: IconButton(
                                    onPressed: selectImage,
                                    icon: const Icon(Icons.add_a_photo),
                                  )),
                            ],
                          ),

                          //username and email
                          Container(
                            margin: const EdgeInsets.only(top: 24),
                            child: Column(
                              children: [
                                Text(
                                  _username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  _email,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: lightGreyUI,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          //sizedbox spacing
                          const SizedBox(
                            height: 12,
                          ),
                          //followers
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    followers.toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: blueUI,
                                    ),
                                  ),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                      color: aquaUI,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Column(
                                children: [
                                  Text(
                                    following.toString(),
                                    style: const TextStyle(
                                      fontSize: 25,
                                      color: blueUI,
                                    ),
                                  ),
                                  const Text(
                                    'Following',
                                    style: TextStyle(
                                      color: purpleUI,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          //
                        ],
                      ),
                    ),
                    //sized box
                    const SizedBox(
                      height: 12,
                    ),
                    //about me
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'About me',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                color: greenUI),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            _bio.length > 210
                                ? _bio.substring(0, 210) + '...'
                                : _bio,
                            style: const TextStyle(
                              fontSize: 14,
                              color: lightGreyUI,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(child: Container()),
                    //button 1
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const editProfile(),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          color: darkGreyUI,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.settings),
                              color: yellowUI,
                            ),
                            const Text(
                              'Edit profile',
                              style: TextStyle(
                                color: yellowUI,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Flexible(child: Container()),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chevron_right),
                              color: lightGreyUI,
                            ),
                          ],
                        ),
                      ),
                    ),

                    //button2
                    InkWell(
                      onTap: signOut,
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          color: darkGreyUI,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              color: redUI,
                              onPressed: () {},
                              icon: const Icon(Icons.logout),
                            ),
                            const Text(
                              'Sign out',
                              style: TextStyle(
                                color: redUI,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
