import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel/reports/controller_payment.dart';
import 'package:intl/intl.dart';

class FragHomePayment extends StatelessWidget {
  const FragHomePayment({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ControllerPayment());
    return Scaffold(
      appBar: AppBar(title: const Text('Revenue Reports')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            _TopControls(controller: controller),
            const SizedBox(height: 12),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Payment Type Report',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),
                            _PaymentTypeControls(controller: controller),

                            const Divider(height: 20),

                            Obx(() {
                              final map = controller.paymentTypeSummary;
                              if (map.isEmpty) {
                                return const Text('No data');
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: map.entries.map((e) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(e.key),
                                        Text(
                                          e.value.toStringAsFixed(2),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                            const Divider(height: 30),
                            const Text('Payments'),
                            const SizedBox(height: 6),

                            Expanded(
                              child: Obx(() {
                                final list = controller.filteredPayments;
                                if (list.isEmpty) {
                                  return const Center(child: Text('No payments'));
                                }

                                return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (_, i) {
                                    final p = list[i];

                                    return _SimpleRow(
                                      mode: p.paymentMode,
                                      date: controller.formatDisplayDate(p.createdAt),
                                      amount: p.amount.toStringAsFixed(2),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Date-wise Report',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),
                            _DateControls(controller: controller),

                            const Divider(height: 20),

                            Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total: ${controller.filteredPayments.length} items'),
                                  Text(
                                    '₹ ${controller.totalAmount.value.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            }),

                            const Divider(height: 30),

                            Expanded(
                              child: Obx(() {
                                final list = controller.filteredPayments;
                                if (list.isEmpty) {
                                  return const Center(child: Text('No records'));
                                }

                                return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (_, i) {
                                    final p = list[i];

                                    return _SimpleRow(
                                      mode: p.paymentMode,
                                      date: controller.formatDisplayDate(p.createdAt),
                                      amount: p.amount.toStringAsFixed(2),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SimpleRow extends StatelessWidget {
  final String mode;
  final String date;
  final String amount;

  const _SimpleRow({
    required this.mode,
    required this.date,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              mode,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          Expanded(
            child: Text(
              date,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text("₹ $amount",textAlign: TextAlign.right,style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14,),
            ),
          ),
        ],
      ),
    );
  }
}
class _TopControls extends StatelessWidget {
  final ControllerPayment controller;

  const _TopControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () => controller.resetFilters(),
          icon: const Icon(Icons.refresh),
          label: const Text('Reset'),
        ),
        const SizedBox(width: 12),
        ElevatedButton.icon(
          onPressed: () => controller.loadAllPayments(),
          icon: const Icon(Icons.download),
          label: const Text('Reload'),
        ),
        ElevatedButton.icon(
          onPressed: controller.exportRevenuePdf,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Export PDF"),
        ),

        const Spacer(),
        Obx(() => Text(
          'Total: ₹ ${controller.totalAmount.value.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
}
class _PaymentTypeControls extends StatefulWidget {
  final ControllerPayment controller;
  const _PaymentTypeControls({required this.controller});

  @override
  State<_PaymentTypeControls> createState() => _PaymentTypeControlsState();
}

class _PaymentTypeControlsState extends State<_PaymentTypeControls> {
  final List<String> _modes = ['All', 'CASH', 'CARD', 'UPI', 'PENDING'];
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selected,
      items: _modes.map((m) =>
          DropdownMenuItem(value: m, child: Text(m))).toList(),
      onChanged: (v) {
        if (v == null) return;
        setState(() => _selected = v);

        if (v == 'All') {
          widget.controller.resetFilters();
        } else {
          widget.controller.getPaymentTypeReport(v);
        }
      },
    );
  }
}


class _DateControls extends StatefulWidget {
  final ControllerPayment controller;
  const _DateControls({required this.controller});

  @override
  State<_DateControls> createState() => _DateControlsState();
}

class _DateControlsState extends State<_DateControls> {
  DateTime selectedDate = DateTime.now();
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          children: [

            ElevatedButton(
              onPressed: () => pickDaily(context),
              child: const Text('Daily'),
            ),
            ElevatedButton(
              onPressed: () => pickMonthly(context),
              child: const Text('Monthly'),
            ),
            ElevatedButton(
              onPressed: () => pickYearly(context),
              child: const Text('Yearly'),
            ),
            ElevatedButton(
              onPressed: () => widget.controller.resetFilters(),
              child: const Text('Show All'),
            ),
          ],
        ),

        const SizedBox(height: 8),
        Text(
          'Selected: ${DateFormat('yyyy-MM-dd').format(selectedDate)}  |  Year: $selectedYear',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Future<void> pickDaily(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.controller.getDailyReport(picked);
    }
  }

  Future<void> pickMonthly(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText:'Pick any date in the month',
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
      widget.controller.getMonthlyReport(picked);
    }
  }

  Future<void> pickYearly(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(selectedYear, 1, 1),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Pick year',
    );

    if (picked != null) {
      setState(() => selectedYear = picked.year);
      widget.controller.getYearlyReport(picked.year);
    }
  }
}
