import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:live/config/Config.dart';
import 'package:live/config/CustomColors.dart';
import 'package:live/constant/Dimens.dart';
import 'package:live/ui/common/CustomImageHolder.dart';
import 'package:live/utils/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoRecordPage extends StatefulWidget
{
  const VideoRecordPage({
    Key? key,
    required this.onVideoRecorded,
  }) : super(key: key);

  final Function(String) onVideoRecorded;

  @override
  VideoRecordPageState createState() =>  VideoRecordPageState();
}

class VideoRecordPageState extends State<VideoRecordPage>
{
  CameraController? controller;
  String? videoPath;

  List<CameraDescription>? cameras;
  int? selectedCameraIdx;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState()
  {
    super.initState();

    // Get the listonNewCameraSelected of available cameras.
    // Then set the first camera as selected.
    availableCameras().then((availableCameras)
    {
      cameras = availableCameras;

      if (cameras!.length > 0)
      {
        setState(()
        {
          selectedCameraIdx = 0;
        });
        _onCameraSwitched(cameras![selectedCameraIdx!]).then((void v) {});
      }
    }).catchError((err)
    {
      print('Error: $err.code\nError Message: $err.message');
    });
  }

  @override
  void dispose()
  {
    controller!.stopVideoRecording();
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xff181A20),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children:
          [
            _cameraPreviewWidget(),
            Positioned(
              left: Dimens.space10.w,
              top: Dimens.space10.w,
              child:  Container(
                height: kToolbarHeight,
                width: kToolbarHeight,
                alignment: Alignment.topLeft,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                child: Container(
                  alignment: Alignment.center,
                  height: Dimens.space26.w,
                  width: Dimens.space26.w,
                  margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.space8.w),
                    ),
                    color: Colors.transparent,
                    border: Border.all(
                      width: Dimens.space2,
                      color: CustomColors.button_back!,
                    ),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      alignment: Alignment.center,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                    ),
                    onPressed: ()
                    {
                      Utils.closeActivity(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: Dimens.space16.w,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: Dimens.space10.w,
              bottom: Dimens.space10.w,
              right: Dimens.space10.w,
              child:  Container(
                height: kToolbarHeight,
                width: Utils.getScreenHeight(context),
                alignment: Alignment.center,
                margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: _cameraTogglesRowWidget(),
                    ),
                    Expanded(
                      child: PlainAssetImageHolder(
                        assetUrl: "",
                        height: Dimens.space24,
                        width: Dimens.space24,
                        assetWidth: Dimens.space24,
                        assetHeight: Dimens.space24,
                        boxFit: BoxFit.contain,
                        iconUrl: controller!.value.isRecordingVideo?Icons.stop:Icons.fiber_manual_record_rounded,
                        iconSize: Dimens.space24,
                        iconColor: controller!.value.isRecordingVideo?Colors.red:Colors.white,
                        boxDecorationColor: Colors.transparent,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        onTap:()
                        {
                          if(controller != null && controller!.value.isInitialized && !controller!.value.isRecordingVideo)
                          {
                            _onRecordButtonPressed();
                          }
                          else if(controller != null && controller!.value.isInitialized && controller!.value.isRecordingVideo)
                          {
                            _onStopButtonPressed();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: PlainAssetImageHolder(
                        assetUrl: "",
                        height: Dimens.space24,
                        width: Dimens.space24,
                        assetWidth: Dimens.space24,
                        assetHeight: Dimens.space24,
                        boxFit: BoxFit.contain,
                        iconUrl: videoPath!=null?Icons.check:Icons.check,
                        iconSize: Dimens.space24,
                        iconColor: videoPath!=null?Colors.white:Colors.transparent,
                        boxDecorationColor: Colors.transparent,
                        outerCorner: Dimens.space0,
                        innerCorner: Dimens.space0,
                        onTap:()
                        {
                          Utils.closeActivity(context);
                          widget.onVideoRecorded(videoPath!);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction)
  {
    switch (direction)
    {
      case CameraLensDirection.back:
        return Icons.video_camera_back;
      case CameraLensDirection.front:
        return Icons.video_camera_front;
      case CameraLensDirection.external:
        return FontAwesomeIcons.cameraRetro;
      default:
        return Icons.video_camera_back;
    }
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget()
  {
    if (controller == null || !controller!.value.isInitialized)
    {
      return Container(
        height: Utils.getScreenHeight(context),
        width: Utils.getScreenWidth(context),
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space10.h, Dimens.space0.w, Dimens.space16.h),
        padding: EdgeInsets.fromLTRB(Dimens.space0.w, Dimens.space0.h, Dimens.space0.w, Dimens.space0.h),
        child: Text(
          Utils.getString("Loading"),
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

    return controller!=null?
    AspectRatio(
      aspectRatio: 1/controller!.value.aspectRatio,
      child: CameraPreview(controller!),
    ):
    CircularProgressIndicator();
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget()
  {
    if (cameras == null)
    {
      return Container();
    }
    CameraDescription selectedCamera = cameras![selectedCameraIdx!];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return PlainAssetImageHolder(
      assetUrl: "",
      height: Dimens.space24,
      width: Dimens.space24,
      assetWidth: Dimens.space24,
      assetHeight: Dimens.space24,
      boxFit: BoxFit.contain,
      iconUrl: _getCameraLensIcon(lensDirection),
      iconSize: Dimens.space24,
      iconColor: CustomColors.background_bg01,
      boxDecorationColor: Colors.transparent,
      outerCorner: Dimens.space0,
      innerCorner: Dimens.space0,
      onTap:_onSwitchCamera,
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async
  {
    if (controller != null)
    {
      await controller!.dispose();
    }

    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    );

    // If the controller is updated then update the UI.
    controller!.addListener(()
    {
      if (mounted)
      {
        setState(() {});
      }

      if (controller!.value.hasError)
      {
        Utils.showToastMessage('Camera error ${controller!.value.errorDescription}');
      }
    });

    try
    {
      await controller!.initialize();
    }
    on CameraException catch (e)
    {
      _showCameraException(e);
    }

    if (mounted)
    {
      setState(() {});
    }
  }

  void _onSwitchCamera()
  {
    selectedCameraIdx = selectedCameraIdx! < cameras!.length - 1
        ? selectedCameraIdx! + 1
        : 0;
    CameraDescription selectedCamera = cameras![selectedCameraIdx!];

    _onCameraSwitched(selectedCamera);

    setState(()
    {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed()
  {
    _startVideoRecording().then((String? filePath)
    {
      Utils.showToastMessage('Recording video started');
    });
  }

  void _onStopButtonPressed()
  {
    _stopVideoRecording().then((_)
    {
      if (mounted) setState(() {});
    });
  }

  Future<String?> _startVideoRecording() async
  {
    if (!controller!.value.isInitialized)
    {
      Utils.showToastMessage('Please wait');
      return null;
    }

    // Do nothing if a recording is on progress
    if (controller!.value.isRecordingVideo)
    {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory = '${appDirectory.path}/Videos';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/${currentTime}.mp4';

    try
    {
      await controller!.startVideoRecording();
      // videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async
  {
    if (!controller!.value.isRecordingVideo)
    {
      return null;
    }

    try
    {
      XFile xFile = await controller!.stopVideoRecording();
      videoPath = xFile.path;
    }
    on CameraException catch (e)
    {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e)
  {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);
    Utils.showToastMessage('Error: ${e.code}\n${e.description}');
  }
}