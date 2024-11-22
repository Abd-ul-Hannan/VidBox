import 'package:VidBox/src/features/social_videos_downloader/domain/entities/video_stats.dart';

class VideoStatsModel extends VideoStats {
  const VideoStatsModel({
    required super.videoLenght,
    required super.viewsCount,
  });

  factory VideoStatsModel.fromJson(Map<String, dynamic> json) {
    return VideoStatsModel(
      videoLenght: json["lengthSeconds"],
      viewsCount: json["viewCount"],
    );
  }
}
