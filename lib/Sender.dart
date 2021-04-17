import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/Address.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/IndexPage.dart';
import 'package:flutterapp2/pages/Mine.dart';
import 'package:flutterapp2/pages/flowdetail.dart';
import 'package:flutterapp2/pages/orderdetail.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Sender extends StatefulWidget {
  int uid;
  Sender({this.uid});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<Sender> {

 String img = "http://kaifa.crmeb.net/uploads/attach/2019/08/20190807/723adbdd4e49a0f9394dfc700ab5dba3.png";
 String nickname = "--";
 String target = "1";
 String sl = "0";
 List data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSender();
  }

  getSender() async {
    ResultData res = await HttpManager.getInstance().get("getSender",params: {"uid":widget.uid},withLoading: false);

   setState(() {
     data = res.data["data"];
     sl = res.data["sl"].toString();
     target = res.data["target"].toString();
     img = res.data["avatar"];
     nickname = res.data["nickname"];
   });

  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    // TODO: implement build
    return MediaQuery.removePadding(removeTop: true,context:context,child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[

          Positioned(
            child: Container(
              width: double.infinity,
              height: 200,
              child: Stack(
                children: <Widget>[
                  Image.asset("img/senderbg.jpg",fit: BoxFit.fill,width: double.infinity,),

                  Container(
                    alignment: Alignment.center,
                    child: Wrap(
                       spacing: 8,
                       crossAxisAlignment: WrapCrossAlignment.center,
                      direction: Axis.vertical,
                      children: <Widget>[
                        ClipOval(
                            child: Image.network(
                              img,
                              fit: BoxFit.fill,
                              width: ScreenUtil().setWidth(75),
                              height: ScreenUtil().setWidth(75),
                            )),
                        Text(nickname),
                        Row(
                          children: <Widget>[
                            Container(
                              width: ScreenUtil().setWidth(120),
                              padding: EdgeInsets.only(top: 3,bottom: 3),
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
                              child: Wrap(
                                spacing: 5,
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  Text("近七单",style: TextStyle(fontSize: 10),),
                                  Text("7投"+target+"中",style: TextStyle(color: Colors.red),)
                                ],
                              ),
                            ),
                            Container(
                              width: ScreenUtil().setWidth(120),
                              padding: EdgeInsets.only(top: 5,bottom: 5),
                              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
                              margin: EdgeInsets.only(left: 10),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 5,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  Text("胜率",style: TextStyle(fontSize: 10),),
                                  Text(sl.toString()+"%",style: TextStyle(color: Colors.red),)
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top: 30,left: 15),
                      child: const Icon(Icons.arrow_back_ios,color: Colors.white,size: 30,),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 200),
            child: ListView(
              children: getList(),
            ),
          )
        ],
      ),
    ),);
  }
  List<Container> getList(){
    return data.asMap().keys.map((e){
      return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 10,color: Color(0xfff5f5f5)))),

        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data[e]["date"].toString()+"   发起方案"),
                  Text(data[e]["plan_title"].toString()!=""?data[e]["plan_title"].toString():"跟我一起中大奖"),
                ],
              ),
            ),
            Container(

              margin: EdgeInsets.only(top: 5,left: 5,right: 5),
              decoration: BoxDecoration(border: Border.all(width: 0.4,color: Colors.grey),borderRadius: BorderRadius.all(Radius.circular(10))),
              child:  Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(border: Border(right: BorderSide(width: 0.4,color: Colors.grey))),

                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 5,top: 5,right: 5),
                          margin: EdgeInsets.only(bottom: 5),
                          decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 0.4,color: Colors.grey)) ),

                          width: ScreenUtil().setWidth(310),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(30),),
                                child: Text("类型"),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(70),),
                                child: Text("自购金额"),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: ScreenUtil().setWidth(40),),
                                child: Text("单倍金额"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 5),
                          width: ScreenUtil().setWidth(280),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(data[e]["type"]=="f"?"竞彩足球":"竞彩篮球"),
                              Text(data[e]["amount"]),
                              Text((data[e]["num"]*2).toString()),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    alignment: Alignment.center,
                    width: ScreenUtil().setWidth(80),
                    child: data[e]["state"] == 0? RaisedButton(
                      color: Colors.deepOrange,
                      onPressed: () {
                        JumpAnimation().jump(flowdetail(data[e]), context);
                      },
                      child: Text('跟单',style: TextStyle(fontSize: 12.0,color: Colors.white),),
                      ///圆角
                      shape: RoundedRectangleBorder(
                          side: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                    ):data[e]["state"] == 2?GestureDetector(
                      onTap: (){
                        JumpAnimation().jump(orderdetail(data[e]["id"],int.parse(data[e]["mode"]),data[e]["type"]), context);
                      },
                      child: Text(data[e]["money"].toString()+"元",style: TextStyle(color: Colors.red),),
                    ):GestureDetector(
                      onTap: (){
                        JumpAnimation().jump(orderdetail(data[e]["id"],int.parse(data[e]["mode"]),data[e]["type"]), context);
                      },
                      child: Text("0.00元"),
                    )
                    ,
                  )
                ],
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}
