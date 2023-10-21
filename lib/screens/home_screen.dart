import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/app/constants/assets_constants.dart';
import '../app/components/custom_focus_background.dart';
import '../app/components/custom_text.dart';
import '../app/components/dimension.dart';
import '../app/components/search_bar.dart';
import '../app/constants/colors.dart';
import '../app/constants/route_constant.dart';
import '../app/config/router_config.dart';
import '../app/providers/todo_provider.dart';
import '../data/shared_preferences/shared_preferences.dart';
import 'completed_task.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _controller = PageController(initialPage: 0);
  List<Map<String, dynamic>> categories = [];
  final DateTime _dateTime = DateTime.now();
  bool isTodayTodo = false;
  List<Map<String, dynamic>> gradient = [
    {
      'gradient': [const Color(0xFF88D2F5), const Color(0xFF0FA9F4)],
    },
    {
      'gradient': [const Color(0xFF7ED9D2), const Color(0xFF10CFB1)],
    },
    {
      'gradient': [const Color(0xFFFEBCA7), const Color(0xFFFD7E7E)],
    },
  ];
  List<Map<String, dynamic>> todoList = [];

  @override
  void initState() {
    super.initState();
    loadDatas();
  }

  loadDatas() async {
    await SharedPreferencesManager.init();

    final getTodoList = SharedPreferencesManager.loadTodos();
    final getCategories = SharedPreferencesManager.loadCategories();
    if (getTodoList.isNotEmpty) {
      setState(() {
        todoList = getTodoList;
      });
      toggleTodo(true);
    } else {
      toggleTodo(false);
    }
    if (getCategories.isNotEmpty) {
      setState(() {
        categories = getCategories;
      });
    } else {
      setState(() {
        categories = [
          {
            'text': 'Personal',
          },
          {
            'text': 'Work',
          },
          {
            'text': 'Books to\nread',
          },
        ];
      });
    }

    if (categories.length > 3) {
      List<List<Color>> gradients = [
        [const Color(0xFF88D2F5), const Color(0xFF0FA9F4)],
        [const Color(0xFF7ED9D2), const Color(0xFF10CFB1)],
        [const Color(0xFFFEBCA7), const Color(0xFFFD7E7E)],
      ];
      categories.map((category) {
        // Get a random gradient from the list of gradients
        final Random random = Random();
        final List<Color> randomGradient =
            gradients[random.nextInt(gradients.length)];
        gradient.add({
          'gradient': randomGradient,
        });
      }).toList();
    }

    addTodo();
  }

  toggleTodo(bool show) {
    context.read<TodoNotifier>().hideTodoList(show);
  }

  addTodo() {
    context.read<TodoNotifier>().addTodos(todoList);
    context.read<TodoNotifier>().addCategories(categories);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final todoNotifier = context.watch<TodoNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F7),
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (value) {},
        children: [
          Stack(
            children: [
              //main content
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: SizedBox(
                  width: mediaQuery.width,
                  height: mediaQuery.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.verticalSpace,
                      //user header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                Assets.userImage,
                                width: 50.w,
                              ),
                              10.horizontalSpace,
                              //greeting
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    requiredText: context
                                        .read<TodoNotifier>()
                                        .greetingText,
                                    fontSize: Appdimen.dim16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor,
                                    textAlign: TextAlign.left,
                                  ),
                                  5.verticalSpace,
                                  CustomText(
                                    requiredText: 'What do you have planned ',
                                    textAlign: TextAlign.left,
                                    fontSize: Appdimen.dim10,
                                    color: AppColors.textColor.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //bell
                          Image.asset(
                            Assets.bellImage,
                            width: 28.w,
                          )
                        ],
                      ),
                      30.verticalSpace,
                      //search
                      CustomTodoSearchBar(
                        controller:
                            context.read<TodoNotifier>().searchController,
                        onTap: () {},
                      ),
                      30.verticalSpace,
                      //categories
                      SizedBox(
                        height: 67.h,
                        width: mediaQuery.width,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: context
                                      .watch<TodoNotifier>()
                                      .categories
                                      .length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        GestureDetector(
                                            child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: ShapeDecoration(
                                            gradient: LinearGradient(
                                              begin:
                                                  const Alignment(0.00, -1.00),
                                              end: const Alignment(0, 1),
                                              colors: gradient[index]
                                                  ['gradient'],
                                            ),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 120.w,
                                            maxWidth: 120.w,
                                            minHeight: 67.h,
                                            maxHeight: 67.h,
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: CustomText(
                                                  requiredText: context
                                                          .read<TodoNotifier>()
                                                          .categories[index]
                                                      ['text'],
                                                  fontSize: Appdimen.dim12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )),
                                        20.horizontalSpace,
                                      ],
                                    );
                                  }),
                              Container(
                                height: 67.h,
                                width: mediaQuery.width,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                constraints: BoxConstraints(
                                  minWidth: 140.w,
                                  maxWidth: 140.w,
                                  minHeight: 67.h,
                                  maxHeight: 67.h,
                                ),
                                decoration: ShapeDecoration(
                                  color: Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.plus,
                                      color: AppColors.textColor,
                                    ),
                                    Flexible(
                                      child: CustomText(
                                        requiredText: 'Add Categories',
                                        fontSize: Appdimen.dim12,
                                        color: const Color(0xFF192028),
                                        fontWeight: FontWeight.w500,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      30.verticalSpace,
                      //upcoming to dos
                      GestureDetector(
                        onTap: () =>
                            context.read<TodoNotifier>().toggleListVisibility(),
                        child: Container(
                          width: 343.w,
                          height: 41.h,
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.w,
                            vertical: 10.h,
                          ),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Upcoming To-do\'s',
                                style: GoogleFonts.roboto(
                                  color: const Color(0xFF192028),
                                  fontSize: Appdimen.dim16,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              10.horizontalSpace,
                              //down arrow
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(todoNotifier.isListVisible
                                    ? CupertinoIcons.chevron_down
                                    : CupertinoIcons.chevron_up),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //list
                      if (todoNotifier.isListVisible)
                        AnimatedOpacity(
                          opacity: todoNotifier.isListVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 800),
                          child: SizedBox(
                            height: mediaQuery.height * 0.3,
                            width: mediaQuery.width,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              color: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height:
                                  context.watch<TodoNotifier>().isListVisible
                                      ? MediaQuery.of(context).size.height
                                      : 0,
                              child: context.watch<TodoNotifier>().isListVisible
                                  ? context
                                          .watch<TodoNotifier>()
                                          .todoList
                                          .isNotEmpty
                                      ? ListView.builder(
                                          itemCount: context
                                              .watch<TodoNotifier>()
                                              .todoList
                                              .length,
                                          itemBuilder: (context, index) {
                                            final item = context
                                                .read<TodoNotifier>()
                                                .todoList[index];
                                            int getDayDiff = _dateTime
                                                .difference(DateTime.parse(
                                                    item['todoFullDate']))
                                                .inHours;

                                            return Visibility(
                                              visible: getDayDiff < 24,
                                              child: InkWell(
                                                onTap: () => context
                                                    .read<TodoNotifier>()
                                                    .toggleItemCheckState(
                                                        index),
                                                child: SizedBox(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            height: 30.h,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Image.asset(
                                                                  item['todoIsCompleted']
                                                                      ? 'assets/png/checked.png'
                                                                      : 'assets/png/unchecked.png',
                                                                  width: 25,
                                                                ),
                                                                10.horizontalSpace,
                                                                SizedBox(
                                                                  width: 180.w,
                                                                  child:
                                                                      CustomText(
                                                                    requiredText:
                                                                        item['todoName'] ??
                                                                            '',
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    softWrap:
                                                                        true,
                                                                    textDecoration: item[
                                                                            'todoIsCompleted']
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : TextDecoration
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 30,
                                                            child: Row(
                                                              children: [
                                                                Text(item[
                                                                        'todoTime'] ??
                                                                    ''),
                                                                10.horizontalSpace,
                                                                const Icon(
                                                                  CupertinoIcons
                                                                      .right_chevron,
                                                                  size: 15,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const Divider(
                                                        color:
                                                            Color(0xFFEBEAEA),
                                                        thickness: 1.5,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text('No todos yet'),
                                        )
                                  : const SizedBox(),
                            ),
                          ),
                        ),

                      20.verticalSpace,
                      //overdue
                      GestureDetector(
                        onTap: () => context
                            .read<TodoNotifier>()
                            .toggleOverdueVisibility(),
                        child: Container(
                          width: 343,
                          height: 39,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //overdue
                                  Text(
                                    'Overdue',
                                    style: GoogleFonts.roboto(
                                      color: const Color(0xFF192028),
                                      fontSize: Appdimen.dim16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  10.horizontalSpace,

                                  //alert
                                  Container(
                                    width: 25,
                                    height: 25,
                                    alignment: Alignment.center,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFFF4C4C),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                    ),
                                    child: Text(
                                      '2',
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: Appdimen.dim10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                  20.verticalSpace
                                ],
                              ),
                              10.horizontalSpace,
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(todoNotifier.isOverdue
                                    ? CupertinoIcons.chevron_down
                                    : CupertinoIcons.chevron_up),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //notes
                      20.verticalSpace,
                      GestureDetector(
                        onTap: () => context
                            .read<TodoNotifier>()
                            .toggleNotesVisibility(),
                        child: Container(
                          width: 343,
                          height: 39,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Notes',
                                style: GoogleFonts.roboto(
                                  color: const Color(0xFF192028),
                                  fontSize: Appdimen.dim16,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              10.horizontalSpace,
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Icon(todoNotifier.isNotes
                                    ? CupertinoIcons.chevron_down
                                    : CupertinoIcons.chevron_up),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (todoNotifier.isFloatingPressed)
                CustomFocusBackground(mediaQuery: mediaQuery),
              //add to do
              if (todoNotifier.isFloatingPressed)
                AnimatedPositioned(
                  curve: Curves.easeInOut,
                  bottom: 130,
                  right: 30,
                  duration: const Duration(milliseconds: 2000),
                  child: GestureDetector(
                    onTap: () {
                      routerConfig.push(RoutesPath.addTodoScreen);
                      context.read<TodoNotifier>().toggleFloatingActionButton();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.easeInOut,
                      width: 129,
                      height: 41,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFF8C22),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/png/add_to_do.png',
                            width: 15,
                          ),
                          10.horizontalSpace,
                          Text(
                            'Add To-do',
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              //add notes
              if (todoNotifier.isFloatingPressed)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.easeInOut,
                  bottom: 80,
                  right: 30,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.easeInOut,
                    width: 129,
                    height: 41,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: ShapeDecoration(
                      color: const Color(0xFF51526B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/png/add_to_do.png',
                          width: 15,
                        ),
                        10.horizontalSpace,
                        Text(
                          'Add Note',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const TaskCompletedScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,
                size: 30,
                color: todoNotifier.navIndex == 0
                    ? AppColors.primaryColor
                    : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined,
                size: 30,
                color: todoNotifier.navIndex == 1
                    ? AppColors.primaryColor
                    : Colors.grey),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings,
                size: 30,
                color: todoNotifier.navIndex == 2
                    ? AppColors.primaryColor
                    : Colors.grey),
            label: 'Settings',
          ),
        ],
        currentIndex: context.watch<TodoNotifier>().navIndex,
        onTap: (index) async {
          context.read<TodoNotifier>().setNavIndex(index);
          _controller.jumpToPage(index);
        },
        selectedLabelStyle: GoogleFonts.roboto(color: AppColors.primaryColor),
        unselectedLabelStyle: GoogleFonts.roboto(color: Colors.grey),
        selectedItemColor: AppColors.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<TodoNotifier>().toggleFloatingActionButton(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: todoNotifier.isFloatingPressed
            ? const Color(0xFF645A50)
            : AppColors.primaryColor,
        child: Icon(
          todoNotifier.isFloatingPressed ? CupertinoIcons.xmark : Icons.add,
        ), // Customize the button color.
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
