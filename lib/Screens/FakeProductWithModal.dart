import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;

import '../resources/Adresources.dart';
import 'ProductsModel.dart';

class FakeProductWithModal extends StatefulWidget {
  const FakeProductWithModal({Key? key}) : super(key: key);

  @override
  State<FakeProductWithModal> createState() => _FakeProductWithModalState();
}

class _FakeProductWithModalState extends State<FakeProductWithModal> {
  List<products>? allproducts;
  bool isloded = false;
  getproduct() async {
    setState(() {
      isloded = true;
    });
    Uri Url = Uri.parse("https://api.escuelajs.co/api/v1/products");
    var response = await http.get(Url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body.toString());
      setState(() {
        allproducts =
            json.map<products>((obj) => products.fromJson(obj)).toList();
        isloded = false;
      });
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getproduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("FakeProductWithModal"),
        ),
        body: (isloded)
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.separated(
          itemCount: allproducts!.length,
          itemBuilder: (context, index) {
            if (index % 3 == 0) {
              return getAd();

            }
            return ListTile(
              leading: Image.network(
                  allproducts![index].images![0].toString()),
              title: Text(allproducts![index].title.toString()),
              subtitle: Text(allproducts![index].price.toString()),
            );

          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 12.0,
            );
          },

        ));
  }
  Widget getAd() {
    BannerAdListener bannerAdListener =
    BannerAdListener(onAdWillDismissScreen: (ad) {
      ad.dispose();
    }, onAdClosed: (ad) {
      debugPrint("Ad Got Closeed");
    });
    BannerAd bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid
          ? "ca-app-pub-3940256099942544/6300978111"
          : "ca-app-pub-3940256099942544/2934735716",
      listener: bannerAdListener,
      request: const AdRequest(),
    );

    bannerAd.load();

    return SizedBox(
      height: 100,
      child: AdWidget(ad: bannerAd),
    );
  }

  Widget listItem(int index) {
    return ListTile(
      title: Text("Item No $index"),
      subtitle: Text("This item is at $index"),
    );
  }
}

