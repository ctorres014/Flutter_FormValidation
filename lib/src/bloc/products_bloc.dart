
import 'dart:io';

import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/providers/product_provider.dart';
import 'package:rxdart/subjects.dart';

class ProductBloc {

  final _productsController = new BehaviorSubject<List<ProductoModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productProvider = new ProductProvider();

  Stream<List<ProductoModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async {
    final products = await _productProvider.getAll();
    _productsController.sink.add(products);
  }

  void addProduct(ProductoModel product) async {
    _loadingController.sink.add(true);
    await _productProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  void editProduct(ProductoModel product) async {
    _loadingController.sink.add(true);
    await _productProvider.editProduct(product);
    _loadingController.sink.add(false);
  }

  Future<int> deleteProduct(String idProduct) async {
    _loadingController.sink.add(true);
   final id = await _productProvider.delete(idProduct);
    _loadingController.sink.add(false);
    return id;
  }

  Future<String> uploadPhoto(File image) async {
    _loadingController.sink.add(true);
    final pothoUrl = _productProvider.loadImage(image);
    _loadingController.sink.add(false);
    return pothoUrl;
  }

  dispose() {
    _productsController?.close();
    _loadingController?.close();
  }

}