import 'package:bitcoin_tracker_flutter/network.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

const api_key = "928ACA3B-3D9C-456B-8956-4D58C8507BC2";

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  String rate = '0';

  @override
  void initState() {
    super.initState();
    getRate();
  }

  Future<dynamic> getRate() async {
    Uri url = Uri.https('rest.coinapi.io',
        '/v1/exchangerate/BTC/$selectedCurrency', {'apikey': '$api_key'});

    NetworkHelper networkHelper = NetworkHelper(url);
    var coinData = await networkHelper.getData();
    setState(() {
      double r = coinData['rate'];
      rate = r.toStringAsFixed(4);
      print("Current Rate for $selectedCurrency is $rate");
    });
  }

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          getRate();
          print(selectedCurrency);
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    } else {
      return iosPicker();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Tracker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $rate $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }
}
