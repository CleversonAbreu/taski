
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:taski/core/constants/app_constants.dart';
import 'package:taski/core/constants/app_sizes.dart';
import 'package:taski/core/theme/app_collors.dart';
import 'package:taski/presentation/widgets/create_task_modal.dart';
import 'task_page.dart';
import 'find_task_page.dart';
import 'completed_task_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return TaskPage(key: UniqueKey());
      case 1:
        return TaskPage(key: UniqueKey());
      case 2:
        return FindTaskPage(key: UniqueKey());
      case 3:
        return CompletedTaskPage(key: UniqueKey());
      default:
        return TaskPage(key: UniqueKey());
    }
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      setState(() {
        _selectedIndex = 0;
      });
      _showCreateTaskModal();
    } else {
      setState(() {
        _selectedIndex = index;
      });
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
      body: _getPage(_selectedIndex), 
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.softGrey,
          ),
          BottomNavigationBar(
            backgroundColor: AppColors.backgroundWhite,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            selectedItemColor: AppColors.lightBlue,
            unselectedItemColor: AppColors.grey400,
            onTap: _onItemTapped,
            items: [
              _buildNavBarItem(AppConstants.iconTodo, AppLocalizations.of(context).toDo, 0),
              _buildNavBarItem(AppConstants.iconPlus, AppLocalizations.of(context).create, 1),
              _buildNavBarItem(AppConstants.iconSearch, AppLocalizations.of(context).search, 2),
              _buildNavBarItem(AppConstants.iconCheck, AppLocalizations.of(context).done, 3),
            ],
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(String icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: AppSizes.s12),
        child: SvgPicture.asset(
          icon,
          width: AppSizes.s24,
          height: AppSizes.s24,
          colorFilter: ColorFilter.mode(
            AppColors.lightGrey,
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.only(bottom: AppSizes.s12),
        child: SvgPicture.asset(
          icon,
          width: AppSizes.s24,
          height: AppSizes.s24,
          colorFilter: ColorFilter.mode(
            AppColors.lightBlue,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}
