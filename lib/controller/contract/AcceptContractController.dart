import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../controller/authController/loginGetX.dart';

class AcceptContractController extends GetxController {
  final loginController = Get.find<loginGetx>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var contractDetails = <String, dynamic>{}.obs;

  // Add these observables for UI state
  var selectedChangesPercentage = ''.obs;
  var formattedContractDate = 'Not specified'.obs;
  var formattedExpiryDate = 'Not specified'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with empty contract details
    contractDetails.value = {};
  }

  Future<void> fetchContractDetails(String contractId) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/get_contract_details.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': loginController.userId.value,
          'contract_id': contractId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          var contract = data['contract'];

          // Convert values for display
          if (contract['agreed_price'] is String) {
            contract['agreed_price'] = double.tryParse(contract['agreed_price']) ?? 0.0;
          }
          if (contract['royalty_percentage'] is String) {
            contract['royalty_percentage'] = double.tryParse(contract['royalty_percentage']) ?? 0.0;
          }

          // Handle dates directly
          contract['contract_date'] = contract['contract_date']?.toString() ?? 'Not specified';
          contract['expiry_date'] = contract['expiry_date']?.toString() ?? 'Not specified';

          // Handle new fields
          contract['film_name'] = contract['film_name']?.toString() ?? '';
          contract['image'] = contract['image']?.toString() ?? '';

          selectedChangesPercentage.value = contract['max_changes_allowed'] ?? '10%';
          contractDetails.value = contract;

          print('Contract Data: $contract');
          print('Film Name: ${contract['film_name']}');
          print('Image: ${contract['image']}');
        } else {
          throw Exception(data['message'] ?? 'Failed to load contract details');
        }
      } else {
        throw Exception('Failed to load contract: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Failed to load contract details: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to load contract details',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> respondToContract(String contractId, String action) async {
    try {
      isLoading(true);
      errorMessage('');

      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/respond_contract.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': loginController.userId.value,
          'contract_id': contractId,
          'action': action,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          Get.back();
          Get.snackbar(
            'Success',
            'Contract ${action}ed successfully',
            backgroundColor: Get.theme.primaryColor,
            colorText: Get.theme.colorScheme.onPrimary,
          );
        } else {
          throw Exception(data['message'] ?? 'Failed to $action contract');
        }
      } else {
        throw Exception('Failed to respond to contract: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage('Failed to respond to contract: ${e.toString()}');
      Get.snackbar(
        'Error',
        'Failed to respond to contract',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading(false);
    }
  }

  // Helper methods for formatting
  String formatDate(String? dateString) {
    print('Formatting date: $dateString'); // Debug print

    if (dateString == null || dateString.isEmpty || dateString == 'null') {
      return 'Not specified';
    }

    try {
      DateTime date;

      // Handle different date formats
      if (dateString.contains('-')) {
        // Handle YYYY-MM-DD format
        date = DateTime.parse(dateString);
      } else {
        // Handle other formats if needed
        date = DateTime.parse(dateString);
      }

      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];

      String formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';
      print('Formatted date result: $formattedDate'); // Debug print
      return formattedDate;
    } catch (e) {
      print('Date formatting error: $e'); // Debug print
      return 'Invalid date: $dateString';
    }
  }

  String formatPrice(dynamic price) {
    if (price == null) return '0.00';

    if (price is num) {
      return price.toStringAsFixed(2);
    }

    if (price is String) {
      try {
        return double.parse(price).toStringAsFixed(2);
      } catch (e) {
        return price;
      }
    }

    return '0.00';
  }

  String getOtherPartyName() {
    final contract = contractDetails.value;
    final userPosition = contract['user_position'] ?? 'receiver';

    if (userPosition == 'sender') {
      return contract['receiver_name'] ?? 'Unknown';
    } else {
      return contract['sender_name'] ?? 'Unknown';
    }
  }

  String getOtherPartyRole() {
    final contract = contractDetails.value;
    final userRole = contract['user_role'] ?? 'author';

    if (userRole == 'author') {
      return 'Director';
    } else if (userRole == 'director') {
      return 'Author';
    } else {
      return 'Author/Director';
    }
  }

  bool isPendingContract() {
    return contractDetails.value['status'] == 'pending';
  }

  // New helper methods for the new fields
  String getFilmProjectName() {
    final contract = contractDetails.value;
    String filmName = contract['film_name']?.toString() ?? '';

    if (filmName.isNotEmpty) {
      return filmName;
    }

    // Fallback to book title if film name is not specified
    return contract['book_title'] ?? 'Not specified';
  }

  String getContractImage() {
    final contract = contractDetails.value;
    return contract['image']?.toString() ?? '';
  }

  bool hasContractImage() {
    String imageUrl = getContractImage();
    return imageUrl.isNotEmpty && imageUrl != 'null';
  }
}