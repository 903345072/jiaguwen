import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterapp2/net/HttpManager.dart';
import 'package:flutterapp2/net/ResultData.dart';
import 'package:flutterapp2/pages/applyDaShen.dart';
import 'package:flutterapp2/pages/awardOptimize.dart';
import 'package:flutterapp2/pages/sendOrder.dart';
import 'package:flutterapp2/pages/success.dart';
import 'package:flutterapp2/utils/EventDioLog.dart';
import 'package:flutterapp2/utils/JumpAnimation.dart';
import 'package:flutterapp2/utils/Toast.dart';
import 'package:flutterapp2/utils/model.dart';
import 'package:flutterapp2/wiget/basketball/basketballMix.dart';
import 'package:flutterapp2/wiget/basketball/basketballSf.dart';
import 'package:flutterapp2/wiget/basketball/basketballrfSf.dart';
import 'package:flutterapp2/wiget/basketball/basketbifen.dart';
import 'package:flutterapp2/wiget/basketball/basketdxf.dart';
import 'package:flutterapp2/wiget/football/banquanchang.dart';
import 'package:flutterapp2/wiget/football/bifen.dart';
import 'package:flutterapp2/wiget/football/feirangqiu.dart';
import 'package:flutterapp2/wiget/football/mix.dart';
import 'package:flutterapp2/wiget/football/rangqiu.dart';
import 'package:flutterapp2/wiget/football/zongjinqiu.dart';

class order extends StatefulWidget {
  Function callBack;
  Map games;
  List game_ids;
  int type;
  int least_game;
  String f_or_b;

  order(this.games, this.game_ids, this.callBack, this.type, this.least_game,
      this.f_or_b);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return order_();
  }
}

class order_ extends State<order> {
  Map min_max = {};
  List zmax = [];
  List zsm = [];
  Map abc = {};
  Map num_to_cn = {
    "1": "一",
    "2": "二",
    "3": "三",
    "4": "四",
    "5": "五",
    "6": "六",
    "7": "末"
  };
  List chuan_ = [];
  int num = 1;
  double money = 0;
  double least_award = 0;
  double max_award = 0;
  bool is_pack = false;
  bool visible_ = false;
  List chuan = [];
  int bot = 100;

  @override


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int i = 0;
    if (widget.least_game < 2) {
      setState(() {
        visible_ = true;
      });
    }
    widget.game_ids.forEach((element) {
      chuan.add({"num": i + 1, "color": Colors.grey});
      i++;
    });
    if(widget.least_game>=2){
      chuan[1]["color"] = Colors.red;
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    ScreenUtil.instance = ScreenUtil(width: 417, height: 867)..init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton( icon:Icon(Icons.arrow_back, color: Colors.white),color: Colors.white,onPressed: (){
          widget.callBack(widget.games);
          Navigator.pop(context);
        },),
        centerTitle: true,
        backgroundColor: Color(0xfffa2020),
        title: Text("投注详情"),
      ),
      body: MediaQuery.removePadding(
          context: context,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: ScreenUtil().setHeight(30),
                    bottom: ScreenUtil().setHeight(getBot())),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: ScreenUtil().setHeight(60)),
                        child: ListView(
                          children: getGameList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () {
                    widget.callBack(widget.games);
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: ScreenUtil().setHeight(60),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0.0, 15.0), //阴影xy轴偏移量
                          blurRadius: 15.0, //阴影模糊程度
                          spreadRadius: 1.0 //阴影扩散程度
                          )
                    ]),
                    alignment: Alignment.center,
                    child: Text("+ 继续选择比赛"),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Offstage(
                          offstage: visible_,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10, top: 10),
                            padding: EdgeInsets.only(left: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Text("标准过关"),
                                ),
                                Wrap(
                                  runSpacing: 5,
                                  children: getChuan(),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(80),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Color(0xffe6e6e6))),
                          padding: EdgeInsets.only(
                              top: ScreenUtil().setHeight(10),
                              left: 5,
                              bottom: ScreenUtil().setHeight(10)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: getText(),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Text("投"),
                                  ),
                                  Container(
                                    width: ScreenUtil().setWidth(70),
                                    height: ScreenUtil().setHeight(38),
                                    margin:
                                        EdgeInsets.only(left: 15, right: 15),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: TextField(
                                            //限制2长度],//只允许输入数字
                                            onChanged: (e) {
                                              setState(() {
                                                num = int.parse(e);
                                                if(num <=1){
                                                  num = 1;
                                                }
                                              });
                                            },
                                            controller: TextEditingController
                                                .fromValue(TextEditingValue(
                                                    text:
                                                        '${this.num == null ? "" : this.num}',
                                                    selection: TextSelection
                                                        .fromPosition(TextPosition(
                                                            affinity:
                                                                TextAffinity
                                                                    .downstream,
                                                            offset:
                                                                '${this.num}'
                                                                    .length)))),
                                            keyboardType: TextInputType.number,
                                            //键盘类型，数字键盘

                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.only(left: 10),
                                              hintText: "",
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(

                                    child: Text("倍"),
                                  )
                                ],
                              ),
                              widget.f_or_b == "f"?GestureDetector(
                                onTap: (){
                                  int check_length = chuan_.length;
                                  if (widget.least_game > 1) {
                                    if (check_length == 0) {
                                      setState(() {
                                        visible_ =
                                        visible_ == true ? false : true;
                                        is_pack =
                                        is_pack == true ? false : true;
                                      });
                                      return;
                                    }
                                  }

                                  if(getNum().length == 0){
                                    Toast.toast(context,msg: "请选择比赛");
                                    return;
                                  }

                                  List check_game = [];
                                  widget.games.forEach((key, value) {
                                    value.forEach((game) {
                                      if (widget.game_ids
                                          .contains(game["id"])) {
                                        List ls1 = game["check_info"];
                                        List attr = [];
                                        ls1.forEach((element) {
                                        List ls2 = element["bet_way"];

                                          ls2.forEach((element2) {
                                            if (element2["color"] == "red") {

                                              String atr = element["id"]
                                                    .toString() +
                                                    "-" +
                                                    element2["id"].toString();
                                              Map pl_ =  jsonDecode(game["checks"]);

                                              String pl;
                                              pl_.forEach((key, value) {
                                                List va = value;

                                                if(element["id"].toString() == key.toString()){

                                                  va.forEach((element3) {
                                                    List vv = element3.toString().split("-");
                                                    if(element2["id"].toString() == vv[0].toString()){
                                                      pl = vv[1];
                                                    }
                                                  });
                                                }
                                              });


                                              attr.add('{"pl":'+pl+',"name":"'+element["name"]+'","week":"'+game["num"]+'","value":"'+element2["value"]+'","h_name":"'+game["h_cn_a"].toString()+'","a_name":"'+game["a_cn_a"].toString()+'","id":'+game["id"].toString()+',"attr":"'+atr+'"}');
                                            }

                                          });
                                        });
                                        check_game.add(attr);
                                      }
                                    });
                                  });
                                  List s2 = [];

                                 if(chuan_.length>0){
                                   int index = 1;
                                   List game_list = [];
                                   chuan_.forEach((element5) {

                                     game_list.add(plzh_(check_game, element5));
                                   });

                                   game_list.forEach((elements1) {
                                     List ls2  = elements1;

                                     ls2.forEach((elements2) {
                                       List ls3 = cartesian_(elements2);


                                       ls3.forEach((elements3) {
                                         List ls1 = elements3.toString().split("&");
                                         List ls4 = [];

                                         ls1.forEach((elements4) {
                                           ls4.add(jsonDecode(elements4));


                                         });



                                         s2.add({"data":ls4,"award":1.0,"base_award":1.0,"num":1,"is_show":true,"index":index});
                                          index++;


                                       });
                                     });
                                   });
                                 }else{
                                   int index = 1;
                                   check_game.forEach((v1) {
                                     List sl = v1;

                                     sl.forEach((v2) {
                                       s2.add({"data":[jsonDecode(v2)],"award":1.0,"base_award":1.0,"num":1,"is_show":true,"index":index});
                                       index++;

                                     });

                                   });
                                 }

                                  List check_games = [];
                                  widget.games.forEach((key, value) {
                                    value.forEach((game) {
                                      if (widget.game_ids
                                          .contains(game["id"])) {
                                        List ls1 = game["check_info"];
                                        List attr = [];
                                        ls1.forEach((element) {
                                          List ls2 = element["bet_way"];
                                          ls2.forEach((element2) {
                                            if (element2["color"] == "red") {
                                              attr.add({
                                                "id": game["id"],
                                                "attr": element["id"]
                                                    .toString() +
                                                    "-" +
                                                    element2["id"].toString()
                                              });
                                            }
                                          });
                                        });
                                        check_games.add(attr);
                                      }
                                    });
                                  });
                                  JumpAnimation().jump(awardOptimize(data: s2,money: int.parse(getMoney()),chuan: chuan_.length,game: check_games), context);
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  decoration: BoxDecoration(color: Color(0xffcccccc)),
                                  margin: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
                                  child: Text("奖金优化",style: TextStyle(color: Colors.white),),
                                ),
                              ):Container(),
                            ],
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(80),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                          GestureDetector(
                            onTap: () async{



                              int check_length = chuan_.length;
                              if (widget.least_game > 1) {
                                if (check_length == 0) {
                                  setState(() {
                                    visible_ =
                                    visible_ == true ? false : true;
                                    is_pack =
                                    is_pack == true ? false : true;
                                  });
                                  return;
                                }
                              }

                              if(getNum().length == 0){
                                Toast.toast(context,msg: "请选择比赛");
                                return;
                              }




                              if(double.parse(getMoney())<100){
                                Toast.toast(context,msg: "投注金额不能低于100元");
                                return;
                              }
                              List check_game = [];
                              widget.games.forEach((key, value) {
                                value.forEach((game) {
                                  if (widget.game_ids
                                      .contains(game["id"])) {
                                    List ls1 = game["check_info"];
                                    List attr = [];
                                    ls1.forEach((element) {
                                      List ls2 = element["bet_way"];
                                      ls2.forEach((element2) {
                                        if (element2["color"] == "red") {
                                          attr.add({
                                            "id": game["id"],
                                            "attr": element["id"]
                                                .toString() +
                                                "-" +
                                                element2["id"].toString()
                                          });
                                        }
                                      });
                                    });
                                    check_game.add(attr);
                                  }
                                });
                              });


                              JumpAnimation().jump(sendOrder(check_game,chuan_,getNum().length,num,widget.f_or_b), context);

                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: ScreenUtil().setWidth(90),
                              color: Color(0xffe6e6e6),
                              child: Text("发单"),
                            ),
                          ),
                              Container(

                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(180),
                                child: Wrap(

                                  direction: Axis.vertical,
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "共" +
                                          getNum().length.toStringAsFixed(0) +
                                          "注",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: ScreenUtil().setSp(14)),
                                    ),
                                    Text(getMoney() + "元",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(14))),
                                    getNum().length>=1? getExpectAward():Container()

                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  int check_length = chuan_.length;
                                  if (widget.least_game > 1) {
                                    if (check_length == 0) {
                                      setState(() {
                                        visible_ =
                                        visible_ == true ? false : true;
                                        is_pack =
                                        is_pack == true ? false : true;
                                      });
                                      return;
                                    }
                                  }

                                  if(getNum().length == 0){
                                    Toast.toast(context,msg: "请选择比赛");
                                    return;
                                  }

                                  EventDioLog("提示", "确认付款", context, () async {


                                    //提交订单
                                    List check_game = [];

                                    widget.games.forEach((key, value) {
                                      value.forEach((game) {
                                        if (widget.game_ids
                                            .contains(game["id"])) {
                                          List ls1 = game["check_info"];
                                          List attr = [];
                                          ls1.forEach((element) {
                                            List ls2 = element["bet_way"];
                                            ls2.forEach((element2) {
                                              if (element2["color"] == "red") {
                                                attr.add({
                                                  "id": game["id"],
                                                  "attr": element["id"]
                                                          .toString() +
                                                      "-" +
                                                      element2["id"].toString()
                                                });
                                              }
                                            });
                                          });
                                          check_game.add(attr);
                                        }
                                      });
                                    });
                                    ResultData res =
                                        await HttpManager.getInstance()
                                            .post("doorder", params: {
                                      "games": check_game,
                                      "chuan": chuan_,
                                      "num": getNum().length,
                                      "bei": num,
                                      "type": widget.f_or_b
                                    });
                                    if (res.data["code"] == 200) {
                                      JumpAnimation().jump(
                                          success(res.data["data"],widget.f_or_b), context);
                                    } else {
                                      Toast.toast(context,
                                          msg: res.data["msg"]);
                                      return;
                                    }
                                  }).showDioLog();
                                },
                                child: Container(
                                  width: ScreenUtil().setWidth(107),
                                  alignment: Alignment.center,
                                  color: Colors.red,
                                  child: Text(
                                    "付款",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              )
            ],
          )),
    );
  }

  getBot() {
    if (widget.least_game == 1) {
      return 100;
    }

    if (!is_pack) {
      int i = chuan.length;
      var a = i / 4;
      int b = int.parse(a.toStringAsFixed(0));
      int c = b * 40 + 90;
      return 100 + c;
    }

    return 100;
  }

  getText() {
    if (widget.least_game == 1) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        width: ScreenUtil().setWidth(70),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(width: 0.6, color: Colors.grey))),
        margin: EdgeInsets.only(right: ScreenUtil().setHeight(70)),
        child: Text("单关"),
      );
    }
    if (!is_pack) {
      return GestureDetector(
        onTap: () {
          setState(() {
            is_pack = true;
            visible_ = true;
          });
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          width: ScreenUtil().setWidth(70),
          decoration: BoxDecoration(
              border:
                  Border(right: BorderSide(width: 0.6, color: Colors.grey))),
          margin: EdgeInsets.only(right: ScreenUtil().setHeight(70)),
          child: Text("收起"),
        ),
      );
    } else {
      return GestureDetector(
          onTap: () {
            setState(() {
              is_pack = false;
              visible_ = false;
            });
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 10, bottom: 10),
            width: ScreenUtil().setWidth(70),
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 0.6, color: Colors.grey))),
            margin: EdgeInsets.only(right: ScreenUtil().setHeight(70)),
            child: Text("展开"),
          ));
    }
  }

  getExpectAward() {
    String text = "预计奖金0";
    List s = getNum();

    List min_ = [];
    List max_ = [];

    List sm = [];
    List lg = [];

    setState(() {
      min_max.removeWhere((key, value) => !chuan_.contains(key));
    });
    min_max.forEach((key, value) {
      List l1 = value;
      l1.forEach((element) {
        List l2 = element;
        if (l2.length > 0) {
          l2.forEach((elementz) {
            lg.add(elementz);
          });
          sm.add(l2[0]);
        }
      });
    });

    sm.sort((left, right) => left.compareTo(right));
    double min = s.length > 0 ? s[0] : 0;
    double max = 0;
    lg.forEach((element2) {
      max += element2;
    });
    min = min * num * 2;
    max = max * num * 2;
    text = "预计奖金" + min.toStringAsFixed(2) + "~" + max.toStringAsFixed(2)+"元";
    if(getNum().length == 1){
      text = "预计奖金" + min.toStringAsFixed(2) +"元";
    }
    if(widget.least_game == 1){
      List h = getNum();
      min = h[0]*num *2;
      max = h[h.length-1]*num *2;
      text = "预计奖金" + min.toStringAsFixed(2) + "~" + max.toStringAsFixed(2)+"元";
    }
    if(getNum().length == 1){
      text = "预计奖金" + min.toStringAsFixed(2)+"元";
    }
    return Text(
      text,
      style: TextStyle(fontSize: ScreenUtil().setSp(13)),
    );
  }

  String getMoney() {
    int i = getNum().length;
    int a = i * num * 2;
    return a.toString();
  }

  List getNum() {

    List zz = [];
    List zmax = [];
    List zsm = [];
    widget.games.forEach((key, value) {
      value.forEach((game) {
        if (widget.game_ids.contains(game["id"])) {
          List ls = [];
          List ls2 = [];
          Map maps = jsonDecode(game["checks"]);
          maps.forEach((key1, value1) {
            List ls1 = value1;

            ls1.sort((left, right){
              List s1 = left.toString().split("-");
              double l1 = double.parse(s1[1]);
              List s2 = right.toString().split("-");
              double l2 = double.parse(s2[1]);
              return l1.compareTo(l2);
            });
            if (ls1.length > 0) {
              List zs = ls1[ls1.length - 1].toString().split("-");
              ls2.add(double.parse(zs[1]));
            }
           // print(ls1);
            ls1.forEach((element) {
              List zs2 = element.toString().split("-");
              ls.add(double.parse(zs2[1]));
            });
          });
          zz.add(ls);
          zmax.add(ls2);
        }
      });
    });

    List ar = [];
    //print(zz);
    if (widget.least_game == 1) {
      zz.forEach((z) {
        List z1 = z;
        z1.forEach((element_) {
          ar.add(element_);
        });
      });
      ar.sort((left, right) => left.compareTo(right));
      return ar;
    }

    chuan.forEach((element) {
      if (element["color"] == Colors.red) {
        setState(() {
          if (!chuan_.contains(element["num"])) {
            chuan_.add(element["num"]);
          }
        });
      } else {
        chuan_.remove(element["num"]);
      }
      ;
    });
    List ars = [];

    chuan_.forEach((element4) {
      plzh(zz, element4, type: "m");
      List lss = plzh(zz, element4);

      lss.forEach((element5) {
        List lss2 = element5;
        lss2.forEach((element6) {
          double m = 1;
          m *= element6;
          ars.add(m);
        });
      });
    });
    ars.sort((left, right) => left.compareTo(right));

    return ars;
  }

  plzh(List arr, int size, {type = "a"}) {

    int len = arr.length;
    int max = pow(2, len);
    int min = pow(2, size) - 1;
    List r_arr = [];
    for (int i = min; i < max; i++) {
      int count = 0;
      List t_arr = [];
      for (int j = 0; j < len; j++) {
        int a = pow(2, j);
        int t = i & a;
        if (t == a) {
          t_arr.add(arr[j]);
          count++;
        }
      }

      if (count == size) {
        r_arr.add(t_arr);
      }
    }

    List arr_ = [];

    r_arr.forEach((element) {
      arr_.add(cartesian(element, r_arr.length));
    });
    if (type == "m") {
      setState(() {
        min_max[size] = arr_;
      });
    }
    ;

    return arr_;
  }


  plzh_(List arr, int size, {type = "a"}) {
    int len = arr.length;
    int max = pow(2, len); //8    8
    int min = pow(2, size) - 1; //3   3,4,5,6,7   7
    List r_arr = [];
    for (int i = min; i < max; i++) {
      int count = 0;
      List t_arr = [];
      for (int j = 0; j < len; j++) {
        int a = pow(2, j);
        int t = i & a;
        if (t == a) {
          t_arr.add(arr[j]);
          count++;
        }
      }
      if (count == size) {
        r_arr.add(t_arr);
      }
    }
    return r_arr;
  }

  cartesian_(List sets) {
    List arr = [];
    String str = "";
    for (int i = 0; i < sets.length - 1; i++) {
      if (i == 0) {
        arr = sets[i];
      }
      List tmp = [];

      arr.forEach((element) {


        List ls = sets[i + 1];
        ls.forEach((element2) {
          String str1 = jsonEncode(element).replaceAll("\\", "").indexOf('"')==0?jsonEncode(element).replaceAll("\\", "").replaceFirst('"', ""):jsonEncode(element).replaceAll("\\", "");
          String str2 = jsonEncode(element2).replaceAll("\\", "").indexOf('"')==0?jsonEncode(element2).replaceAll("\\", "").replaceFirst('"', ""):jsonEncode(element2).replaceAll("\\", "");
         tmp.add(element+"&"+element2);
        });
      });
      arr = tmp;
    }
    return arr;
  }

  cartesian(List sets, int len) {
    List arr = [];

    for (int i = 0; i < sets.length - 1; i++) {
      if (i == 0) {
        arr = sets[i];
      }
      List tmp = [];

      arr.forEach((element) {
        List ls = sets[i + 1];

        ls.forEach((element2) {
          tmp.add(element * element2);
        });
      });
      arr = tmp;
    }
    ;
    arr.sort((left, right) => left.compareTo(right));

    return arr;
  }

  getChuan() {
    List ls;
    ls = widget.game_ids.asMap().keys.map((e) {
      String num = (e + 1).toString();
      return GestureDetector(
        onTap: () {
          setState(() {
            chuan[e]["color"] =
                chuan[e]["color"] == Colors.red ? Colors.grey : Colors.red;
          });
        },
        child: Container(
          width: ScreenUtil().setWidth(90),
          height: ScreenUtil().setHeight(40),
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: chuan[e]["color"])),
          child: Text(num + "串1"),
        ),
      );
    }).toList();
    if (ls.length > 0) {
      ls.removeAt(0);
    }

    return ls;
  }

  List getGameList() {
    List ls;
    ls = widget.games.keys.map((e) {
      String date = e;

      String week = widget.games[e][0]["num"].toString().substring(0, 1);
      List list_game = widget.games[e];
      BoxDecoration boxde = BoxDecoration(
          color: Color(0xfffff5f8),
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)));
      if (widget.game_ids.length == 0) {
        boxde = null;
      }
      return Container(
        decoration: boxde,
        child: Container(
            decoration: BoxDecoration(color: Color(0xfffff5f8)),
            child: Column(
              children: getGame(list_game, e),
            )),
      );
    }).toList();
    Widget db = Container(
      alignment: Alignment.center,
      child: Text("sadasd"),
    );

    return ls;
  }

  List getGameList_foot(List list_game_, e2) {
    return list_game_.asMap().keys.map((e) {
      String week = list_game_[e]["num"].toString().substring(0, 1);
      String order_no = list_game_[e]["num"].toString().substring(1, 4);
      String week_time = "周" + num_to_cn[week] + order_no;
      String hour_time = list_game_[e]["dtime"].toString().substring(11, 16);
      String ls_name = list_game_[e]["l_cn_a"];
      String zd_name = list_game_[e]["h_cn"];
      String kd_name = list_game_[e]["a_cn"];
      String p_goal = list_game_[e]["p_goal"].toString();
      List p_status = list_game_[e]["p_status"].toString().split(",");

      if (list_game_[e]["type"] == 1) {
        p_goal = list_game_[e]["p_goal"].toString().split(",")[1]; //让球个数
      }
      if (list_game_[e]["type"] == 2 ||
          list_game_[e]["type"] == 3 ||
          list_game_[e]["type"] == 4 ||
          list_game_[e]["type"] == 5 ||
          list_game_[e]["type"] == 6) {
        p_status = [
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString()
        ];
      }

      List ttg_odds = list_game_[e]["ttg_odds"].toString().split(","); //总进球赔率
      List half_odds = list_game_[e]["hafu_odds"].toString().split(","); //半全场赔率
      List spf = list_game_[e]["had_odds"].toString().split(","); //非让球赔率

      List rqspf = list_game_[e]["hhad_odds"].toString().split(","); //让球赔率
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
      if (list_game_.length > 1) {
        border = Border(bottom: BorderSide(width: 0.2, color: Colors.grey));
        bot = 15;
      } else {
        border = null;
        bot = 0;
      }
      if (e == list_game_.length - 1) {
        bot = 0;
        border = null;
      }
      if (widget.game_ids.contains(list_game_[e]["id"])) {
        return Container(
          padding: EdgeInsets.only(bottom: bot, left: 15),
          decoration: BoxDecoration(color: Color(0xfffff5f8), border: border),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
          child: Row(
            children: <Widget>[
              //比赛组件
              getComponent(p_status, p_goal, widget.games, e2, e, zd_name,
                  kd_name, spf, rqspf, crs_win, ttg_odds, half_odds),
              IconButton(
                onPressed: () {
                  widget.game_ids.remove(list_game_[e]["id"]);
                  setState(() {});
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              )
              //比赛组件
            ],
          ),
        );
      } else {
        return Container();
      }
    }).toList();
  }

  List getGame(List list_game_, e2) {
    if (widget.f_or_b == "f") {
      return getGameList_foot(list_game_, e2);
    } else {
      return getGameList_basket(list_game_, e2);
    }
  }

  List getGameList_basket(List list_game_, e2) {
    return list_game_.asMap().keys.map((e) {
      String week = list_game_[e]["num"].toString().substring(0, 1);
      String order_no = list_game_[e]["num"].toString().substring(1, 4);
      String week_time = "周" + num_to_cn[week] + order_no;
      String hour_time = list_game_[e]["dtime"].toString().substring(11, 16);
      String ls_name = list_game_[e]["l_cn_abbr"];
      String zd_name = list_game_[e]["h_cn_abbr"];
      String kd_name = list_game_[e]["a_cn_abbr"];
      List p_goal = list_game_[e]["p_goal"].toString().split(",");
      List p_status = list_game_[e]["p_status"].toString().split(",");
      List hdc_odds; //让分赔率
      List mnl_odds; //非让分赔率
      String dafen;
      List dxf_odds; //大小分赔率
      List wnm_win; //胜分差主胜赔率
      List wnm_lose; //胜分差客胜赔率
      if (list_game_[e]["type"] == 1) {

        dafen = list_game_[e]["p_goal"].toString().split(",")[3];
        dxf_odds = list_game_[e]["hilo_odds"].toString().split(","); //大小分赔率
        hdc_odds = list_game_[e]["hdc_odds"].toString().split(","); //让分赔率
        mnl_odds = list_game_[e]["mnl_odds"].toString().split(","); //非让分赔率
        wnm_win = list_game_[e]["wnm_win"].toString().split(","); //胜分差主胜赔率
        wnm_lose = list_game_[e]["wnm_lose"].toString().split(","); //胜分差客胜赔率
      }
      if (list_game_[e]["type"] == 2) {
        mnl_odds = list_game_[e]["mnl_odds"].toString().split(","); //非让分赔率
        hdc_odds = ["0", "0"]; //非让分赔率
      }

      if (list_game_[e]["type"] == 3) {
        mnl_odds = ["0", "0"]; //非让分赔率
        hdc_odds = list_game_[e]["hdc_odds"].toString().split(","); //让分赔率
      }

      if (list_game_[e]["type"] == 4) {
        mnl_odds = ["0", "0"];
        hdc_odds = ["0", "0"];
        wnm_win = list_game_[e]["wnm_win"].toString().split(","); //胜分差主胜赔率
        wnm_lose = list_game_[e]["wnm_lose"].toString().split(","); //胜分差客胜赔率
      }

      if (list_game_[e]["type"] != 1) {
        p_status = [
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString(),
          list_game_[e]["p_status"].toString()
        ];
        dafen = "0";
        dxf_odds = ["0", "0"];
      }
      if (list_game_[e]["type"] == 5) {
        mnl_odds = ["0", "0"];
        hdc_odds = ["0", "0"];
        dxf_odds = list_game_[e]["hilo_odds"].toString().split(","); //大小分赔率
      }

      Border border;
      double bot;
      if (list_game_.length > 1) {
        border = Border(bottom: BorderSide(width: 0.2, color: Colors.grey));
        bot = 15;
      } else {
        border = null;
        bot = 0;
      }
      if (e == list_game_.length - 1) {
        bot = 0;
        border = null;
      }
      if (widget.game_ids.contains(list_game_[e]["id"])) {
        return Container(
          padding: EdgeInsets.only(bottom: bot, left: 15),
          decoration: BoxDecoration(border: border),
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //比赛组件
              getComponent_bas(
                  p_status,
                  p_goal,
                  widget.games,
                  e2,
                  e,
                  zd_name,
                  kd_name,
                  mnl_odds,
                  hdc_odds,
                  dxf_odds,
                  wnm_win,
                  wnm_lose,
                  dafen),
              IconButton(
                onPressed: () {
                  widget.game_ids.remove(list_game_[e]["id"]);
                  setState(() {});
                },
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
              )
              //比赛组件
            ],
          ),
        );
      } else {
        return Container();
      }
    }).toList();
  }

  getComponent(p_status, p_goal, games, e2, e, zd_name, kd_name, spf, rqspf,
      crs_win, ttg_odds, half_odds) {
    switch (widget.type) {
      case 0:
        return mix(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          p_goal: p_goal,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          spf: spf,
          rqspf: rqspf,
          crs_win: crs_win,
          ttg_odds: ttg_odds,
          half_odds: half_odds,
        );
      case 1:
        return rangqiu(
            callBack: (value) {
              setState(() {
                games = value;
              });
            },
            p_status: p_status,
            p_goal: p_goal,
            games: games,
            e2: e2,
            e: e,
            zd_name: zd_name,
            kd_name: kd_name,
            rqspf: rqspf);
      case 2:
        return feirangqiu(
            callBack: (value) {
              setState(() {
                games = value;
              });
            },
            p_status: p_status,
            p_goal: p_goal,
            games: games,
            e2: e2,
            e: e,
            zd_name: zd_name,
            kd_name: kd_name,
            spf: spf);
      case 3:
        return zongjinqiu(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          ttg_odds: ttg_odds,
        );
      case 4:
        return bifen(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          crs_win: crs_win,
        );
      case 5:
        return banquanchang(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          half_odds: half_odds,
        );
      case 6:
        return feirangqiu(
            callBack: (value) {
              setState(() {
                games = value;
              });
            },
            p_status: p_status,
            p_goal: p_goal,
            games: games,
            e2: e2,
            e: e,
            zd_name: zd_name,
            kd_name: kd_name,
            spf: spf);
      case 7:
        return rangqiu(
            callBack: (value) {
              setState(() {
                games = value;
              });
            },
            p_status: p_status,
            p_goal: p_goal,
            games: games,
            e2: e2,
            e: e,
            zd_name: zd_name,
            kd_name: kd_name,
            rqspf: rqspf);
      case 8:
        return zongjinqiu(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          ttg_odds: ttg_odds,
        );
      case 9:
        return bifen(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          crs_win: crs_win,
        );
      case 10:
        return banquanchang(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          half_odds: half_odds,
        );
    }
  }

  getComponent_bas(p_status, p_goal, games, e2, e, zd_name, kd_name, mnl_odds,
      hdc_odds, dxf_odds, wnm_win, wnm_lose, dafen) {
    switch (widget.type) {
      case 0:
        return basketballMix(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          dafen: dafen,
          p_goal: p_goal,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          sf: mnl_odds,
          rfsf: hdc_odds,
          zs_sfc: wnm_win,
          ks_sfc: wnm_lose,
          dxf: dxf_odds,
        );
      case 1:
        return basketballSf(
            callBack: (value) {
              setState(() {
                games = value;
              });
            },
            p_status: p_status,
            games: games,
            e2: e2,
            e: e,
            zd_name: zd_name,
            kd_name: kd_name,
            sf: mnl_odds);
      case 2:
        return basketballrfSf(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          rfsf: hdc_odds,
          p_goal: p_goal,
        );
      case 3:
        return basketbifen(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          zs_sfc: wnm_win,
          ks_sfc: wnm_lose,
        );
      case 4:
        return basketdxf(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          dxf: dxf_odds,
          p_goal: p_goal,
        );
      case 5:
        return basketballSf(
            callBack: (value) {
              setState(() {
                games = value;
              });
            },
            p_status: p_status,
            games: games,
            e2: e2,
            e: e,
            zd_name: zd_name,
            kd_name: kd_name,
            sf: mnl_odds);
      case 6:
        return basketballrfSf(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          rfsf: hdc_odds,
          p_goal: p_goal,
        );
      case 7:
        return basketbifen(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          zs_sfc: wnm_win,
          ks_sfc: wnm_lose,
        );
      case 8:
        return basketdxf(
          callBack: (value) {
            setState(() {
              games = value;
            });
          },
          p_status: p_status,
          games: games,
          e2: e2,
          e: e,
          zd_name: zd_name,
          kd_name: kd_name,
          dxf: dxf_odds,
          p_goal: p_goal,
        );
    }
  }
}
