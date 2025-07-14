import 'dart:developer';

import 'package:first/core/constants/color_constant.dart';
import 'package:first/features/detailes/view/detailes.dart';
import 'package:first/features/home/controller/home_controller.dart';
import 'package:first/features/profile/view/create.dart';
import 'package:first/features/update/controller/update_controller.dart';
import 'package:first/features/update/view/update_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key,});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false).getData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Students"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon((Icons.person),),
          ),
          
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, value, child) {
          if (value.userData.isEmpty && value.error != null) {
            return const Center(child: Text("No data found."));
          }
          if (value.userData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: value.userData.length,
            itemBuilder: (context, index) {
              final user = value.userData[index];
              final docId = user.id;
              

              return Card(
                color: ColorConstant.light,
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Detailes(index: index),
                      ),
                    );
                  },
                  title: Text(
                    user.username ?? "Unnamed User",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(name: user.username ?? "" , age: user.age ?? "" , place: user.place ?? "" , index: index,id: docId ?? '',)));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<UpdateController>().delete(context, docId!);
                          value.getData();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePage()),
              );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
