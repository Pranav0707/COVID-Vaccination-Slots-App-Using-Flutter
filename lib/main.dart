import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_gradient_text/easy_gradient_text.dart';
import 'package:vaccine_slot_vaccany_app/preventions.dart';
import 'slots.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController pincodecontroller = TextEditingController();
  TextEditingController daycontroller = TextEditingController();
  PageController pageController = PageController();
  String _chosenValue;
  bool isbuttonpressed = false;
  List slots = [];
  List cases = [];
  int index;

  void initState() {
    super.initState();
    _fetchData();
  }

  fetchslots() async {
    await http
        .get(Uri.parse(
            "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=" +
                pincodecontroller.text +
                '&date=' +
                daycontroller.text +
                '%2f' +
                _chosenValue +
                '%2f2021'))
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        slots = result["sessions"];
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Slot(
                    slots: slots,
                  )));
    });
  }

  _fetchData() async {
    await http
        .get(Uri.parse("https://data.covid19india.org/data.json"))
        .then((value) {
      Map data = json.decode(value.body);
      setState(() {
        cases = data["statewise"];
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Colors.black,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Vaccination ',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Text('Slots'),
          SizedBox(width: 15)
        ]),
        actions: <Widget>[
          Icon(
            Icons.medical_services,
            color: Colors.white,
          ),
          SizedBox(
            width: 5,
          )
        ],
      ),
      drawer: new Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.blue[100]),
                accountName:
                    Text("Covid-19 app", style: TextStyle(color: Colors.black)),
                accountEmail: null,
                currentAccountPicture: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("assets/vaccine_image.jpg"),
                )),
            new ListTile(
              subtitle: Text(
                "Click Here To See Preventative measures",
              ),
              title: new Text('Preventive Measures'),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new Prevention()));
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset("assets/vaccine_image.jpg"),
              ),
              TextField(
                controller: pincodecontroller,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(hintText: "Enter PIN Code"),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      child: TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: daycontroller,
                          decoration: InputDecoration(hintText: "Enter Date")),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    child: Container(
                      height: 52,
                      child: DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _chosenValue,
                        iconSize: 24,
                        //elevation: 5,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: <String>[
                          '01',
                          '02',
                          '03',
                          '04',
                          '05',
                          '06',
                          '07',
                          '08',
                          '09',
                          '10',
                          '11',
                          '12',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Enter Month",
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor)),
                  child: Text("Find Slots"),
                  onPressed: () {
                    fetchslots();
                  },
                ),
              ),
              SizedBox(height: 20),
              Container(
                  alignment: Alignment.center,
                  child: GradientText(
                    text: "Live Count Of Covid Cases",
                    colors: <Color>[Colors.purple, Colors.blue],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline),
                  )),
              SizedBox(height: 20),
              ListView.separated(
                padding: EdgeInsets.only(bottom: 10),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: cases.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    controller: pageController,
                    child: Container(
                      height: 180,
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cases[index]["state"],
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Text(
                            "Total Active Cases :" + cases[index]["active"],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontStyle: FontStyle.italic),
                          ),
                          Text(
                              "Total Cases Confirmed :" +
                                  cases[index]["confirmed"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                          Text("Total Deaths :" + cases[index]["deaths"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                          Text(
                              "Covid Patients Recovered :" +
                                  cases[index]["recovered"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                          Text(
                              "Delta Cases Confirmed :" +
                                  cases[index]["deltaconfirmed"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                          Text(
                              "Deaths Caused by Delta :" +
                                  cases[index]["deltadeaths"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                          Text(
                              "Delta Recovered Patients :" +
                                  cases[index]["deltarecovered"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 8,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
