import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/core/helpers/screen_helper.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/controllers/bank_transaction/bank_transaction_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);

class BankTransactionView extends GetView<BankTransactionController> {
  const BankTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);
    final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Screen.close(),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white : Colors.black,
              border: Border.all(
                color: isDark ? Colors.white : Colors.black,
                width: 2,
              ),
            ),
            child: Icon(
              CupertinoIcons.back,
              color: isDark ? Colors.black : Colors.white,
              size: 20,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _kAccentYellow,
              border: Border.all(color: Colors.black, width: 2.5),
            ),
            child: AppText(
              controller.bank.name.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 16),
            child: GestureDetector(
              onTap: () => _showFilterSheet(context),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _kAccentBlue,
                  border: Border.all(color: Colors.black, width: 2.5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(3, 3)),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.slider_horizontal_3,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(radius: 16));
        }

        final dataSource = _BankTransactionsDataSource(
          transactions: controller.transactions,
          isDark: isDark,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      label: 'INCOME',
                      value:
                          '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                      accent: _kAccentGreen,
                      cardBg: cardBg,
                    ),
                  ),
                  12.wBox,
                  Expanded(
                    child: _buildStatCard(
                      label: 'EXPENSE',
                      value:
                          '₹${controller.totalExpense.value.toStringAsFixed(2)}',
                      accent: _kAccentRed,
                      cardBg: cardBg,
                    ),
                  ),
                ],
              ),
              10.hBox,
              Row(
                children: [
                  Expanded(
                    child: _buildChipCard(
                      label: 'TYPE',
                      value: controller.selectedType.value.toUpperCase(),
                      cardBg: cardBg,
                      isDark: isDark,
                    ),
                  ),
                  12.wBox,
                  Expanded(
                    child: _buildChipCard(
                      label: 'DATE',
                      value: controller.dateLabel,
                      cardBg: cardBg,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              10.hBox,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  border: const Border.fromBorderSide(_kBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: AppText(
                  '${controller.transactions.length} TRANSACTIONS  •  TOTAL VALUE ₹${controller.totalValue.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              18.hBox,
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: cardBg,
                  border: const Border.fromBorderSide(_kBorder),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: _nbLabel('BANK TRANSACTION TABLE', isDark),
              ),
              18.hBox,
              Expanded(
                child: controller.transactions.isEmpty
                    ? _buildEmptyState(isDark, cardBg)
                    : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardBg,
                          border: const Border.fromBorderSide(_kBorder),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(5, 5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.black),
                          child: SfDataGrid(
                            source: dataSource,
                            columnWidthMode: ColumnWidthMode.none,
                            horizontalScrollPhysics:
                                const AlwaysScrollableScrollPhysics(),
                            verticalScrollPhysics:
                                const AlwaysScrollableScrollPhysics(),
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            rowHeight: 60,
                            headerRowHeight: 56,
                            columns: [
                              GridColumn(
                                columnName: 'date',
                                width: 130,
                                label: _GridHeaderLabel(label: 'DATE'),
                              ),
                              GridColumn(
                                columnName: 'category',
                                width: 180,
                                label: _GridHeaderLabel(label: 'CATEGORY'),
                              ),
                              GridColumn(
                                columnName: 'type',
                                width: 120,
                                label: _GridHeaderLabel(label: 'TYPE'),
                              ),
                              GridColumn(
                                columnName: 'amount',
                                width: 140,
                                label: _GridHeaderLabel(label: 'AMOUNT'),
                              ),
                              GridColumn(
                                columnName: 'notes',
                                width: 140,
                                label: _GridHeaderLabel(label: 'NOTES'),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatCard({
    required String label,
    required String value,
    required Color accent,
    required Color cardBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        border: const Border.fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              color: Colors.grey,
            ),
          ),
          6.hBox,
          AppText(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChipCard({
    required String label,
    required String value,
    required Color cardBg,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cardBg,
        border: const Border.fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: Colors.grey,
            ),
          ),
          4.hBox,
          AppText(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.7,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark, Color cardBg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
      decoration: BoxDecoration(
        color: cardBg,
        border: const Border.fromBorderSide(_kBorder),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(5, 5), blurRadius: 0),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.building_2_fill,
              size: 50,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            18.hBox,
            AppText(
              'NO TRANSACTIONS FOUND',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white54 : Colors.black54,
                letterSpacing: 1,
              ),
            ),
            8.hBox,
            AppText(
              'TRY CHANGING YOUR TYPE OR DATE FILTER.',
              align: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white38 : Colors.black38,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nbLabel(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white : Colors.black,
        border: Border.all(
          color: isDark ? Colors.white : Colors.black,
          width: 2,
        ),
      ),
      child: AppText(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: isDark ? Colors.black : Colors.white,
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);
        final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;

        return Container(
          decoration: BoxDecoration(
            color: bg,
            border: const Border(
              top: BorderSide(color: Colors.black, width: 2.5),
              left: BorderSide(color: Colors.black, width: 2.5),
              right: BorderSide(color: Colors.black, width: 2.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 42, height: 4, color: Colors.black26),
              ),
              20.hBox,
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                color: _kAccentYellow,
                child: const AppText(
                  'FILTER OPTIONS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
              ),
              20.hBox,
              AppText(
                'TRANSACTION TYPE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: 1,
                ),
              ),
              12.hBox,
              Obx(
                () => Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _filterChip(
                      label: 'ALL',
                      value: 'all',
                      isDark: isDark,
                      cardBg: cardBg,
                    ),
                    _filterChip(
                      label: 'INCOME',
                      value: 'income',
                      isDark: isDark,
                      cardBg: cardBg,
                    ),
                    _filterChip(
                      label: 'EXPENSE',
                      value: 'expense',
                      isDark: isDark,
                      cardBg: cardBg,
                    ),
                  ],
                ),
              ),
              20.hBox,
              AppText(
                'DATE FILTER',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                  letterSpacing: 1,
                ),
              ),
              12.hBox,
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showMonthYearPicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: cardBg,
                          border: const Border.fromBorderSide(_kBorder),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              offset: Offset(3, 3),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Obx(
                          () => AppText(
                            controller.dateLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  10.wBox,
                  GestureDetector(
                    onTap: () => controller.updateDate(null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: _kAccentRed,
                        border: const Border.fromBorderSide(_kBorder),
                      ),
                      child: const AppText(
                        'CLEAR',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              20.hBox,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.clearFilters();
                    Navigator.of(ctx).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kAccentBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2.5),
                    ),
                  ),
                  child: const AppText(
                    'RESET ALL FILTERS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filterChip({
    required String label,
    required String value,
    required bool isDark,
    required Color cardBg,
  }) {
    final isSelected = controller.selectedType.value == value;
    final color = switch (value) {
      'income' => _kAccentGreen,
      'expense' => _kAccentRed,
      _ => _kAccentBlue,
    };

    return GestureDetector(
      onTap: () => controller.updateType(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : cardBg,
          border: const Border.fromBorderSide(_kBorder),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0),
          ],
        ),
        child: AppText(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) async {
    final initialDate = controller.selectedDate.value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      controller.updateDate(picked);
    }
  }
}

class _GridHeaderLabel extends StatelessWidget {
  const _GridHeaderLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      color: _kAccentYellow,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AppText(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.black,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _BankTransactionsDataSource extends DataGridSource {
  _BankTransactionsDataSource({
    required List<TransactionModel> transactions,
    required this.isDark,
  }) : _rows = transactions
           .map<DataGridRow>(
             (tx) => DataGridRow(
               cells: [
                 DataGridCell<String>(
                   columnName: 'date',
                   value: DateFormat('dd MMM yyyy').format(tx.date),
                 ),
                 DataGridCell<String>(
                   columnName: 'category',
                   value: tx.category.toUpperCase(),
                 ),
                 DataGridCell<String>(
                   columnName: 'type',
                   value: tx.type.toUpperCase(),
                 ),
                 DataGridCell<String>(
                   columnName: 'amount',
                   value: '₹${tx.amount.toStringAsFixed(2)}',
                 ),
                 DataGridCell<String>(
                   columnName: 'notes',
                   value: (tx.notes == null || tx.notes!.trim().isEmpty)
                       ? '-'
                       : tx.notes!,
                 ),
               ],
             ),
           )
           .toList();

  final bool isDark;
  final List<DataGridRow> _rows;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final type = row
        .getCells()
        .firstWhere((cell) => cell.columnName == 'type')
        .value
        .toString()
        .toLowerCase();
    final isIncome = type == 'income';

    return DataGridRowAdapter(
      color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      cells: row.getCells().map((cell) {
        final isAmount = cell.columnName == 'amount';
        final textColor = isAmount
            ? (isIncome ? _kAccentGreen : _kAccentRed)
            : (isDark ? Colors.white : Colors.black);

        return Container(
          alignment: cell.columnName == 'amount'
              ? Alignment.centerRight
              : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            cell.value.toString(),
            maxLines: cell.columnName == 'notes' ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isAmount ? FontWeight.w900 : FontWeight.w700,
              color: textColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}
