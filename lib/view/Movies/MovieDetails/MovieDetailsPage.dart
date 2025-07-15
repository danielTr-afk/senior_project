import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';

class MovieDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      'https://i.gr-assets.com/images/S/compressed.photo.goodreads.com/books/1566425108l/33._SY475_.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Back button
                Positioned(
                  top: 40,
                  left: 20,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    child: Icon(Icons.arrow_back, color: textColor2),
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
                  styleText(text: "BookFlix", fSize: 16, color: secondaryColor, fontWeight: FontWeight.bold,),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: styleText(text: "The Lord Of The King", fSize: 30, color: textColor2, fontWeight: FontWeight.bold,),
                      ),
                      Icon(Icons.bookmark_border, color: textColor2),
                    ],
                  ),
                  SizedBox(height: 10),
                  styleText(text: "Drama, Fantasy, Horror", fSize: 17, color: mainColor2!),
                  SizedBox(height: 10),
                  styleText(text: "When a young boy vanishes, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.", fSize: 20, color: textColor2),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      _buildInfoBadge(context, "+16"),
                      SizedBox(width: 8),
                      _buildInfoBadge(context, "2016"),
                      SizedBox(width: 8),
                      _buildInfoBadge(context, "⭐ 8.8"),
                      SizedBox(width: 8),
                      _buildInfoBadge(context, "Watch Trailer"),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(Icons.play_arrow, color: textColor2),
                    label: styleText(text: "Watch now", fSize: 20, color: textColor2),
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
      child: styleText(text: text, fSize: 14, color: textColor2)
    );
  }
}