import 'package:flutter/material.dart';

import 'package:formvalidation/src/models/product_model.dart';
import 'package:formvalidation/src/providers/product_provider.dart';

class HomePage extends StatelessWidget {
  final productProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),),
      body: _createList(context),
      floatingActionButton: _createBottom(context),
    );
  }

  Widget _createBottom(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.purple,
      onPressed: () => Navigator.pushNamed(context, 'product'),
    );
  }

  Widget _createList(BuildContext context) {
    return FutureBuilder(
      future: productProvider.getAll(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if(snapshot.hasData) {
          return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) => _createItem(context, snapshot.data[i])
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );

  }

  Widget _createItem(BuildContext context, ProductoModel product) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
          productProvider.delete(product.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (product.fotoUrl == null)
              ? Image(image: AssetImage('assets/no-image.png'),)
              : FadeInImage(
                  image: NetworkImage(product.fotoUrl),
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  height: 300.0,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
                ListTile(
                  title: Text('${product.titulo} - ${product.valor}'),
                  subtitle: Text(product.id),
                  onTap: () => Navigator.pushNamed(context, 'product', arguments: product)  
                ),
            ],
          )
        )

        
    );
  }

}