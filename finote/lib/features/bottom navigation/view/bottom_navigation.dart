import 'package:finote/core/constants/color_const.dart';
import 'package:finote/features/AddTransaction/controller/add_tansaction_controller.dart';
import 'package:finote/features/AddTransaction/view/add_transaction_page.dart';
import 'package:finote/features/bottom%20navigation/controller/bottom_navigation_controller.dart';
import 'package:finote/features/history/view/history.dart';
import 'package:finote/features/home/view/home.dart';
import 'package:finote/features/profile/controller/profile_controller.dart';
import 'package:finote/features/profile/view/profile.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:finote/core/constants/text_const.dart';

class MainBottomNavScreen extends StatelessWidget {
  const MainBottomNavScreen({super.key});

  final List<Widget> pages = const [
    HomePage(),
    AddTransactionPage(),
    HistoryPage()
  ];
  @override
  Widget build(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_){
      Provider.of<ProfileController>(context,listen: false).profileData();
  });

    return Consumer<BottomNavigationController>(
      builder: (context, controller, child) {
        return Scaffold(
          backgroundColor: ColorConst.backgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: false, // This hides the back button
          backgroundColor: ColorConst.backgroundColor,
            actions: [
              IconButton(onPressed: (){
                showReceiptPicker(context);
              }, 
              icon: Icon(Icons.qr_code_scanner_outlined)),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(),));
                  },
                  child: CircleAvatar(
                    backgroundColor: ColorConst.white,
                    child: Icon(Icons.person_outlined,color: ColorConst.black,),
                  ),
                ),
              )
            ],
          ),
          body: pages[controller.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
          backgroundColor: ColorConst.backgroundColor,
            currentIndex: controller.currentIndex,
            onTap: controller.setIndex,
            elevation: 8,
            selectedItemColor: Colors.black,
            unselectedItemColor: ColorConst.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: TextConst.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: TextConst.transactions,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: TextConst.history,
              ),
            ],
          ),
        );
      },
    );
  }
  void showReceiptPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text("Scan with Camera"),
          onTap: () {
            Navigator.pop(context);
            context
                .read<AddTansactionController>()
                .scanReceipt(ImageSource.camera);
          },
        ),
        ListTile(
          leading: const Icon(Icons.image),
          title: const Text("Pick from Gallery"),
          onTap: () {
            Navigator.pop(context);
            context
                .read<AddTansactionController>()
                .scanReceipt(ImageSource.gallery);
          },
        ),
      ],
    ),
  );
}

}
