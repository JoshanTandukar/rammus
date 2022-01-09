import 'dart:io';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:live/ui/common/ButtonWidget.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/utils/Utils.dart';
import 'package:video_player/video_player.dart';

class FileDescriptionDialog extends StatefulWidget
{
  FileDescriptionDialog({
    Key? key,
    required this.filePath,
    required this.onUpload,
  }) : super(key: key);

  final String filePath;
  final Function(String, String) onUpload;

  @override
  FileDescriptionDialogState createState() => FileDescriptionDialogState();
}

class FileDescriptionDialogState extends State<FileDescriptionDialog>
{
  TextEditingController controllerFileName = TextEditingController();
  TextEditingController controllerFileDescription = TextEditingController();

  String fileType = "image";
  String fileName = "";
  File? file;
  int fileSize = 0;

  VideoPlayerController? _controller;

  @override
  void initState()
  {
    super.initState();
    file = File.fromUri(Uri.parse(widget.filePath));
    getFileSize();
    _controller = VideoPlayerController.file(
      File.fromUri(Uri.parse(widget.filePath)),
      // closedCaptionFile: _loadCaptions(),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );
    _controller!.addListener(()
    {

    });
    _controller!.setLooping(true);
    _controller!.initialize();

    fileName = widget.filePath.toString().split("/").last;
    String tempFileExt = widget.filePath.split(".").last;
    if(tempFileExt.toLowerCase() == "jpeg" || tempFileExt.toLowerCase() == "jpg" || tempFileExt.toLowerCase() == "png" || tempFileExt.toLowerCase() == "gif" || tempFileExt.toLowerCase() == "tiff" || tempFileExt.toLowerCase() == "psd" || tempFileExt.toLowerCase() == "pdf" || tempFileExt.toLowerCase() == "eps" || tempFileExt.toLowerCase() == "ai" || tempFileExt.toLowerCase() == "indo" || tempFileExt.toLowerCase() == "raw")
    {
      fileType = "image";
      print("File Type if "+fileType);
    }
    else if(tempFileExt.toLowerCase() == "mpg" || tempFileExt.toLowerCase() == "mp2" || tempFileExt.toLowerCase() == "mpeg" || tempFileExt.toLowerCase() == "mpe" || tempFileExt.toLowerCase() == "mpv" || tempFileExt.toLowerCase() == "ogg" || tempFileExt.toLowerCase() == "mp4" || tempFileExt.toLowerCase() == "m4p" || tempFileExt.toLowerCase() == "m4v" || tempFileExt.toLowerCase() == "avi" || tempFileExt.toLowerCase() == "wmv" || tempFileExt.toLowerCase() == "mov" || tempFileExt.toLowerCase() == "qt" || tempFileExt.toLowerCase() == "flv" || tempFileExt.toLowerCase() == "swf")
    {
      fileType = "video";
      print("File Type else if "+fileType);
    }
    else
    {
      print("File Type "+tempFileExt.toLowerCase());
      fileType = tempFileExt;
      print("File Type else "+fileType);
    }
    controllerFileName.text = fileName.split(".").first;
  }

  @override
  void dispose()
  {
    _controller!.pause();
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: CustomColors.background_bg01,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Dimens.space12.r),
            topRight: Radius.circular(Dimens.space12.r),
          ),
        ),
        height: Dimens.space600.h,
        alignment: Alignment.bottomCenter,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children:
          [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space10.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("uploadFile"),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.text_active,
                  fontFamily: Config.PoppinsSemiBold,
                  fontSize: Dimens.space18.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space5.h, Dimens.space0.w, Dimens.space5.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints)
                {
                  if(fileType == "image")
                  {
                    return RoundedFileImageHolderWithText(
                      height: Dimens.space200,
                      width: Dimens.space200,
                      textColor: Colors.white,
                      fontFamily: Config.PoppinsExtraBold,
                      text: "",
                      fileUrl: widget.filePath,
                      outerCorner: Dimens.space0,
                      innerCorner: Dimens.space0,
                      iconSize: Dimens.space0,
                      iconUrl: Icons.camera_alt_outlined,
                      iconColor: Colors.transparent,
                      boxDecorationColor: Colors.transparent,
                      boxFit: BoxFit.contain,
                      onTap: () {},
                    );
                  }
                  else if(fileType == "video")
                  {
                    return Container(
                      height: Dimens.space200.w,
                      width: Dimens.space200.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space16.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            VideoPlayer(_controller!),
                            ClosedCaption(text: _controller!.value.caption.text),
                            _ControlsOverlay(controller: _controller!),
                            VideoProgressIndicator(_controller!, allowScrubbing: true),
                          ],
                        ),
                      ),
                    );
                  }
                  else
                  {
                    return Container(
                      height: Dimens.space200.w,
                      width: Dimens.space200.w,
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space16.h),
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                      child: Text(
                        fileName,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Color(0xff5E6272),
                          fontFamily: Config.PoppinsSemiBold,
                          fontSize: Dimens.space14.sp,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space5.h, Dimens.space0.w, Dimens.space5.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                filesize(fileSize),
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.text_active,
                  fontFamily: Config.PoppinsSemiBold,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space5.h, Dimens.space20.w, Dimens.space5.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("fileName"),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.text_active,
                  fontFamily: Config.PoppinsSemiBold,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space5.h, Dimens.space0.w, Dimens.space5.h),
              padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
              child: TextField(
                maxLines: 1,
                controller: controllerFileName,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: CustomColors.title_active,
                    fontFamily: Config.InterSemiBold,
                    fontSize: Dimens.space16.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value)
                {
                  // validationMessage = "";
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    Dimens.space20.w,
                    Dimens.space12.h,
                    Dimens.space0.w,
                    Dimens.space12.h,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  suffixIcon: controllerFileName.text.length > 0 ?
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: CustomColors.title_deactive,
                      size: Dimens.space14.w,
                    ),
                    onPressed: ()
                    {
                      setState(()
                      {
                        controllerFileName.text = "";
                      });
                    },
                  ) :
                  Container(
                    height: 1,
                    width: 1,
                  ),
                  filled: true,
                  fillColor: Color(0xff5E6272),
                  hintText: Utils.getString("fileName"),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(
                    color: CustomColors.title_active,
                    fontFamily: Config.InterSemiBold,
                    fontSize: Dimens.space16.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space10.h, Dimens.space20.w, Dimens.space5.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Text(
                Utils.getString("fileDesc"),
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: CustomColors.text_active,
                  fontFamily: Config.PoppinsSemiBold,
                  fontSize: Dimens.space14.sp,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space5.h, Dimens.space0.w, Dimens.space5.h),
              padding: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
              child: TextField(
                maxLines: 1,
                controller: controllerFileDescription,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: CustomColors.title_active,
                    fontFamily: Config.InterSemiBold,
                    fontSize: Dimens.space16.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value)
                {
                  // validationMessage = "";
                  setState(() {});
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(
                    Dimens.space20.w,
                    Dimens.space12.h,
                    Dimens.space0.w,
                    Dimens.space12.h,
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  focusedErrorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xff5E6272),
                        width: Dimens.space1.w),
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                  ),
                  suffixIcon: controllerFileDescription.text.length > 0 ?
                  IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: CustomColors.title_deactive,
                      size: Dimens.space14.w,
                    ),
                    onPressed: ()
                    {
                      setState(()
                      {
                        controllerFileDescription.text = "";
                      });
                    },
                  ) :
                  Container(
                    height: 1,
                    width: 1,
                  ),
                  filled: true,
                  fillColor: Color(0xff5E6272),
                  hintText: Utils.getString("fileDesc"),
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(
                    color: CustomColors.title_active,
                    fontFamily: Config.InterSemiBold,
                    fontSize: Dimens.space16.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space20.h, Dimens.space0.w, Dimens.space0.h),
              padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space20.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedButtonWidget(
                      width: Dimens.space100.w,
                      height: Dimens.space48.h,
                      onPressed: ()
                      {
                        Utils.closeActivity(context);
                      },
                      corner: Dimens.space300.r,
                      buttonTextColor: Colors.white,
                      buttonBorderColor: Color(0xff5E6272),
                      buttonBackgroundColor: Color(0xff5E6272),
                      buttonText: Utils.getString("cancel"),
                      fontStyle: FontStyle.normal,
                      titleTextAlign: TextAlign.left,
                      innerContainerAlignment: Alignment.center,
                      buttonFontSize: Dimens.space14.sp,
                      buttonFontWeight: FontWeight.normal,
                      buttonFontFamily: Config.InterBold,
                      hasShadow: false,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space20.w, Dimens.space0.h),
                    padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    child: RoundedButtonWidget(
                      width: Dimens.space100.w,
                      height: Dimens.space48.h,
                      onPressed: ()
                      {
                        if(fileSize > 20971520)
                        {
                          Utils.showToastMessage("File size limit exceeded. Max 20 Mb");
                        }
                        else
                        {
                          widget.onUpload(controllerFileName.text, controllerFileDescription.text);
                        }
                      },
                      corner: Dimens.space300.r,
                      buttonTextColor: Colors.white,
                      buttonBorderColor: Colors.blue,
                      buttonBackgroundColor: Colors.blue,
                      buttonText: Utils.getString("upload"),
                      fontStyle: FontStyle.normal,
                      titleTextAlign: TextAlign.left,
                      innerContainerAlignment: Alignment.center,
                      buttonFontSize: Dimens.space14.sp,
                      buttonFontWeight: FontWeight.normal,
                      buttonFontFamily: Config.InterBold,
                      hasShadow: false,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getFileSize() async
  {
    fileSize = await file!.length();
    setState(() {});
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const _examplePlaybackRates = [
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (context) {
              return [
                for (final speed in _examplePlaybackRates)
                  PopupMenuItem(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}