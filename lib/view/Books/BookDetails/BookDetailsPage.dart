import 'package:cached_network_image/cached_network_image.dart';
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

class BookDetailsPage extends StatefulWidget {
  final String bookId;

  const BookDetailsPage({super.key, required this.bookId});

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  Map<String, dynamic>? bookData;
  List<Map<String, dynamic>> comments = [];
  bool isLoading = true;
  bool isLiked = false;
  bool isLoadingLike = false;
  bool isAddingComment = false;
  TextEditingController commentController = TextEditingController();

  // Get the login controller to access user data
  final loginGetx loginController = Get.find<loginGetx>();

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
    fetchComments();
    checkLikeStatus();
  }

  Future<void> fetchBookDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/get_book_details.php?id=${widget.bookId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            bookData = data['data'];
            isLoading = false;
          });
        } else {
          print('Error fetching book details: ${data['message']}');
          setState(() {
            isLoading = false;
          });
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching book details: $e');
    }
  }

  Future<void> fetchComments() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/get_book_comments.php?book_id=${widget.bookId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            comments = List<Map<String, dynamic>>.from(data['data']);
          });
        } else {
          print('Error fetching comments: ${data['message']}');
        }
      } else {
        print('HTTP Error fetching comments: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> checkLikeStatus() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/BookFlix/check_like_status.php?book_id=${widget.bookId}&user_id=${loginController.userId.value}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            isLiked = data['is_liked'] ?? false;
          });
        } else {
          print('Error checking like status: ${data['message']}');
        }
      } else {
        print('HTTP Error checking like status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error checking like status: $e');
    }
  }

  Future<void> toggleLike() async {
    if (isLoadingLike) return; // Prevent multiple requests

    setState(() {
      isLoadingLike = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/toggle_like_book.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'book_id': widget.bookId,
          'user_id': loginController.userId.value.toString(),
          'action': isLiked ? 'unlike' : 'like', // Add the action parameter
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            isLiked = data['is_liked'] ?? false;
            if (bookData != null) {
              bookData!['likes'] = data['new_likes_count'];
            }
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Like status updated'),
              duration: Duration(seconds: 1),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error toggling like: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update like status: $e')),
      );
    } finally {
      setState(() {
        isLoadingLike = false;
      });
    }
  }

  Future<void> addComment() async {
    if (commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a comment')),
      );
      return;
    }

    setState(() {
      isAddingComment = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/add_comments_book.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'book_id': widget.bookId,
          'user_id': loginController.userId.value.toString(),
          'comment': commentController.text.trim(), // This matches what PHP expects
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            commentController.clear();
          });

          // Close dialog first
          Navigator.of(context).pop();

          // Refresh comments
          await fetchComments();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Comment added successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add comment: ${data['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error adding comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding comment: $e')),
      );
    } finally {
      setState(() {
        isAddingComment = false;
      });
    }
  }

  Future<void> openPDF() async {
    if (bookData == null || bookData!['pdf_url'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF not available for this book')),
      );
      return;
    }

    try {
      final url = bookData!['pdf_url'];
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/book_${widget.bookId}.pdf');
        await file.writeAsBytes(response.bodyBytes);

        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open PDF file')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening PDF: $e')),
      );
    }
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              styleText(
                text: "Add Comment",
                fSize: 20,
                color: textColor2,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 4,
                style: TextStyle(color: textColor2),
                decoration: InputDecoration(
                  hintText: "Write your comment...",
                  hintStyle: TextStyle(color: mainColor2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: mainColor2!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: mainColor2!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: secondaryColor!),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: isAddingComment ? null : () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: styleText(text: "Cancel", fSize: 16, color: textColor2),
                  ),
                  ElevatedButton(
                    onPressed: isAddingComment ? null : addComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isAddingComment
                        ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: textColor2,
                      ),
                    )
                        : styleText(text: "Post", fSize: 16, color: textColor2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (isLoading) {
      return Scaffold(
        backgroundColor: blackColor2,
        appBar: AppBar(
          backgroundColor: blackColor2,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor2),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(color: secondaryColor),
        ),
      );
    }

    if (bookData == null) {
      return Scaffold(
        backgroundColor: blackColor2,
        appBar: AppBar(
          backgroundColor: blackColor2,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: textColor2),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: styleText(
            text: "Book not found",
            fSize: 18,
            color: textColor2,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: blackColor2,
      appBar: AppBar(
        backgroundColor: blackColor2,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor2),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: styleText(
          text: 'Book Details',
          fSize: 30,
          color: textColor2,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: isLoadingLike
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: textColor2,
              ),
            )
                : Icon(
              Icons.favorite,
              color: textColor2,
            ),
            onPressed: (){},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.45,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: bookData!['image'] ?? '',
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: Center(
                          child: CircularProgressIndicator(
                            color: secondaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: Icon(Icons.book, size: 50, color: textColor2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      styleText(
                        text: bookData!['title'] ?? 'Unknown Title',
                        fSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor2,
                      ),
                      const SizedBox(height: 8),
                      styleText(
                        text: "by ${bookData!['author_name'] ?? 'Unknown Author'}",
                        fSize: 16,
                        color: mainColor2!,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              // Parse the rating as double, defaulting to 0.0 if parsing fails
                              double rating = 0.0;
                              try {
                                rating = double.parse(bookData!['rating']?.toString() ?? '0.0');
                              } catch (e) {
                                rating = 0.0;
                              }

                              return Icon(
                                Icons.star,
                                color: index < rating.round()
                                    ? Colors.orange
                                    : Colors.grey,
                                size: 18,
                              );
                            }),
                          ),
                          SizedBox(width: 8),
                          styleText(
                            text: bookData!['rating']?.toString() ?? '0.0',
                            fSize: 16,
                            color: mainColor2!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.favorite, color: Colors.red, size: 16),
                          SizedBox(width: 4),
                          styleText(
                            text: "${bookData!['likes'] ?? 0} likes",
                            fSize: 14,
                            color: mainColor2!,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _button(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    isLiked ? "Unlike" : "Like",
                    color: isLiked ? Colors.red : textColor2!,
                    onPressed: isLoadingLike ? null : toggleLike,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _button(
                    Icons.comment,
                    "Comment",
                    onPressed: showCommentDialog,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            styleText(
              text: "About the book",
              fSize: 22,
              color: textColor2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            styleText(
              text: bookData!['description'] ?? 'No description available.',
              fSize: 18,
              color: mainColor2!,
            ),
            const SizedBox(height: 20),
            styleText(
              text: "Community Reviews (${comments.length})",
              fSize: 20,
              color: textColor2,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            if (comments.isEmpty)
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: styleText(
                    text: "No comments yet. Be the first to comment!",
                    fSize: 16,
                    color: mainColor2!,
                  ),
                ),
              )
            else
              ...comments.map((comment) => Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: mainColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: comment['profile_image'] != null && comment['profile_image'].isNotEmpty
                          ? NetworkImage(comment['profile_image'])
                          : null,
                      child: comment['profile_image'] == null || comment['profile_image'].isEmpty
                          ? Icon(Icons.person, color: textColor2)
                          : null,
                      radius: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styleText(
                            text: comment['user_name'] ?? 'Anonymous',
                            fSize: 16,
                            color: textColor2,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 4),
                          styleText(
                            text: comment['comment_text'] ?? '',
                            fSize: 14,
                            color: mainColor2!,
                          ),
                          const SizedBox(height: 4),
                          styleText(
                            text: comment['created_at'] ?? '',
                            fSize: 12,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )).toList(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: screenWidth - 32,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: FloatingActionButton.extended(
          onPressed: openPDF,
          backgroundColor: secondaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          label: styleText(
            text: "Read Now",
            fSize: 20,
            color: textColor2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _button(IconData icon, String text, {Color color = Colors.white, VoidCallback? onPressed}) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        foregroundColor: color,
      ),
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: 18, color: color),
      label: styleText(text: text, fSize: 18, color: color),
    );
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }
}