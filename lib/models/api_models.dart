// we will make a class here and later define it's object in homepage

import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiModels{
  //Dictionary Method
  Future getWordsAPI(String word) async {
    String url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$word';
    var response = await http.get(Uri.parse(url), headers: {'accept':'application/json'}); 
    var data = json.decode(response.body); 
    return data;
  }
}