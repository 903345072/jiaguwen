import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutterapp2/SharedPreferences/TokenStore.dart';
import 'package:flutterapp2/net/Address.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/IndexBack.dart';
import 'package:flutterapp2/pages/IndexPage.dart';
import 'package:flutterapp2/pages/Mine.dart';
import 'package:flutterapp2/pages/flowUsers.dart';
import 'package:flutterapp2/pages/order.dart';
import 'package:flutterapp2/utils/EventDioLog.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Rute.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../main.dart';

class flowdetail extends StatefulWidget {
  Map data;
  flowdetail(this.data);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Login_();
  }
}

class Login_ extends State<flowdetail> {
  String old_pwd;
  String new_pwd;
  String re_pwd;
  bool check = false;
  int num = 1;
  FocusNode _commentFocus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commentFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    // TODO: implement build
    return FlutterEasyLoading(
      child: Scaffold(


        appBar: AppBar(

          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            size: 20.0,
            color: Colors.white, //修改颜色
          ),
          backgroundColor: Color(0xfffa2020),
          title: Text("方案详情",style: TextStyle(fontSize: ScreenUtil().setSp(18)),),
        ),
        backgroundColor:  Color(0xfff5f5f5),
        body:  Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(color:Colors.white,border: Border(bottom: BorderSide(width: 10,color: Color(0xfff5f5f5)))),
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadiusDirectional.circular(16)),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            widget.data["type"]=="f"?"img/football.png":"img/basketball.png",
                            fit: BoxFit.fill,
                            width: ScreenUtil().setWidth(60),
                            height: ScreenUtil().setWidth(60),
                          ),
                        ),
                        Wrap(
                          spacing: 5,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text(widget.data["nickname"],style: TextStyle(fontWeight: FontWeight.bold),),
                            Text("自购金额"),
                            Text(widget.data["amount"]+".0元",style: TextStyle(fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: <Widget>[
                            Text("起跟金额"),
                            Text((widget.data["start_money"]).toString()+"元",style: TextStyle(fontWeight: FontWeight.bold),)
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(color:Colors.white,border: Border(bottom: BorderSide(width: 10,color: Color(0xfff5f5f5)))),

                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 5,top: 5),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.mode_edit,color: Colors.grey,),
                              Text("方案信息")
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("彩种:",style: TextStyle(letterSpacing: 8),),
                              ),
                              Text(widget.data["type"]=="f"?"竞彩足球":"竞彩篮球",style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("跟单信息:"),
                              ),
                              Text("共"+widget.data["all_amount"].toString()+"元",style: TextStyle(color: Colors.grey),),
                              GestureDetector(
                                onTap: (){
                                  JumpAnimation().jump(flowUsers(order_id: widget.data["id"],), context);
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(120)),
                                  decoration: BoxDecoration(color: Colors.red),
                                  child: Text("跟单列表",style: TextStyle(color: Colors.white),),
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("状态:",style: TextStyle(letterSpacing: 8),),
                              ),
                              Text("招募中(开赛后可查看投注详情)",style: TextStyle(color: Colors.red),)
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  Container(

                    decoration: BoxDecoration(color:Colors.white,border: Border(bottom: BorderSide(width: 5,color: Color(0xfff5f5f5)))),

                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 5,top: 3),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.book,color: Colors.grey,),
                              Text("投注内容")
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(


                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("过关方式:"),
                              ),
                              Text(widget.data["chuan"]!=""?widget.data["chuan"]+"串1":"单关",style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("下单时间:"),
                              ),
                              Text(widget.data["order_time"].toString(),style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("标题:",style: TextStyle(letterSpacing: 8),),
                              ),
                              Text("(无标题)",style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          margin: EdgeInsets.only(left: 30,top: 3,bottom: 5),
                          child: Row(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                child: Text("描述:",style: TextStyle(letterSpacing: 8),),
                              ),
                              Text("跟我一起中大奖",style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        alignment: Alignment.center,
                        height: ScreenUtil().setHeight(70),
                        child: Row(
                          children: <Widget>[
                            Text("购买"),
                            Container(
                              width: ScreenUtil().setWidth(70),
                              height: ScreenUtil().setHeight(38),
                              margin: EdgeInsets.only(left: 15, right: 15),

                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TextField(
                                      //限制2长度],//只允许输入数字
                                      onChanged: (e) {
                                        setState(() {
                                          num = int.parse(e) ;
                                        });
                                      },
                                      controller: TextEditingController.fromValue(
                                          TextEditingValue(
                                              text:
                                              '${this.num == null ? "" : this.num}',
                                              selection: TextSelection.fromPosition(
                                                  TextPosition(
                                                      affinity: TextAffinity.downstream,
                                                      offset: '${this.num}'.length)))),
                                      keyboardType: TextInputType.number,
                                      //键盘类型，数字键盘

                                      decoration: InputDecoration(

                                        contentPadding: EdgeInsets.only(left: 10),
                                        hintText: "",
                                        border: OutlineInputBorder(),

                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 15),
                              child: Text("倍"),
                            ),
                            Text((num*widget.data["start_money"]).toString()+"元",style: TextStyle(color: Colors.red),),

                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          EventDioLog("提示","确认付款",context,() async {
                            ResultData res = await HttpManager.getInstance().post("doFlowOrder",params:{"id":widget.data["id"],"num":num,});
                            if(res.data["code"] == 200){
                              Toast.toast(context,msg: "付款成功");
                              JumpAnimation().jump(IndexBack(), context);
                            }else{
                              Toast.toast(context,msg: res.data["msg"]);
                              return;
                            }
                          }).showDioLog();

                        },
                        child: Container(
                          width: ScreenUtil().setWidth(100),
                          alignment: Alignment.center,
                          height: ScreenUtil().setHeight(70),
                          color: Colors.red,
                          child: Text("付款",style: TextStyle(color: Colors.white),),
                        ),
                      ),



                    ],
                  ),
                ),
              )
            ],
          ),

      ),
    );
  }
}
