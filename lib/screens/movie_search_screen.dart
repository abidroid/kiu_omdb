import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {

  var nameC = TextEditingController();

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

                    if( movieName.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please provide movie name'))
                      );
                    }else{

                      // call a function to fetch movie data
                    }

                  },
                  label: const Text('Search'),
                  icon: Icon(Icons.search),
                )),
              ],
            ),

            Expanded(child: Placeholder()),
          ],
        ),
      ),
    );
  }
}
