import 'dart:io';

import 'package:anotacoes_blocos/helpers/admob.dart';
import 'package:anotacoes_blocos/helpers/notepad_helper.dart';
import 'package:anotacoes_blocos/ui/notpad_card.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';



enum OrderOptions{orderaz, orderza}
class HomePage extends StatefulWidget {

  final Color col;
  HomePage({this.col});
  @override
  _HomePageState createState() => _HomePageState();

}
var now = new DateTime.now();
var formatter = new DateFormat('dd-MM-yyyy');



class _HomePageState extends State<HomePage> {

//Admob methods
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  final Anuncio anuncio = Anuncio();

  NotpadHelper _notpadHelper = NotpadHelper();

  List<Notpad> notpads = List();
  String formatted = formatter.format(now);
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();
    setState(() {
      _getNotpadNotes();
    });
    _notpadHelper.getAllContacts().then((list) {
      print(list);
    });
    /*  Notpad c = Notpad();
    c.title = "item2";
    c.content = "2descricao";
    c.data    = formatted;
    c.img     = "111teste1img";
    c.img1    = "11teste2";
    c.img2    = "11teste3";
    c.color   = 1;
    _notpadHelper.saveContact(c);

    _notpadHelper.getAllContacts().then((list) {
      print(list);
    });*/
    // _notpadHelper.deleteContact(1);
    FirebaseAdMob.instance.initialize(appId:"ca-app-pub-9275202133724780~5052682217");
    _bannerAd = anuncio.createBannerAd()..load()..show( anchorOffset: 80.0,
      // Banner Position
      anchorType: AnchorType.top,);
  }

  int _color = 0;

  @override
  void dispose() {

    super.dispose();

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Anotations for Students"),
          backgroundColor: Colors.blue,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.info),onPressed:(){
              _show(context);
            },

            ),

            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(child: Text("Order asc"),value: OrderOptions.orderaz,),
                const PopupMenuItem<OrderOptions>(child: Text("Order desc"),value: OrderOptions.orderza,)
              ],
              onSelected:
              _ordeList
              ,
            )

          ],
        ),

        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            anuncio.createInterstitialAd()..load()..show();
            // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
            _showContactPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.orange[900],),
        body: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1,
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 2,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                  )
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text("Add press",style:
                    TextStyle(color: Colors.white, fontSize: 30),),
                  ),
                  Center(
                    child: Text("+",style:
                    TextStyle(color: Colors.white, fontSize: 100),),
                  ),
                ],
              )


            ),
            ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: notpads.length, itemBuilder: (context, index) {
              return _notpadCard(context, index);
            }),
          ],
        )
    );
  }

  Widget _notpadCard(context, index) {
    return GestureDetector(
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: 150,
        decoration: BoxDecoration(

            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),

            )
        ),
        child: Card(
          color: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )
          ),
          child: Padding(padding: EdgeInsets.all(10),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: notpads[index].img != null ?
                      FileImage(File(notpads[index].img)) :
                      AssetImage("images/notepad.png"),
                    ),
                  ),
                ),
                Flexible(
                    child:
                    Padding(padding: EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                              child: Container(

                                child:
                                Text(notpads[index].title ?? "",
                                  style: TextStyle(fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.center,
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 1,
                                height: 60,
                                decoration: BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),

                                    )
                                ),
                              )
                          ),

                          Row(
                            children: <Widget>[
                              Flexible(
                                flex: 2,
                                child:
                                Container(
                                  child: Text(notpads[index].data ?? "",
                                    style: TextStyle(fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width / 2,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50),
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50),

                                      )
                                  ),
                                ),
                              ),
                            ],

                          ),
                          Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                FlatButton(

                                  child: Text("Edit", style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  onPressed: () {
                                        _showContactPage(notpad: notpads[index]);

                                  },
                                  shape: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                  color: Colors.brown,
                                ),Hero(
                                  tag:notpads[index],
                                  child:
                                  FlatButton(

                                    child: Text("Delete", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),),
                                    onPressed: () {
                                      _showOptions(context, index);
                                    },
                                    color: Colors.red[800],
                                    shape: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),)
                ),
              ],
            ),
          ),
        ),
      ),

      onTap: () {
        anuncio.createInterstitialAd()..load()..show();

        Navigator.push(context, MaterialPageRoute(

            builder: (context) => NotPadCard(notpad: notpads[index],)));
      },

    );
  }

  void _showContactPage({Notpad notpad}) async {
    final recNotes = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NotPadCard(notpad: notpad,)));

    if (recNotes != null) {
      if (notpad != null) {
        await _notpadHelper.updateContact(recNotes);
      } else {
        await _notpadHelper.saveContact(recNotes);
      }
      _getNotpadNotes();
    }
  }

  void _getNotpadNotes() {
    _notpadHelper.getAllContacts().then((list) {
      setState(() {
        notpads = list;
      });
    });
  }

//Update Option
void _showEdit(context, index){

}
// DELETE Options
  void _showOptions(context, index) {
    showDialog(context: context,
        builder: (context) {
          return Hero(
            tag:notpads[index],
                child:AlertDialog(
                  title: Text("Exclusion"),
                  content: Text("Confirm exclusion?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Close"  ,style: TextStyle(
                          fontSize: 20
                      ),),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    FlatButton(
                      child: Text("Yes!",style: TextStyle(
                          fontSize: 20),),
                      onPressed: () {
                        Navigator.pop(context);
                        _notpadHelper.deleteContact(
                            notpads[index].id);
                        setState(() {
                          notpads.removeAt(index);
                        });
                      },
                    ),

                  ],

                ),
          );
        }
    );
  }

  void _show(context) {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            child: Text("Ok"),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
        title: Text("Important Info"),
        content: Text(
            "This data is save in local storage.\n Caution with this informations for no loste.",
        style: TextStyle(fontSize: 20),),
      );
    });
  }

  void _ordeList(OrderOptions result){
    switch(result){
      case OrderOptions.orderaz:
        notpads.sort((a, b){
          return a.data.toLowerCase().compareTo(b.data.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        notpads.sort((a, b){
          return b.data.toLowerCase().compareTo(a.data.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}
