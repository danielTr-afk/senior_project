import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import '../../controller/authController/loginGetX.dart';
import '../../controller/books/booksController.dart';
import '../../controller/contract/createContractController.dart';

class createContract extends StatelessWidget {
  final CreateContractController _controller = Get.put(CreateContractController());
  final BooksController _booksController = Get.put(BooksController());
  final loginGetx _authController = Get.find<loginGetx>();

  createContract({super.key});

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
            Obx(() => CircleAvatar(
              radius: 45,
              backgroundImage: _authController.profileImage.value.isNotEmpty
                  ? NetworkImage(_authController.profileImage.value)
                  : const NetworkImage('https://randomuser.me/api/portraits/women/44.jpg'),
            )),
            const SizedBox(height: 10),
            Obx(() => styleText(
              text: _authController.userName.value.isNotEmpty
                  ? _authController.userName.value
                  : "Lynne Foster",
              fSize: 25,
              color: textColor2,
              fontWeight: FontWeight.bold,
            )),
            Obx(() => styleText(
              text: _authController.userRole.value == 2
                  ? "Author"
                  : _authController.userRole.value == 3
                  ? "Director"
                  : "Author/Director",
              fSize: 20,
              color: mainColor2!,
            )),
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
                  // Choose a Person field
                  Autocomplete<Map<String, dynamic>>(
                    displayStringForOption: (Map<String, dynamic> option) => option['name'].toString(),
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Map<String, dynamic>>.empty();
                      }
                      await _controller.searchUsers(textEditingValue.text);
                      return _controller.users;
                    },
                    onSelected: (Map<String, dynamic> selection) {
                      // Use the controller method to properly handle selection
                      _controller.selectPerson(selection);
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return Obx(() => TextFormField(
                        controller: fieldController,
                        focusNode: fieldFocusNode,
                        style: TextStyle(color: textColor2, fontSize: 18),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: mainColor,
                          labelText: "Choose a Person",
                          labelStyle: TextStyle(
                            color: mainColor2,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: secondaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(Icons.person_search, color: secondaryColor),
                          suffixIcon: _controller.loadingUsers.value
                              ? const CircularProgressIndicator()
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
                      ));
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<Map<String, dynamic>> onSelected,
                        Iterable<Map<String, dynamic>> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Map<String, dynamic> option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () => onSelected(option),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    color: mainColor,
                                    child: styleText(
                                      text: option['name'],
                                      fSize: 16,
                                      color: textColor2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Choose a Book field
                  Autocomplete<Map<String, dynamic>>(
                    displayStringForOption: (Map<String, dynamic> option) => option['title'].toString(),
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<Map<String, dynamic>>.empty();
                      }
                      return _booksController.books.where((book) => book['title']
                          .toString()
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (Map<String, dynamic> selection) {
                      // Use the controller method to properly handle selection
                      _controller.selectBook(selection);
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController fieldController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted) {
                      return Obx(() => TextFormField(
                        controller: fieldController,
                        focusNode: fieldFocusNode,
                        style: TextStyle(color: textColor2, fontSize: 18),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: mainColor,
                          labelText: "Choose a Book",
                          labelStyle: TextStyle(
                            color: mainColor2,
                            fontWeight: FontWeight.w500,
                          ),
                          floatingLabelStyle: TextStyle(
                            color: secondaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(Icons.menu_book_outlined, color: secondaryColor),
                          suffixIcon: _booksController.isLoading.value
                              ? const CircularProgressIndicator()
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
                      ));
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<Map<String, dynamic>> onSelected,
                        Iterable<Map<String, dynamic>> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4.0,
                          child: Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Map<String, dynamic> option = options.elementAt(index);
                                return GestureDetector(
                                  onTap: () => onSelected(option),
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    color: mainColor,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        styleText(
                                          text: option['title'],
                                          fSize: 16,
                                          color: textColor2,
                                        ),
                                        styleText(
                                          text: option['author_name'] ?? 'Unknown Author',
                                          fSize: 14,
                                          color: mainColor2!,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),

                  // Film Project field - this will now store the film name
                  contractInput(
                    context,
                    "Film Project Name",
                    _controller.filmController,
                    icon: Icons.movie_creation_outlined,
                  ),
                  contractInput(
                    context,
                    "Contract Date",
                    _controller.dateController,
                    isDate: true,
                    icon: Icons.date_range_outlined,
                  ),
                  contractInput(
                    context,
                    "Expiry Date",
                    _controller.expiryDateController,
                    isDate: true,
                    icon: Icons.date_range_outlined,
                  ),
                  contractInput(
                    context,
                    "Agreed Price (\$)",
                    _controller.priceController,
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                  ),
                  contractInput(
                    context,
                    "Royalty Percentage",
                    _controller.royaltyController,
                    icon: Icons.percent,
                    keyboardType: TextInputType.number,
                  ),

                  // Additional Terms Section
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TextFormField(
                      controller: _controller.additionalTermsController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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
                  ),

                  // Changes Allowed Percentage Section
                  Obx(() => Padding(
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
                              groupValue: _controller.changesAllowedPercentage.value,
                              onChanged: (String? newValue) {
                                _controller.changesAllowedPercentage.value = newValue!;
                              },
                              activeColor: secondaryColor,
                            ),
                            styleText(text: "5%", fSize: 16, color: textColor2),
                            const SizedBox(width: 15),
                            Radio<String>(
                              value: '10%',
                              groupValue: _controller.changesAllowedPercentage.value,
                              onChanged: (String? newValue) {
                                _controller.changesAllowedPercentage.value = newValue!;
                              },
                              activeColor: secondaryColor,
                            ),
                            styleText(text: "10%", fSize: 16, color: textColor2),
                            const SizedBox(width: 15),
                            Radio<String>(
                              value: '15%',
                              groupValue: _controller.changesAllowedPercentage.value,
                              onChanged: (String? newValue) {
                                _controller.changesAllowedPercentage.value = newValue!;
                              },
                              activeColor: secondaryColor,
                            ),
                            styleText(text: "15%", fSize: 16, color: textColor2),
                          ],
                        ),
                      ],
                    ),
                  )),

                  // Signature Section - Updated to handle image properly
                  Obx(() => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        styleText(
                          text: "Your Signature:",
                          fSize: 16,
                          color: textColor2,
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _controller.pickSignatureImage(),
                          child: Container(
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
                            child: _controller.signatureImagePath.value == null
                                ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: secondaryColor,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                styleText(
                                  text: "Tap to add signature",
                                  fSize: 14,
                                  color: mainColor2!,
                                ),
                              ],
                            )
                                : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_controller.signatureImagePath.value!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 100,
                              ),
                            ),
                          ),
                        ),
                        if (_controller.signatureImagePath.value != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _controller.signatureImagePath.value = null;
                                  },
                                  child: styleText(
                                    text: "Remove",
                                    fSize: 14,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            styleText(
              text: "By clicking 'Send Contract', you confirm sending the contract details to the recipient.",
              fSize: 20,
              color: textColor2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Send Contract Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: (_controller.isSubmitting.value || _controller.loadingUsers.value)
                    ? null
                    : () {
                  _controller.sendContract(context: context);
                },
                child: _controller.isSubmitting.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : styleText(
                  text: "Send Contract",
                  fSize: 22,
                  color: textColor2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
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
                  Get.snackbar("Message", "Message feature coming soon!");
                },
                child: styleText(
                  text: "Message Recipient",
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
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextFormField(
        controller: controller,
        readOnly: isDate,
        keyboardType: keyboardType,
        onTap: isDate
            ? () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
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
              ? Icon(icon ?? Icons.person_search, color: secondaryColor)
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