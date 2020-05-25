import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class ImageConfig{
  
  Future<File> compressImage(File image) async{
    final tempPath =await getTemporaryDirectory();
    final paths = tempPath.path;
    var images = await FlutterImageCompress.compressAndGetFile(
      image.absolute.path,"$paths/image.jpeg",
      quality: 60,
      format: CompressFormat.jpeg
    );
    return images;
  }
}
