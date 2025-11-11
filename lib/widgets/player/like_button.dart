import 'package:flutter/material.dart';
import 'package:muzzbirzha_mobile/models/user_reaction.dart';
import 'package:muzzbirzha_mobile/network/muzz_client.dart';
import 'package:muzzbirzha_mobile/providers/auth_provider.dart';
import 'package:muzzbirzha_mobile/providers/track_list_provider.dart';
import 'package:provider/provider.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  late final dynamic trackListProvider;
  late final dynamic authProvider;
  final _muzzClient = MuzzClient();
  int _userId = 0;
  int _trackId = 0;
  bool _isLiked = false;
  int _likesCount = 0;
  Color _color = Colors.white70;
  IconData _icon = Icons.thumb_up_outlined;

  @override
  void initState() {
    trackListProvider = Provider.of<TrackListProvider>(context, listen: false);
    authProvider = Provider.of<AuthProvider>(context, listen: false);

    _userId = authProvider.loggedInUser.id;
    _trackId =
        trackListProvider.trackList[trackListProvider.currentTrackIndex].id;

    _isLiked = trackListProvider
            .trackList[trackListProvider.currentTrackIndex].userReactions
            .where((u) => u.userId == _userId)
            .length >
        0;

    _likesCount = trackListProvider
        .trackList[trackListProvider.currentTrackIndex].userReactions.length;
    _color = _isLiked ? Colors.red : Colors.white70;
    super.initState();
  }

  void likeUnLike() async {
    _isLiked = !_isLiked;

    if (_isLiked) {
      var successResponse = await _muzzClient.likeTrack(
          trackListProvider.currentTrack.id, authProvider.loggedInUser.id);
      if (successResponse) {
        trackListProvider
            .trackList[trackListProvider.currentTrackIndex].userReactions
            .add(UserReaction(userId: _userId, trackId: _trackId));
      }
    } else {
      var successResponse = await _muzzClient.deleteLikeFromTrack(
          trackListProvider.currentTrack.id, authProvider.loggedInUser.id);
      if (successResponse) {
        trackListProvider
            .trackList[trackListProvider.currentTrackIndex].userReactions
            .removeWhere(
                (ur) => ur.userId == _userId && ur.trackId == _trackId);
      }
    }

    setState(() {
      _color = _isLiked ? Colors.red : Colors.white70;
      _icon = _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: likeUnLike,
      child: Icon(
        _icon,
        //color: _color,
      ),
    );
  }
}
