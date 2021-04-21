import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/applyDaShen.dart';
import 'package:flutterapp2/pages/article.dart';
import 'package:flutterapp2/pages/lanqiukaijiang.dart';
import 'package:flutterapp2/pages/zuqiukaijiang.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/wiget/CommonWiget.dart';
import 'package:marquee_flutter/marquee_flutter.dart';

import 'basketball.dart';
import 'football.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPage createState() => _IndexPage();
}

class _IndexPage extends State<IndexPage> with AutomaticKeepAliveClientMixin {
  ScrollController _controller;
  Timer _timer;
  double _offset = 0.0;

  List newsContainer ;
  List news;
  List zhongjiang = [];
  void initState() {
    super.initState();
    news = [];
    newsContainer= [];
    loadNews();
  }
  loadNews() async {
   ResultData res = await HttpManager.getInstance().get("news",withLoading: false);
   ResultData res1 = await HttpManager.getInstance().get("zhongjiang",withLoading: false);

   setState(() {
     news = res.data["news"];
     zhongjiang = res1.data["data"];
   });
  }
  List getNews(){
    if(news != null){
      return news.asMap().keys.map((e){
        return GestureDetector(
          onTap: (){
            JumpAnimation().jump(article(id: news[e]["id"],index: e+1,), context);
          },
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),

                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.network(news[e]["img"],fit: BoxFit.fill,width: ScreenUtil().setWidth(130),height: ScreenUtil().setHeight(76),),
                        Wrap(
                          spacing: 13,
                          direction: Axis.vertical,
                          children: <Widget>[
                            Container(
                              width:ScreenUtil().setWidth(232),
                              child: Text(news[e]["title"],maxLines: 1,
                                overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                            Text(news[e]["date"])
                          ],
                        )
                      ],
                    ),

                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      }).toList();
    }else{
      List<Widget> list = [];
      list.add(Text("暂无数据"));
      return list;
    }
  }


  final SystemUiOverlayStyle _style =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);

  @override
  bool get wantKeepAlive => true;
  List img_url = [
    "img/s1.jpg",
    "img/swi1.jpg",

  ];
  List texts = [
    {"name": "上证指数", "value": "2268.1 2.1%"},
    {"name": "深圳成指", "value": "5123.3 24.1%"}
  ];
  double appBarAlpha = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(_style);
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);
    return Scaffold(
        appBar: PreferredSize(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xfffa2020),
              ),
              child: Center(
                child: SafeArea(
                  child: Text(
                    "老九门",
                    style: TextStyle(
                        color: Colors.white, fontSize: ScreenUtil().setSp(20)),
                  ),
                ),
              ),
            ),
            preferredSize: Size(double.infinity, ScreenUtil().setHeight(60))),
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: ListView(
            children: <Widget>[
              Container(
                height: ScreenUtil().setHeight(175),
                child: Swiper(
                  itemCount: img_url.length,
                  autoplay: true,
                  itemBuilder: (BuildContext context, int index) {
                    return index !=3?Image.asset(
                      img_url[index],
                      fit: BoxFit.fill,
                    ):GestureDetector(
                      onTap: (){
                        JumpAnimation().jump(applyDaShen(), context);
                      },
                      child: Image.asset(
                        img_url[index],
                        fit: BoxFit.fill,
                      ),
                    );
                  },
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(right: 15),
                      builder: DotSwiperPaginationBuilder(
                          color: Color.fromRGBO(200, 200, 200, 0.5),
                          size: 8.0,
                          activeSize: 5.0)),
                ),
              ),
              Container(

                padding: EdgeInsets.all(2),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(color: Color(0xffebebeb)),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.notifications,color: Colors.orange,),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      width: ScreenUtil().setWidth(350),
                      height: ScreenUtil().setHeight(35),
                      child: Swiper(
                        itemCount: zhongjiang.length,
                        scrollDirection: Axis.vertical,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text("恭喜 ",style: TextStyle(color: Color(0xff575757)),),
                                Text(zhongjiang[index]["nickname"]+" ",style: TextStyle(color: Color(0xff575757))),
                                Text("喜中",style: TextStyle(color: Color(0xff575757))),
                                zhongjiang[index]["type"] =="f"? Text("竞彩足球",style: TextStyle(color: Color(0xff575757))):Text("竞彩篮球",style: TextStyle(color: Color(0xff575757))),
                                Text(zhongjiang[index]["award_money"].toString(),style: TextStyle(color: Colors.red),),
                                Text("元",style: TextStyle(color: Color(0xff575757)))
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: ScreenUtil().setHeight(45),
                margin: EdgeInsets.only(top: 2),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 15),
                      height: ScreenUtil().setHeight(25),
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(width: 3, color: Colors.red))),
                    ),
                    Text("热门彩票")
                  ],
                ),
              ),

              Divider(
                height: 7,
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Ink(

                      child: InkWell(

                        splashColor: Colors.black26,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadiusDirectional.circular(16)),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                "img/football.png",
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(55),
                                height: ScreenUtil().setWidth(55),
                              ),
                            ),

                          Container(
                                height: ScreenUtil().setWidth(55),
                                child: Wrap(
                                  direction: Axis.vertical,
                                  alignment: WrapAlignment.spaceAround,
                                  children: <Widget>[Text("竞彩足球"), Text("五大联赛",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(12)))],
                                ),
                              ),

                          ],
                        ),
                        onTap: () {
                          JumpAnimation().jump(football(), context);
                        },
                      ),
                    ),
                    Ink(
                      child: InkWell(
                        splashColor: Colors.black26,
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadiusDirectional.circular(16)),
                              clipBehavior: Clip.antiAlias,
                              child: Image.asset(
                                "img/basketball.png",
                                fit: BoxFit.fill,
                                width: ScreenUtil().setWidth(55),
                                height: ScreenUtil().setWidth(55),
                              ),
                            ),
                            Container(
                              height: ScreenUtil().setWidth(55),
                              child: Wrap(
                                direction: Axis.vertical,
                                alignment: WrapAlignment.spaceAround,
                                children: <Widget>[Text("竞彩篮球"), Text("美职女篮开赛",style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(12)),)],
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          JumpAnimation().jump(basketball(), context);
                        },
                      ),
                    )
                  ],
                ),
              ),
              CommonWiget().getTaiTou("比分"),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: (){
                        JumpAnimation().jump(zuqiukaijiang(), context);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadiusDirectional.circular(5)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          "img/swiper3.jpg",
                          fit: BoxFit.fill,
                          width: ScreenUtil().setWidth(180),
                          height: ScreenUtil().setHeight(105),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        JumpAnimation().jump(lanqiukaijiang(), context);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadiusDirectional.circular(5)),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          "img/swiper2.jpg",
                          fit: BoxFit.fill,
                          width: ScreenUtil().setWidth(180),
                          height: ScreenUtil().setHeight(105),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              CommonWiget().getTaiTou("资讯"),
              Column(
                children: getNews(),
              )
            ],
          ),
        ));
  }
  getZhongJiang(){
    String str = "";
    String type = "";
    zhongjiang.forEach((element) {
      if(element["type"] == "f"){
        type = "竞彩足球";
      }else{
        type = "竞彩篮球";
      }
      str+= "恭喜 " +element["nickname"]+" "+"喜中"+type+element["award_money"].toString()+"元";
      str += "                      ";
    });
    return str;
  }
}
