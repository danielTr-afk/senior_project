import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';

class AcceptContractPage extends StatelessWidget {
  const AcceptContractPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        title: styleText(
          text: "Acceptance Contract",
          fSize: 30,
          color: textColor2,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage(
                'https://randomuser.me/api/portraits/women/44.jpg',
              ),
            ),
            const SizedBox(height: 10),
            styleText(
              text: "Lynne Foster",
              fSize: 25,
              color: textColor2,
              fontWeight: FontWeight.bold,
            ),
            styleText(
              text: "Director",
              fSize: 20,
              color: mainColor2!,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: blackColor2,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: mainColor2!,
                    blurRadius: 8,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Column(
                children: [
                  contractDetail("Author", "David Miller"),
                  contractDetail("Book", "Enchanted Journey"),
                  contractDetail("Film", "ENCHANTED JOURNEY"),
                  contractDetail("Signed Date", "April 24, 2024"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            styleText(
              text:
              "By clicking 'Accept', you agree to the terms outlined in the contract between yourself and the author.",
              fSize: 20,
              color: textColor2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contract Rejected!')),
                      );
                    },
                    child: styleText(
                      text: "Reject",
                      fSize: 22,
                      color: textColor2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contract Accepted!')),
                      );
                    },
                    child: styleText(
                      text: "Accept",
                      fSize: 22,
                      color: textColor2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Message Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: mainColor2!, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message Author Clicked!')),
                  );
                },
                child: styleText(
                  text: "Message Author",
                  fSize: 22,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contractDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          styleText(text: '$title: ', fSize: 20, color: secondaryColor, fontWeight: FontWeight.bold,),
          Expanded(
            child: styleText(text: value, fSize: 20, color: textColor2)
          ),
        ],
      ),
    );
  }
}
