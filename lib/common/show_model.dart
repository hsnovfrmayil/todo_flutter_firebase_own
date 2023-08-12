import 'package:data_statement/model/todo_model.dart';
import 'package:data_statement/provider/radio_provider.dart';
import 'package:data_statement/provider/service_provider.dart';
import 'package:data_statement/widgets/textfield_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:riverpod/riverpod.dart';
import '../constants/app_style.dart';
import '../provider/date_time_provider.dart';
import '../widgets/date_time_widget.dart';
import '../widgets/radio_widget.dart';

class AddNewTaskModel extends ConsumerWidget {
  AddNewTaskModel({
    super.key,
  });
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateProv = ref.watch(dateProvider);
    return Container(
      padding: EdgeInsets.all(30),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "New Task Todo",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Divider(
            thickness: 1.2,
            color: Colors.grey.shade200,
          ),
          Gap(12),
          Text(
            "Title Task",
            style: AppStyle.headingOne,
          ),
          Gap(6),
          TextFieldWidget(
            hintText: "Add Task name.",
            maxLines: 1,
            txtController: titleController,
          ),
          Gap(12),
          Text(
            "Description",
            style: AppStyle.headingOne,
          ),
          Gap(6),
          TextFieldWidget(
            hintText: "Add Description",
            maxLines: 5,
            txtController: descriptionController,
          ),
          Gap(12),
          Text(
            "Category",
            style: AppStyle.headingOne,
          ),
          Row(
            children: [
              Expanded(
                child: RadioWidget(
                  titleRadio: "LRN",
                  CategColor: Colors.green,
                  valueInput: 1,
                  onChangedValue: () =>
                      ref.read(radioProvider.notifier).update((state) => 1),
                ),
              ),
              Expanded(
                child: RadioWidget(
                  titleRadio: "WRK",
                  CategColor: Colors.blue.shade700,
                  valueInput: 2,
                  onChangedValue: () =>
                      ref.read(radioProvider.notifier).update((state) => 2),
                ),
              ),
              Expanded(
                child: RadioWidget(
                  titleRadio: "GEN",
                  CategColor: Colors.amberAccent.shade700,
                  valueInput: 3,
                  onChangedValue: () =>
                      ref.read(radioProvider.notifier).update((state) => 3),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateTimeWidget(
                iconSection: CupertinoIcons.calendar,
                titleText: "Date",
                valueText: dateProv,
                onTap: () async {
                  final getValue = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2025));
                  if (getValue != null) {
                    print(getValue.toString());
                    final format = DateFormat.yMd();
                    print(format.format(getValue));
                    ref
                        .read(dateProvider.notifier)
                        .update((state) => format.format(getValue));
                  }
                },
              ),
              Gap(22),
              DateTimeWidget(
                iconSection: CupertinoIcons.clock,
                titleText: "Time",
                valueText: ref.watch(timeProvider),
                onTap: () async {
                  final getTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (getTime != null) {
                    ref
                        .read(timeProvider.notifier)
                        .update((state) => getTime.format(context));
                  }
                },
              ),
            ],
          ),
          Gap(12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.blue.shade800,
                        ),
                      ),
                      elevation: 0),
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel"),
                ),
              ),
              Gap(20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0),
                  onPressed: () {
                    final getRadioValue = ref.read(radioProvider);
                    String category = '';
                    switch (getRadioValue) {
                      case 1:
                        category = "Learning";
                        break;
                      case 2:
                        category = "Working";
                        break;
                      case 3:
                        category = "General";
                        break;
                    }

                    ref.read(serviceProvider).addNewTask(
                        "${titleController.text}_101_${category}",
                        ToDoModel(
                          docID: "${titleController.text}_101_${category}",
                          titleTask: titleController.text,
                          description: descriptionController.text,
                          category: category,
                          dateTask: ref.read(dateProvider),
                          timeTask: ref.read(timeProvider),
                          isDone: false,
                        ));
                    print("Data is saving");
                    titleController.clear();
                    descriptionController.clear();
                    ref.read(radioProvider.notifier).update((state) => 0);
                    ref
                        .read(dateProvider.notifier)
                        .update((state) => 'dd/mm/yy');
                    ref
                        .read(timeProvider.notifier)
                        .update((state) => "hh : mm");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Create",
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
