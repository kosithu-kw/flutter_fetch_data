import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class Product {
  final String name;
  final String description;
  final String price;

  Product(this.name, this.description, this.price);


}


class _MyAppState extends State<MyApp> {


  Future fetchProduct() async {
    var res = await http.get(Uri.https("raw.githubusercontent.com", "/kosithu-kw/test/master/data.json"));
    var jsonData=jsonDecode(res.body);

    List<Product> products=[];

    for(var p in jsonData){
        Product product=Product(p["name"].toString(), p["description"].toString(), p["price"].toString());
        products.add(product);
    }
    print(products.length);
    return products;

  }





  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("Fetch Data"),),
          body: new Container(
            child: FutureBuilder(
              future: fetchProduct(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                      itemBuilder: (context, index){
                          return ListTile(
                            title: Text(snapshot.data[index].name),
                          );
                      }
                  );

                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                // By default, show a loading spinner.
                return Center(
                  child: CircularProgressIndicator()
                );
              },
            ),
          ),
        ),
    );
  }
}
