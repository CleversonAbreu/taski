// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:taski/core/constants/app_constants.dart';
// import 'package:taski/core/constants/app_fonts.dart';
// import 'package:taski/core/constants/app_sizes.dart';
// import 'package:taski/core/theme/app_collors.dart';
// import 'package:taski/presentation/providers/find_task_provider.dart';
// import 'package:taski/presentation/widgets/find_task_tile.dart';
// import 'package:taski/presentation/widgets/task_app_bar.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class FindTaskPage extends StatelessWidget {
//   const FindTaskPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: TaskAppBar(),
//       backgroundColor: AppColors.backgroundWhite,
//       body: Padding(
//         padding: EdgeInsets.all(AppSizes.s24),
//         child: Consumer<FindTaskProvider>(
//           builder: (context, provider, child) {
//             return Column(
//               children: [
//                 Container(
//                   height: AppSizes.s48,
//                   decoration: BoxDecoration(
//                     color: AppColors.softGrey,
//                     borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
//                   ),
//                   child: TextField(
//                     controller: provider.searchController,
//                     onChanged: provider.filterTasks,
//                     decoration: InputDecoration(
//                       hintText: AppLocalizations.of(context).searchTask,
//                       hintStyle: TextStyle(fontFamily: AppFonts.urbanist),
//                       prefixIcon: Icon(Icons.search, color: AppColors.lightBlue),
//                       suffixIcon: provider.searchController.text.isNotEmpty
//                           ? IconButton(
//                               icon: Icon(Icons.cancel_rounded, size: AppSizes.iconSizeSmall, color: AppColors.lightGrey),
//                               onPressed: provider.clearSearch,
//                             )
//                           : null,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
//                         borderSide: BorderSide(color: AppColors.lightGrey, width: 1),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(AppSizes.borderRadiusMedium),
//                         borderSide: BorderSide(color: AppColors.lightBlue, width: AppSizes.s2),
//                       ),
//                       contentPadding: EdgeInsets.symmetric(vertical: AppSizes.s12, horizontal: AppSizes.s16),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: AppSizes.s20),
//                 if (provider.isSearching)
//                   Expanded(
//                     child: provider.filteredTasks.isEmpty
//                         ? Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 AppConstants.imageNotFound,
//                                 width: AppSizes.spacingLarge,
//                                 height: AppSizes.spacingLarge,
//                               ),
//                               SizedBox(height: AppSizes.s12),
//                               Text(AppLocalizations.of(context).noResultFound, style: TextStyle(color: AppColors.lightGrey, fontSize: AppSizes.s16)),
//                             ],
//                           )
//                         : ListView.builder(
//                             itemCount: provider.filteredTasks.length,
//                             itemBuilder: (context, index) {
//                               return FindTaskTile(task: provider.filteredTasks[index]);
//                             },
//                           ),
//                   ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taski/core/constants/app_constants.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/presentation/providers/find_task_provider.dart';
import 'package:taski/presentation/widgets/find_task_tile.dart';
import 'package:taski/presentation/widgets/task_app_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FindTaskPage extends StatelessWidget {
  const FindTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TaskAppBar(),
      backgroundColor: AppColors.backgroundWhite,
      body: Padding(
        padding: EdgeInsets.all(AppSizes.s24),
        child: Consumer<FindTaskProvider>(
          builder: (context, provider, child) {
            if (provider.errorMessage != null) {
              String message;

              if (provider.errorMessage == AppConstants.errorLoadTasks) {
                message = AppLocalizations.of(context).errorLoadTasks;
              } else if (provider.errorMessage ==
                  AppConstants.errorUpdateTask) {
                message = AppLocalizations.of(context).errorUpdateTask;
              } else if (provider.errorMessage == AppConstants.errorAddTask) {
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
                context.read<FindTaskProvider>().clearErrorMessage();
              });
            }

            return Column(
              children: [
                Container(
                  height: AppSizes.s48,width: 367,
                  decoration: BoxDecoration(
                    color: AppColors.softGrey,
                    borderRadius:
                        BorderRadius.circular(AppSizes.borderRadiusMedium),
                  ),
                  child: TextField(
                    controller: provider.searchController,
                    onChanged: provider.filterTasks,
                    style: TextStyle(
                      fontFamily: AppFonts.urbanist,
                      fontSize: AppFonts.medium,
                      color: AppColors.darkPurple,
                    ),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).searchTask,
                      hintStyle: TextStyle(fontFamily: AppFonts.urbanist),
                      prefixIcon:
                          Icon(Icons.search, color: AppColors.lightBlue),
                      suffixIcon: provider.searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.cancel_rounded,
                                  size: AppSizes.iconSizeSmall,
                                  color: AppColors.lightGrey),
                              onPressed: provider.clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadiusMedium),
                        borderSide:
                            BorderSide(color: AppColors.lightGrey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadiusMedium),
                        borderSide: BorderSide(
                            color: AppColors.lightBlue, width: AppSizes.s2),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: AppSizes.s12, horizontal: AppSizes.s16),
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.s20),
                if (provider.isSearching)
                  Expanded(
                    child: provider.filteredTasks.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                AppConstants.imageNotFound,
                                width: AppSizes.spacingLarge,
                                height: AppSizes.spacingLarge,
                              ),
                              SizedBox(height: AppSizes.s12),
                              Text(
                                AppLocalizations.of(context).noResultFound,
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: AppSizes.s16,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: provider.filteredTasks.length,
                            itemBuilder: (context, index) {
                              return FindTaskTile(
                                  task: provider.filteredTasks[index]);
                            },
                          ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
