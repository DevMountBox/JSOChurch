
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jsochurch/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/my_colors.dart';

class UpdateView extends StatelessWidget {
  String text;
  String button;
  String address;
  UpdateView({Key? key,required this.text,required this.button,required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: myWhite,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 100,
                margin: EdgeInsets.only(bottom: 70),
                padding: EdgeInsets.only(top: 80),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/church_logo.png"),

                    scale: 5,
                    fit: BoxFit.scaleDown,
                  ),
                ),
child: customBoldText(text: "JSO church Directory", color: myBlack, fontSize: 16),
              ),
              Center(child: Image.asset("assets/images/update.png",scale: 3,)),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text("We added lots of new features and fix some bugs to make your experience as smooth as possible",textAlign: TextAlign.center,),
              ),
              SizedBox(height:50,),

              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  splashColor: Colors.white,
                  onTap: (){
                    _launchURL(address);
                  },
                  child: Container(
                    height: 40,
                    width: 150,

                    decoration: BoxDecoration(
                        color: buttonBlue,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10,),
                            child: Text(button,style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              fontFamily: 'Inter',
                              color: myWhite,
                            ),),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );

  }
  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }
}
