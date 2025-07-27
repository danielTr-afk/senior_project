import 'package:f_book2/controller/variables.dart';
import 'package:f_book2/view/GlobalWideget/styleText.dart';
import 'package:f_book2/view/contract/contractWideget/contractListForm.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/contract/getContractController.dart';

class contractsListPage extends StatelessWidget {
  contractsListPage({super.key});

  final controller = Get.put(GetContractController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        title: styleText(
          text: "My Contracts",
          fSize: 25,
          color: textColor2,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: secondaryColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: textColor2),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: styleText(
              text: controller.errorMessage.value,
              fSize: 18,
              color: Colors.red,
            ),
          );
        }

        if (controller.contracts.isEmpty) {
          return Center(
            child: styleText(
              text: 'No contracts found',
              fSize: 18,
              color: textColor2,
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.contracts.length,
          itemBuilder: (context, index) {
            final contract = controller.contracts[index];
            return ContractListForm(
              bookTitle: contract['book_title'] ?? 'No Title',
              authorName: contract['author_name'] ?? 'Unknown Author',
              senderName: contract['sender_name'],
              status: contract['status'] ?? 'pending',
              image: contract['book_image'] ?? '',
              price: contract['agreed_price'],
              royalty: contract['royalty_percentage'],
              onTap: () {
                if (contract['id'] != null) {
                  Get.toNamed(
                    '/AcceptContractPage',
                    arguments: {
                      'contractId': contract['id'].toString(),
                      'contractData': contract,
                    },
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Invalid contract data',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            );
          },
        );
      }),
    );
  }
}