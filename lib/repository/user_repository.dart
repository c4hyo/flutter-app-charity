import 'package:charity_app_new/model/user_model.dart';
import 'package:dio/dio.dart';

class UserRepository{
  Dio dio = new Dio();
  Response response;
  String uri = "http://api-charity.mdcnugroho.my.id/api/user/";

  Future<UserModel> login({UserModel model}) async{
    try{
      response = await dio.post(uri+"login",
        data: model.toJson(),
        options: Options(
          headers: {
            "Accept":"application/json"
          }
        ),
      );
      var responseUser = response.data;
      UserModel models = UserModel.fromJson(responseUser);
      return models;
    }catch(e){
      if(e.type == DioErrorType.RESPONSE){
        if(e.response.statusCode == 401){
          throw Exception("User not found");
        }
      }
      throw Exception(e);
    }
  }

  Future<int> register({UserModel model}) async{
    try{
      response = await dio.post(uri+"register",
        data: model.toJson(),
        options: Options(
          headers: {
            "Accept":"application/json"
          }
        )
      );
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }

  Future<List<UserModel>> index() async{
    try{
      response = await dio.get(uri,
        options: Options(
          headers: {
            "Accept":"application/json"
          }
        )
      );
      List list = response.data;
      List<UserModel> userModel = list.map((e) => UserModel.fromJson(e)).toList();
      return userModel;
    }catch(e){
      throw Exception(e);
    }
  }

  Future<int> update({int id,UserModel model}) async{
    FormData formData = new FormData.fromMap({
      "_method":"PUT",
      "name":model.name,
      "email":model.email,
      "password":model.password
    });
    try{
      response = await dio.post(uri+id.toString(),
        data: formData,
        options: Options(
          headers: {
            "Accpet":"application/json"
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
      response = await dio.delete(uri+id.toString());
      dio.options.headers["Accept"] ="application/json";
      return response.statusCode;
    }catch(e){
      throw Exception(e);
    }
  }
}