import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app/data/models/bank_model.dart';
import 'package:test_app/data/models/category_model.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/data/repositories/category_repository.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';
import 'package:test_app/presentation/widgets/app_dialogs.dart';

class AddTransactionController extends GetxController {
  late TransactionRepository _transactionRepository;
  late CategoryRepository _categoryRepository;
  late BankRepository _bankRepository;

  // Form Controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Observables
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final Rx<BankModel?> selectedBank = Rx<BankModel?>(null);
  final RxList<BankModel> banks = <BankModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPayback = false.obs;

  @override
  void onInit() async {
    super.onInit();
    _transactionRepository = Get.find<TransactionRepository>();
    _categoryRepository = Get.find<CategoryRepository>();
    _bankRepository = Get.find<BankRepository>();
    selectedDate.value = DateTime.now();
    await loadCategories();
    await loadBanks();
  }

  // Load all categories
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final allCategories = await _categoryRepository.getAllCategories();
      categories.value = allCategories;
    } catch (e) {
      AppDialogs.showSnackbar(
        message: 'Failed to load categories: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Load all banks
  Future<void> loadBanks() async {
    try {
      isLoading.value = true;
      final allBanks = await _bankRepository.getAllBanks();
      banks.value = allBanks;
      if (banks.length == 1) {
        selectedBank.value = banks.first;
      }
    } catch (e) {
      AppDialogs.showSnackbar(
        message: 'Failed to load banks: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Format date to display
  String getFormattedDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Pick date from calendar
  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      update();
    }
  }

  // Save transaction
  Future<void> saveTransaction() async {
    if (amountController.text.isEmpty) {
      AppDialogs.showSnackbar(message: 'Please enter amount', isError: true);
      return;
    }

    if (selectedDate.value == null) {
      AppDialogs.showSnackbar(message: 'Please select date', isError: true);
      return;
    }

    if (selectedCategory.value == null) {
      AppDialogs.showSnackbar(message: 'Please select category', isError: true);
      return;
    }

    if (selectedBank.value == null) {
      AppDialogs.showSnackbar(message: 'Please select bank', isError: true);
      return;
    }

    try {
      isLoading.value = true;
      final double amount = double.parse(amountController.text);

      final transaction = TransactionModel(
        amount: amount,
        category: selectedCategory.value!.name,
        date: selectedDate.value!,
        notes: notesController.text.isEmpty ? null : notesController.text,
        type: selectedCategory.value!.type,
        bankId: selectedBank.value!.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isPayback: isPayback.value,
        isCompleted: false,
      );

      await _transactionRepository.addTransaction(transaction);

      // Update bank balance
      double newBalance = selectedBank.value!.balance;
      if (transaction.type == 'income') {
        newBalance += transaction.amount;
      } else {
        newBalance -= transaction.amount;
      }
      await _bankRepository.updateBankBalance(
        selectedBank.value!.id!,
        newBalance,
      );

      AppDialogs.showSnackbar(
        message: 'Transaction saved successfully',
        isSuccess: true,
      );

      // Clear only amount and category as requested
      amountController.clear();
      notesController.clear();
      selectedCategory.value = null;
      isPayback.value = false;
      // selectedDate and selectedBank are kept to allow fast multiple entries

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().getAllTransactions();
      }

      if (Get.isRegistered<BanksController>()) {
        Get.find<BanksController>().loadBanks();
      }

      update();
    } catch (e) {
      debugPrint('Error saving transaction: $e');
      AppDialogs.showSnackbar(
        message: 'Failed to save transaction: $e',
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
