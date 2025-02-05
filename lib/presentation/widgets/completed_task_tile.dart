import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/presentation/providers/completed_task_provider.dart';

class CompletedTaskTile extends StatefulWidget {
  final TaskModel task;
  const CompletedTaskTile({super.key, required this.task});

  @override
  // ignore: library_private_types_in_public_api
  _CompletedTaskTileState createState() => _CompletedTaskTileState();
}

class _CompletedTaskTileState extends State<CompletedTaskTile> {
  bool isExpanded = false;

  void deleteTask() {
    final taskProvider = context.read<CompletedTaskProvider>();
    taskProvider.deleteTask(widget.task.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.s24,
        vertical: AppSizes.s8,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundGray,
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
        ),
        child: Column(
          children: [
            ListTile(
              leading: Checkbox(
                value: widget.task.isCompleted,
                onChanged: (v) {},
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall),
                ),
                side: BorderSide(
                  color: AppColors.grey400,
                  width: AppSizes.s2,
                ),
                fillColor: WidgetStateProperty.all(AppColors.lightGrey),
              ),
              title: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  widget.task.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.grey400,
                  ),
                ),
              ),
              trailing: 
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: AppColors.primaryRed,
                      ),
                      onPressed: deleteTask,
                    ),
            ),
            
          ],
        ),
      ),
    );
  }
}
