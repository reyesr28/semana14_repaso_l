import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:semana14_repaso_l/api/post.dart';

class Service{

  static Future<Post> listaPost() async{
    final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));

    if(response.statusCode==200){
      return Post.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error de comsumo de API');
    }
  }

  static Future<Post> consultaPost(String id) async{
    final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/${id}"));
    if(response.statusCode==200){
      return Post.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error de comsumo de API');
    }
  }
}