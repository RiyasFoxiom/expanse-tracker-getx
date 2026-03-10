import 'package:get/get.dart';
import 'package:test_app/data/datasources/bank_local_datasource.dart';
import 'package:test_app/data/datasources/category_local_datasource.dart';
import 'package:test_app/data/datasources/local_auth_datasource.dart';
import 'package:test_app/data/datasources/transaction_local_datasource.dart';
import 'package:test_app/data/repositories/bank_repository.dart';
import 'package:test_app/data/repositories/category_repository.dart';
import 'package:test_app/data/repositories/local_auth_repository_impl.dart';
import 'package:test_app/data/repositories/transaction_repository.dart';
import 'package:test_app/domain/repositories/local_auth_repository.dart';
import 'package:test_app/presentation/controllers/add_banks/add_banks_controller.dart';
import 'package:test_app/presentation/controllers/add_category/add_category_controller.dart';
import 'package:test_app/presentation/controllers/add_transaction/add_transaction_controller.dart';
import 'package:test_app/presentation/controllers/banks/banks_controller.dart';
import 'package:test_app/presentation/controllers/categories/categories_controller.dart';
import 'package:test_app/presentation/controllers/home/home_controller.dart';
import 'package:test_app/presentation/controllers/landing/landing_controller.dart';
import 'package:test_app/presentation/controllers/profile/profile_controller.dart';
import 'package:test_app/presentation/controllers/splash/splash_controller.dart';
import 'package:test_app/core/services/local_auth_service.dart';
import 'package:test_app/presentation/controllers/transactions/transactions_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Initialize data layer
    Get.put<CategoryLocalDataSource>(CategoryLocalDataSource());
    Get.put<CategoryRepository>(
      CategoryRepository(Get.find<CategoryLocalDataSource>()),
    );
    Get.put<TransactionLocalDataSource>(TransactionLocalDataSource());
    Get.put<TransactionRepository>(
      TransactionRepository(Get.find<TransactionLocalDataSource>()),
    );

    Get.put<BankLocalDataSource>(BankLocalDataSource());
    Get.put<BankRepository>(BankRepository(Get.find<BankLocalDataSource>()));

    Get.put(LocalAuthService());

    Get.put(LocalAuthDataSource(Get.find()));
    Get.put<LocalAuthRepository>(LocalAuthRepositoryImpl(Get.find()));

    // Initialize controllers
    Get.put(SplashController(Get.find<LocalAuthRepository>()));
    Get.lazyPut(() => LandingController());
    Get.lazyPut(() => AddCategoryController(), fenix: true);
    Get.lazyPut(() => CategoriesController());

    Get.lazyPut(() => AddTransactionController());

    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => TransactionsController(), fenix: true);
    Get.lazyPut(() => BanksController(), fenix: true);
    Get.lazyPut(() => AddBanksController());
    Get.put<ProfileController>(ProfileController(), permanent: true);
    // Get.lazyPut(() => BankTransactionsController(), fenix: true);
  }
}
