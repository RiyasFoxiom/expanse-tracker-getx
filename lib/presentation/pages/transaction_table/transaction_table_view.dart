import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:test_app/core/extensions/space_ext.dart';
import 'package:test_app/data/models/transaction_model.dart';
import 'package:test_app/presentation/controllers/transaction_table/transaction_table_controller.dart';
import 'package:test_app/presentation/widgets/app_text.dart';

const _kBorder = BorderSide(color: Colors.black, width: 2.5);
const _kAccentYellow = Color(0xFFFFE600);
const _kAccentGreen = Color(0xFF00C853);
const _kAccentRed = Color(0xFFFF1744);
const _kAccentBlue = Color(0xFF2979FF);

class TransactionTableView extends GetView<TransactionTableController> {
  const TransactionTableView({super.key});

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
        toolbarHeight: 66,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              8.wBox,
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _kAccentYellow,
                    border: Border.all(color: Colors.black, width: 2.5),
                  ),
                  child: AppText(
                    controller.pageTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 16),
            child: Obx(
              () => GestureDetector(
                onTap: () => _showMonthYearPicker(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _kAccentBlue,
                    border: Border.all(color: Colors.black, width: 2.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.calendar,
                        size: 16,
                        color: Colors.white,
                      ),
                      8.wBox,
                      AppText(
                        controller.formattedMonth.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
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

        final dataSource = _TransactionsDataSource(
          transactions: controller.transactions,
          isDark: isDark,
        );

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            children: [
              if (controller.isCategoryMode)
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        label: 'TRANSACTIONS',
                        value: controller.transactionCount.value.toString(),
                        accent: _kAccentBlue,
                        cardBg: cardBg,
                      ),
                    ),
                    12.wBox,
                    Expanded(
                      child: _buildStatCard(
                        label: 'TOTAL VALUE',
                        value:
                            '₹${controller.totalAmount.value.toStringAsFixed(2)}',
                        accent: _kAccentRed,
                        cardBg: cardBg,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            label: 'CURRENT MONTH INCOME',
                            value:
                                '₹${controller.totalIncome.value.toStringAsFixed(2)}',
                            accent: _kAccentGreen,
                            cardBg: cardBg,
                          ),
                        ),
                        12.wBox,
                        Expanded(
                          child: _buildStatCard(
                            label: 'CURRENT MONTH EXPENSE',
                            value:
                                '₹${controller.totalExpense.value.toStringAsFixed(2)}',
                            accent: _kAccentRed,
                            cardBg: cardBg,
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
                        '${controller.transactionCount.value} TRANSACTIONS IN ${controller.formattedMonth.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
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
                child: AppText(
                  controller.isCategoryMode
                      ? 'CURRENT MONTH TABLE FOR ${controller.categoryName!.toUpperCase()}'
                      : 'CURRENT MONTH TABLE FOR ALL TRANSACTIONS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
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
              CupertinoIcons.table,
              size: 44,
              color: isDark ? Colors.white54 : Colors.black45,
            ),
            14.hBox,
            AppText(
              'NO TRANSACTIONS IN THIS MONTH',
              align: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            8.hBox,
            AppText(
              'SELECT ANOTHER MONTH TO VIEW MORE DATA.',
              align: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMonthYearPicker(BuildContext context) async {
    int tempYear = controller.selectedMonth.value.year;
    int tempMonth = controller.selectedMonth.value.month;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        final bg = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F5F0);
        final cardBg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
        final maxYear = DateTime.now().year + 1;

        return StatefulBuilder(
          builder: (context, setSheetState) => Container(
            decoration: BoxDecoration(
              color: bg,
              border: const Border(
                top: BorderSide(color: Colors.black, width: 2.5),
                left: BorderSide(color: Colors.black, width: 2.5),
                right: BorderSide(color: Colors.black, width: 2.5),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, color: Colors.black26),
                20.hBox,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  color: _kAccentYellow,
                  child: const AppText(
                    'SELECT MONTH',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.black,
                    ),
                  ),
                ),
                20.hBox,
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(3, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  height: 100,
                  child: CupertinoPicker(
                    itemExtent: 36,
                    scrollController: FixedExtentScrollController(
                      initialItem: tempYear - 2020,
                    ),
                    onSelectedItemChanged: (idx) {
                      setSheetState(() {
                        tempYear = 2020 + idx;
                      });
                    },
                    children: List.generate(
                      maxYear - 2020 + 1,
                      (index) => Center(
                        child: Text(
                          '${2020 + index}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                20.hBox,
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.7,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final isSelected = tempMonth == month;

                    return GestureDetector(
                      onTap: () {
                        setSheetState(() {
                          tempMonth = month;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? _kAccentBlue : cardBg,
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: Center(
                          child: AppText(
                            DateFormat('MMM').format(DateTime(2024, month)),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                20.hBox,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.of(sheetContext).pop();
                      await controller.updateMonth(
                        DateTime(tempYear, tempMonth, 1),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kAccentYellow,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 2.5),
                      ),
                    ),
                    child: const AppText(
                      'APPLY MONTH',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
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

class _TransactionsDataSource extends DataGridSource {
  _TransactionsDataSource({
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
