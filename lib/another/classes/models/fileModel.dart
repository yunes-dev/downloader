class FileModel {
  String id_file;
  String fileTitle;
  String filePublishDate;
  String fileID;
  String downloading;
  double progress;
  String url;
  String downurl;
  String pathfile;
  String fileQuality;
  String txtMassege;
  int size;
  int sizeLocal;
  String imageFile;
  String typDown;
  String type;
  FileModel(
      {required this.id_file,
      required this.fileTitle,
      required this.filePublishDate,
      required this.fileID,
      required this.downloading,
      required this.progress,
      required this.typDown,
      required this.url,
      required this.downurl,
      required this.pathfile,
      required this.fileQuality,
      required this.size,
      required this.sizeLocal,
      required this.imageFile,
      required this.txtMassege,
      required this.type});
}
