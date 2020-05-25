import 'dart:io';

import 'package:charity_app_new/config/image.dart';
import 'package:charity_app_new/model/post_model.dart';
import 'package:dio/dio.dart';

class PostRepository{
  Dio dio = new Dio();
  Response response;
  String uri = "http://api-charity.mdcnugroho.my.id/api/post/";
  ImageConfig imageConfig = new ImageConfig();

  // index 
  Future<List<PostModel>> index() async{
    try{
      response = await dio.get(
        uri,
        options: Options(headers: {"Accept":"application/json"}) 
      );
      List list = response.data;
      List<PostModel> postModel = list.map((e) => PostModel.fromJson(e)).toList();
      print(postModel);
      return postModel;
    }catch(e){
      throw Exception(e);
    }
  }

  // create 
  Future<int> create({PostModel model,String token,File thumbnail})async{
    try{
        String fileName = (thumbnail == null)?null:thumbnail.path.split("/").last;
        File image = (thumbnail == null)?null:await imageConfig.compressImage(thumbnail);
        FormData _data = new FormData.fromMap({
          "title":model.title,
          "description":model.description,
          "thumbnail": (thumbnail == null)?null:await MultipartFile.fromFile(image.path,filename: fileName),
        });
      response = await dio.post("http://api-charity.mdcnugroho.my.id/api/post",
        data: _data,
        options: Options(
          responseType: ResponseType.json,
          contentType: "multipart/form-data",
          headers: {
            "Authorization":"Bearer $token",
            "Accept":"application/json"
          }
        )
      );
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }

  // update 
  Future<int> update({int id,PostModel model,String token,File thumbnail}) async{
    try{
        String fileName = (thumbnail == null)?null:thumbnail.path.split("/").last;
        File image = (thumbnail == null)?null:await imageConfig.compressImage(thumbnail);
        FormData _data = new FormData.fromMap({
          "title":model.title,
          "description":model.description,
          "thumbnail": (thumbnail == null)?null:await MultipartFile.fromFile(image.path,filename: fileName),
          "_method":"PUT"
        });
      response = await dio.post(
        uri+id.toString(),
        data: _data,
        options: Options(
          responseType: ResponseType.json,
          contentType: "multipart/form-data",
          headers: {
            "Authorization":"Bearer $token",
            "Accept":"application/json"
          }
        )
      );
      
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }
  // delete 
  Future<int> delete({int id}) async{
    try{
      response = await dio.delete(
        uri+id.toString(),
        options: Options(
          headers: {
            "accpet":"application/json"
          }
        )
      );
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }
}