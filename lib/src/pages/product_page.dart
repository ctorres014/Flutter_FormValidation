import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/providers/product_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {


  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final keyForm     = GlobalKey<FormState>();
  final keyScaffold = GlobalKey<ScaffoldState>();

  ProductProvider productProvider = new ProductProvider();

  ProductoModel product = new ProductoModel();
  File photo;
  
  @override
  Widget build(BuildContext context) {
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null) {
      product = prodData;
    }
    return Scaffold(
      key: keyScaffold,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPhoto,
          ),
           IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: keyForm,
            child: Column(
                children: <Widget>[
                  _displayPhoto(),
                  _createName(),
                  _createPrice(),
                  _createAvailable(),
                  _createBottom()
                ],
              ),
            ),
          )
        ),
      );
  }

  Widget _createName() {
    return TextFormField(
      initialValue: product.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      onSaved: (value) => product.titulo = value,
      validator: (value) {
        return (value.length > 3) ? null : 'Debe ingresar un nombre';
      },
    );
  }

  Widget _createPrice() {
    return TextFormField(
      initialValue: product.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      onSaved: (value) => product.valor = num.tryParse(value),
      validator: (value) {
        if(utils.isNumeric(value)) {
          return null;
        } else {
          return 'Debe ingresar un valor numérico';
        }
      },
    );
  }

  Widget _createAvailable() {
    return SwitchListTile(
      value: product.disponible,
      activeColor: Colors.deepPurple,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {
        product.disponible = value;
      }),
    );
  }

  Widget _createBottom() {
    return RaisedButton.icon(
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      color: Colors.deepPurple,
      textColor: Colors.white,
      onPressed: _submit,
    );
  }

  void _submit() async{
    if(!keyForm.currentState.validate()) return;
    keyForm.currentState.save();

    // setState(() {
      
    // });
    if(photo != null) {
      product.fotoUrl = await productProvider.loadImage(photo);
    }

    if(product.id == null) {
      productProvider.createProduct(product);
    } else {
      productProvider.editProduct(product);
    }
    displaySnackbar('Producto guardado');
    Navigator.pop(context);
  }



  _displayPhoto() {
    if(product.fotoUrl != null) {
      return FadeInImage(
          image: NetworkImage(product.fotoUrl),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.cover,
        );
    }else {
      return Image(
        image: AssetImage(photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }


  void displaySnackbar(String menssage) {
    final snackbar = SnackBar(
      content: Text(menssage),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.green,
    );
    // Para mostrar el snackbar necesitamos tener una referencia
    // del scaffold
    keyScaffold.currentState.showSnackBar(snackbar);
  }

  _selectPhoto() async {
    photo = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if(photo != null) {
      product.fotoUrl = null;
    }
    setState(() { });
  }

  _takePhoto() async {
    photo = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if(photo != null) {
      // limpieza
    }
    setState(() { });
  }


}