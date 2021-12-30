import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/pages/IndexPage.dart';
import 'package:flutterapp2/pages/config/config.dart';
import 'package:flutterapp2/utils/EventDioLog.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:flutterapp2/utils/checkMethod.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/wiget/beijing/bbf.dart';
import 'package:flutterapp2/wiget/beijing/bonup.dart';
import 'package:flutterapp2/wiget/beijing/bqc.dart';
import 'package:flutterapp2/wiget/beijing/bsf.dart';
import 'package:flutterapp2/wiget/beijing/bspf.dart';
import 'package:flutterapp2/wiget/beijing/bttg.dart';
import 'package:flutterapp2/wiget/football/banquanchang.dart';
import 'package:flutterapp2/wiget/football/bifen.dart';
import 'package:flutterapp2/wiget/football/feirangqiu.dart';
import 'package:flutterapp2/wiget/football/mix.dart';
import 'package:flutterapp2/wiget/football/rangqiu.dart';
import 'package:flutterapp2/wiget/football/zongjinqiu.dart';

import 'IndexBack.dart';
import 'beijingorder.dart';
import 'order.dart';
class beijing extends StatefulWidget {
  @override
  _GZXDropDownMenuTestPageState createState() =>
      _GZXDropDownMenuTestPageState();
}
class _GZXDropDownMenuTestPageState extends State<beijing> {
  Future _future;
  List game_ids = [];
  Map num_to_cn = {"1":"一","2":"二","3":"三","4":"四","5":"五","6":"六","7":"末"};
  Map games = {};
  List game_mid_list = [];
  int least_game = 1;
  List lsl = [{"color":Colors.red}];
  List frqspf_ = [{"text":"主胜","color":Color(0xfffff5f8)},{"text":"平","color":Color(0xfffff5f8)},{"text":"主负","color":Color(0xfffff5f8)}];
  List methods = [
    {"name": "胜平负","least_game":1},
    {"name": "总进球数","least_game":1},
    {"name": "半全场胜平负","least_game":1},
    {"name": "上下盘单双数","least_game":1},
    {"name": "单场比分","least_game":1},
  ];
  bool withLoading = false;
  int index = 0;
  Icon cur_icon = Icon(
    Icons.arrow_drop_down,
    color: Colors.white,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _future = getGames();
  }

  Future getGames() async {
   ResultData res = await HttpManager.getInstance().get("beijing_game",params: {"type":index+1},withLoading: withLoading);
   setState(() {

       if(res.data["count"] > 0){
         games = res.data["games"];
       }else{
         games = {};
         Toast.toast(context,msg: "暂无对阵信息");
       }



   });
  }
  List getMethods() {
    return methods.asMap().keys.map((e) {
      Border cur_border;
      Color color;
      if (e == index) {
        cur_border = Border.all(width: 2, color: Colors.red);
        color= Colors.red;
      } else {
        cur_border = null;
        color= Colors.white;
      }
      return GestureDetector(
          onTap: () {
            if(e < methods.length){
              setState(() {
                index = e;
                least_game = methods[e]["least_game"];
                withLoading = true;
                Navigator.pop(context);
              });

                getGames();

            }


          },
          child: Container(
            decoration: BoxDecoration(color: color),
            alignment: Alignment.center,
            width: ScreenUtil().setWidth(120),
            height: ScreenUtil().setHeight(50),
            child: Text(
              methods[e]["name"],
              style: TextStyle(fontSize: ScreenUtil().setSp(16)),
            ),
          ));
    }).toList();
  }

  List getGameList(){

   return games.keys.map((e){
     String date = e;


     List list_game =  games[e];
      return Container(
        decoration: BoxDecoration(color: Colors.white,border: Border(bottom: BorderSide(width: 0.3,color: Colors.grey))),
        child: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: ExpansionTile(
              title: Text(date+" "+list_game.length.toString()+"场比赛可投"),
              children: <Widget>[
                Container(
                  decoration: BoxDecoration( color: Color(0xfffff5f8)),
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.only(
                     right: 15,  bottom: 10),
                    child: Column(

                        children: getGameList_(list_game,e),
                    ),
                  ),
                )
              ],
            )),
      );
    }).toList();
  }
  List getGameList_(List list_game_,e2){

    return list_game_.asMap().keys.map((e){

      String hour_time = list_game_[e]["dtime"].toString().substring(11,16);
      String ls_name = list_game_[e]["l_cn"];
      String game_no = list_game_[e]["game_no"].toString();
      String qh = list_game_[e]["game_no"].toString();
      String zd_name = list_game_[e]["h_cn"];
      String kd_name = list_game_[e]["a_cn"];
      String p_goal  = list_game_[e]["p_goal"].toString();
      List ttg_odds = list_game_[e]["ttg_odds"].toString().split(",");//总进球赔率
      List onup = list_game_[e]["on_up"].toString().split(",");//总进球赔率
      List half_odds = list_game_[e]["hafu_odds"].toString().split(",");//半全场赔率
      List spf = list_game_[e]["had_odds"].toString().split(",");//非让球赔率
      List sf = list_game_[e]["hhad_odds"].toString().split(",");//让球赔率
      List crs_win = list_game_[e]["crs_win"].toString().split(","); //胜比分赔率
      List crs_draw = list_game_[e]["crs_draw"].toString().split(","); //平比分赔率
      List crs_lose = list_game_[e]["crs_lose"].toString().split(","); //负比分赔率

      crs_draw.forEach((element) {
        crs_win.add(element);
      });
      crs_lose.forEach((element) {
        crs_win.add(element);
      });
     Border border;
     double bot;
     if(list_game_.length>1){
       border =  Border(bottom: BorderSide(width: 0.2,color: Colors.grey));
       bot =15;
     }else{
       border = null;
       bot =0;
     }
     if(e == list_game_.length-1){
       bot = 0;
       border = null;
     }
      return Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(bottom: bot,left: 3),
            decoration: BoxDecoration(
                border: border
            ),
            margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Wrap(
                  spacing: 3,
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(ls_name,style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(14)),),
                    Text(qh,style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(14)),),
                    Text(hour_time,style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(14)),),
                  ],
                ),
                //比赛组件
                getComponent(["1","1","1","1"],p_goal,games,e2,e,zd_name,kd_name,spf,sf,crs_win,ttg_odds,half_odds,onup)
                //比赛组件
              ],
            ),
          )
        ],
      );
    }).toList();
  }
getComponent(p_status,p_goal,games,e2,e,zd_name,kd_name,spf,sf,crs_win,ttg_odds,half_odds,onup){

    switch(index){
      case 0:
        return bspf(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,p_goal:p_goal,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,spf: spf
        );
      case 1:
        return bttg(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,ttg_odds: ttg_odds,
        );
      case 2:
        return bqc(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,half_odds: half_odds,
        );
      case 3:
        return bonup(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,ttg_odds: onup,
        );
      case 4:
        return bbf(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,crs_win: crs_win,
        );
      case 6:
        return feirangqiu(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,p_goal:p_goal,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,spf: spf
        );
      case 7:
        return rangqiu(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,p_goal:p_goal,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,rqspf: sf
        );
      case 8:
        return zongjinqiu(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,ttg_odds: ttg_odds,
        );
      case 9:
        return bifen(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,crs_win: crs_win,
        );
      case 10:
        return banquanchang(callBack: (value) {
          setState(() {
            games = value;
          });
        },p_status:p_status,games: games,e2: e2,e: e,zd_name: zd_name,kd_name: kd_name,half_odds: half_odds,
        );
    }



}
  getGameNum(){
    game_ids = [];
    games.forEach((key, value) {
        List ls  = value;
        ls.forEach((element) {
        List e2 = element["check_info"];
        e2.forEach((element1) {
          List e3 = element1["bet_way"];
          e3.forEach((element2) {
            if(element2["color"] != "co"){
              if(!game_ids.contains(element["id"])){
                game_ids.add(element["id"]);
              }
            }
          });
        });
      });
    });
    return game_ids.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    return FlutterEasyLoading(
      child: Scaffold(

        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          iconTheme: IconThemeData(
            size: 22.0,
            color: Colors.white, //修改颜色
          ),
          backgroundColor: Color(0xfffa2020),
          title: GestureDetector(
            onTap: () {
              showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Material(
                            child: Container(
                              margin: EdgeInsets.only(top: 25),
                              color: Colors.white,
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                children: getMethods(),
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  methods[index]["name"],
                  style: TextStyle(fontSize: ScreenUtil().setSp(16)),
                ),
                cur_icon
              ],
            ),
          ),
        ),
        backgroundColor: Color(0xfff5f5f5),
        body: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeLeft: true,
            removeRight: true,
            child:

            FutureBuilder(
                future: _future,
                builder: (context, snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return  Center(child: CircularProgressIndicator());

                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Center(
                          child: Text('网络请求出错'),
                        );
                      }
                      return Stack(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: ScreenUtil().setHeight(60)),
                                  child: ListView(
                                    children: getGameList(),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.white,
                              height: ScreenUtil().setHeight(60),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {

                                        games.forEach((key, value) {
                                          List ls  = value;
                                          ls.forEach((element) {
                                            List e2 = element["check_info"];

                                            element["checks"] = '{}';
                                            e2.forEach((element1) {
                                              List e3 = element1["bet_way"];
                                              e3.forEach((element2) {

                                                element2["color"] = "co";
                                              });
                                            });
                                          });
                                        });
                                      });

                                    },
                                    child: Container(
                                      decoration: BoxDecoration(border: Border(right: BorderSide(color: Color(0xfff2f2f2),width: 0.5))),
                                      alignment: Alignment.center,
                                      width: ScreenUtil().setWidth(90),
                                      child: Text("清空"),
                                    ),
                                  ),
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    direction: Axis.vertical,
                                    children: <Widget>[
                                      Text("已选择"+ getGameNum() +"场",style: TextStyle(color: Colors.red),),
                                      //Text("至少选择"+ least_game.toString()+"场比赛")
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: (){

                                    if(int.parse(getGameNum())< least_game){
                                        Toast.toast(context,msg: "请至少选择"+least_game.toString()+"比赛");
                                        return;
                                      }
                                  //一场比赛选了spf、rqspf
                                      JumpAnimation().jump(beijingorder(games,game_ids,(value){
                                        setState(() {
                                          games = value;
                                        });
                                      },index,methods[index]["least_game"],"bd"), context);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: ScreenUtil().setHeight(60),
                                      decoration: BoxDecoration(color:Colors.red,border: Border(left: BorderSide(color: Color(0xfff2f2f2),width: 1))),
                                      width: ScreenUtil().setWidth(90),
                                      child: Text("选好了",style: TextStyle(color: Colors.white),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                  }
                  return null;
                }
            )


        ),
      ),
    );
  }
}

class MySeparator extends StatelessWidget {
  final double height;
  final Color color;

  const MySeparator({this.height = 1, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashWidth = 4.0;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
