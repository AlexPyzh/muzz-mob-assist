import 'dart:io' show Platform;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:muzzbirzha_mobile/models/global_using_models.dart';
import 'package:muzzbirzha_mobile/models/http_models/create_album_response.dart';
import 'package:muzzbirzha_mobile/models/http_models/create_track_response.dart';
import 'package:muzzbirzha_mobile/models/http_models/create_or_update_artist_response.dart';
import 'package:muzzbirzha_mobile/models/http_models/get_categories_response.dart';
import 'package:muzzbirzha_mobile/models/http_models/get_history_response.dart';
import 'package:muzzbirzha_mobile/models/http_models/get_user_invests_response.dart';
import 'package:muzzbirzha_mobile/models/http_models/move_file_request.dart';
import 'package:muzzbirzha_mobile/models/investment.dart';

class MuzzClient {
  String baseUrl = "";

  MuzzClient() {
    _configureBaseUrl();
  }

  void _configureBaseUrl() {
    if (kIsWeb) {
      // Web platform - доступ к localhost
      baseUrl = "http://localhost:5000";
    } else {
      if (Platform.isAndroid) {
        // Android эмулятор использует 10.0.2.2 для доступа к host machine
        baseUrl = "http://10.0.2.2:5000";
      } else if (Platform.isIOS) {
        // iOS симулятор может использовать localhost
        baseUrl = "http://localhost:5000";
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        // Desktop платформы - прямой доступ к localhost
        baseUrl = "http://localhost:5000";
      } else {
        // Fallback для других платформ
        baseUrl = "http://localhost:5000";
      }
    }

    if (kDebugMode) {
      print("MuzzClient configured with baseUrl: $baseUrl");
    }
  }

  final _dio = Dio();

  Future<CreateOrUpdateTrackResponse> createTrack(Track track) async {
    Response<dynamic>? restResponse;
    var createTrackResposne = CreateOrUpdateTrackResponse(
      data: null,
      success: false,
      message: "",
    );

    try {
      restResponse =
          await _dio.post('$baseUrl/api/Track', data: track.toJsonNoId());

      createTrackResposne =
          CreateOrUpdateTrackResponse.fromJson(restResponse.data);
    } catch (error) {
      createTrackResposne.success = false;
      createTrackResposne.message = error.toString();
      if (kDebugMode) {
        print(error);
      }
    }
    return createTrackResposne;
  }

  Future<CreateOrUpdateTrackResponse> updateTrack(Track track) async {
    Response<dynamic>? restResponse;
    var updateTrackResposne = CreateOrUpdateTrackResponse(
      data: null,
      success: false,
      message: "",
    );

    try {
      restResponse = await _dio.put('$baseUrl/api/Track', data: track.toJson());

      updateTrackResposne =
          CreateOrUpdateTrackResponse.fromJson(restResponse.data);
    } catch (error) {
      updateTrackResposne.success = false;
      updateTrackResposne.message = error.toString();
      if (kDebugMode) {
        print(error);
        //print(restResponse!.data.toString());
      }
    }
    return updateTrackResposne;
  }

  Future deleteTrack(int trackId) async {
    Response<dynamic>? restResponse;

    try {
      restResponse = await _dio.delete('$baseUrl/api/Track/$trackId');
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<List<Track>> getTracks() async {
    List<Track> tracks = [];
    try {
      var response = await _dio.get('$baseUrl/api/Track');
      tracks = GetTracksResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return tracks;
  }

  Future<List<Track>> getMostLikedTracks() async {
    List<Track> tracks = [];
    try {
      var response = await _dio.get('$baseUrl/api/Track/mostLiked');
      tracks = GetTracksResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return tracks;
  }

  Future<List<Track>> getMostLikedArtistTracks(int artistId) async {
    List<Track> tracks = [];
    try {
      var response = await _dio.get('$baseUrl/api/Track/mostLiked/$artistId');
      tracks = GetTracksResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return tracks;
  }

  Future<Track> getTrackById(int trackId) async {
    Track track = Track();
    try {
      var response = await _dio.get('$baseUrl/api/Track/$trackId');
      track = GetTrackResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return track;
  }

  Future<List<Track>> getTracksByCategoryId(int categoryId) async {
    List<Track> tracks = [];
    try {
      var response = await _dio.get('$baseUrl/api/Track/Category/$categoryId');
      tracks = GetTracksResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return tracks;
  }

  Future<List<Playlist>> getPlaylists() async {
    List<Playlist> playlists = [];
    try {
      var response = await _dio.get('$baseUrl/api/Playlist');
      playlists = GetPlaylistsResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return playlists;
  }

  Future<CreateOrUpdateAlbumResponse> createAlbum(Album album) async {
    Response<dynamic>? restResponse;
    CreateOrUpdateAlbumResponse createAlbumResponse =
        CreateOrUpdateAlbumResponse(
      data: null,
      success: false,
      message: "",
    );

    try {
      restResponse =
          await _dio.post('$baseUrl/api/Album', data: album.toJson());

      createAlbumResponse =
          CreateOrUpdateAlbumResponse.fromJson(restResponse.data);
    } catch (error) {
      createAlbumResponse.success = false;
      createAlbumResponse.message = error.toString();
      if (kDebugMode) {
        print(error);
        print(restResponse!.data.toString());
      }
    }
    return createAlbumResponse;
  }

  Future<CreateOrUpdateAlbumResponse> updateAlbum(Album album) async {
    Response<dynamic>? restResponse;

    CreateOrUpdateAlbumResponse updateAlbumResponse =
        CreateOrUpdateAlbumResponse(
      data: null,
      success: false,
      message: "",
    );

    try {
      restResponse =
          await _dio.put('$baseUrl/api/Album', data: album.toJsonWithId());

      updateAlbumResponse =
          CreateOrUpdateAlbumResponse.fromJson(restResponse.data);
    } catch (error) {
      updateAlbumResponse.success = false;
      updateAlbumResponse.message = error.toString();
      if (kDebugMode) {
        print(error);
        print(restResponse!.data.toString());
      }
    }
    return updateAlbumResponse;
  }

  Future<bool> deleteAlbum(int albumId) async {
    var success = false;

    try {
      var restResponse = await _dio.delete('$baseUrl/api/Album/$albumId');

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<List<Album>> getAlbumsByArtistId(int artistId) async {
    List<Album> albums = [];
    try {
      var response = await _dio.get('$baseUrl/api/Album/artist/$artistId');
      albums = GetAlbumsResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return albums;
  }

  Future<List<Track>> getSinglesByArtistId(int artistId) async {
    List<Track> singles = [];
    try {
      var response = await _dio.get('$baseUrl/api/Track/artist/$artistId');
      final allTracks = GetTracksResponse.fromJson(response.data).data;
      // Фильтруем только синглы
      singles = allTracks.where((track) => track.isSingle == true).toList();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return singles;
  }

  Future<RegResponse> registerUser(RegRequest regRequest) async {
    var regResponse = RegResponse();
    try {
      var response = await _dio.post('$baseUrl/api/Auth/register',
          data: regRequest.toJson());
      regResponse = RegResponse.fromJson(response.data);
      regResponse.success = true;
    } catch (error) {
      if (kDebugMode) {
        regResponse.success = false;
        print(error);
      }
    }
    return regResponse;
  }

  Future<LoginResponse> login(LoginRequest loginRequest) async {
    var loginResponse = LoginResponse();
    try {
      var jsonRequest = loginRequest.toJson();
      var response =
          await _dio.post('$baseUrl/api/Auth/login', data: jsonRequest);
      loginResponse = LoginResponse.fromJson(response.data);
      loginResponse.success = true;
    } catch (error) {
      if (kDebugMode) {
        loginResponse.success = false;
        print(error);
      }
    }
    return loginResponse;
  }

  Future<bool> likeTrack(int trackId, int userId) async {
    var success = true;
    try {
      var response =
          await _dio.post('$baseUrl/api/UserReaction/Like/$trackId/$userId');
      success = true;
    } catch (error) {
      if (kDebugMode) {
        success = false;
        print(error);
      }
    }
    return success;
  }

  Future<bool> deleteLikeFromTrack(int trackId, int userId) async {
    var success = true;
    try {
      var response =
          await _dio.delete('$baseUrl/api/UserReaction/Like/$trackId/$userId');
      success = true;
    } catch (error) {
      if (kDebugMode) {
        success = false;
        print(error);
      }
    }
    return success;
  }

  Future<Response<Artist>> createArtist(Artist artist) async {
    Response<Artist> response = Response(requestOptions: RequestOptions());

    try {
      response = await _dio.post('$baseUrl/api/Artist', data: artist.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return response;
  }

  Future<CreateOrUpdateArtistResponse> updateArtist(Artist artist) async {
    Response<dynamic>? restResponse;
    var updateArtistResponse = CreateOrUpdateArtistResponse(
      data: null,
      success: false,
      message: "",
    );

    try {
      restResponse =
          await _dio.put('$baseUrl/api/Artist', data: artist.toJson());

      updateArtistResponse =
          CreateOrUpdateArtistResponse.fromJson(restResponse.data);
    } catch (error) {
      updateArtistResponse.success = false;
      updateArtistResponse.message = error.toString();
      if (kDebugMode) {
        print(error);
      }
    }
    return updateArtistResponse;
  }

  Future<List<CategoryMuz>?>? getCategories() async {
    List<CategoryMuz>? categories = [];
    try {
      var response = await _dio.get('$baseUrl/api/Category');
      categories = GetCategoriesResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return categories;
  }

  Future<Artist> getArtistById(int artistId,
      {bool showNotPublished = false}) async {
    var artist = Artist();
    try {
      var response = await _dio.get('$baseUrl/api/Artist/$artistId',
          queryParameters: {"showNotPublished": showNotPublished});
      artist = GetArtistResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return artist;
  }

  Future<List<Artist>> getArtists() async {
    List<Artist> artists = [];
    try {
      var response = await _dio.get('$baseUrl/api/Artist/');
      artists = GetArtistsResponse.fromJson(response.data).data!;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return artists;
  }

  Future<List<Artist>> getUserArtists(int userId) async {
    List<Artist> artists = [];
    try {
      var response = await _dio.get('$baseUrl/api/Artist/user/$userId');
      artists = GetArtistsResponse.fromJson(response.data).data!;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return artists;
  }

  Future<List<History>> getHistoryByUserId(int userId) async {
    List<History> history = [];
    try {
      var response = await _dio
          .get('$baseUrl/api/History', queryParameters: {"userId": userId});
      history = GetHistoryResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return history;
  }

  Future<List<History>> getTrackHistoryByUserId(int userId) async {
    List<History> history = [];
    try {
      var response = await _dio.get('$baseUrl/api/History/',
          queryParameters: {"userId": userId, "typeOfEntity": 0});

      history = GetHistoryResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return history;
  }

  Future<History> addHistory(History history) async {
    History addedHistory = History();
    try {
      var jsonHistory = history.toJson();
      var response =
          await _dio.post('$baseUrl/api/History', data: history.toJson());

      addedHistory = History.fromJson(response.data);
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return addedHistory;
  }

  Future<List<Playlist>> getUserPlaylists(int userId) async {
    List<Playlist> playlists = [];
    try {
      var response = await _dio
          .get('$baseUrl/api/Playlist/', queryParameters: {"userId": userId});

      playlists = GetPlaylistsResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return playlists;
  }

  Future<Playlist> createPersonalPlaylist(Playlist playlist) async {
    try {
      var requestBody = playlist.toJson();

      var response =
          await _dio.post('$baseUrl/api/Playlist/', data: playlist.toJson());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return playlist;
  }

  Future<List<Track>> getUserLikedTracks(int userId) async {
    List<Track> tracks = [];
    try {
      var response = await _dio.get('$baseUrl/api/Track/Liked/$userId');

      tracks = GetTracksResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return tracks;
  }

  Future<bool> uploadImageFromBytes(
    String imageName,
    Uint8List? imageBytes,
  ) async {
    var success = false;

    print(imageBytes!.length);

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        Uint8List.fromList(imageBytes),
      ),
    });

    try {
      var response =
          await _dio.post('$baseUrl/api/File/image/$imageName', data: formData);

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<bool> uploadImageFromPath(
    String localPath,
    String remotePath,
    String imageName,
  ) async {
    var success = false;
    var extension = localPath.split(".").last;

    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        localPath,
        filename: imageName,
        contentType: MediaType("image", extension),
      ),
    });

    try {
      var response = await _dio.post(
        '$baseUrl/api/File/image',
        queryParameters: {"path": remotePath},
        data: formData,
        options: Options(
          headers: {
            "accept": "text/plain",
            "Content-Type": "multipart/form-data"
          },
        ),
      );

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<bool> deleteImage(
    String imagePath,
  ) async {
    var success = false;

    try {
      var response = await _dio.delete(
        '$baseUrl/api/File/image',
        queryParameters: {"path": imagePath},
      );

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<bool> moveImageFile(
    String oldPath,
    String newPath,
  ) async {
    var success = false;

    var moveFileRequest = MoveFileRequest(
      oldPath: oldPath,
      newPath: newPath,
    );

    try {
      var response = await _dio.post(
        '$baseUrl/api/File/image/move',
        data: moveFileRequest.toJson(),
      );

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<bool> uploadMuzFileFromPath(
    String localPath,
    String remotePath,
    String muzFileName,
  ) async {
    var success = false;
    var extension = localPath.split(".").last;

    FormData formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        localPath,
        filename: muzFileName,
        contentType: MediaType("audio", extension),
      ),
    });

    try {
      var response = await _dio.post(
        '$baseUrl/api/File/music',
        queryParameters: {
          "path": remotePath,
        },
        data: formData,
        options: Options(
          headers: {
            "accept": "text/plain",
            "Content-Type": "multipart/form-data"
          },
        ),
      );

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<bool> deleteMuzFile(
    String path,
  ) async {
    var success = false;

    try {
      var response = await _dio.delete(
        '$baseUrl/api/File/music',
        queryParameters: {"path": path},
      );

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<bool> moveMuzFile(
    String oldPath,
    String newPath,
  ) async {
    var success = false;

    var moveFileRequest = MoveFileRequest(
      oldPath: oldPath,
      newPath: newPath,
    );

    try {
      var response = await _dio.post(
        '$baseUrl/api/File/music/move',
        data: moveFileRequest.toJson(),
      );

      success = true;
    } catch (error) {
      success = false;
      if (kDebugMode) {
        print(error);
      }
    }
    return success;
  }

  Future<Investment> investInTrack(Investment investment) async {
    try {
      var response = await _dio.post('$baseUrl/api/Track/Invest',
          data: investment.toJsonNoId());
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return investment;
  }

  Future<List<Investment>> getUnitedUserInvestments(int userId) async {
    List<Investment> investments = [];

    try {
      var response = await _dio.get('$baseUrl/api/Invest/united/$userId');
      investments = GetUserInvestmentsResponse.fromJson(response.data).data;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return investments;
  }
}
