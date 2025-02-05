import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_constants.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/presentation/providers/task_provider.dart';
import 'package:taski/presentation/widgets/create_task_modal.dart';
import 'package:taski/presentation/widgets/task_app_bar.dart';
import 'package:taski/presentation/widgets/task_tile.dart';
import 'package:taski/presentation/widgets/welcome_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks(isRefresh: true);
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final taskProvider = context.read<TaskProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      if (taskProvider.hasMore && !taskProvider.isLoading) {
        taskProvider.loadTasks(isRefresh: false);
      }
    }
  }

  void _showCreateTaskModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSizes.borderRadiusLarge),
        ),
      ),
      builder: (context) => const CreateTaskModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.s16),
        child: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            String message;
            if (taskProvider.errorMessage != null) {
              if (taskProvider.errorMessage == AppConstants.errorLoadTasks) {
                message = AppLocalizations.of(context).errorLoadTasks;
              } else if (taskProvider.errorMessage ==
                  AppConstants.errorUpdateTask) {
                message = AppLocalizations.of(context).errorUpdateTask;
              } else if (taskProvider.errorMessage ==
                  AppConstants.errorAddTask) {
                message = AppLocalizations.of(context).errorAddTask;
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
                context.read<TaskProvider>().clearErrorMessage();
              });
            }
            if (taskProvider.isLoading && taskProvider.tasks.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<TaskProvider>().loadTasks(isRefresh: true);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSizes.s16, right: AppSizes.s16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Welcome(),
                    ),
                  ),
                  Expanded(
                    child: taskProvider.tasks.isEmpty
                        ? Center(
                            child: CreateTask(context),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: taskProvider.tasks.length +
                                (taskProvider.isLoading ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= taskProvider.tasks.length) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              final task = taskProvider.tasks[index];
                              return TaskTile(task: task);
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Column CreateTask(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          AppConstants.imageNotFound,
          width: AppSizes.spacingLarge,
          height: AppSizes.spacingLarge,
        ),
        SizedBox(height: AppSizes.s12),
        Text(
          AppLocalizations.of(context).youHaveNoTasks,
          style: TextStyle(
            color: AppColors.grey400,
            fontSize: AppFonts.large,
            fontFamily: AppFonts.urbanist,
            fontWeight: AppFonts.semiBold,
          ),
        ),
        SizedBox(height: AppSizes.s20),
        ElevatedButton.icon(
          onPressed: () {
            _showCreateTaskModal();
          },
          icon: Icon(Icons.add, color: AppColors.lightBlue),
          label: Text(
            AppLocalizations.of(context).createTask,
            style: TextStyle(
              color: AppColors.lightBlue,
              fontSize: AppFonts.mediumLarge,
              fontFamily: AppFonts.urbanist,
              fontWeight: AppFonts.semiBold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            // ignore: deprecated_member_use
            backgroundColor: AppColors.transparentBlue,
            padding: EdgeInsets.symmetric(
                horizontal: AppSizes.s24, vertical: AppSizes.s12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.s8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
