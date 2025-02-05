import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_constants.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/presentation/providers/completed_task_provider.dart';
import 'package:taski/presentation/widgets/completed_task_tile.dart';
import 'package:taski/presentation/widgets/task_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CompletedTaskPage extends StatefulWidget {
  const CompletedTaskPage({super.key});

  @override
  _CompletedTaskPageState createState() => _CompletedTaskPageState();
}

class _CompletedTaskPageState extends State<CompletedTaskPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompletedTaskProvider>().loadTasks(isRefresh: true);
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final taskProvider = context.read<CompletedTaskProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (taskProvider.hasMore && !taskProvider.isLoading) {
        taskProvider.loadTasks(isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      body: Consumer<CompletedTaskProvider>(
        builder: (context, taskProvider, child) {
          if (taskProvider.errorMessage != null) {
            String message;
            if (taskProvider.errorMessage == AppConstants.errorLoadTasks) {
              message = AppLocalizations.of(context).errorLoadTasks;
            } else if (taskProvider.errorMessage ==
                AppConstants.errorDeleteTask) {
              message = AppLocalizations.of(context).errorDeleteTask;
            } else {
              message = AppLocalizations.of(context).unexpectedError;
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    message,
                    style: TextStyle(color: AppColors.backgroundWhite),
                  ),
                  backgroundColor: AppColors.primaryRed,
                ),
              );
            });
            Future.delayed(Duration.zero, () {
              // ignore: use_build_context_synchronously
              context.read<CompletedTaskProvider>().clearErrorMessage();
            });
          }

          if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context
                  .read<CompletedTaskProvider>()
                  .loadTasks(isRefresh: true);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s32, vertical: AppSizes.s12),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).completedTasks,
                        style: TextStyle(
                          color: AppColors.darkPurple,
                          fontSize: AppFonts.extraLarge,
                          fontFamily: AppFonts.urbanist,
                          fontWeight: AppFonts.bold,
                        ),
                      ),
                      SizedBox(width: 115.w),
                      Consumer<CompletedTaskProvider>(
                        builder: (context, provider, child) {
                          return provider.isDeletingAll
                              ? const SizedBox(
                                  height: AppSizes.s20,
                                  width: AppSizes.s20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: AppSizes.s2,
                                    color: AppColors.primaryRed,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    await provider.deleteAllTasks();
                                  },
                                  child: Text(
                                    AppLocalizations.of(context).deleteAll,
                                    style: TextStyle(
                                      color: AppColors.primaryRed,
                                      fontSize: AppFonts.mediumLarge,
                                      fontFamily: AppFonts.urbanist,
                                      fontWeight: AppFonts.semiBold,
                                    ),
                                  ),
                                );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: taskProvider.tasks.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context).noCompletedTaskYet,
                            style: TextStyle(
                              color: AppColors.grey400,
                              fontSize: AppFonts.medium,
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.s4),
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: taskProvider.tasks.length +
                                (taskProvider.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= taskProvider.tasks.length) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              final task = taskProvider.tasks[index];
                              return CompletedTaskTile(task: task);
                            },
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
