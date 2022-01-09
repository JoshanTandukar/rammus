import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live/bloc/signout_bloc/SignOutBloc.dart';
import 'package:live/bloc/signout_bloc/SignOutEvent.dart';
import 'package:live/bloc/signout_bloc/SignOutState.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Constants.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/ui/welcome/WelcomePage.dart';
import 'package:live/utils/Prefs.dart';
import 'package:live/utils/Utils.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  SignOutBloc signOutBloc =
  SignOutBloc(InitialSignOutState());

  @override
  void initState() {
    super.initState();
    signOutBloc =
        BlocProvider.of<SignOutBloc>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F9FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile',style:
        TextStyle(fontSize: 20, color: CustomColors.text_deactive01),),
        backgroundColor: Color(0xffF5F9FA),
      ),
      body: BlocConsumer(
        bloc: signOutBloc,
        listener: (context, state){
          if (state is SignOutSuccessState) {
            Prefs.clear();
            Utils.removeStackActivity(context, WelcomePage());
          }
        },
        builder: (context,state){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: PlainAssetImageHolder(
                    assetUrl: "assets/images/UserAvatar.png",
                    height: Dimens.space110.w,
                    assetHeight: Dimens.space110.w,
                    assetWidth: Dimens.space110.w,
                    iconUrl: Icons.person,
                    iconSize: 100,
                    onTap: () {},
                    width: 130,
                    boxDecorationColor: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Full Name",
                  style:
                  TextStyle(fontSize: 13, color: CustomColors.text_deactive01),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Prefs.getString(Const.VALUE_HOLDER_USER_NAME)??"",
                  style: TextStyle(fontSize: 17,color: Color(0xff5E6272),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Email",
                  style:
                  TextStyle(fontSize: 13, color: CustomColors.text_deactive01),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Prefs.getString(Const.VALUE_HOLDER_USER_EMAIL)??"",
                  style: TextStyle(fontSize: 17,color: Color(0xff5E6272),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Password",
                  style:
                  TextStyle(fontSize: 13, color: CustomColors.text_deactive01),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "*********",
                  style: TextStyle(fontSize: 17,color: Color(0xff5E6272),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Phone Number",
                  style:
                  TextStyle(fontSize: 13, color: CustomColors.text_deactive01),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  Prefs.getString(Const.VALUE_HOLDER_USER_PHONE)??"",
                  style: TextStyle(fontSize: 17,color: Color(0xff5E6272),
                  ),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: ()
                  {
                    print("this is logout");
                    signOutBloc.add(SignOutResponseEvent());

                  },
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.arrow_right_square,
                          color: CustomColors.text_deactive01),
                      SizedBox(
                        width: 13,
                      ),
                      Text(
                        "Sign Out",
                        style: TextStyle(
                          fontSize: 20,),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
