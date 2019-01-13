import 'dart:io';
import 'package:anotacoes_blocos/helpers/admob.dart';
import 'package:anotacoes_blocos/ui/page_image.dart';
import 'package:anotacoes_blocos/ui/page_image1.dart';
import 'package:anotacoes_blocos/ui/page_image2.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:masked_text_input_formatter/masked_text_input_formatter.dart';
import 'package:anotacoes_blocos/helpers/notepad_helper.dart';
import 'package:anotacoes_blocos/ui/home_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';





class NotPadCard extends StatefulWidget {

  final Notpad notpad, visible;
  NotPadCard({this.notpad, this.visible});

  @override
  _NotPadCardState createState() => _NotPadCardState();
}
var now = new DateTime.now();
var formatter = new DateFormat('dd-MM-yyyy');

class _NotPadCardState extends State<NotPadCard> {

  final _titleController = TextEditingController();
  final _ontentController =TextEditingController();
  final _dataController  = TextEditingController();
  final _colorController = TextEditingController();

  final _titleFocus =FocusNode();
  final _dataFocus  = FocusNode();
  Notpad _editNotpad;
  bool _notEdited = false;
  bool _visible = true;

  Cor _selectedChoice= _cors[0]; // The app's "state".

  String _info= "Insira as informações acima";

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

//Admob methods
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  final Anuncio anuncio = Anuncio();




  Color _color = Colors.white;
  @override
  void initState() {
    super.initState();



    if(widget.notpad==null){
      _editNotpad = Notpad();
    //_dataController.text = formatter.format(now);


    }else{
      _editNotpad= Notpad.fromMap(widget.notpad.toMap());


      _titleController.text = _editNotpad.title;
      _ontentController.text = _editNotpad.content;
      _dataController.text = _editNotpad.data;
      _selectedChoice.index = _editNotpad.color;

    }
    _getData();

  }
  void _getData(){
    print(formatter.format(now));
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editNotpad.title??"New title"),

        actions: <Widget>[
      IconButton(icon: Icon(Icons.info),onPressed:(){
      _show(context);
    },)

       /* Row(
          children: <Widget>[
            Text(
              "Card colors:",style: TextStyle(fontSize: 20),
            ),
          GestureDetector(
           child: Container(
             padding: EdgeInsets.all(5),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,


              ),
            ),
            onTap: (){
             setState(() {
               _editNotpad.color = 22;

             });




            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal

              ),
            ),
            onTap: (){
              _color = Colors.teal;
              Navigator.pop(context, MaterialPageRoute(
                  builder: (context)=> HomePage(col: _color)


              ));
              print(_color);
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightGreen

              ),
            ),
            onTap: (){
              setState(() {
                _color= Colors.lightGreen;
                print(_color);
              });
            },
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.all(5),
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.purple

              ),
            ),
            onTap: (){
              setState(() {
                _color= Colors.purple;
                Navigator.pop(context, MaterialPageRoute(
                  builder: (context)=> HomePage(col: _color)


                ));
                print(_color);
              });

            },
          ),
          ],
        ),
*/
        ],
      ),
      backgroundColor: _selectedChoice.cor,
      floatingActionButton: FloatingActionButton(onPressed: (){
      /* if(_editNotpad.title.isEmpty)
            FocusScope.of(context).requestFocus(_titleFocus);
       else if(_editNotpad.data.isEmpty)
         FocusScope.of(context).requestFocus(_dataFocus);
           else*/
             if(_formkey.currentState.validate()){
               anuncio.createInterstitialAd()..load()..show();
               Navigator.pop(context, _editNotpad);
             }
      },
      backgroundColor: Colors.orange[900],
      child: Icon(Icons.save),),
      body:Container(
        color: Colors.black,
        child:   ListView(
                  scrollDirection: Axis.vertical,
                  children: <Widget>[
                    _notPadCard(context),
                    Divider(),
                    Form(
                      key: _formkey,

                    child:  Row(
                      children: <Widget>[


                        Expanded(
                          flex: 2,

                          child: Container(
                            child: TextFormField(controller: _titleController,style: TextStyle(fontSize: 22),
                            //  focusNode: _titleFocus,
                              validator: (value){
                              if(value.isEmpty ){
                                return "Is not empty";
                              }else{
                                _editNotpad.title= value;
                              }
                              },maxLength: 20,
                              decoration: InputDecoration( border: OutlineInputBorder(),

                                  hintText: "Title here"),
                            ),
                          ),
                        ),
                        Expanded(
                          flex :2,
                          child: Container(
                            child: TextFormField(controller: _dataController,style: TextStyle(fontSize: 18),
                              inputFormatters: [
                                MaskedTextInputFormatter(
                                  mask: 'xx-xx-xxxx',
                                  separator: '-',
                                )
                              ],
                              validator: (value){
                                if(value.isEmpty ){
                                  return "Is not empty";
                                }else{
                                  _editNotpad.data= value;
                                }
                              },

                              decoration: InputDecoration( border: OutlineInputBorder(),
                                  hintText: "dd-mm-yyyy",hintStyle: TextStyle(fontSize: 15),icon: IconButton(icon: Icon(Icons.date_range, color: Colors.white,),
                                      onPressed: (){
                                        setState(() {
                                          _dataController.text= formatter.format(now);
                                          _editNotpad.data=_dataController.text;
                                          print(_dataController.text);
                                        });

                                      })),
                            ),
                          ),

                        ),
                      ],
                    ),
                    ),
                    new Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),

                      margin: EdgeInsets.symmetric(vertical: 5.0),
                      height: 400.0,
                      child: SingleChildScrollView(
                          child:  TextField(
                            controller: _ontentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 100,


                            style: TextStyle(fontSize: 25.0 , color: Colors.black ),
                            decoration: InputDecoration(

                              labelText: "Add",

                            ),onChanged: (text){
                            _notEdited = true;
                            setState(() {
                              _editNotpad.content = text;
                            });

                          },
                          )
                      ),

                    ),
                  ],
                ),
              ),


    );

  }
Widget _notPadCard(BuildContext context){
    return new Container(
        margin: EdgeInsets.all(0),
        height: 200,
        width: double.infinity,

        child: Card(
            elevation: 10,
            child:  Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                 Column(
                    children: <Widget>[
              Hero(
                tag:"tes",
              child:     GestureDetector(
                        child:  Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(

                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image:_editNotpad.img !=null?
                              FileImage(File(_editNotpad.img)):
                              AssetImage("images/notepad.png"),
                            ),
                          ),
                        ),
                        onTap: () {

                          _requestCanOrGallery();
                        },onLongPress: (){
                          if(_editNotpad.img !=null){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context)=> PageImage(widget.notpad.img)));
                            print(widget.notpad.img);
                          }else{
                            return showDialog(context: context,
                              builder: (context){
                              return AlertDialog(
                                title: Text("Image N/A"),
                                content: Text("Not found image"),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Ok", style: TextStyle(fontSize: 20),),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                              }

                            );
                          }
                        
                      }, ),),
                      Text("See/Add",style: TextStyle(color: Colors.black),),

                    ],
                  ),
                 Column(
                   children: <Widget>[
                     Hero(
                       tag: "tes1",
                       child: GestureDetector(
                         child:  Container(
                           width: 150,
                           height: 150,
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             image: DecorationImage(
                               fit: BoxFit.cover,
                               image:_editNotpad.img1 !=null?
                               FileImage(File(_editNotpad.img1)):
                               AssetImage("images/notepad.png"),
                             ),
                           ),
                         ),
                         onTap: (){
                           _requestCanOrGallery1();
                         },
                         onLongPress: (){



                           if(_editNotpad.img1 !=null){
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (context)=> PageImage1(widget.notpad.img1)));
                             print(widget.notpad.img1);
                           }else{
                             return showDialog(context: context,
                                 builder: (context){
                                   return AlertDialog(
                                     title: Text("Image N/A"),
                                     content: Text("Not found image"),
                                     actions: <Widget>[
                                       FlatButton(
                                         child: Text("Ok", style: TextStyle(fontSize: 20),),
                                         onPressed: (){
                                           Navigator.pop(context);
                                         },
                                       )
                                     ],
                                   );
                                 }

                             );
                           }

                         },

                       ),
                     ),

                     Text("See/Add",style: TextStyle(color: Colors.black),)
                   ],
                 ),
                 Column(
                   children: <Widget>[
                     Hero(
                       tag:"tes2",
                       child: GestureDetector(
                         child:  Container(
                           width: 150,
                           height: 150,
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,

                             image: DecorationImage(
                               fit: BoxFit.cover,
                               image:_editNotpad.img2 !=null?
                               FileImage(File(_editNotpad.img2)):
                               AssetImage("images/notepad.png"),
                             ),
                           ),
                         ),
                         onTap: (){
                           _requestCanOrGallery2();
                         },
                         onLongPress: (){



                           if(_editNotpad.img2 !=null){
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (context)=> PageImage2(widget.notpad.img2)));
                             print(widget.notpad.img2);
                           }else{
                             return showDialog(context: context,
                                 builder: (context){
                                   return AlertDialog(
                                     title: Text("Image N/A"),
                                     content: Text("Not found image"),
                                     actions: <Widget>[
                                       FlatButton(
                                         child: Text("Ok", style: TextStyle(fontSize: 20),),
                                         onPressed: (){
                                           Navigator.pop(context);
                                         },
                                       )
                                     ],
                                   );
                                 }

                             );
                           }

                         },
                       ),
                     ),

                     Text("See/Add",style: TextStyle(color: Colors.black),)
                   ],
                 ),

                ],
              ),

            )
        )
    );
}          //9
  static  List<Cor> _cors =  <Cor>[
     Cor(title: "Orange", cor: Colors.deepOrange),
     Cor(title: "Amber", cor: Colors.amber),
     Cor(title: "Yellow", cor: Colors.yellow),
     Cor(title: "LightGreen", cor: Colors.lightGreen),
     Cor(title: "Cyan", cor: Colors.cyan),
     Cor(title: "BlueGrey", cor: Colors.blueGrey),
     Cor(title: "Brown", cor: Colors.brown),
     Cor(title: "Grey", cor: Colors.grey),
  ];
  _requestCanOrGallery(){
    showModalBottomSheet(context: context,
        builder: (context){
          return BottomSheet(onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:  FlatButton(
                          child: Text("Gallery",
                            style: TextStyle(color: Colors.red, fontSize: 20),),
                          onPressed: (){
                            setState(() {
                              ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                                if(file==null)return;
                                setState(() {
                                  _editNotpad.img = file.path;
                                });
                              });
                            });

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:  FlatButton(
                          child: Text("Camera",
                            style: TextStyle(color: Colors.red, fontSize: 20),),
                          onPressed: (){
                            Navigator.pop(context);
                            ImagePicker.pickImage(source: ImageSource.camera).then((file){
                              if(file==null)return;
                              setState(() {
                                _editNotpad.img = file.path;
                              });

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
  _requestCanOrGallery1(){
    showModalBottomSheet(context: context,
        builder: (context){
          return BottomSheet(onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      Padding(
                        padding: EdgeInsets.all(10),
                        child:  FlatButton(
                          child: Text("Gallery",
                            style: TextStyle(color: Colors.red, fontSize: 20),),
                          onPressed: (){
                            setState(() {
                              ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                                if(file==null)return;
                                setState(() {
                                  _editNotpad.img1 = file.path;
                                });
                              });
                            });

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:  FlatButton(
                          child: Text("Camera",
                            style: TextStyle(color: Colors.red, fontSize: 20),),
                          onPressed: (){
                            Navigator.pop(context);
                            ImagePicker.pickImage(source: ImageSource.camera).then((file){
                              if(file==null)return;
                              setState(() {
                                _editNotpad.img1 = file.path;
                              });

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
  _requestCanOrGallery2(){
    showModalBottomSheet(context: context,
        builder: (context){
          return BottomSheet(onClosing: (){},
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:  FlatButton(
                          child: Text("Gallery",
                            style: TextStyle(color: Colors.red, fontSize: 20),),
                          onPressed: (){
                            setState(() {
                              ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                                if(file==null)return;
                                setState(() {
                                  _editNotpad.img2 = file.path;
                                });
                              });
                            });

                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:  FlatButton(
                          child: Text("Camera",
                            style: TextStyle(color: Colors.red, fontSize: 20),),
                          onPressed: (){
                            Navigator.pop(context);
                            ImagePicker.pickImage(source: ImageSource.camera).then((file){
                              if(file==null)return;
                              setState(() {
                                _editNotpad.img2 = file.path;
                              });

                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
  void _show(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            title: Text("Info"),
            content: Text(
              "For add image shot press and switch.\n"
                  "For See image long press new screen opened.",
              style: TextStyle(fontSize: 20),
            ),
          );
        });
  }

}
class Cor {
   Cor({this.index,this.title, this.cor});
   int index;
  final String title;
  final Color cor;
}
