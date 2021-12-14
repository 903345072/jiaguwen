import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';

class shopInfo extends StatefulWidget{
  @override
  _shopInfo createState() => _shopInfo();
}
class _shopInfo extends State<shopInfo>{
  String cp_name = "";
  String cp_time = "";
  String cp_pic = "";
  String cp_address ="";
  String cp_qq ="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }
  getUserInfo() async{
    ResultData res = await HttpManager.getInstance().get("userInfo",withLoading: false);
    setState(() {
      if(res.data != null){
        cp_name = res.data["cp_name"];
        cp_time = res.data["cp_time"];
        cp_pic= res.data["cp_pic"];
        cp_address = res.data["cp_address"];
        cp_qq = res.data["cp_qq"];
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(

        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(
          size: 25.0,
          color: Colors.white, //修改颜色
        ),
        backgroundColor: Color(0xfffa2020),
        title: Text("店铺信息",style: TextStyle(fontSize: 15),),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              runSpacing: 5,
              children: <Widget>[
                Container(
                  child: Text("基础信息"),
                ),
                Divider(),
                Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: <Widget>[
                      Text("店主名"),
                      Text(cp_name)
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Wrap(
                    spacing: 20,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text("客服QQ"),
                      Text(cp_qq)
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: <Widget>[
                      Text("所在地"),
                      Text(cp_address)
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: <Widget>[
                      Text("开店时间"),
                      Text(cp_time)
                    ],
                  ),
                ),
                Divider(),
                Container(
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 20,
                    children: <Widget>[
                      Text("代销证图片"),
                      Image.network(cp_pic,fit: BoxFit.fill,width: 180,)
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }

}