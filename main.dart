import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PhotoListScreen(),
    );
  }
}

class PhotoListScreen extends StatefulWidget {
  @override
  _PhotoListScreenState createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {
  List<dynamic> photos = [];

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }
  Future<void> fetchPhotos() async {
    final Uri url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        photos = data;
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery'),
      ),
      body: photos.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(photos[index]['title']),
            leading: Image.network(photos[index]['thumbnailUrl']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhotoDetailScreen(
                    id: photos[index]['id'],
                    title: photos[index]['title'],
                    url: photos[index]['url'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final int id;
  final String title;
  final String url;

  PhotoDetailScreen({required this.id, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Detail'),
      ),
      body: Column(
        children: <Widget>[
          Image.network(url),
          SizedBox(height: 16.0),
          Text('ID: $id'),
          Text('Title: $title'),
        ],
      ),
    );
  }
}
