import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_order/blocs/theming/theming_cubit.dart';
import 'package:just_order/blocs/theming/theming_state.dart';
import 'package:just_order/screens/notification/ui/widget/notification_item.dart';
import 'package:just_order/core/theme/colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              shadowColor: Colors.grey,
              title: Text(
                'Notifications',
                style: TextStyle(
                  color: state.themeMode == ThemeMode.light
                      ? Colors.black
                      : Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              leading: Padding(
                padding:
                const EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
                child: Container(
                  width: 34,
                  height: 34,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF4F4F4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 18,
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                    top: 10.0,
                    bottom: 10.0,
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      elevation: 0.0,
                      padding: const EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      foregroundColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.done_all,
                          color: AppColor.primaryColor,
                          size: 14,
                        ),
                        Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size(MediaQuery
                    .sizeOf(context)
                    .width, 70),
                child: TabBar(
                  physics: const BouncingScrollPhysics(),
                  overlayColor:
                  const WidgetStatePropertyAll(Colors.transparent),
                  isScrollable: true,
                  dividerColor: Colors.transparent,
                  tabAlignment: TabAlignment.start,
                  unselectedLabelColor: state.themeMode == ThemeMode.light
                      ? const Color(0xFF898888)
                      : const Color(0xFFE02C45),
                  unselectedLabelStyle: TextStyle(
                    color: state.themeMode == ThemeMode.light
                        ? const Color(0xFF898888)
                        : const Color(0xFFE02C45),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                  labelStyle: TextStyle(
                    color: const Color(0xFFE02C45),
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                  indicatorColor: const Color(0xFFE02C45),
                  tabs: [
                    Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            const Text(
                              'All',
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              padding: const EdgeInsets.all(6),
                              decoration: ShapeDecoration(
                                color: const Color(0x19E02C45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 6,
                                children: [
                                  Text(
                                    '+99',
                                    style: TextStyle(
                                      //color: Color(0xFFE02C45) /* Primary */,
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 8,
                          children: [
                            const Text(
                              'Unread',
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              padding: const EdgeInsets.all(6),
                              decoration: ShapeDecoration(
                                color: const Color(0x19E02C45),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                spacing: 6,
                                children: [
                                  Text(
                                    '5',
                                    style: TextStyle(
                                      //color: Color(0xFFE02C45) /* Primary */,
                                      fontSize: 10,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                      height: 1.40,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                children: [
                  allNotificationWidget(),
                  unreadNotificationWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget allNotificationWidget() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return const NotificationItem();
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Divider(
            color: Color(0xFFF4F4F4),
          ),
        );
      },
    );
  }

  Widget unreadNotificationWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return null;
      },
    );
  }
}
