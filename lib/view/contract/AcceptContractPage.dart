import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/contract/AcceptContractController.dart';

class AcceptContractPage extends StatelessWidget {
  AcceptContractPage({super.key});

  final controller = Get.put(AcceptContractController());
  final Map<String, dynamic> args = Get.arguments;

  @override
  Widget build(BuildContext context) {
    // Initialize with arguments data if available
    if (controller.contractDetails.isEmpty && args['contractData'] != null) {
      final contractArg = args['contractData'];

      // Only assign if film_name/contract_date aren't empty
      if ((contractArg['film_name']?.toString().isNotEmpty ?? false) &&
          (contractArg['contract_date']?.toString().isNotEmpty ?? false)) {
        controller.contractDetails.value = contractArg;
      }
    }


    // Fetch fresh contract details
    controller.fetchContractDetails(args['contractId']);

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
      body: Obx(() {
        if (controller.isLoading.value && controller.contractDetails.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                styleText(
                  text: controller.errorMessage.value,
                  fSize: 18,
                  color: Colors.red,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchContractDetails(args['contractId']),
                  child: Text('Retry'),
                ),
              ],
            ),
          );
        }

        final contract = controller.contractDetails;
        final isPending = controller.isPendingContract();
        final otherPartyName = controller.getOtherPartyName();
        final otherPartyRole = controller.getOtherPartyRole();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: secondaryColor,
                child: Icon(Icons.person, size: 50, color: textColor2),
              ),
              const SizedBox(height: 10),
              styleText(
                text: otherPartyName,
                fSize: 25,
                color: textColor2,
                fontWeight: FontWeight.bold,
              ),
              styleText(
                text: otherPartyRole,
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
                    // Person field (the other party)
                    contractDetailViewOnly(
                        "Person",
                        otherPartyName,
                        Icons.person
                    ),

                    // Book field
                    contractDetailViewOnly(
                        "Book",
                        contract['book_title'] ?? 'Not specified',
                        Icons.menu_book
                    ),

                    // Film Project field - Updated to use film_name
                    contractDetailViewOnly(
                        "Film Project",
                        controller.getFilmProjectName(),
                        Icons.movie_creation_outlined
                    ),

                    contractDetailViewOnly(
                        "Contract Date",
                        controller.formatDate(controller.contractDetails['contract_date']?.toString()),
                        Icons.date_range_outlined
                    ),

                    contractDetailViewOnly(
                        "Expiry Date",
                        controller.formatDate(controller.contractDetails['expiry_date']?.toString()),
                        Icons.date_range_outlined
                    ),


                    // Agreed Price
                    contractDetailViewOnly(
                        "Agreed Price (\$)",
                        "\$${controller.formatPrice(contract['agreed_price'])}",
                        Icons.attach_money
                    ),

                    // Royalty Percentage
                    contractDetailViewOnly(
                        "Royalty Percentage",
                        "${controller.formatPrice(contract['royalty_percentage'])}%",
                        Icons.percent
                    ),

                    // Additional Terms Section
                    if (contract['additional_terms'] != null && contract['additional_terms'].toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          maxLines: 4,
                          initialValue: contract['additional_terms'].toString(),
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

                    // Changes Allowed Percentage Section
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
                                groupValue: controller.selectedChangesPercentage.value,
                                onChanged: null, // Disabled for view only
                                activeColor: secondaryColor,
                              ),
                              styleText(text: "5%", fSize: 16, color: textColor2),
                              const SizedBox(width: 15),
                              Radio<String>(
                                value: '10%',
                                groupValue: controller.selectedChangesPercentage.value,
                                onChanged: null, // Disabled for view only
                                activeColor: secondaryColor,
                              ),
                              styleText(text: "10%", fSize: 16, color: textColor2),
                              const SizedBox(width: 15),
                              Radio<String>(
                                value: '15%',
                                groupValue: controller.selectedChangesPercentage.value,
                                onChanged: null, // Disabled for view only
                                activeColor: secondaryColor,
                              ),
                              styleText(text: "15%", fSize: 16, color: textColor2),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Signature Section - Updated to show image if available
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          styleText(
                            text: "${otherPartyRole}'s Signature:",
                            fSize: 16,
                            color: textColor2,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: secondaryColor.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: controller.hasContractImage()
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                controller.getContractImage(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: mainColor2!,
                                        ),
                                        const SizedBox(height: 8),
                                        styleText(
                                          text: "Failed to load image",
                                          fSize: 14,
                                          color: mainColor2!,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                      color: secondaryColor,
                                    ),
                                  );
                                },
                              ),
                            )
                                : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.draw,
                                    size: 40,
                                    color: mainColor2!,
                                  ),
                                  const SizedBox(height: 8),
                                  styleText(
                                    text: "Digital Signature",
                                    fSize: 16,
                                    color: mainColor2!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (isPending) ...[
                const SizedBox(height: 20),
                styleText(
                  text: "By clicking 'Accept', you agree to the terms outlined in the contract between yourself and the ${otherPartyRole.toLowerCase()}.",
                  fSize: 20,
                  color: textColor2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // Action Buttons Row
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
                        onPressed: controller.isLoading.value ? null : () {
                          controller.respondToContract(
                              args['contractId'].toString(),
                              'reject'
                          );
                        },
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : styleText(
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
                        onPressed: controller.isLoading.value ? null : () {
                          controller.respondToContract(
                              args['contractId'].toString(),
                              'accept'
                          );
                        },
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : styleText(
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
              ] else ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: contract['status'] == 'accepted' ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: contract['status'] == 'accepted' ? Colors.green : Colors.red,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        contract['status'] == 'accepted' ? Icons.check_circle : Icons.cancel,
                        color: contract['status'] == 'accepted' ? Colors.green : Colors.red,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      styleText(
                        text: "Contract ${contract['status'] == 'accepted' ? 'Accepted' : 'Rejected'}",
                        fSize: 20,
                        color: textColor2,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
              ],

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
                    // Navigate to messaging page or show message dialog
                    Get.snackbar(
                      'Message',
                      'Opening chat with ${otherPartyName}...',
                      backgroundColor: mainColor2,
                      colorText: textColor2,
                    );
                  },
                  child: styleText(
                    text: "Message ${otherPartyRole}",
                    fSize: 22,
                    color: textColor2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
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