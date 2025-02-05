import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_constants.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/presentation/providers/task_provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {

  @override
  void initState() {
    super.initState();
    _loadTotalTasks();
  }

  void _loadTotalTasks() {
    Future.microtask(() =>
        // ignore: use_build_context_synchronously
        context.read<TaskProvider>().getTotalTasks()); // Garante atualização
  }

  @override
  Widget build(BuildContext context) {
    final totalTasks = context.watch<TaskProvider>().totalTasks;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: AppLocalizations.of(context).welcome,
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: AppFonts.extraLarge,
                  fontFamily: AppFonts.urbanist,
                  fontWeight: AppFonts.bold,
                ),
              ),
              TextSpan(
                text: AppConstants.avatarName,
                style: TextStyle(
                  color: AppColors.lightBlue,
                  fontSize: AppFonts.extraLarge,
                  fontFamily: AppFonts.urbanist,
                  fontWeight: AppFonts.bold,
                ),
              ),
              TextSpan(
                text: '.',
                style: TextStyle(
                  color: AppColors.darkPurple,
                  fontSize: AppFonts.extraLarge,
                  fontFamily: AppFonts.urbanist,
                  fontWeight: AppFonts.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s8),
        SizedBox(
          child: Text(
            totalTasks > 0
                ? AppLocalizations.of(context).youHave + totalTasks.toString() + (totalTasks > 1 ? AppLocalizations.of(context).tasksTodo : AppLocalizations.of(context).taskTodo)
                : AppLocalizations.of(context).createTaskAchieve,
            style: TextStyle(
              color: AppColors.bluishGrey,
              fontSize: AppFonts.large,
              fontFamily: AppFonts.urbanist,
              fontWeight: AppFonts.mediumWeight,
            ),
          ),
        ),
      ],
    );
  }
}
