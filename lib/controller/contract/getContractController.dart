import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../authController/loginGetX.dart';

class GetContractController extends GetxController {
  var contracts = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContracts();
  }

  Future<void> fetchContracts() async {
    try {
      isLoading(true);
      errorMessage('');

      final loginController = Get.find<loginGetx>();
      final userId = loginController.userId.value;

      if (userId == 0) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('http://10.0.2.2/BookFlix/get_pending_contracts.php'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          contracts.assignAll(List<Map<String, dynamic>>.from(data['contracts']));
        } else {
          throw Exception(data['message'] ?? 'Failed to load contracts');
        }
      } else {
        throw Exception('Failed to load contracts: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage(e.toString());
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> refreshContracts() async {
    await fetchContracts();
  }
}