import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreens extends StatefulWidget {
  var productid = '';
  ProductDetailScreens({required this.productid});
  State<ProductDetailScreens> createState() => _ProductDetailScreensState();
}

class _ProductDetailScreensState extends State<ProductDetailScreens> {
  var image = '';
  var title = "";
  var price = '';
  getdetaildata() async {
    Uri url = Uri.parse(
        "https://api.escuelajs.co/api/v1/products/" + widget.productid);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      setState(() {
        title = json["title"].toString();
        image = json["images"][0].toString();
        price = json["price"].toString();
      });
    } else {
      print("error");
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetaildata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Detail")),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (image == null)
                  ? CircularProgressIndicator()
                  : Center(child: Container(height: 300.0, child: Image.network(image))),
              SizedBox(height: 10.0,),
              Text(title),
              SizedBox(height: 10.0,),
              Text(price),
            ],
          ),
        ));
  }
}
