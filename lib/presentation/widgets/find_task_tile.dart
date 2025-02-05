import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/presentation/providers/find_task_provider.dart';

final kWidth = 55.h;

class FindTaskTile extends StatefulWidget {
  final TaskModel task;
  const FindTaskTile({super.key, required this.task});

  @override
  // ignore: library_private_types_in_public_api
  _FindTaskTileState createState() => _FindTaskTileState();
}

class _FindTaskTileState extends State<FindTaskTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.read<FindTaskProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s4,
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
              contentPadding: EdgeInsets.zero,
              leading: Checkbox(
               activeColor: AppColors.lightBlue,
                value: widget.task.isCompleted,
                onChanged: (value) =>taskProvider.toggleTaskCompletion(widget.task),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusSmall),
                ),
                side: BorderSide(
                  color: AppColors.grey400,
                  width: AppSizes.s2,
                ),
              ),
              title: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(widget.task.title,
                    style: TextStyle(
                      color: AppColors.darkPurple,
                      fontSize: AppFonts.large,
                      fontFamily: AppFonts.urbanist,
                      fontWeight: AppFonts.semiBold,
                    )),
              ),
              trailing: isExpanded
                  ? null
                  : IconButton(
                      color: AppColors.bluishGrey,
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        setState(() {
                          isExpanded = true;
                        });
                      },
                    ),
            ),
            if (isExpanded)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: kWidth),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: AppSizes.s16, bottom: AppSizes.s8),
                      child: Text(
                        widget.task.description,
                        style: TextStyle(
                          color: AppColors.bluishGrey,
                          fontSize: AppFonts.medium,
                          fontFamily: AppFonts.urbanist,
                          fontWeight: AppFonts.mediumWeight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
