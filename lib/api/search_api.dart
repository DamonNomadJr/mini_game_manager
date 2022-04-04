import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchAPI {
  static String apiKey =
      "0d9f3c725ca36251b5452ba457aca2d560c075caa95a531aa3aa6ae419cb224e";

  static Future<Map<String, dynamic>>? createAlbum(String query) async {
    var responseData = await http.get(
      Uri.https(
        "serpapi.com",
        "search.json",
        <String, String>{
          'q': '$query 1920*1080',
          'tbm': 'isch',
          'key': apiKey,
        },
      ),
    );
    return json.decode(responseData.body);
  }
}

class GoogleImagePicker extends StatefulWidget {
  final String searchQuery;
  const GoogleImagePicker({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  State<GoogleImagePicker> createState() => _GoogleImagePickerState();
}

class _GoogleImagePickerState extends State<GoogleImagePicker> {
  @override
  Widget build(BuildContext context) {
    String? imageLink;
    return Scaffold(
      appBar: AppBar(title: const Text("Select an Image")),
      body: SizedBox(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: SearchAPI.createAlbum(widget.searchQuery),
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>?> snapshot) {
            if (snapshot.hasData) {
              List<Widget> list = [];
              for (var item in (snapshot.data)!['images_results']) {
                if (item['original']
                    .toString()
                    .contains(RegExp(r'.jpg|.jpeg|png'))) {
                  list.add(
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: InkWell(
                        onTap: () {
                          imageLink = item['original'];
                          Navigator.pop(context, imageLink);
                        },
                        child: Image.network(
                          item['thumbnail'],
                        ),
                      ),
                    ),
                  );
                }
              }
              return GridView(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 1,
                ),
                children: list,
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
