import 'dart:async';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:live/bloc/chat_bloc/ChatBloc.dart';
import 'package:live/bloc/chat_bloc/ChatEvent.dart';
import 'package:live/bloc/chat_bloc/ChatState.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/chat_video_only/ChatVideoOnlyPage.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/ui/common/dialog/CreateChannelDialog.dart';
import 'package:live/ui/send_message/SendMessagePage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/viewobject/model/createChannel/ChatCreateChannelResponse.dart';
import 'package:lottie/lottie.dart';

class DashboardPage extends StatefulWidget
{
  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin
{
  bool isCollapsed = false;
  // late double screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 300);
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _menuScaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState()
  {
    super.initState();
    print(Prefs.getString(Const.VALUE_HOLDER_USER_NAME)![0]);
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _menuScaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(1, 1), end: Offset(0, 0)).animate(_controller);
  }


  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    // david+figma@peeq.live
    // spay_rik!scal4TUH

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CustomColors.background_bg01,
        systemNavigationBarColor: CustomColors.background_bg01,
        statusBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        statusBarBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarIconBrightness: Utils.isLightMode()?Brightness.dark:Brightness.light,
        systemNavigationBarDividerColor: CustomColors.background_bg01,
      ),
    );

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: _menuScaleAnimation,
            child: HomeScreen(),
          ),
          dashboard(context),
        ],
      ),
    );
  }

  Widget dashboard(context)
  {
    return AnimatedPositioned(
      duration: duration,
      top: 0,
      bottom: 0,
      left: isCollapsed ? 0 : 0.83 * Utils.getScreenWidth(context),
      right: isCollapsed ? 0 : -0.7 * Utils.getScreenWidth(context),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Material(
          animationDuration: duration,
          color: Colors.transparent,
          child: Stack(
            children: [
              Container(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 48),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
                          child: Icon(Icons.menu, color: Colors.black87),
                          onTap: () {
                            setState(() {
                              if (isCollapsed)
                                _controller.forward();
                              else
                                _controller.reverse();

                              isCollapsed = !isCollapsed;
                            });
                          },
                        ),
                        Text("Chat",
                            style:
                            TextStyle(fontSize: 24, color: Colors.black45)),
                        Icon(Icons.settings, color: Colors.black45),
                      ],
                    ),
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("name",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black45)),
                              subtitle: Text("message",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black45)),
                              trailing: Text("date",
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.black45)),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 10,
                              color: Colors.black12,
                            );
                          },
                          itemCount: 30),
                    )
                  ],
                ),
              ),
              if (!isCollapsed)
                InkWell(
                    onTap: () {
                      _controller.reverse();
                      isCollapsed = !isCollapsed;
                      setState(() {});
                    },
                    child: Container())
              else
                Container()
            ],
          ),
        ),
      ),
    );
  }
}


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  ChatBloc chatBloc = ChatBloc(InitialChatState());
  bool isLoading = false;
  final Random r = Random();
  final List<IconData> iconData = <IconData>[
    Icons.health_and_safety,
    Icons.add_shopping_cart_outlined
  ];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int sideTabIndex = 0;
  List<String> image = [
    "assets/images/shopping.jpg",
    "assets/images/icon_medical_background.jpg",
    "assets/images/jewellery.jpg",
    "assets/images/shopping.jpg"
  ];
  List<String> server = ["Peeq Live"];
  List<String> generalRoomName = [
    "Shopping",
  ];
  @override
  void dispose()
  {
    chatBloc.close();
    super.dispose();
  }

  @override
  void initState()
  {
    super.initState();
    chatBloc = BlocProvider.of<ChatBloc>(context, listen: false);
    chatBloc.add(
      ChatChannelJoinedEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: chatBloc,
      listener: (context, state) {
        print("this is state $state");
        if (state is ChatProgressState)
        {
          isLoading = true;
        }
        else if (state is ChatChannelJoinedSuccessState)
        {
          isLoading = false;
          setState(() {});
        }
        else if (state is ChatErrorState)
        {
          isLoading = false;
        }
      },
      builder: (context, state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            menu(context, state),
            isLoading
                ? Container(
              height: Utils.getScreenHeight(context),
              width: Utils.getScreenWidth(context),
              color: CustomColors.title_active!.withOpacity(0.2),
              child: Center(
                child: Lottie.asset(
                  'assets/lottie/Peeq_loader.json',
                  height: Utils.getScreenWidth(context) * 0.6,
                ),
              ),
            )
                : Container(),
          ],
        );
      },
    );
  }

  Widget sideMenu(int index, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: sideTabIndex == index
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Visibility(
          child: Container(
            height: Dimens.space38.w,
            width: Dimens.space2.w,
            alignment: Alignment.centerRight,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space26.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            color: Colors.white,
          ),
          visible: sideTabIndex == index ? true : false,
        ),
        InkWell(
          onTap: () {
            sideTabIndex = index;
            setState(() {});
          },
          child: Container(
            height: sideTabIndex == index ? Dimens.space54.w : Dimens.space54.w,
            width: sideTabIndex == index ? Dimens.space54.w : Dimens.space54.w,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space26.h),
            padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                Dimens.space0.w, Dimens.space0.h),
            decoration: BoxDecoration(
              color:
              sideTabIndex == index ? Color(0xff080A4D) : Colors.transparent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topLeft: sideTabIndex == index
                    ? Radius.circular(Dimens.space8.r)
                    : Radius.circular(Dimens.space8.r),
                topRight: sideTabIndex == index
                    ? Radius.circular(Dimens.space0.r)
                    : Radius.circular(Dimens.space8.r),
                bottomLeft: sideTabIndex == index
                    ? Radius.circular(Dimens.space8.r)
                    : Radius.circular(Dimens.space8.r),
                bottomRight: sideTabIndex == index
                    ? Radius.circular(Dimens.space0.r)
                    : Radius.circular(Dimens.space8.r),
              ),
              border: Border(
                top: BorderSide(
                  width: Dimens.space1.r,
                  color: sideTabIndex == index
                      ? Colors.transparent
                      : Color(0xff080A4D),
                ),
                bottom: BorderSide(
                  width: Dimens.space1.r,
                  color: sideTabIndex == index
                      ? Colors.transparent
                      : Color(0xff080A4D),
                ),
                left: BorderSide(
                  width: Dimens.space1.r,
                  color: sideTabIndex == index
                      ? Colors.transparent
                      : Color(0xff080A4D),
                ),
                right: BorderSide(
                  width: Dimens.space1.r,
                  color: sideTabIndex == index
                      ? Colors.transparent
                      : Color(0xff080A4D),
                ),
              ),
            ),
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                color: sideTabIndex == index ? Colors.white : Color(0xff080A4D),
                fontSize: Dimens.space26.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget titleBar(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.space10.w,
          Dimens.space15.h,
          Dimens.space10.w,
          Dimens.space10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xff5E6272),
                fontSize: Dimens.space14.sp),
          ),
          SvgPicture.asset(
            "assets/svg/rightButton.svg",
            fit: BoxFit.cover,
            color: Color(0xff5E6272),
            alignment: Alignment.center,
            clipBehavior: Clip.antiAlias,
            allowDrawingOutsideViewBox: false,
            cacheColorFilter: true,
            placeholderBuilder: (BuildContext context) =>
                Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 15,
                  color: CustomColors.title_active,
                ),
          ),
        ],
      ),
    );
  }

  Widget iconTextTile(String icon, String title){
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.space10.w,
          Dimens.space0.h,
          Dimens.space10.w,
          Dimens.space5.h),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                Dimens.space5.w,
                Dimens.space0.h,
                Dimens.space5.w,
                Dimens.space0.h),
            child: SvgPicture.asset(
              "assets/svg/$icon.svg",
              fit: BoxFit.cover,
              color: Color(0xff5E6272),
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              allowDrawingOutsideViewBox: false,
              cacheColorFilter: true,
              placeholderBuilder: (BuildContext context) =>
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 15,
                    color: CustomColors.title_active,
                  ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xff5E6272),
                fontSize: Dimens.space13.sp),
          ),
        ],
      ),
    );
  }

  Widget menu(context, state) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffF5F9FA),
        resizeToAvoidBottomInset: true,
        body: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.fromLTRB(
              Dimens.space0.w,
              Utils.getStatusBarHeight(context),
              Utils.getScreenWidth(context) * 0.12,
              Dimens.space0.h),
          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
              Dimens.space0.w, Dimens.space0.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space25.h,
                    Dimens.space0.w, Dimens.space0.h),
                child: Container(
                  width: Dimens.space60.w,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: Dimens.space48.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: PlainAssetImageHolder(
                              height: Dimens.space48,
                              width: Dimens.space48,
                              assetWidth: Dimens.space48,
                              assetHeight: Dimens.space48,
                              assetUrl:
                              "assets/images/icon_home_image_border_oval.png",
                              outerCorner: Dimens.space0,
                              innerCorner: Dimens.space0,
                              iconSize: Dimens.space0,
                              iconUrl: Icons.camera_alt_outlined,
                              iconColor: Colors.transparent,
                              boxDecorationColor: Colors.transparent,
                              boxFit: BoxFit.contain,
                              onTap: () {},
                            ),
                          ),
                          Container(
                            height: Dimens.space40.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: PlainAssetImageHolder(
                              height: Dimens.space40,
                              width: Dimens.space40,
                              assetWidth: Dimens.space40,
                              assetHeight: Dimens.space40,
                              assetUrl: "assets/images/icon_profile.png",
                              outerCorner: Dimens.space0,
                              innerCorner: Dimens.space0,
                              iconSize: Dimens.space0,
                              iconUrl: Icons.camera_alt_outlined,
                              iconColor: Colors.transparent,
                              boxDecorationColor: Colors.transparent,
                              boxFit: BoxFit.contain,
                              onTap: () {},
                            ),
                          ),
                          Container(
                            height: Dimens.space48.h,
                            alignment: Alignment.center,
                            margin: EdgeInsets.fromLTRB(
                                Dimens.space7.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            padding: EdgeInsets.fromLTRB(
                                Dimens.space0.w,
                                Dimens.space0.h,
                                Dimens.space0.w,
                                Dimens.space0.h),
                            child: RoundedFileImageHolderWithText(
                              height: Dimens.space42,
                              width: Dimens.space42,
                              textColor: Colors.white,
                              text: Prefs.getString(
                                  Const.VALUE_HOLDER_USER_NAME)![0]
                                  .toUpperCase(),
                              fileUrl: '',
                              outerCorner: Dimens.space20,
                              innerCorner: Dimens.space20,
                              iconSize: Dimens.space0,
                              iconUrl: Icons.camera_alt_outlined,
                              iconColor: Colors.transparent,
                              boxDecorationColor: Colors.transparent,
                              boxFit: BoxFit.contain,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: Dimens.space48.h,
                        alignment: Alignment.center,
                        margin: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h),
                        padding: EdgeInsets.fromLTRB(
                            Dimens.space0.w,
                            Dimens.space0.h,
                            Dimens.space0.w,
                            Dimens.space0.h),
                        child: PlainAssetImageHolder(
                          height: Dimens.space48.h,
                          width: Dimens.space48.h,
                          assetWidth: Dimens.space48.h,
                          assetHeight: Dimens.space48.h,
                          assetUrl: "assets/images/dashboardLogo.png",
                          outerCorner: Dimens.space0,
                          innerCorner: Dimens.space0,
                          iconSize: Dimens.space0,
                          iconUrl: Icons.camera_alt_outlined,
                          iconColor: Colors.transparent,
                          boxDecorationColor: Colors.transparent,
                          boxFit: BoxFit.contain,
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space26.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          padding: EdgeInsets.fromLTRB(
                              Dimens.space0.w,
                              Dimens.space0.h,
                              Dimens.space0.w,
                              Dimens.space0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              sideMenu(0, server[0][0]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h,
                      Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Dimens.space12.r),
                      topRight: Radius.circular(Dimens.space12.r),
                      bottomLeft: Radius.circular(Dimens.space0.r),
                      bottomRight: Radius.circular(Dimens.space0.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        width: double.infinity,
                        height: Dimens.space48.h,
                        decoration: BoxDecoration(
                          color: Color(0xff080A4D),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(Dimens.space12.r),
                            topRight: Radius.circular(Dimens.space12.r),
                            bottomLeft: Radius.circular(Dimens.space0.r),
                            bottomRight: Radius.circular(Dimens.space0.r),
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space14.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: Text(
                                server[sideTabIndex],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                  color: Colors.white,
                                  fontFamily: Config.PoppinsSemiBold,
                                  fontSize: Dimens.space16.sp,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Dimens.space4.w,
                                  Dimens.space0.h,
                                  Dimens.space0.w,
                                  Dimens.space0.h),
                              child: SvgPicture.asset(
                                "assets/svg/downButton.svg",
                                fit: BoxFit.cover,
                                color: Colors.white,
                                alignment: Alignment.center,
                                clipBehavior: Clip.antiAlias,
                                allowDrawingOutsideViewBox: false,
                                cacheColorFilter: true,
                                placeholderBuilder: (BuildContext context) =>
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 15,
                                      color: CustomColors.title_active,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              titleBar("Direct Message"),
                              // messageTile(sideTabIndex == 0? "David Kanel":sideTabIndex == 1? "Niranjan Pant":sideTabIndex == 2?"Aquib Virani":"Nicholas Ni"),
                              titleBar("Sessions"),
                              // messageTile(sideTabIndex == 0? "David Kanel":sideTabIndex == 1? "Niranjan Pant":sideTabIndex == 2?"Aquib Virani":"Nicholas Ni"),
                              titleBar("Live Stream"),
                              // iconTextTile("live","Room Name"),
                              titleBar("Videos"),
                              state is ChatChannelJoinedSuccessState && state.chatChannelJoinedResponse[sideTabIndex].channels != null && state.chatChannelJoinedResponse[sideTabIndex].channels!.length != 0 ?
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: ListView.builder(
                                  itemCount: state.chatChannelJoinedResponse[sideTabIndex].channels!.length,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          alignment: Alignment.center,
                                        ),
                                        onPressed: ()
                                        {
                                          if(state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.split("_")[0].toLowerCase()=="video")
                                          {
                                            List<Channel> channels = [];
                                            channels.addAll(state.channelGroupJoinedResponse[sideTabIndex].channels!);
                                            channels.addAll(state.chatChannelJoinedResponse[sideTabIndex].channels!);
                                            Utils.openActivity(
                                              context,
                                              ChatVideoOnlyPage(
                                                urlIndex: sideTabIndex,
                                                roomId: state.chatChannelJoinedResponse[sideTabIndex].channels![index].sId!,
                                                roomName: state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!,
                                                serverUrl: server[sideTabIndex],
                                                channelsList: channels,
                                                isPrivate: state.chatChannelJoinedResponse[sideTabIndex].channels![index].t == "p" ? true : false,
                                                roomDescription: state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!=null?state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!.replaceAll("_", " "):state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.toLowerCase()!="general"?state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.replaceAll("_", " "):generalRoomName[sideTabIndex],
                                                onLeaveChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                                onDeleteChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                              ),
                                            ).then((value)
                                            {
                                              chatBloc.add(
                                                ChatChannelJoinedEvent(),
                                              );
                                            });
                                          }
                                          else
                                          {
                                            Utils.openActivity(
                                              context,
                                              SendMessagePage(
                                                // isFromDashboard: true,
                                                urlIndex: sideTabIndex,
                                                roomId: state.chatChannelJoinedResponse[sideTabIndex].channels![index].sId!,
                                                roomName: state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!,
                                                roomDescription: state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!=null?state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!.replaceAll("_", " "):state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.toLowerCase()!="general"?state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.replaceAll("_", " "):generalRoomName[sideTabIndex],
                                                isPrivate: state.chatChannelJoinedResponse[sideTabIndex].channels![index].t == "p" ? true : false,
                                                onLeaveChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                                onDeleteChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints)
                                          {
                                            if(state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!=null && state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!.isNotEmpty)
                                            {
                                              return iconTextTile("Videocamera", state.chatChannelJoinedResponse[sideTabIndex].channels![index].description != null && state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!.isNotEmpty ? state.chatChannelJoinedResponse[sideTabIndex].channels![index].description!.replaceAll("_", " ") : generalRoomName[sideTabIndex]);
                                            }
                                            else
                                            {
                                              return iconTextTile("Videocamera", state.chatChannelJoinedResponse[sideTabIndex].channels![index].name != null && state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.isNotEmpty && state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.toLowerCase() != "general"? state.chatChannelJoinedResponse[sideTabIndex].channels![index].name!.replaceAll("_", " ") : generalRoomName[sideTabIndex]);
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                  ),
                                  shrinkWrap: true,
                                ),
                              ) :
                              Container(),
                              state is ChatChannelJoinedSuccessState && state.channelGroupJoinedResponse[sideTabIndex].channels != null && state.channelGroupJoinedResponse[sideTabIndex].channels!.length != 0 ?
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                child: ListView.builder(
                                  itemCount: state.channelGroupJoinedResponse[sideTabIndex].channels!.length,
                                  itemBuilder: (BuildContext context, int index)
                                  {
                                    return Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                          alignment: Alignment.center,
                                        ),
                                        onPressed: ()
                                        {
                                          if(state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.split("_")[0].toLowerCase()=="video")
                                          {
                                            List<Channel> channels = [];
                                            channels.addAll(state.channelGroupJoinedResponse[sideTabIndex].channels!);
                                            channels.addAll(state.chatChannelJoinedResponse[sideTabIndex].channels!);
                                            Utils.openActivity(
                                              context,
                                              ChatVideoOnlyPage(
                                                urlIndex: sideTabIndex,
                                                roomId: state.channelGroupJoinedResponse[sideTabIndex].channels![index].sId!,
                                                roomName: state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!,
                                                serverUrl: server[sideTabIndex],
                                                channelsList: channels,
                                                isPrivate: state.channelGroupJoinedResponse[sideTabIndex].channels![index].t == "p" ? true : false,
                                                roomDescription: state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!=null? state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!.replaceAll("_", " "):state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.toLowerCase()!="general"?state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.replaceAll("_", " "): generalRoomName[sideTabIndex],
                                                onLeaveChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                                onDeleteChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                              ),
                                            ).then((value)
                                            {
                                              chatBloc.add(
                                                ChatChannelJoinedEvent(),
                                              );
                                            });
                                          }
                                          else
                                          {
                                            Utils.openActivity(
                                              context,
                                              SendMessagePage(
                                                // isFromDashboard: true,
                                                urlIndex: sideTabIndex,
                                                roomId: state.channelGroupJoinedResponse[sideTabIndex].channels![index].sId!,
                                                roomName: state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!,
                                                roomDescription: state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!=null? state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!.replaceAll("_", " "): state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.toLowerCase()!="general"?state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.replaceAll("_", " "):generalRoomName[sideTabIndex],
                                                isPrivate: state.channelGroupJoinedResponse[sideTabIndex].channels![index].t == "p" ? true : false,
                                                onLeaveChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                                onDeleteChannel: ()
                                                {
                                                  Utils.closeActivity(context);
                                                  chatBloc.add(
                                                    ChatChannelJoinedEvent(),
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        },
                                        child: LayoutBuilder(
                                          builder: (BuildContext context, BoxConstraints constraints)
                                          {
                                            if(state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!=null && state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!.isNotEmpty)
                                            {
                                              return iconTextTile("Videocamera", state.channelGroupJoinedResponse[sideTabIndex].channels![index].description != null && state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!.isNotEmpty ? state.channelGroupJoinedResponse[sideTabIndex].channels![index].description!.replaceAll("_", " ") : generalRoomName[sideTabIndex]);
                                            }
                                            else
                                            {
                                              return iconTextTile("Videocamera", state.channelGroupJoinedResponse[sideTabIndex].channels![index].name != null && state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.isNotEmpty  &&  state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.toLowerCase() != "general"? state.channelGroupJoinedResponse[sideTabIndex].channels![index].name!.replaceAll("_", " ") : generalRoomName[sideTabIndex]);
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.fromLTRB(
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                    Dimens.space0,
                                  ),
                                  shrinkWrap: true,
                                ),
                              )
                                  : Container(),
                              titleBar("Other"),
                              // iconTextTile("Path","Room Name"),
                              titleBar("Community"),
                              // iconTextTile("Users","Room Namel"),
                              titleBar("Guests"),
                              // userOnlineStatusTile(),
                              titleBar("Hosts"),
                              userOnlineStatusTile(),
                            ],
                          ),
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
    );
  }

  void showDialogCreateChannel() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.space12.r),
      ),
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CreateChannelDialog(
          urlIndex: sideTabIndex,
          onChannelCreateSuccess: () {
            chatBloc.add(
              ChatChannelJoinedEvent(),
            );
          },
        );
      },
    );
  }

  Widget messageTile(String name){
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.space10.w,
          Dimens.space0.h,
          Dimens.space10.w,
          Dimens.space0.h),
      child: Container(
        height: Dimens.space38.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space5.w,
                      Dimens.space0.h),
                  child: Image.asset("assets/images/userProfile.png",height: Dimens.space24.h,width: Dimens.space24.h,),
                ),
                Text(name,style: TextStyle(
                  fontSize: Dimens.space13.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E6272),
                ),),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("10:31 AM",style: TextStyle(
                  fontSize: Dimens.space9.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                ),),
                Container(height: Dimens.space8.h,width: Dimens.space8.h,
                  decoration: BoxDecoration(
                    color: Color(0xff1ABCFE),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  ),),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget userOnlineStatusTile(){
    return Padding(
      padding: EdgeInsets.fromLTRB(
          Dimens.space10.w,
          Dimens.space3.h,
          Dimens.space10.w,
          Dimens.space3.h),
      child: Container(
        height: Dimens.space38.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      Dimens.space0.w,
                      Dimens.space0.h,
                      Dimens.space5.w,
                      Dimens.space0.h),
                  child: Image.asset("assets/images/userProfile.png",height: Dimens.space32.h,width: Dimens.space32.h,),
                ),
                Text(sideTabIndex == 0? "David Kanel":sideTabIndex == 1? "Dr Niranjan Pant":sideTabIndex == 2?"Aquib Virani":"Dr Nicholas Ni",style: TextStyle(
                  fontSize: Dimens.space13.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E6272),
                ),),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("10:31 AM",style: TextStyle(
                  fontSize: Dimens.space9.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff000000),
                ),),
                Container(
                  height: Dimens.space8.h,width: Dimens.space8.h,
                  decoration: BoxDecoration(
                    color: Color(0xff1ABCFE),
                    borderRadius: BorderRadius.all(Radius.circular(Dimens.space10.r)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  IconData randomIcon2() => iconData[r.nextInt(iconData.length)];
}


Future<dynamic> onBackgroundMessage(RemoteMessage message) async
{
  await Firebase.initializeApp();
  print("Notification Data: " + message.data.toString());
  if(message.data.containsKey("type") && message.data["type"].toString().toLowerCase() == "START_VIDEO".toLowerCase())
  {
    Utils.showCallNotification(title: message.data["title"], body: message.data["body"], serverUrl: message.data["serverUrl"], channelName: message.data["roomName"], uid: message.data["subject"]);
  }
}


// Row(
// children: [
// Container(
// alignment: Alignment.centerRight,
// margin: EdgeInsets.fromLTRB(
// Dimens.space0.w,
// Dimens.space0.h,
// Dimens.space5.w,
// Dimens.space0.h),
// padding: EdgeInsets.fromLTRB(
// Dimens.space0.w,
// Dimens.space0.h,
// Dimens.space0.w,
// Dimens.space0.h),
// child: RoundedFileImageHolderWithText(
// height: Dimens.space26,
// width: Dimens.space26,
// textColor: CustomColors.field_bgWhite!,
// text: "",
// fileUrl: "",
// outerCorner: Dimens.space6,
// innerCorner: Dimens.space6,
// iconSize: Dimens.space26,
// iconUrl: Icons.add_circle_outline_rounded,
// iconColor: Color(0xff90959E),
// boxDecorationColor: Colors.transparent,
// boxFit: BoxFit.contain,
// onTap: () {
// showDialogCreateChannel();
// },
// ),
// ),
// Container(
// alignment: Alignment.centerRight,
// margin: EdgeInsets.fromLTRB(
// Dimens.space0.w,
// Dimens.space0.h,
// Dimens.space0.w,
// Dimens.space0.h),
// padding: EdgeInsets.fromLTRB(
// Dimens.space0.w,
// Dimens.space0.h,
// Dimens.space0.w,
// Dimens.space0.h),
// child: RoundedFileImageHolderWithText(
// height: Dimens.space26,
// width: Dimens.space26,
// textColor: CustomColors.field_bgWhite!,
// text: "",
// fileUrl: "",
// outerCorner: Dimens.space6,
// innerCorner: Dimens.space6,
// iconSize: Dimens.space26,
// iconUrl: Icons.add_call,
// iconColor: Color(0xff90959E),
// boxDecorationColor: Colors.transparent,
// boxFit: BoxFit.contain,
// onTap: () {
// Utils.openActivity(
// context, CallViewPage());
// },
// ),
// ),
// ],
// ),
