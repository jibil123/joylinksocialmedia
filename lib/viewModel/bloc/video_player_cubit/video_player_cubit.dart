import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:meta/meta.dart';
import 'package:video_player/video_player.dart';

part 'video_player_state.dart';

class VideoPlayerBloc extends Cubit<VideoPlayerState> {
  final String videoUrl;

  VideoPlayerBloc(this.videoUrl) : super(VideoPlayerLoading()) {
    _initialize();
  }

  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  void _initialize() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      await _controller.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _controller,
        aspectRatio: _controller.value.aspectRatio,
        autoPlay: true,
        looping: true,
        showControls: false,
      );
      emit(VideoPlayerInitialized(_chewieController!));
      _controller.play();
    } catch (e) {
      emit(VideoPlayerError('Failed to initialize video player'));
    }
  }

  @override
  Future<void> close() {
    _controller.dispose();
    _chewieController?.dispose();
    return super.close();
  }
}