import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

import '../models/movie.dart';
import 'package:http/http.dart' as http;

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  var nameC = TextEditingController();

  Movie? movie;
  StreamController streamController = StreamController();
  Stream? stream;

  searchMovie({required String movieName}) async {
    streamController.add('loading');

    String url =
        'https://www.omdbapi.com/?t=$movieName&plot=full&apikey=94e188aa';
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['Response'] == 'False') {
        streamController.add('Movie Not Found');
      } else {
        movie = Movie.fromJson(jsonResponse);
        streamController.add(movie);
      }
    } else {
      streamController.add('Something went wrong');
    }
  }

  @override
  void initState() {
    stream = streamController.stream;
    streamController.add('empty');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Movie Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameC,
              decoration: InputDecoration(
                hintText: 'Movie Name',
                border: OutlineInputBorder(),
              ),
            ),
            Gap(8),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    //nameC.text = '';
                    nameC.clear();
                    streamController.add('empty');
                  },
                  label: const Text('Clear'),
                  icon: Icon(Icons.cancel),
                )),
                Gap(16),
                Expanded(
                    child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    String movieName = nameC.text.trim();

                    if (movieName.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please provide movie name')));
                    } else {
                      // call a function to fetch movie data
                      searchMovie(movieName: movieName);
                    }
                  },
                  label: const Text('Search'),
                  icon: Icon(Icons.search),
                )),
              ],
            ),
            Expanded(
              child: StreamBuilder(
                stream: stream,
                builder: (context, snapshot) {
                  if (snapshot.data == 'loading') {
                    return SpinKitFadingCircle(
                      color: Colors.amber,
                    );
                  }

                  if (snapshot.data == 'empty') {
                    return Text('Please provide movie name');
                  }

                  if (snapshot.data == 'Movie Not Found') {
                    return Text('Movie Not Found');
                  }

                  if (snapshot.data == 'Something went wrong') {
                    return Text('something went wrong');
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.network(
                          movie!.poster!,
                          width: 200,
                          height: 300,
                        ),
                        Text(movie!.actors!),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
