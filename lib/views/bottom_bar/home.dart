import 'package:ecoville_bloc/utilities/color_constants.dart';
import 'package:ecoville_bloc/views/bottom_bar/pages/categories_page.dart';
import 'package:ecoville_bloc/views/bottom_bar/pages/home_page.dart';
import 'package:ecoville_bloc/views/bottom_bar/pages/collected_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import '../../blocs/minimal_functionality/bottom_navigation/bottom_navigation_cubit.dart';
import 'pages/add_page.dart';
import 'pages/profile_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget getBody() {
    List<Widget> pages = [
      HomePage(),
       CategoriesPage(),
       AddPage(),
      const NotificationsPage(),
      const ProfilePage(),
    ];
    return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
      builder: (context, state) {
        return IndexedStack(
          index: state is TabChanged ? state.index : 0,
          children: pages,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavigationCubit(),
      child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          extendBody: false,
          body: getBody(),
          bottomNavigationBar: getFooter()),
    );
  }

  Widget getFooter() {
    final List<Map<String, dynamic>> items = [
      {
        "two": Icons.home_outlined,
        "one": Icons.home_rounded,
        "three": "Home",
      },
      {
        "two": Icons.window_outlined,
        "one": Icons.window_rounded,
        "three": "Categories",
      },
      {
        "two": Icons.add,
        "one": Icons.add,
        "three": "add",
      },
      {
        "two": Icons.request_page_outlined,
        "one": Icons.request_page_rounded,
        "three": "Requests",
      },
      {
        "two": Icons.person_2_outlined,
        "one": Icons.person_2_rounded,
        "three": "Profile",
      },
    ];
    return Builder(builder: (context) {
      return BlocBuilder<BottomNavigationCubit, BottomNavigationState>(
        builder: (context, state) {
          return AnimatedBottomNavigationBar.builder(
            elevation: 0,
            // backgroundColor: Colors.white,
            notchSmoothness: NotchSmoothness.softEdge,
            splashRadius: 1,
            itemCount: items.length,
            splashSpeedInMilliseconds: 160,
            activeIndex: state is TabChanged ? state.index : 0,
            gapWidth: 10,
            onTap: (index) {
              BlocProvider.of<BottomNavigationCubit>(context).changeTab(index);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
            },
            tabBuilder: (int index, bool isActive) {
              final icons = items[index];
              return index == 2
                  ? Container(
                      width: 45,
                      height: 45,
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        icons['one'],
                        size: 22,
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Icon(
                          isActive ? icons['one'] : icons['two'],
                          size: 22,
                          color:
                              isActive ? secondaryColor : const Color(0xff666666),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          icons['three'],
                          style: TextStyle(
                            color:
                                isActive ? secondaryColor : Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    );
            },
          );
        },
      );
    });
  }
}
