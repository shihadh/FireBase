import 'package:first/core/constants/color_constant.dart';
import 'package:first/features/profile/constant/textconst.dart';
import 'package:first/features/profile/controller/create_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final formkey =GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add student"),
        centerTitle: true,
      ),
      body: Center(
        child: Consumer<CreateController>(
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
                    controller: value.namecontroller,
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
                    controller: value.agecontroller,
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
                    controller: value.placecontroller,
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
                    value.add(formkey, context);
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
