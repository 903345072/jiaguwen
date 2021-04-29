import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/wiget/IconInput.dart';

import '../Sender.dart';

class search extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return search_();
  }
}

class search_ extends State<search> {
  List hot = [];
  Map<String, Object> idCard =  {
    "value": "",
    "title": "请输入用户名1",
    "tip": "请输入用户名 如: 张顺飞",
    "icon": Icon(Icons.search, color: Colors.grey),
    "is_edit": false,
    "type":null
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadinfo();
  }
  loadinfo() async{
    ResultData result = await HttpManager.getInstance()
        .get("hot_search",params: {"name":idCard["value"]}, withLoading: false);
    if(result.data["data"] != null){
      setState(() {
        hot = result.data["data"];
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
             Container(

               padding: EdgeInsets.only(bottom: 10),
               child:  Row(
                 crossAxisAlignment: CrossAxisAlignment.center,

                 children: <Widget>[
                   GestureDetector(
                     onTap: (){
                       Navigator.pop(context);
                     },
                     child: Container(
                       margin: EdgeInsets.only(top: 15),
                       child: Icon(Icons.arrow_back_ios),
                     ),
                   ),
                   Expanded(
                     child: IconInput(
                       data: idCard,
                       callBack: (value) {
                         setState(() {
                           idCard["value"] = value;
                           loadinfo();
                         });
                       },
                     ),
                   ),
                   GestureDetector(
                     onTap: (){
                       setState(() {
                         idCard["value"] = "";
                         loadinfo();
                       });
                     },
                     child: Container(
                       margin: EdgeInsets.only(top: 15),
                       child: GestureDetector(
                         child: Icon(Icons.close),
                       ),
                     ),
                   )
                 ],
               ),
             ),
              Container(
                padding: EdgeInsets.only(top: 15,left: 15),
                width: double.infinity,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("热搜推荐",style: TextStyle(color: Colors.red),),
                    Container(
                      margin: EdgeInsets.only(top: 15),
                      child: Wrap(
                        children: hot.asMap().keys.map((e){
                          return GestureDetector(
                            onTap: () async {
                              JumpAnimation().jump(Sender(uid: hot[e]["uid"],), context);
                              //热搜加1
                              ResultData result = await HttpManager.getInstance()
                                  .get("add_hot",params: {"uid":hot[e]["uid"]}, withLoading: false);
                              loadinfo();
                            },
                            child: Container(
                              padding: EdgeInsets.only(right: 5),
                              width: 500,
                              height: 75,
                              child: Card(

                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(left: 10,right: 15),
                                      child: ClipOval(

                                          child: Image.network(

                                            hot[e]["avatar"],
                                            fit: BoxFit.fill,
                                            width: ScreenUtil().setWidth(55),
                                            height: ScreenUtil().setWidth(55),
                                          )),
                                    ),
                                    Text(hot[e]["real_name"]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
  
}

