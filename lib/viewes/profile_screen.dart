import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/utils/enums.dart';
import 'package:newapp/utils/image_model.dart';
import 'package:newapp/widgets/custom_circular_avatar.dart';
import 'package:path/path.dart' as p;

class ProfileScreen extends StatefulWidget {
  final String email;
  final String name;
  final String mobileNumber;

  const ProfileScreen({
    Key? key,
    required this.email,
    required this.name,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ValueNotifier<ImageModel?> _profileBytes = ValueNotifier<ImageModel?>(null);
  final ImagePicker _picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  XFile? image;
  void onAddAttachmentClick() async {
    final XFile? attachment = await _picker.pickImage(source: ImageSource.gallery);

    if (attachment != null) {
      String fileName = attachment.name;
      Uint8List bytes = await attachment.readAsBytes();
      _profileBytes.value = ImageModel(fileType: p.extension(fileName).replaceAll(".", ""), byteImage: bytes);
    }
  }

  void onCameraClick() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    final XFile? attachment = await _picker.pickImage(source: ImageSource.camera);

    if (attachment != null) {
      String fileName = attachment.name;
      Uint8List bytes = await attachment.readAsBytes();
      _profileBytes.value = ImageModel(fileType: p.extension(fileName).replaceAll(".", ""), byteImage: bytes);
    }
  }

  void onSaveClick() async {
    if (_profileBytes.value != null) {
      // Save the image to the profile
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final String fileName = '${user?.uid}.jpg';
        final Reference storageReference = FirebaseStorage.instance.ref().child('user/profile/$fileName');
        final UploadTask uploadTask = storageReference.putData(_profileBytes.value!.byteImage!);
        await uploadTask.whenComplete(() async {
          final String downloadUrl = await storageReference.getDownloadURL();
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Image saved successfully')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('failed to save image')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('please select image to save')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Profile Info"),
              ValueListenableBuilder<ImageModel?>(
                valueListenable: _profileBytes,
                builder: (context, _, __) {
                  return Center(
                    child: CustomCircularAvatar(
                      hasBorder: false,
                      backgroundColor: AppColorScheme.kLightBlueColor,
                      border: Border.all(width: 0),
                      avatarType: _profileBytes.value == null ? CircularAvatarType.DEFAULT : CircularAvatarType.MEMORY,
                      assetPath: null,
                      isEditable: true,
                      onEditClick: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Take a photo'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      onCameraClick();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Choose from gallery'),
                                    onTap: () {
                                      Navigator.pop(context);
                                      onAddAttachmentClick();
                                    },
                                  ),
              image != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        //to show image, you type like this.
                        File(image!.path),
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                      ),
                    ),
                  )
                : const Text(
                    "No Image",
                    style: TextStyle(fontSize: 20),
                  )
                                ],
                              ),
                            );
                          },
                        );
                      },
                      imageBytes: _profileBytes.value?.byteImage,
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Email: ${widget.email}'),
              const SizedBox(
                height: 20,
              ),
              Text('Name: ${widget.name}'),
              const SizedBox(
                height: 20,
              ),
              Text('Mobile Number: ${widget.mobileNumber}'),
              const SizedBox(
                height: 20,
              ),
              // Add more widgets to display other sign-up data if needed
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ElevatedButton(
            onPressed: onSaveClick,
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
