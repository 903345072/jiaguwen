import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/Login.dart';
import 'package:flutterapp2/pages/cash.dart';
import 'package:flutterapp2/pages/cashlist.dart';
import 'package:flutterapp2/pages/editCard.dart';
import 'package:flutterapp2/pages/editPassword.dart';
import 'package:flutterapp2/pages/kefu.dart';
import 'package:flutterapp2/pages/orderlist.dart';
import 'package:flutterapp2/pages/recharge.dart';
import 'package:flutter/services.dart';
import 'package:flutterapp2/pages/shopInfo.dart';
import 'package:flutterapp2/utils/EventDioLog.dart';
import 'package:flutterapp2/utils/ImageCompressUtil.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'exchange.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutterapp2/utils/freshStyle.dart';



class Mine extends StatefulWidget {
  String _title;
  @override
  _Mine createState() => _Mine();
}

class _Mine extends State<Mine>  with SingleTickerProviderStateMixin ,AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final SystemUiOverlayStyle _style =
  SystemUiOverlayStyle(statusBarColor: Colors.transparent);

  Map user_info = {"nickname":"","award_amount":0.0,"has_bank":"0","now_money":0.0,"img_url":"http//www.baidu.com/img/flexible/logo/pc/result.png","zhongjiang":"0"};
  Map user_message_cate = {
    "account": "1000",
    "validContract": "12",
    "deposit": "12043.00"
  };

  File _image;
  String version = "";
  Future _openModalBottomSheet() async {
    final option = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200.0,
            child: Column(
              children: <Widget>[

                ListTile(

                  title: Text('??????',textAlign: TextAlign.center),
                  onTap: () async{
                    Navigator.pop(context);
                    var image = await ImagePicker.pickImage(source: ImageSource.camera);
                    var ss = await ImageCompressUtil().imageCompressAndGetFile(image);
                    setState(() {
                      _image = ss;
                    });
                    _upLoadImage(_image);
                  },
                ),
                ListTile(
                  title: Text('???????????????',textAlign: TextAlign.center),
                  onTap: () async {
                    Navigator.pop(context);
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
                    var ss = await ImageCompressUtil().imageCompressAndGetFile(image);
                    setState(() {
                      _image = ss;
                    });
                    _upLoadImage(_image);
                  },
                ),
                ListTile(
                  title: Text('??????',textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '??????');
                  },
                ),
              ],
            ),
          );
        }
    );


  }
  @override
  void initState() {
    super.initState();
    getUserInfo();
    getVersion();
  }
  GlobalKey<RefreshHeaderState> _headerKey = GlobalKey<RefreshHeaderState>();
  getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }
  getUserInfo() async{
    ResultData res = await HttpManager.getInstance().get("userInfo",withLoading: false);
    setState(() {
      if(res.data != null){
        user_info["nickname"] = res.data["nickname"];
        user_info["now_money"] = res.data["now_money"];
        user_info["has_bank"] = res.data["has_bank"];
        user_info["img_url"] = res.data["avatar"];
        user_info["zhongjiang"] = res.data["zhongjiang"];
        user_info["award_amount"] =res.data["award_amount"];
      }
    });
  }
  _upLoadImage(File image) async {



    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);

    // FormData formData = new FormData.fromMap({
    //   "file": new MultipartFile.fromFile (new File(path), name)
    // });

    FormData formdata = FormData.fromMap({
      "filename":name,
      "file":  base64Encode(image.readAsBytesSync())
    });
    ResultData res = await HttpManager.getInstance().post("user/edit_avatar",params: formdata,withLoading: false);
    if(res.code == 200){
      Toast.toast(context,msg:"????????????");
      setState(() {
        user_info["img_url"] = res.data["url"];
      });
    }else{
      Toast.toast(context,msg:"????????????");
    }

  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);
    SystemChrome.setSystemUIOverlayStyle(_style);
    return FlutterEasyLoading(
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: EasyRefresh(
              refreshHeader:MaterialHeader(key: _headerKey,

              ),
              onRefresh: () async {
                await new Future.delayed(const Duration(seconds: 1), () {
                  getUserInfo();
                });
              },
              child: Stack(
                children: <Widget>[
                  Positioned(
                    child: Container(
                      child: ClipRRect(
                        child: Image.asset(
                          "img/mineback.jpg",
                          fit: BoxFit.fill,
                          width: ScreenUtil.screenWidth,
                          height: 150,
                        ),
                      ),
                    ),
                  ),


                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        top: 40, left: 10, right: 10),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      children: <Widget>[
                        Container(
                          child: Container(
                            width: ScreenUtil().setWidth(390),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Wrap(
                                  spacing: 16,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    ClipOval(
                                        child: Image.network(
                                          user_info["img_url"],
                                          fit: BoxFit.fill,
                                          width: ScreenUtil().setWidth(60),
                                          height: ScreenUtil().setWidth(60),
                                        )),
                                    Text(
                                      user_info["nickname"],
                                      style: TextStyle(color: Colors.white,fontSize: 25),
                                    )
                                  ],
                                ),
                                IconButton(
                                  onPressed: () async{
//                            var image = await ImagePicker.pickImage(source: ImageSource.camera);
//                            print(image);
                                    _openModalBottomSheet();
                                  },
                                  icon: Icon(Icons.edit,color: Colors.white,),
                                )
                              ],
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(10)),
                          child: Wrap(
                            direction: Axis.vertical,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("??????",style: TextStyle(fontSize: 12),),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      user_info["now_money"].toStringAsFixed(2)+"???",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text("??????",style: TextStyle(fontSize: 12),),
                                  Container(
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      user_info["award_amount"].toStringAsFixed(2)+"???",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: ScreenUtil().setWidth(390),
                          color: Colors.white,
                          margin: EdgeInsets.only(
                              top: 15),
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  JumpAnimation().jump(recharge(), context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 2),

                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                      Image.asset("img/chongzhi.png",width: 35,),
                                      Text("??????")
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  JumpAnimation().jump(exchange(), context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 2),

                                  child: Wrap(

                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                      Icon(Icons.import_export),
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text("??????"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  ResultData res = await HttpManager.getInstance().get("userInfo",withLoading: false);

                                  if(res.data["has_bank"] == 0){
                                    Toast.toast(context,msg: "???????????????????????????");
                                    JumpAnimation().jump(editCard(), context);
                                    return;
                                  }
                                  JumpAnimation().jump(cash(), context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(bottom: 2),
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                      Image.asset("img/tixian.png",width: 35,),
                                      Text("??????")
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Colors.white),

                          width: ScreenUtil().setWidth(390),
                          padding: EdgeInsets.only(left: ScreenUtil().setWidth(20),right: ScreenUtil().setWidth(40),top: 20,bottom: 10),
                          margin: EdgeInsets.only(top: 5),
                          child:  Wrap(
                            spacing: 20,
                            direction: Axis.vertical,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child:  GestureDetector(
                                  onTap: (){
//                            Router.navigatorKey.currentState.pushNamedAndRemoveUntil("/editCard",
//                                ModalRoute.withName("/"));
                                    JumpAnimation().jump(editCard(), context);
                                  },
                                  child: Wrap(
                                    spacing: 15,
                                    children: <Widget>[
                                      Icon(const IconData(0xe603,fontFamily: "iconfont"),size: 17,),
                                      Text("????????????"),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: GestureDetector(
                                  onTap: (){
                                    JumpAnimation().jump(orderlist(), context);
                                  },
                                  child: Wrap(
                                    spacing: 15,
                                    children: <Widget>[
                                      Icon(const IconData(0xe60a,fontFamily: "iconfont"),color: Colors.red,size: 17,),
                                      Text("????????????"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: GestureDetector(
                                  onTap: (){
                                    JumpAnimation().jump(cashlist(), context);
                                  },
                                  child: Wrap(
                                    spacing: 15,
                                    children: <Widget>[
                                      Icon(const IconData(0xe607,fontFamily: "iconfont"),color: Colors.deepOrange,size: 15,),
                                      Text("????????????"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5,),
                                child: GestureDetector(
                                  onTap: (){
                                    JumpAnimation().jump(editPassword(), context);
                                  },
                                  child: Wrap(
                                    spacing: 15,
                                    children: <Widget>[
                                      Icon(const IconData(0xe605,fontFamily: "iconfont"),size: 17,),
                                      Text("????????????"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5,),
                                child: GestureDetector(
                                  onTap: (){
                                    JumpAnimation().jump(shopInfo(), context);
                                  },
                                  child: Wrap(
                                    spacing: 15,
                                    children: <Widget>[
                                      Icon(Icons.shopping_cart,size: 17,),
                                      Text("????????????"),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 5),
                                child: GestureDetector(
                                  onTap: () async {

                                    ResultData result = await HttpManager.getInstance().get(
                                        "logout",withLoading: false);
                                    if(result.code == 200){
                                      TokenStore().clearToken("token");
                                      TokenStore().clearToken("is_login");
                                      JumpAnimation().jump(Login(), context);
                                    }
                                  },
                                  child: Wrap(
                                    spacing: 15,
                                    children: <Widget>[
                                      Icon(const IconData(0xe604,fontFamily: "iconfont"),size: 18,),
                                      Text("????????????"),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Container(
                            child: GestureDetector(
                              onTap: (){
                                Future res = Clipboard.setData(ClipboardData(text: '5392548'));
                                res.whenComplete(() =>Toast.toast(context,msg: "????????????"));
                              },
                              child: Container(
                                child:Image.asset("img/kefu.jpg",fit: BoxFit.fill,width: 310,height: 75,),
                              ),
                            ),
                          ),
                        ),
                        Container(

                          child: Wrap(

                            spacing: 11,
                            crossAxisAlignment:WrapCrossAlignment.center,
                            children: <Widget>[
                              Text("????????????:",style: TextStyle(color: Colors.grey,fontSize: 12),),
                              Text("v"+version,style: TextStyle(color: Colors.grey,fontSize: 12)),

                            ],
                          ),
                        )



                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
