class StringUtils {
  String trimString(String stringToFormat) {
    var formattedString = stringToFormat
        .trim()
        .replaceAll(" ", "_")
        .replaceAll(",", "_")
        .toLowerCase();
    return formattedString;
  }

  String createArtistImageFileName(
    String artisName,
    String extention,
  ) {
    var path = "${trimString(artisName)}_cover.$extention";
    return path;
  }

  String createArtistImageFilePath(
    String artisName,
    String imageFileName,
  ) {
    var path = "${trimString(artisName)}/$imageFileName";
    return path;
  }

  String createSingleOrAlbumImageFileName(
    String artistName,
    String singleOrAlbumName,
    String extention,
  ) {
    var name =
        "${trimString(artistName)}_${trimString(singleOrAlbumName)}_cover.$extention";
    return name;
  }

  String createAlbumImageFilePath(
    String artisName,
    String imageFileName,
  ) {
    var path = "${trimString(artisName)}/albums/$imageFileName";
    return path;
  }

  String createSingleImageFilePath(
    String artisName,
    String imageFileName,
  ) {
    var path = "${trimString(artisName)}/singles/$imageFileName";
    return path;
  }

  String createSingleMuzFileName(
    String artistName,
    String trackName,
    String extention,
  ) {
    var name = "${trimString(artistName)}_${trimString(trackName)}.$extention";
    return name;
  }

  String createSingleMuzFilePath(
    String artistName,
    String muzFileName,
  ) {
    var path = "${trimString(artistName)}/singles/$muzFileName";
    return path;
  }

  String createAlbumMuzFileName(
    String artistName,
    String albumName,
    String trackName,
    String extention,
  ) {
    var name =
        "${trimString(artistName)}_${trimString(albumName)}_${trimString(trackName)}.$extention";
    return name;
  }

  String createAlbumMuzFilePath(
    String artistName,
    String albumName,
    String muzFileName,
  ) {
    var path =
        "${trimString(artistName)}/albums/${trimString(albumName)}/$muzFileName";
    return path;
  }

  String getFilePathFromUrl(String fileUrl, String artistName) {
    var beforeBucketName = fileUrl.split(":").last;
    var path = beforeBucketName.substring(beforeBucketName.indexOf("/") + 1);

    //var path = "/$artistName/${fileUrl.split("/$artistName/").last}";
    return path;
  }

  String getFileNameFromPathOrUrl(String filePathOrUrl) {
    var name = filePathOrUrl.split("/").last;
    return name;
  }
}
