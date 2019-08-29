import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

import 'package:formvalidation/src/models/product_model.dart';

class ProductProvider {
  final String _url = 'https://flutter-varios-7daba.firebaseio.com';

 Future<bool> createProduct(ProductoModel product) async {
   final url = '$_url/productos.json';

    // productoModelToJson transforma el model en un json string
   final resp = await http.post(url, body: productoModelToJson(product));

   final decodeData = json.decode(resp.body);

   print('modelToJson  ===>  ${productoModelToJson(product)}');
   print('decodeData  ===>  $decodeData');
  
   return true;
 }

 Future<List<ProductoModel>> getAll() async {
   final url = '$_url/productos.json';

   final resp = await http.get(url);

   // Usamos el map porque el json esta porfado por un mapa (condigo)
   // y el objecto con sus propiedades que tiene como clave strings
   // y valores en este caso de tipo dynamic
   final Map<String, dynamic> decodeData = json.decode(resp.body);
   final List<ProductoModel> products = new List();

   if(decodeData == null) return [];

   decodeData.forEach((id, product) {
     final prodTemp = ProductoModel.fromJson(product);
     prodTemp.id = id;
     products.add(prodTemp);
   });

   print('decodeData  ===>  $decodeData');
  
   return products;
 }

 Future<int> delete(String id) async {
    final url = '$_url/productos.json/$id.json';

    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
 }

 Future<bool> editProduct(ProductoModel product) async {
   final url = '$_url/productos/${product.id}.json';

    // productoModelToJson transforma el model en un json string
   final resp = await http.put(url, body: productoModelToJson(product));

   final decodeData = json.decode(resp.body);
   
   print('decodeData  ===>  $decodeData');
  
   return true;
 }

 Future<String> loadImage(File image) async {
   final url = Uri.parse('https://api.cloudinary.com/v1_1/dehppqilh/image/upload?upload_preset=cx8xxzvn');
   final mimeType = mime(image.path).split('/');

   // Creamos el request para adjuntar la imagen
   final imageUploadRequest = http.MultipartRequest(
     'POST',
     url
   );

   // Preparamos el archivo para adjuntarlo al request anteiormente generado
   final file = await http.MultipartFile.fromPath(
     'file', 
     image.path,
     contentType: MediaType(mimeType[0], mimeType[1])
     );

   // Adjunto el archivo al uploadrequest
    imageUploadRequest.files.add(file);

    // Ejecutamos la peticion
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
 }

}