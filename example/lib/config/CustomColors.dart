// Copyright (c) 2019, the PS Project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// PS license that can be found in the LICENSE file.

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:live/utils/Utils.dart';

class CustomColors
{
  CustomColors._();


  // Peeq Color

  //appbar
  static Color? appbar_statusBarColor ;
  static Color? appbar_barStyle;
  static Color? appbar_backgroundColor;
  static Color? appbar_tinColor;

  //button
  static Color? button_iconActive;
  static Color? button_textActive;
  static Color? button_deactive;
  static Color? button_textDeactive;
  static Color? button_active;
  static Color? button_deactiveButtonText;
  static Color? button_colorful06;
  static Color? button_textDanger;
  static Color? button_toggleActive;
  static Color? button_deactiveBg02;
  static Color? button_back;


  // background
  static Color? background_bg01;
  static Color? background_bg02;

  //brandColor
  static Color? brandColor_primary;
  static Color? brandColor_secondary;

  //text
  static Color? text_active;
  static Color? text_deactive01;
  static Color? text_deactive02;

  //title
  static Color? title_active ;
  static Color? title_deactive;

  //field
  static Color? field_textDeactive;
  static Color? field_textActive;
  static Color? field_nameActive;
  static Color? field_line;
  static Color? field_cursorActive;
  static Color? field_name;
  static Color? field_primary;
  static Color? field_bgWhite;

  //colorful
  static Color? colorful_colorful01;
  static Color? colorful_colorful02;
  static Color? colorful_colorful03;
  static Color? colorful_colorful04;
  static Color? colorful_colorful05;
  static Color? colorful_colorful06;
  static Color? colorful_colorful07;
  static Color? colorful_colorful08;

  //gradient
  static List<Color> gradient_gradient01 = [];
  static List<Color>? gradient_gradient02 = [];
  static List<Color>? gradient_gradient03 = [];
  static List<Color>? gradient_gradient04 = [];
  static List<Color>? gradient_gradient05 = [];
  static List<Color>? gradient_gradient06 = [];
  static List<Color>? gradient_gradient07 = [];
  static List<Color>? gradient_gradient08 = [];
  static List<Color>? gradient_gradient09 = [];
  static List<Color>? gradient_gradient10 = [];
  static List<Color>? gradient_bg1 = [];

  //toast
  static Color? toast_backgroundInfo;
  static Color? toast_text01;
  static Color? toast_text02;
  static Color? toast_iconSuccess;
  static Color? toast_success;
  static Color? toast_btn;
  static Color? toast_error;

  //icon
  static Color? icon_bg01;
  static Color? icon_bg02;
  static Color? icon_bg03;
  static List<Color> icon_success = [];
  static Color? icon_active ;
  static Color? icon_deactiveDarkest;
  static Color? icon_strokeLight;
  static Color? icon_primary;
  static Color? icon_stockDark;

  //card
  static List<Color>? card_gradient_bg01 = [];
  static Color? card_gradient_textActive;

  //stoke
  static List<Color>? stoke_linear01 = [];

  //selection
  static Color? selection_active;

  //selection
  static Color? success_default;

  //selection
  static Color? danger_default;

  //selection
  static Color? attachmentBackgroundColor;

///////////////////////////////////////////////////////////
////////////////////Light Color////////////////////////////
///////////////////////////////////////////////////////////

  //appbar
  static Color? l_appbar_statusBarColor = Color(0xff135E99);
  static Color? l_appbar_barStyle = Color(0xff000);
  static Color? l_appbar_backgroundColor = Color(0xff2196F3);
  static Color? l_appbar_tinColor = Color(0xff2196F3);

  //button
  static Color? l_button_iconActive = Color(0xffFFFFFF);
  static Color? l_button_textActive = Color(0xffFFFFFF);
  static Color? l_button_deactive = Color(0xff5E6272);
  static Color? l_button_textDeactive = Color(0xff5E6272);
  static Color? l_button_active = Color(0xff1ABCFE);
  static Color? l_button_deactiveButtonText = Color(0xffFFFFFF).withOpacity(0.4);
  static Color? l_button_colorful06 = Color(0xffFFFFFF);
  static Color? l_button_textDanger = Color(0xffFFFFFF);
  static Color? l_button_toggleActive = Color(0xffFFFFFF);
  static Color? l_button_deactiveBg02 = Color(0xffC0C1C6);
  static Color? l_button_back = Color(0xff2F3136);


  // background
  static Color? l_background_bg01 = Color(0xffFFFFFF);
  static Color? l_background_bg02 = Color(0xffFFFFFF);

  //brandColor
  static Color? l_brandColor_primary = Color(0xff1ABCFE);
  static Color? l_brandColor_secondary = Color(0xffC25FFF);

  //text
  static Color? l_text_active  = Color(0xff040000);
  static Color? l_text_deactive01  = Color(0xff5E6272);
  static Color? l_text_deactive02  = Color(0xff);

  //title
  static Color? l_title_active = Color(0xff040000);
  static Color? l_title_deactive = Color(0xff5E6272);

  //field
  static Color? l_field_textDeactive = Color(0xff5E6272);
  static Color? l_field_textActive = Color(0xff040000);
  static Color? l_field_nameActive = Color(0xff5E6272);
  static Color? l_field_line = Color(0xffE9E9E9);
  static Color? l_field_cursorActive = Color(0xff);
  static Color? l_field_name = Color(0xff);
  static Color? l_field_primary = Color(0xff);
  static Color? l_field_bgWhite = Color(0xff);

  //colorful
  static Color? l_colorful_colorful01 = Color(0xffA06AF9);
  static Color? l_colorful_colorful02 = Color(0xffFBA3FF);
  static Color? l_colorful_colorful03 = Color(0xff8E96FF);
  static Color? l_colorful_colorful04 = Color(0xff94F0F0);
  static Color? l_colorful_colorful05 = Color(0xff4CD964);
  static Color? l_colorful_colorful06 = Color(0xffFFDD72);
  static Color? l_colorful_colorful07 = Color(0xffFF968E);
  static Color? l_colorful_colorful08 = Color(0xffC25FFF);

  //gradient
  static List<Color> l_gradient_gradient01 = [
    Color(0xffFFB8DD),
    Color(0xffBE9EFF),
    Color(0xff88C0FC),
    Color(0xff86FF99),
  ];
  static List<Color>? l_gradient_gradient02 = [
    Color(0xffC393FF),
    Color(0xffE42A6C)
  ];
  static List<Color>? l_gradient_gradient03 = [
    Color(0xffFFEBA2),
    Color(0xffFF8669)
  ];
  static List<Color>? l_gradient_gradient04 = [
    Color(0xff9ADB7F),
    Color(0xff6EA95C)
  ];
  static List<Color>? l_gradient_gradient05 = [
    Color(0xffFFF9B0),
    Color(0xffD3FFFA),
    Color(0xffFFC4FA),
  ];
  static List<Color>? l_gradient_gradient06 = [
    Color(0xffFFAFAF),
    Color(0xffFFB07B),
    Color(0xffFFB37A),
    Color(0xffFFECB7),
    Color(0xffD6FFAA),
    Color(0xff0091FF),
    Color(0xff0091FF),
    Color(0xff6236FF),
    Color(0xffB620E0),
  ];
  static List<Color>? l_gradient_gradient07 = [
    Color(0xffBBFFE7),
    Color(0xff86FFCA)
  ];
  static List<Color>? l_gradient_gradient08 = [
    Color(0xffFFB28E),
    Color(0xffFF7A55)
  ];
  static List<Color>? l_gradient_gradient09 = [
    Color(0xff353843),
    Color(0xff181A20)
  ];
  static List<Color>? l_gradient_gradient10 = [
    Color(0xffF78361),
    Color(0xffF54B64)
  ];
  static List<Color>? l_gradient_bg1 = [
    Color(0xff),
    Color(0xff)
  ];

  //toast
  static Color? l_toast_backgroundInfo = Color(0xff364B81);
  static Color? l_toast_text01 = Color(0xff5E6272);
  static Color? l_toast_text02 = Color(0xffFFFFFF);
  static Color? l_toast_iconSuccess = Color(0xffFFFFFF);
  static Color? l_toast_success = Color(0xff4CD964);
  static Color? l_toast_btn = Color(0xffFFFFFF);
  static Color? l_toast_error = Color(0xffF24E1E);

  //icon
  static Color? l_icon_bg01 = Color(0xff181A20);
  static Color? l_icon_bg02 = Color(0xff5E6272);
  static Color? l_icon_bg03 = Color(0xff9297A7);
  static List<Color> l_icon_success = [
    Color(0xff9ADB7F),
    Color(0xff6EA95C)
  ];
  static Color? l_icon_active = Color(0xff5E6272);
  static Color? l_icon_deactiveDarkest = Color(0xff000000);
  static Color? l_icon_strokeLight = Color(0xffFFFFFF);
  static Color? l_icon_primary = Color(0xff1ABCFE);
  static Color? l_icon_stockDark = Color(0xff5E6272);

  //card
  static List<Color>? l_card_gradient_bg01 = [
    Color(0xffFFB8DD),
    Color(0xffBE9EFF),
    Color(0xff88C0FC),
    Color(0xff86FF99),
  ];
  static Color? l_card_gradient_textActive = Color(0xffFFFFFF);

  //stoke
  static List<Color>? l_stoke_linear01 = [
    Color(0xffFFFFFF),
    Color(0xffFFFFFF),
  ];

  //selection
  static Color l_selection_active = Color(0xff1ABCFE);

  //selection
  static Color l_success_default = Color(0xff219653);

  //selection
  static Color l_danger_default = Color(0xffF04D4D);

  //attachment container background color
  static Color l_attachment_background = Color(0xff246BFD);



///////////////////////////////////////////////////////////
////////////////////Dark Color////////////////////////////
///////////////////////////////////////////////////////////
  //appbar
  static Color? d_appbar_statusBarColor = Color(0xff135E99);
  static Color? d_appbar_barStyle = Color(0xff000);
  static Color? d_appbar_backgroundColor = Color(0xff2196F3);
  static Color? d_appbar_tinColor = Color(0xff2196F3);

  //button
  static Color? d_button_iconActive = Color(0xffFFFFFF);
  static Color? d_button_textActive = Color(0xffFFFFFF);
  static Color? d_button_deactive = Color(0xff5E6272);
  static Color? d_button_textDeactive = Color(0xff5E6272);
  static Color? d_button_active = Color(0xff1ABCFE);
  static Color? d_button_deactiveButtonText = Color(0xffFFFFFF).withOpacity(0.4);
  static Color? d_button_colorful06 = Color(0xffFFDD72);
  static Color? d_button_textDanger = Color(0xffF67878);
  static Color? d_button_toggleActive = Color(0xff000000);
  static Color? d_button_deactiveBg02 = Color(0xffC0C1C6);
  static Color? d_button_back = Color(0xff2F3136);


  // background
  static Color? d_background_bg01 = Color(0xff181A20);
  static Color? d_background_bg02 = Color(0xff262A34);

  //brandColor
  static Color? d_brandColor_primary = Color(0xff1ABCFE);
  static Color? d_brandColor_secondary = Color(0xffC25FFF);

  //text
  static Color? d_text_active  = Color(0xffFFFFFF);
  static Color? d_text_deactive01  = Color(0xff5E6272);
  static Color? d_text_deactive02  = Color(0xff3A3D46);

  //title
  static Color? d_title_active = Color(0xffFFFFFF);
  static Color? d_title_deactive = Color(0xff5E6272);

  //field
  static Color? d_field_textDeactive = Color(0xff5E6272);
  static Color? d_field_textActive = Color(0xffFFFFFF);
  static Color? d_field_nameActive = Color(0xff5E6272);
  static Color? d_field_line = Color(0xff262A34);
  static Color? d_field_cursorActive = Color(0xffFFFFFF);
  static Color? d_field_name = Color(0xff3A3D46);
  static Color? d_field_primary = Color(0xff1ABCFE);
  static Color? d_field_bgWhite = Color(0xffFFFFFF);

  //colorful
  static Color? d_colorful_colorful01 = Color(0xffA06AF9);
  static Color? d_colorful_colorful02 = Color(0xffFBA3FF);
  static Color? d_colorful_colorful03 = Color(0xff8E96FF);
  static Color? d_colorful_colorful04 = Color(0xff94F0F0);
  static Color? d_colorful_colorful05 = Color(0xff4CD964);
  static Color? d_colorful_colorful06 = Color(0xffFFDD72);
  static Color? d_colorful_colorful07 = Color(0xffFF968E);
  static Color? d_colorful_colorful08 = Color(0xffC25FFF);

  //gradient
  static List<Color> d_gradient_gradient01 = [
    Color(0xffFFB8DD),
    Color(0xffBE9EFF),
    Color(0xff88C0FC),
    Color(0xff86FF99),
  ];
  static List<Color>? d_gradient_gradient02 = [
    Color(0xffC393FF),
    Color(0xffE42A6C)
  ];
  static List<Color>? d_gradient_gradient03 = [
    Color(0xffFFEBA2),
    Color(0xffFF8669)
  ];
  static List<Color>? d_gradient_gradient04 = [
    Color(0xff9ADB7F),
    Color(0xff6EA95C)
  ];
  static List<Color>? d_gradient_gradient05 = [
    Color(0xffFFF9B0),
    Color(0xffD3FFFA),
    Color(0xffFFC4FA),
  ];
  static List<Color>? d_gradient_gradient06 = [
    Color(0xffFFAFAF),
    Color(0xffFFB07B),
    Color(0xffFFB37A),
    Color(0xffFFECB7),
    Color(0xffD6FFAA),
    Color(0xff0091FF),
    Color(0xff0091FF),
    Color(0xff6236FF),
    Color(0xffB620E0),
  ];
  static List<Color>? d_gradient_gradient07 = [
    Color(0xffBBFFE7),
    Color(0xff86FFCA)
  ];
  static List<Color>? d_gradient_gradient08 = [
    Color(0xffFFB28E),
    Color(0xffFF7A55)
  ];
  static List<Color>? d_gradient_gradient09 = [
    Color(0xff353843),
    Color(0xff181A20)
  ];
  static List<Color>? d_gradient_gradient10 = [
    Color(0xffF78361),
    Color(0xffF54B64)
  ];
  static List<Color>? d_gradient_bg1 = [
    Color(0xffEF88ED),
    Color(0xff7269E3),
    Color(0xff8350DB),
  ];

  //toast
  static Color? d_toast_backgroundInfo = Color(0xff262A34);
  static Color? d_toast_text01 = Color(0xffFFFFFF);
  static Color? d_toast_text02 = Color(0xffBBAACC);
  static Color? d_toast_iconSuccess = Color(0xffFFFFFF);
  static Color? d_toast_success = Color(0xff4CD964);
  static Color? d_toast_btn = Color(0xffFFFFFF);
  static Color? d_toast_error = Color(0xffF24E1E);

  //icon
  static Color? d_icon_bg01 = Color(0xff181A20);
  static Color? d_icon_bg02 = Color(0xff5E6272);
  static Color? d_icon_bg03 = Color(0xff9297A7);
  static List<Color> d_icon_success = [
    Color(0xff9ADB7F),
    Color(0xff6EA95C)
  ];
  static Color? d_icon_active = Color(0xffFFFFFF);
  static Color? d_icon_deactiveDarkest = Color(0xff000000);
  static Color? d_icon_strokeLight = Color(0xffFFFFFF);
  static Color? d_icon_primary = Color(0xff1ABCFE);
  static Color? d_icon_stockDark = Color(0xff5E6272);

  //card
  static List<Color>? d_card_gradient_bg01 = [
    Color(0xffFFB8DD),
    Color(0xffBE9EFF),
    Color(0xff88C0FC),
    Color(0xff86FF99),
  ];
  static Color? d_card_gradient_textActive = Color(0xffFFFFFF);

  //stoke
  static List<Color>? d_stoke_linear01 = [
    Color(0xffFFFFFF),
    Color(0xffFFFFFF),
  ];

  //selection
  static Color d_selection_active = Color(0xff1ABCFE);

  //selection
  static Color d_success_default = Color(0xff219653);

  //selection
  static Color d_danger_default = Color(0xffF04D4D);

  //attachment container background color
  static Color d_attachment_background = Color(0xff246BFD);









  static void loadColor()
  {
    if (Utils.isLightMode())
    {
      _loadLightColors();
    }
    else
    {
      _loadDarkColors();
    }
  }

  static void loadColor2(bool isLightMode) {
    if (isLightMode) {
      _loadLightColors();
    } else {
      _loadDarkColors();
    }
  }

  static void _loadLightColors()
  {
//appbar
    appbar_statusBarColor  =l_appbar_statusBarColor;
    appbar_barStyle =l_appbar_barStyle;
    appbar_backgroundColor =l_appbar_backgroundColor;
    appbar_tinColor =l_appbar_tinColor;

//button
    button_iconActive =l_button_iconActive;
    button_textActive=l_button_textActive;
    button_deactive=l_button_deactive;
    button_textDeactive=l_button_textDeactive;
    button_active=l_button_active;
    button_deactiveButtonText=l_button_deactiveButtonText;
    button_colorful06=l_button_colorful06;
    button_textDanger=l_button_textDanger;
    button_toggleActive=l_button_toggleActive;
    button_deactiveBg02=l_button_deactiveBg02;
    button_back =l_button_back;


// background
    background_bg01=l_background_bg01;
    background_bg02=l_background_bg02;

//brandColor
    brandColor_primary=l_brandColor_primary;
    brandColor_secondary=l_brandColor_secondary;

//text
    text_active=l_text_active;
    text_deactive01=l_text_deactive01;
    text_deactive02=l_text_deactive02;

//title
    title_active=l_title_active ;
    title_deactive=l_title_deactive;

//field
    field_textDeactive=l_field_textDeactive;
    field_textActive=l_field_textActive;
    field_nameActive=l_field_nameActive;
    field_line=l_field_line;
    field_cursorActive=l_field_cursorActive;
    field_name=l_field_name;
    field_primary=l_field_primary;
    field_bgWhite=l_field_bgWhite;

//colorful
    colorful_colorful01=l_colorful_colorful01;
    colorful_colorful02=l_colorful_colorful02;
    colorful_colorful03=l_colorful_colorful03;
    colorful_colorful04=l_colorful_colorful04;
    colorful_colorful05=l_colorful_colorful05;
    colorful_colorful06=l_colorful_colorful06;
    colorful_colorful07=l_colorful_colorful07;
    colorful_colorful08=l_colorful_colorful08;

//gradient
    gradient_gradient01 =l_gradient_gradient01;
    gradient_gradient02 =l_gradient_gradient02;
    gradient_gradient03 =l_gradient_gradient03;
    gradient_gradient04 =l_gradient_gradient04;
    gradient_gradient05 =l_gradient_gradient05;
    gradient_gradient06 =l_gradient_gradient06;
    gradient_gradient07 =l_gradient_gradient07;
    gradient_gradient08 =l_gradient_gradient08;
    gradient_gradient09 =l_gradient_gradient09;
    gradient_gradient10 =l_gradient_gradient10;
    gradient_bg1 =l_gradient_bg1;

//toast
    toast_backgroundInfo=l_toast_backgroundInfo;
    toast_text01=l_toast_text01;
    toast_text02=l_toast_text02;
    toast_iconSuccess=l_toast_iconSuccess;
    toast_success=l_toast_success;
    toast_btn=l_toast_btn;
    toast_error=l_toast_error;

//icon
    icon_bg01=l_icon_bg01;
    icon_bg02=l_icon_bg02;
    icon_bg03=l_icon_bg03;
    icon_success =l_icon_success;
    icon_active=l_icon_active ;
    icon_deactiveDarkest=l_icon_deactiveDarkest;
    icon_strokeLight=l_icon_strokeLight;
    icon_primary=l_icon_primary;
    icon_stockDark=l_icon_stockDark;

//card
    card_gradient_bg01 =l_card_gradient_bg01;
    card_gradient_textActive=l_card_gradient_textActive;

//stoke
    stoke_linear01 =l_stoke_linear01;

//selection
    selection_active=l_selection_active;

//selection
    success_default=l_success_default;

//selection
    danger_default=l_danger_default;

    //attachment background
    attachmentBackgroundColor = l_attachment_background;

  }

  static void _loadDarkColors() {
//appbar
    appbar_statusBarColor  =d_appbar_statusBarColor;
    appbar_barStyle =d_appbar_barStyle;
    appbar_backgroundColor =d_appbar_backgroundColor;
    appbar_tinColor =d_appbar_tinColor;

//button
    button_iconActive =d_button_iconActive;
    button_textActive=d_button_textActive;
    button_deactive=d_button_deactive;
    button_textDeactive=d_button_textDeactive;
    button_active=d_button_active;
    button_deactiveButtonText=d_button_deactiveButtonText;
    button_colorful06=d_button_colorful06;
    button_textDanger=d_button_textDanger;
    button_toggleActive=d_button_toggleActive;
    button_deactiveBg02=d_button_deactiveBg02;
    button_back =d_button_back;


// background
    background_bg01=d_background_bg01;
    background_bg02=d_background_bg02;

//brandColor
    brandColor_primary=d_brandColor_primary;
    brandColor_secondary=d_brandColor_secondary;

//text
    text_active=d_text_active;
    text_deactive01=d_text_deactive01;
    text_deactive02=d_text_deactive02;

//title
    title_active=d_title_active ;
    title_deactive=d_title_deactive;

//field
    field_textDeactive=d_field_textDeactive;
    field_textActive=d_field_textActive;
    field_nameActive=d_field_nameActive;
    field_line=d_field_line;
    field_cursorActive=d_field_cursorActive;
    field_name=d_field_name;
    field_primary=d_field_primary;
    field_bgWhite=d_field_bgWhite;

//colorful
    colorful_colorful01=d_colorful_colorful01;
    colorful_colorful02=d_colorful_colorful02;
    colorful_colorful03=d_colorful_colorful03;
    colorful_colorful04=d_colorful_colorful04;
    colorful_colorful05=d_colorful_colorful05;
    colorful_colorful06=d_colorful_colorful06;
    colorful_colorful07=d_colorful_colorful07;
    colorful_colorful08=d_colorful_colorful08;

//gradient
    gradient_gradient01 =d_gradient_gradient01;
    gradient_gradient02 =d_gradient_gradient02;
    gradient_gradient03 =d_gradient_gradient03;
    gradient_gradient04 =d_gradient_gradient04;
    gradient_gradient05 =d_gradient_gradient05;
    gradient_gradient06 =d_gradient_gradient06;
    gradient_gradient07 =d_gradient_gradient07;
    gradient_gradient08 =d_gradient_gradient08;
    gradient_gradient09 =d_gradient_gradient09;
    gradient_gradient10 =d_gradient_gradient10;
    gradient_bg1 =d_gradient_bg1;

//toast
    toast_backgroundInfo=d_toast_backgroundInfo;
    toast_text01=d_toast_text01;
    toast_text02=d_toast_text02;
    toast_iconSuccess=d_toast_iconSuccess;
    toast_success=d_toast_success;
    toast_btn=d_toast_btn;
    toast_error=d_toast_error;

//icon
    icon_bg01=d_icon_bg01;
    icon_bg02=d_icon_bg02;
    icon_bg03=d_icon_bg03;
    icon_success =d_icon_success;
    icon_active=d_icon_active ;
    icon_deactiveDarkest=d_icon_deactiveDarkest;
    icon_strokeLight=d_icon_strokeLight;
    icon_primary=d_icon_primary;
    icon_stockDark=d_icon_stockDark;

//card
    card_gradient_bg01 =d_card_gradient_bg01;
    card_gradient_textActive=d_card_gradient_textActive;

//stoke
    stoke_linear01 =d_stoke_linear01;

//selection
    selection_active=d_selection_active;

//selection
    success_default=d_success_default;

//selection
    danger_default=d_danger_default;

    //attachment background
    attachmentBackgroundColor = d_attachment_background;
  }
}
