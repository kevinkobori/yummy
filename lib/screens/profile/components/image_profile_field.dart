import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import '../../../components/image_source_sheet.dart';
import '../../../controllers/user/user_manager.dart';
import '../profile_page.dart';

class ImageProfileField extends StatefulWidget {
  @override
  _ImageProfileFieldState createState() => _ImageProfileFieldState();
}

class _ImageProfileFieldState extends State<ImageProfileField> {
  @override
  Widget build(BuildContext context) {
    final userManager = context.watch<UserManager>();
    File image;

    ImageProvider<Object> returnImage() {
      if (image == null)
        return userManager.user.imageProfile != null
            ? NetworkImage(
                userManager.user.imageProfile,
              )
            : null;
      else
        return FileImage(
          image,
        ) as ImageProvider<Object>;
    }

    void onImagesSelected(List<dynamic> listImages, String type) {
      if (type == 'instagram') {
      } else {
        setState(() {
          image = listImages[0] as File;
        });
        userManager.user.uploadImageProfile(listImages[0] as File).then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => ProfilePage()),
          );
        });
      }
    }

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: returnImage(),
          ),
          Positioned(
            right: -28,
            bottom: -12,
            child: ElevatedButton(
              onPressed: () {
                if (Platform.isAndroid)
                  showModalBottomSheet(
                      context: context,
                      builder: (_) => ImageSourceSheet(
                            onImagesSelected: onImagesSelected,
                          ));
                else
                  showCupertinoModalPopup(
                      context: context,
                      builder: (_) => ImageSourceSheet(
                            onImagesSelected: onImagesSelected,
                          ));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<CircleBorder>(
                  const CircleBorder(),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.camera_alt, color: Colors.black, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
