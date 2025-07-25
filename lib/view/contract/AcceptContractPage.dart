import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          text: "Contract Details",
          fSize: 30,
          color: textColor2,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: textColor2,
          onPressed: () => Get.back(),
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
              padding: const EdgeInsets.all(10),
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
                  // Person field (view only)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "David Miller",
                      style: TextStyle(color: textColor2, fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: mainColor,
                        labelText: "Person",
                        labelStyle: TextStyle(
                          color: mainColor2,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: secondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(Icons.person, color: secondaryColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3), width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Book field (view only)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      initialValue: "Enchanted Journey",
                      style: TextStyle(color: textColor2, fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: mainColor,
                        labelText: "Book",
                        labelStyle: TextStyle(
                          color: mainColor2,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: secondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(Icons.menu_book, color: secondaryColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3), width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Other fields (view only)...
                  contractDetailViewOnly("Film Project", "ENCHANTED JOURNEY", Icons.movie_creation_outlined),
                  contractDetailViewOnly("Contract Date", "April 24, 2024", Icons.date_range_outlined),
                  contractDetailViewOnly("Expiry Date", "April 24, 2025", Icons.date_range_outlined),
                  contractDetailViewOnly("Agreed Price (\$)", "\$1000", Icons.attach_money),
                  contractDetailViewOnly("Royalty Percentage", "15%", Icons.percent),

                  // Additional Terms Section (view only)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      readOnly: true,
                      maxLines: 4,
                      initialValue: "No major changes to the core story allowed. Director has creative freedom for visual adaptation.",
                      style: TextStyle(color: textColor2, fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: mainColor,
                        labelText: "Additional Terms",
                        labelStyle: TextStyle(
                          color: mainColor2,
                          fontWeight: FontWeight.w500,
                        ),
                        floatingLabelStyle: TextStyle(
                          color: secondaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        prefixIcon: Icon(Icons.note_add, color: secondaryColor),
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: secondaryColor.withOpacity(0.3), width: 1.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.white, width: 1.5),
                        ),
                      ),
                    ),
                  ),

                  // Changes Allowed Percentage Section (view only)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleText(
                          text: "Maximum Changes Allowed to Book's Story:",
                          fSize: 16,
                          color: textColor2,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Radio<String>(
                              value: '5%',
                              groupValue: '10%', // Preselected value
                              onChanged: null, // Disabled
                              activeColor: secondaryColor,
                            ),
                            styleText(text: "5%", fSize: 16, color: textColor2),
                            const SizedBox(width: 15),
                            Radio<String>(
                              value: '10%',
                              groupValue: '10%', // Preselected value
                              onChanged: null, // Disabled
                              activeColor: secondaryColor,
                            ),
                            styleText(text: "10%", fSize: 16, color: textColor2),
                            const SizedBox(width: 15),
                            Radio<String>(
                              value: '15%',
                              groupValue: '10%', // Preselected value
                              onChanged: null, // Disabled
                              activeColor: secondaryColor,
                            ),
                            styleText(text: "15%", fSize: 16, color: textColor2),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Signature Section (view only)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleText(
                          text: "Author's Signature:",
                          fSize: 16,
                          color: textColor2,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: secondaryColor.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Image.network(
                              'https://signaturely.com/wp-content/uploads/2020/11/signaturely-how-to-sign-a-PDF-1.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            styleText(
              text: "By clicking 'Accept', you agree to the terms outlined in the contract between yourself and the author.",
              fSize: 20,
              color: textColor2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // Buttons Row (same as before)
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

            // Message Button (same as before)
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

  Widget contractDetailViewOnly(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        readOnly: true,
        initialValue: value,
        style: TextStyle(color: textColor2, fontSize: 18),
        decoration: InputDecoration(
          filled: true,
          fillColor: mainColor,
          labelText: label,
          labelStyle: TextStyle(
            color: mainColor2,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: TextStyle(
            color: secondaryColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Icon(icon, color: secondaryColor),
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.3), width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
        ),
      ),
    );
  }
}