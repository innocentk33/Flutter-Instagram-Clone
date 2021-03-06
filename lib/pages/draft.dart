// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:geocoder/geocoder.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:uuid/uuid.dart';

// class Upload extends StatefulWidget {
//   @override
//   _UploadState createState() => _UploadState();
// }

// class _UploadState extends State<Upload> {
//   File file;
//   Address address;

//   Map<String, double> currentLocation = Map();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController locationController = TextEditingController();

//   bool uploading = false;

//   @override
//   void initState() {
//     currentLocation['latitude'] = 0.0;
//     currentLocation['longitude'] = 0.0;
//     initPlatformState();

//     super.initState();
//   }

//   initPlatformState() async {
//     // Address first = await getUserLoaction();
//     Address first = null;
//     setState(() {
//       address = first;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return file == null
//         ? Center(
//             child: IconButton(
//             icon: Icon(Icons.file_upload),
//             onPressed: () {
//               _selectImage(context);
//             },
//           ))
//         : Scaffold(
//             resizeToAvoidBottomPadding: false,
//             appBar: AppBar(
//               backgroundColor: Colors.white70,
//               leading: IconButton(
//                 icon: Icon(
//                   Icons.arrow_back,
//                   color: Colors.black,
//                 ),
//                 onPressed: clearImage,
//               ),
//               title: Text(
//                 'Post to',
//                 style: TextStyle(color: Colors.black),
//               ),
//               actions: [
//                 FlatButton(
//                   onPressed: postImage,
//                   child: Text(
//                     'Post',
//                     style: TextStyle(
//                         color: Colors.blueAccent,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20.0),
//                   ),
//                 )
//               ],
//             ),
//             body: ListView(
//               children: [
//                 PostForm(
//                     imageFile: file,
//                     descriptionController: descriptionController,
//                     locationController: locationController,
//                     loading: uploading),
//                 Divider(),
//                 (address == null)
//                     ? Container()
//                     : SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         padding: EdgeInsets.only(right: 5.0, left: 5.0),
//                         child: Row(
//                           children: [
//                             buildLocationButton(address.featureName),
//                             buildLocationButton(address.subLocality),
//                             buildLocationButton(address.locality),
//                             buildLocationButton(address.subAdminArea),
//                             buildLocationButton(address.adminArea),
//                             buildLocationButton(address.countryName),
//                           ],
//                         ),
//                       ),
//                 (address == null) ? Container : Divider()
//               ],
//             ),
//           );
//   }

//   // method to build buttons with location
//   buildLocationButton(String locationName) {
//     if (locationName != null && locationName.isNotEmpty) {
//       return InkWell(
//         onTap: () {
//           locationController.text = locationName;
//         },
//         child: Center(
//           child: Container(
//             height: 30.0,
//             padding: EdgeInsets.only(left: 8.0, right: 8.0),
//             margin: EdgeInsets.only(right: 3.0, left: 3.0),
//             decoration: BoxDecoration(
//                 color: Colors.grey, borderRadius: BorderRadius.circular(5.0)),
//             child: Center(
//               child: Text(
//                 locationName,
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//           ),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }

//   _selectImage(BuildContext context) async {
//     return showDialog(
//         context: context,
//         barrierDismissible: false,
//         builder: (BuildContext context) {
//           return SimpleDialog(
//             title: Text('Create a post'),
//             children: [
//               SimpleDialogOption(
//                 child: Text('Take a photo'),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   File imageFile = await ImagePicker.pickImage(
//                       source: ImageSource.camera,
//                       maxWidth: 1920,
//                       maxHeight: 1200,
//                       imageQuality: 80);

//                   setState(() {
//                     file = imageFile;
//                   });
//                 },
//               ),
//               SimpleDialogOption(
//                 child: Text('Choose from Gallery'),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   File imageFile = await ImagePicker.pickImage(
//                       source: ImageSource.gallery,
//                       maxWidth: 1920,
//                       maxHeight: 1200,
//                       imageQuality: 80);
//                   setState(() {
//                     file = imageFile;
//                   });
//                 },
//               ),
//               SimpleDialogOption(
//                 child: Text("Cancel"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               )
//             ],
//           );
//         });
//   }

//   void clearImage() {
//     setState(() {
//       file = null;
//     });
//   }

//   void postImage() {
//     setState(() {
//       uploading = true;
//     });
//   }
// }

// class PostForm extends StatelessWidget {
//   final imageFile;
//   final TextEditingController descriptionController;
//   final TextEditingController locationController;
//   final bool loading;
//   PostForm(
//       {this.imageFile,
//       this.descriptionController,
//       this.loading,
//       this.locationController});
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         loading
//             ? LinearProgressIndicator()
//             : Padding(padding: EdgeInsets.only(top: 0.0)),
//         Divider(),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             CircleAvatar(
//               backgroundImage: AssetImage("assets/images/avatar1.png"),
//             ),
//             Container(
//               width: 250.0,
//               child: TextField(
//                 controller: descriptionController,
//                 decoration: InputDecoration(
//                     hintText: "Write a caption", border: InputBorder.none),
//               ),
//             ),
//             Container(
//               height: 45.0,
//               width: 45.0,
//               child: AspectRatio(
//                 aspectRatio: 487 / 451,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           fit: BoxFit.fill,
//                           alignment: FractionalOffset.topCenter,
//                           image: FileImage(imageFile))),
//                 ),
//               ),
//             )
//           ],
//         ),
//         Divider(),
//         ListTile(
//           leading: Icon(Icons.pin_drop),
//           title: Container(
//             width: 250.0,
//             child: TextField(
//               controller: locationController,
//               decoration: InputDecoration(
//                   hintText: "Where was this photo taken ?",
//                   border: InputBorder.none),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }

// Future<String> uploadImage(var imageFile) async {
//   var uuid = Uuid().v1();
//   StorageReference ref =
//       FirebaseStorage.instance.ref().child("post_${uuid}.jpg");
//   StorageUploadTask uploadTask = ref.putFile(imageFile);

//   String downloadUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
//   return downloadUrl;
// }

// void postToFireStore(
//     {String mediaUrl, String location, String description}) async {
//   var reference = FirebaseFirestore.instance.collection("insta_posts");

//   reference.add({});
// }
