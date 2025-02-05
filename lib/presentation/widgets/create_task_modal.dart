import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/presentation/providers/task_provider.dart';

class CreateTaskModal extends StatefulWidget {
  const CreateTaskModal({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateTaskModalState createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.s16,
          right: AppSizes.s16,
          top: AppSizes.s16,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSizes.s16,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    activeColor: AppColors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppSizes.borderRadiusSmall),
                    ),
                    side: BorderSide(
                      color: AppColors.grey400,
                      width: AppSizes.s2,
                    ),
                    onChanged: (bool? value) {
                      setState(() {
                        isCompleted = value ?? false;
                      });
                    },
                  ),
                  SizedBox(width: AppSizes.s8),
                  Expanded(
                    child: TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).whatsInYorMind,
                        hintStyle: TextStyle(
                          fontSize: AppFonts.large,
                          fontFamily: AppFonts.urbanist,
                          color: AppColors.bluishGrey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.s20),
              Row(
                children: [
                  SizedBox(width: AppSizes.s12),
                  Icon(Icons.edit, color: AppColors.bluishGrey),
                  SizedBox(width: AppSizes.s16),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context).addNote,
                        hintStyle: TextStyle(color: AppColors.bluishGrey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    String title = titleController.text.trim();
                    if (title.isNotEmpty) {
                      context.read<TaskProvider>().addTask(
                            titleController.text,
                            noteController.text,
                            isCompleted,
                          );
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context).create,
                    style: TextStyle(
                      color: AppColors.lightBlue,
                      fontSize: AppFonts.large,
                      fontFamily: AppFonts.urbanist,
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
