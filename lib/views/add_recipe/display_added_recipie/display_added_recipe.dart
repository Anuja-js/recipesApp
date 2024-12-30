import 'package:flutter/material.dart';
import 'package:newsapp/views/home/home_screen.dart';

import '../../../config/color/colors.dart';
import '../../../config/componets/text_custom.dart';
class DisplayAddedRecipe extends StatelessWidget {
  const DisplayAddedRecipe({required this.responseData}) ;
  final Map<String, dynamic> responseData;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
    onWillPop:(){

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return HomeScreen();
    }));
    return Future.value(true);
    },
      child: Scaffold(backgroundColor: AppColor.darkFontColor,
        appBar: AppBar(
          backgroundColor: AppColor.darkBgColor,
          elevation: 1,leading: IconButton(onPressed: (){
        }, icon: Icon(Icons.arrow_back_ios_outlined,color: AppColor.darkFontColor,)),
          title: TextCustom(text: 'Recipe Result',textSize: 18,fontWeight: FontWeight.bold,),
        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Recipe Card Created Successfully!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            responseData['url'] != null
                ? Image.network(
              responseData['url'],
              width: double.infinity,
              fit: BoxFit.fitHeight,
            )
                : Text('No image available'),

          ],
        ),
      ),
    );
  }
}
