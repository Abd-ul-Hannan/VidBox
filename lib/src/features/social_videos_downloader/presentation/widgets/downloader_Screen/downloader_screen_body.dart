// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:VidBox/src/core/media_query.dart';
// import 'package:VidBox/src/features/social_videos_downloader/presentation/widgets/downloader_Screen/downloader_screen_supported_platforms.dart';

// import '../../../../../config/routes_manager.dart';
// import '../../../../../core/common_widgets/app_background.dart';
// import '../../../../../core/common_widgets/circular_loader_with_overlay.dart';
// import '../../../../../core/common_widgets/toast.dart';
// import '../../../../../core/utils/app_colors.dart';
// import '../../../../../core/utils/app_enums.dart';
// import '../../bloc/downloader_bloc/downloader_bloc.dart';
// import 'bottom_sheet/downloader_bottom_sheet.dart';
// import 'downloader_screen_input_field.dart';
// import 'downloader_screen_appbar.dart';

// class DownloaderScreenBody extends StatefulWidget {
//   const DownloaderScreenBody({super.key});

//   @override
//   State<DownloaderScreenBody> createState() => _DownloaderScreenBodyState();
// }

// class _DownloaderScreenBodyState extends State<DownloaderScreenBody> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final TextEditingController videoLinkController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           width: context.width,
//           height: context.height / 2.2,
//           decoration: const BoxDecoration(
//             color: AppColors.primaryColor,
//             borderRadius: BorderRadius.only(
//               bottomLeft: Radius.circular(40),
//               bottomRight: Radius.circular(40),
//             ),
//           ),
//         ),
//         SafeArea(
//           child: BlocConsumer<DownloaderBloc, DownloaderState>(
//             listener: (context, state) {
//               if (state is DownloaderSaveVideoLoading) {
//                 Navigator.of(context).popAndPushNamed(Routes.downloads);
//               }
//               if (state is DownloaderGetVideoFailure) {
//                 buildToast(msg: state.message, type: ToastType.error);
//               }
//               if (state is DownloaderGetVideoSuccess &&
//                   state.video.videoLinks.isEmpty) {
//                 buildToast(msg: state.video.message!, type: ToastType.error);
//               }
//               if (state is DownloaderGetVideoSuccess &&
//                   state.video.videoLinks.isNotEmpty) {
//                 print('downloader get video success');
//                 buildDownloadBottomSheet(context, state.video);
//               }
//               if (state is DownloaderSaveVideoSuccess) {
//                 buildToast(msg: state.message, type: ToastType.success);
//               }
//               if (state is DownloaderSaveVideoFailure) {
//                 buildToast(msg: state.message, type: ToastType.error);
//               }
//             },
//             builder: (context, state) {
//               return Stack(
//                 children: [
//                   const AppBackground(
//                     heightRatio: 1.5,
//                   ),
//                   SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: context.height * 0.02,
//                         ),
//                         const AppBarWithLogo(),
//                         SizedBox(
//                           height: context.height * 0.03,
//                         ),
//                         Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               DownloaderScreenInputField(
//                                 videoLinkController: videoLinkController,
//                                 formKey: formKey,
//                               ),
//                               SizedBox(height: context.height * 0.03),
//                               const DownloaderScreenSupportedPlatforms(),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:VidBox/src/features/social_videos_downloader/presentation/widgets/downloader_Screen/bottom_sheet/downloader_bottom_sheet.dart';
import 'package:VidBox/src/features/social_videos_downloader/presentation/widgets/downloader_Screen/downloader_screen_supported_platforms.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart'; // Correct import

import '../../../../../config/routes_manager.dart';
import '../../../../../core/common_widgets/app_background.dart';
import '../../../../../core/common_widgets/toast.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_enums.dart';
import '../../bloc/downloader_bloc/downloader_bloc.dart';
import 'downloader_screen_input_field.dart';
import 'downloader_screen_appbar.dart';

class DownloaderScreenBody extends StatefulWidget {
  const DownloaderScreenBody({super.key});

  @override
  State<DownloaderScreenBody> createState() => _DownloaderScreenBodyState();
}

class _DownloaderScreenBodyState extends State<DownloaderScreenBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController videoLinkController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Handle URL shared when the app is launched or resumed
    ReceiveSharingIntent.instance
        .getInitialMedia()
        .then((List<SharedMediaFile> value) {
      if (value.isNotEmpty) {
        setState(() {
          // Accessing the path or URL of the media shared
          videoLinkController.text = value.first
              .path; // Use the correct property for the path or URI of the shared media
        });
      }
    });

    // Listen for ongoing shared media
    ReceiveSharingIntent.instance.getMediaStream().listen(
        (List<SharedMediaFile> mediaFiles) {
      if (mediaFiles.isNotEmpty) {
        setState(() {
          // Accessing the path or URL of the media shared
          videoLinkController.text = mediaFiles.first
              .path; // Use the correct property for the path or URI of the shared media
        });
      }
    }, onError: (err) {
      print("Error: $err");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 2.2,
          decoration: const BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        SafeArea(
          child: BlocConsumer<DownloaderBloc, DownloaderState>(
            listener: (context, state) {
              if (state is DownloaderSaveVideoLoading) {
                Navigator.of(context).popAndPushNamed(Routes.downloads);
              }
              if (state is DownloaderGetVideoFailure) {
                buildToast(msg: state.message, type: ToastType.error);
              }
              if (state is DownloaderGetVideoSuccess &&
                  state.video.videoLinks.isEmpty) {
                buildToast(msg: state.video.message!, type: ToastType.error);
              }
              if (state is DownloaderGetVideoSuccess &&
                  state.video.videoLinks.isNotEmpty) {
                buildDownloadBottomSheet(context, state.video);
              }
              if (state is DownloaderSaveVideoSuccess) {
                buildToast(msg: state.message, type: ToastType.success);
              }
              if (state is DownloaderSaveVideoFailure) {
                buildToast(msg: state.message, type: ToastType.error);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  const AppBackground(
                    heightRatio: 1.5,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        const AppBarWithLogo(),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),
                        Center(
                          child: Column(
                            children: [
                              DownloaderScreenInputField(
                                videoLinkController: videoLinkController,
                                formKey: formKey,
                              ),
                              SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.03),
                              const DownloaderScreenSupportedPlatforms(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
