import 'dart:developer';

import 'package:first/core/constants/color_constant.dart';
import 'package:first/features/profile/constant/textconst.dart';
import 'package:first/features/update/controller/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdatePage extends StatelessWidget {
  final String name;
  final String age;
  final String place;
  final String id;
  final int index;
  const UpdatePage({super.key,required this.name,required this.age,required this.place, required this.index,required this.id});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UpdateController>(context);
    provider.updateNamecontroller.text = name;
    provider.updatAgecontroller.text = age;
    provider.updatePlacecontroller.text = place;
    final formkey =GlobalKey<FormState>();
    log("id- $id");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add student"),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<UpdateController>(
          builder: (context, value, child) => Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    validator: (val) {
                      if(val == null || val.isEmpty){
                        return 'Enter your name';
                      }else{
                        return null;
                      }
                    },
                    controller: value.updateNamecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: Textconst.name,
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),SizedBox(height: 10,),
                  TextFormField(
                    validator: (val) {
                      if(val == null || val.isEmpty){
                        return 'Enter your age';
                      }else{
                        return null;
                      }
                    },
                    controller: value.updatAgecontroller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: Textconst.age,
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  
                  TextFormField(
                    validator: (val) {
                      if(val == null || val.isEmpty){
                        return 'Enter the place';
                      }else{
                        return null;
                      }
                    },
                    controller: value.updatePlacecontroller,
                    decoration: InputDecoration(
                      
                      border: OutlineInputBorder(),
                      hintText: Textconst.place,
                      errorBorder: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade300,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10)),
                      minimumSize: Size(50, 50)
                    ),
                    onPressed: (){
                    value.update(formkey, context,id);
                  }, child: Text(Textconst.butten,style: TextStyle(color: ColorConstant.light),))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}