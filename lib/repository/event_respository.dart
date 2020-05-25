import 'dart:io';

import 'package:charity_app_new/config/image.dart';
import 'package:charity_app_new/model/event_model.dart';
import 'package:dio/dio.dart';

class EventRepository{
  Dio dio = new Dio();
  Response response;
  String uri = "http://api-charity.mdcnugroho.my.id/api/event/";
  ImageConfig imageConfig = new ImageConfig();
  
  Future<List<EventModel>> index() async{
    try{
      response = await dio.get(uri,
        options: Options(
          headers: {
            "Accept":"application/json"
          }
        )
      );
      List list = response.data;
      List<EventModel> eventModel = list.map((f) => EventModel.fromJson(f)).toList();
      return eventModel;
    }catch(e){
      throw Exception(e);
    }
  }
  Future<int> create({EventModel model,String token,File thumbnail}) async{
    try{
      
      String fileName = (thumbnail==null)?null:thumbnail.path.split("/").last;
      File image = (thumbnail == null)?null:await imageConfig.compressImage(thumbnail);
      FormData _data = new FormData.fromMap({
        "title":model.title,
        "place":model.place,
        "description":model.description,
        "date_event":model.dateEvent,
        "thumbnail":(thumbnail==null)?null:await MultipartFile.fromFile(image.path,filename:fileName)
      });

      response = await dio.post("http://api-charity.mdcnugroho.my.id/api/event",
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
  Future<int> update({int id,EventModel model,String token,File thumbnail}) async{
    String fileName = (thumbnail==null)?null:thumbnail.path.split("/").last;
    File image = (thumbnail == null)?null:await imageConfig.compressImage(thumbnail);
    FormData formData = new FormData.fromMap({
      "_method":"PUT",
      "title": model.title,
      "place":model.place,
      "description":model.description,
      "thumbnail": (thumbnail==null)?null:await MultipartFile.fromFile(image.path,filename:fileName)
    });
    try{
      response = await dio.post(
        uri+id.toString(),
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
          headers: {
            "Accept":"application/json",
            "Authorization":"Bearer $token",
          }
        )
      );
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }
  Future<int> delete({int id}) async{
    try{
      response = await dio.delete(
        uri+id.toString(),
        options: Options(headers: {"Accept":"application/json"})
      );
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }
}