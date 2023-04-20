import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'ProductDetailScreens.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<List>? alldata;
  Future<List> getdata() async {
    Uri Url = Uri.parse("https://api.escuelajs.co/api/v1/products");
    var response = await http.get(Url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      print("==========");
      return json;
    } else {
      print("error");
      return [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      alldata = getdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Products"),
        ),
        body: FutureBuilder(
          future: alldata,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return Center(
                  child: Text("No Found Data"),
                );
              } else {
                return GridView.builder(
                  itemCount: snapshot.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                  mainAxisExtent: 256),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        var id = snapshot.data![index]["id"].toString();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProductDetailScreens(
                            productid: id,
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(snapshot.data![index]["images"][0]
                                    .toString()),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  children: [
                                    Flexible(child: Text(snapshot.data![index]["title"].toString())),
                                  ],
                                ),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text("Rs. " +
                                    snapshot.data![index]["price"].toString()),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
