import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:taski/core/constants/app_constants.dart';
import 'package:taski/core/constants/app_fonts.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';



class TaskAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TaskAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.all(AppSizes.s8),
        child: Row(
          children: [
            Image.asset(
              AppConstants.imageLogo,
              width: AppSizes.s40,
              height: AppSizes.s40,
            ),
            Image.asset(
              AppConstants.imageNameLogo,
            ),
            SizedBox(width: 172.w),
            Row(
              children: [
                Text(
                  AppConstants.avatarName,
                  style: TextStyle(
                    color: AppColors.darkPurple,
                    fontSize: AppFonts.mediumLarge,
                    fontFamily: AppFonts.urbanist,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
                SizedBox(width: AppSizes.s12),
                CircleAvatar(backgroundImage: AssetImage(AppConstants.imageAvatar)),
              ],
            )
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: AppSizes.s0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
