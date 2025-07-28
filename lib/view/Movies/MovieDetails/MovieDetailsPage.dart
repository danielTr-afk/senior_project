import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:get/get.dart';
import '../../../controller/authController/loginGetX.dart';

class MovieDetailsPage extends StatefulWidget {
  final String filmId;

  const MovieDetailsPage({Key? key, required this.filmId}) : super(key: key);

  @override
  _MovieDetailsPageState createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> with AutomaticKeepAliveClientMixin {
  Map<String, dynamic>? movieData;
  bool isLoading = true;
  bool isLiked = false;
  bool isLikeLoading = false;
  List<Map<String, dynamic>> comments = [];
  TextEditingController commentController = TextEditingController();
  bool _disposed = false;

  // Get user ID from login controller safely
  String get currentUserId {
    try {
      final loginController = Get.find<loginGetx>();
      return loginController.userId.value.toString();
    } catch (e) {
      print('Error getting user ID: $e');
      return '32'; // fallback ID
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (!mounted || _disposed) return;

    try {
      await fetchMovieDetails();
      if (mounted && !_disposed) {
        await checkFilmLikeStatus();
      }
    } catch (e) {
      print('Error initializing data: $e');
      if (mounted && !_disposed) {
        _showError('Failed to load movie details');
      }
    }
  }

  @override
  void dispose() {
    _disposed = true;
    commentController.dispose();
    super.dispose();
  }

  void _safeSetState(VoidCallback fn) {
    if (mounted && !_disposed) {
      setState(fn);
    }
  }

  void _showError(String message) {
    if (mounted && !_disposed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> fetchMovieDetails() async {
    if (_disposed) return;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/film.php?id=${widget.filmId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (_disposed) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success' &&
            data['data'] != null &&
            data['data']['films'] != null &&
            data['data']['films'].isNotEmpty) {

          _safeSetState(() {
            movieData = Map<String, dynamic>.from(data['data']['films'][0]);
            isLoading = false;
          });
        } else {
          _safeSetState(() {
            isLoading = false;
          });
          _showError('Movie not found');
        }
      } else {
        _safeSetState(() {
          isLoading = false;
        });
        _showError('Failed to load movie: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching movie details: $e');
      if (!_disposed) {
        _safeSetState(() {
          isLoading = false;
        });
        _showError('Network error: ${e.toString()}');
      }
    }
  }

  Future<void> checkFilmLikeStatus() async {
    if (_disposed || movieData == null) return;

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/check_film_like_status.php?film_id=${widget.filmId}&user_id=$currentUserId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      if (_disposed) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _safeSetState(() {
            isLiked = data['is_liked'] ?? false;
          });
        }
      }
    } catch (e) {
      print('Error checking film like status: $e');
      // Don't show error for like status check, it's not critical
    }
  }

  Future<void> toggleLike() async {
    if (isLikeLoading || _disposed || movieData == null) return;

    _safeSetState(() {
      isLikeLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/toggle_like_film.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'film_id': widget.filmId,
          'user_id': currentUserId,
        },
      ).timeout(const Duration(seconds: 15));

      if (_disposed) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          _safeSetState(() {
            if (movieData != null) {
              movieData!['likes'] = data['likes'];
            }
            isLiked = data['is_liked'] ?? false;
          });

          if (mounted && !_disposed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(data['message'] ?? (isLiked ? 'Movie liked!' : 'Movie unliked!')),
                duration: const Duration(seconds: 2),
                backgroundColor: isLiked ? Colors.red : Colors.grey,
              ),
            );
          }
        } else {
          _showError('Error: ${data['message'] ?? 'Unknown error'}');
        }
      } else {
        _showError('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error toggling like: $e');
      _showError('Network error occurred');
    } finally {
      if (!_disposed) {
        _safeSetState(() {
          isLikeLoading = false;
        });
      }
    }
  }

  Future<void> _downloadAndOpenFile(String url, String fileName, String fileType) async {
    if (_disposed) return;

    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return PopScope(
            canPop: false,
            child: Dialog(
              backgroundColor: blackColor2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: secondaryColor),
                    const SizedBox(height: 20),
                    styleText(
                      text: 'Loading $fileType...',
                      fSize: 16,
                      color: textColor2,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      // Download the file
      final response = await http.get(
        Uri.parse(url),
      ).timeout(const Duration(minutes: 5));

      if (_disposed) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        return;
      }

      if (response.statusCode == 200) {
        // Get the app's document directory
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Close loading dialog
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        if (_disposed) return;

        // Open file with default app
        final result = await OpenFile.open(filePath);

        if (result.type != ResultType.done && !_disposed) {
          _showError('Unable to open $fileType: ${result.message}');
        }
      } else {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        _showError('Failed to download $fileType');
      }
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      print('Error downloading/opening file: $e');
      _showError('Error opening $fileType');
    }
  }

  Future<void> playTrailer() async {
    if (_disposed || movieData == null) return;

    final trailerUrl = movieData!['trailer']?.toString();
    if (trailerUrl == null || trailerUrl.isEmpty) {
      _showError('Trailer not available');
      return;
    }

    String fileName = 'trailer_${widget.filmId}.mp4';
    if (trailerUrl.contains('.')) {
      final extension = trailerUrl.split('.').last.split('?').first;
      fileName = 'trailer_${widget.filmId}.$extension';
    }

    await _downloadAndOpenFile(trailerUrl, fileName, 'trailer');
  }

  Future<void> playMovie() async {
    if (_disposed || movieData == null) return;

    final movieUrl = movieData!['movie_file']?.toString();
    if (movieUrl == null || movieUrl.isEmpty) {
      _showError('Movie file not available');
      return;
    }

    String fileName = 'movie_${widget.filmId}.mp4';
    if (movieUrl.contains('.')) {
      final extension = movieUrl.split('.').last.split('?').first;
      fileName = 'movie_${widget.filmId}.$extension';
    }

    await _downloadAndOpenFile(movieUrl, fileName, 'movie');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (movieData == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              styleText(
                text: "Movie not found",
                fSize: 20,
                color: textColor2,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _safeSetState(() {
                    isLoading = true;
                  });
                  _initializeData();
                },
                child: const Text('Retry'),
              ),
            ],
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
                        stops: const [0.6, 0.85, 1.0],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.network(
                      movieData!['image']?.toString() ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: const Icon(Icons.error, color: Colors.white),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[800],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                              color: secondaryColor,
                            ),
                          ),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  styleText(
                    text: "BookFlix",
                    fSize: 16,
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: styleText(
                          text: movieData!['title']?.toString() ?? 'Unknown Title',
                          fSize: 30,
                          color: textColor2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.bookmark_border, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 10),
                  styleText(
                    text: movieData!['category']?.toString() ?? 'Unknown Category',
                    fSize: 17,
                    color: mainColor2!,
                  ),
                  const SizedBox(height: 10),
                  styleText(
                    text: movieData!['description']?.toString() ?? 'No description available',
                    fSize: 20,
                    color: textColor2,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      // Like button with dynamic icon and loading state
                      GestureDetector(
                        onTap: isLikeLoading ? null : toggleLike,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isLiked ? Colors.red.withOpacity(0.2) : blackColor2,
                            borderRadius: BorderRadius.circular(6),
                            border: isLiked ? Border.all(color: Colors.red, width: 1) : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isLikeLoading)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              else
                                Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : textColor2,
                                  size: 16,
                                ),
                              const SizedBox(width: 4),
                              styleText(
                                text: "${movieData!['likes'] ?? 0}",
                                fSize: 14,
                                color: textColor2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildInfoBadge(context, "⭐ ${movieData!['rating'] ?? 0.0}"),
                      const SizedBox(width: 8),
                      // Watch Trailer button
                      GestureDetector(
                        onTap: playTrailer,
                        child: _buildInfoBadge(context, "🎬 Trailer"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: playMovie,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      minimumSize: const Size(double.infinity, 50),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: blackColor2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: styleText(text: text, fSize: 14, color: textColor2),
    );
  }
}