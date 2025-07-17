import 'package:flutter/material.dart';
import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';

class createContract extends StatelessWidget {
  createContract({super.key});

  final TextEditingController directorController = TextEditingController();
  final TextEditingController bookController = TextEditingController();
  final TextEditingController filmController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0,
        title: styleText(
          text: "Create Contract",
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
              text: "Author",
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
                  contractInput(context, "Director", directorController, isSearch: true),
                  contractInput(context, "Book", bookController, isSearch: true),
                  contractInput(context, "Film", filmController, icon: Icons.movie_creation_outlined),
                  contractInput(context, "Signed Date", dateController, isDate: true, icon: Icons.date_range_outlined),
                ],
              ),
            ),
            const SizedBox(height: 20),
            styleText(
              text: "By clicking 'Send Contract', you confirm sending the contract details to the director.",
              fSize: 20,
              color: textColor2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contract Sent!')),
                  );
                },
                child: styleText(
                  text: "Send Contract",
                  fSize: 22,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
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
                    const SnackBar(content: Text('Message Director Clicked!')),
                  );
                },
                child: styleText(
                  text: "Message Director",
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

  Widget contractInput(
      BuildContext context,
      String label,
      TextEditingController controller, {
        bool isSearch = false,
        bool isDate = false,
        IconData? icon,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: isDate,
        onTap: isDate
            ? () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text = "${picked.year}-${picked.month}-${picked.day}";
          }
        }
            : null,
        style: const TextStyle(color: Colors.white, fontSize: 18),
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
          prefixIcon: isSearch
              ? Icon(Icons.search, color: secondaryColor)
              : icon != null
              ? Icon(icon, color: secondaryColor)
              : null,
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor.withOpacity(0.3), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: secondaryColor, width: 2),
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
