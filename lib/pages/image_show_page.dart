import 'package:flutter/material.dart';

class ImageShowPage extends StatelessWidget {
  const ImageShowPage({
    super.key,
    required this.imageUrl,
  });
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   foregroundColor: Colors.black,
      // ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            Image.network(
              imageUrl,
              width: MediaQuery.of(context).size.width - 100,
              height: MediaQuery.of(context).size.height / 3,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
