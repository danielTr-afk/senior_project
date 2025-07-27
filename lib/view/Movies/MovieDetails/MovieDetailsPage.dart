import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MovieDetailsPage extends StatefulWidget {
  final String filmId;

  const MovieDetailsPage({Key? key, required this.filmId}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  Map<String, dynamic>? movieData;
  bool isLoading = true;
  bool showComments = false;
  List<Map<String, dynamic>> comments = [];
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> fetchMovieDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/film.php?id=${widget.filmId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            movieData = data['data']['films'][0];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> toggleLike() async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/toggle_like.php'),
        body: {
          'film_id': widget.filmId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            if (movieData != null) {
              movieData!['likes'] = data['likes'];
            }
          });
          // Show a brief feedback to user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Thanks for liking!'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      }
    } catch (e) {
      print('Error toggling like: $e');
    }
  }

  Future<void> _downloadAndOpenFile(String url, String fileName, String fileType) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: blackColor2,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: secondaryColor),
                  SizedBox(height: 20),
                  styleText(
                    text: 'Loading $fileType...',
                    fSize: 16,
                    color: textColor2,
                  ),
                ],
              ),
            ),
          );
        },
      );

      // Download the file
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Get the app's document directory
        final directory = await getApplicationDocumentsDirectory();

        // Create file path
        final filePath = '${directory.path}/$fileName';

        // Write file to device
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Close loading dialog
        Navigator.pop(context);

        // Open file with default app
        final result = await OpenFile.open(filePath);

        // Handle the result
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unable to open $fileType: ${result.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download $fileType'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      print('Error downloading/opening file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error opening $fileType: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> playTrailer() async {
    if (movieData?['trailer'] != null && movieData!['trailer'].isNotEmpty) {
      final trailerUrl = movieData!['trailer'];
      print('Opening trailer from: $trailerUrl'); // Debug log

      // Extract file extension from URL or use a default
      String fileName = 'trailer_${widget.filmId}.mp4';
      if (trailerUrl.contains('.')) {
        final extension = trailerUrl.split('.').last.split('?').first;
        fileName = 'trailer_${widget.filmId}.$extension';
      }

      await _downloadAndOpenFile(trailerUrl, fileName, 'trailer');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trailer not available')),
      );
    }
  }

  Future<void> playMovie() async {
    if (movieData?['movie_file'] != null && movieData!['movie_file'].isNotEmpty) {
      final movieUrl = movieData!['movie_file'];
      print('Opening movie from: $movieUrl'); // Debug log

      // Extract file extension from URL or use a default
      String fileName = 'movie_${widget.filmId}.mp4';
      if (movieUrl.contains('.')) {
        final extension = movieUrl.split('.').last.split('?').first;
        fileName = 'movie_${widget.filmId}.$extension';
      }

      await _downloadAndOpenFile(movieUrl, fileName, 'movie');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Movie file not available')),
      );
    }
  }

  Future<void> addComment(String comment) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/add_comment.php'),
        body: {
          'film_id': widget.filmId,
          'user_id': '32', // Replace with actual user ID
          'comment': comment,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          commentController.clear();
          fetchComments();
        }
      }
    } catch (e) {
      print('Error adding comment: $e');
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/get_comments.php?film_id=${widget.filmId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            comments = List<Map<String, dynamic>>.from(data['comments']);
          });
        }
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  void _showCommentsDialog() {
    fetchComments();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: blackColor2,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  styleText(
                    text: "Comments",
                    fSize: 20,
                    color: textColor2,
                    fontWeight: FontWeight.bold,
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: textColor2),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styleText(
                            text: comment['user_name'] ?? 'Anonymous',
                            fSize: 14,
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(height: 4),
                          styleText(
                            text: comment['comment'],
                            fSize: 16,
                            color: textColor2,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: commentController,
                        style: TextStyle(color: textColor2),
                        decoration: InputDecoration(
                          hintText: "Add a comment...",
                          hintStyle: TextStyle(color: textColor2!.withOpacity(0.7)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: mainColor2!),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: mainColor2!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: secondaryColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          addComment(commentController.text);
                        }
                      },
                      icon: Icon(Icons.send, color: secondaryColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (movieData == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: styleText(
            text: "Movie not found",
            fSize: 20,
            color: textColor2,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // Top Image
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                        stops: [0.6, 0.85, 1.0],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      movieData!['image'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Icon(Icons.error, color: Colors.white),
                        );
                      },
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 40,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      child: Icon(Icons.arrow_back_ios, color: textColor2),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content after image
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styleText(
                    text: "BookFlix",
                    fSize: 16,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: styleText(
                          text: movieData!['title'] ?? 'Unknown Title',
                          fSize: 30,
                          color: textColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.bookmark_border, color: textColor2),
                    ],
                  ),
                  SizedBox(height: 10),
                  styleText(
                    text: movieData!['category'] ?? 'Unknown Category',
                    fSize: 17,
                    color: mainColor2!,
                  ),
                  SizedBox(height: 10),
                  styleText(
                    text: movieData!['description'] ?? 'No description available',
                    fSize: 20,
                    color: textColor2,
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: toggleLike,
                        child: _buildInfoBadge(
                          context,
                          "❤️ ${movieData!['likes'] ?? 0}",
                        ),
                      ),
                      SizedBox(width: 8),
                      // Comments button
                      GestureDetector(
                        onTap: _showCommentsDialog,
                        child: _buildInfoBadge(context, "💬 Comments"),
                      ),
                      SizedBox(width: 8),
                      _buildInfoBadge(context, "⭐ ${movieData!['rating'] ?? 0.0}"),
                      SizedBox(width: 8),
                      // Watch Trailer button
                      GestureDetector(
                        onTap: playTrailer,
                        child: _buildInfoBadge(context, "🎬 Watch Trailer"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: playMovie,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.play_arrow, color: textColor2),
                    label: styleText(
                      text: "Watch now",
                      fSize: 20,
                      color: textColor2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBadge(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: blackColor2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: styleText(text: text, fSize: 14, color: textColor2),
    );
  }
}