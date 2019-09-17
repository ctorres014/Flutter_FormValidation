import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';

import 'package:formvalidation/src/models/product_model.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();


    return Scaffold(
      appBar: AppBar(title: Text('Home Page'),),
      body: _createList(context, productsBloc),
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

  Widget _createList(BuildContext context, ProductBloc bloc) {

    return StreamBuilder(
      stream: bloc.productsStream ,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot){
        if(snapshot.hasData) {
          return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) => _createItem(context, snapshot.data[i], bloc)
          );
        } else {
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );

  }

  Widget _createItem(BuildContext context, ProductoModel product, ProductBloc bloc) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: (direction) {
         bloc.deleteProduct(product.id);
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