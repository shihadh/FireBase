import 'package:finote/core/constants/color_const.dart';
import 'package:finote/core/constants/text_const.dart';
import 'package:finote/features/business%20profile/view/update_business_profile.dart';
import 'package:finote/features/profile/controller/profile_controller.dart';
import 'package:finote/features/profile/widgets/button_widget.dart';
import 'package:finote/features/profile/widgets/card_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileController>(context, listen: false);
    return Scaffold(
      backgroundColor: ColorConst.backgroundColor,
      appBar: AppBar(
        title: Text(TextConst.profileTitle),
        backgroundColor: ColorConst.backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Container(
                height: 210,
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorConst.black,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 15,
                          ),
                          child: Container(
                            height: 25,
                            width: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: ColorConst.premiumBg,
                            ),
                            child: Center(
                              child: Text(
                                TextConst.premium,
                                style: TextStyle(color: ColorConst.premium),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 90,
                      width: 100,
                      decoration: BoxDecoration(
                        color: ColorConst.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        FontAwesomeIcons.building,
                        color: ColorConst.white,
                        size: 50,
                      ),
                    ),
                    Text(
                      provider.profile?.name?.toUpperCase() ??
                          TextConst.nonValue,
                      style: TextStyle(color: ColorConst.white, fontSize: 30),
                    ), // company name
                  ],
                ),
              ),
              const SizedBox(height: 20),
              CardWidgets(
                title: TextConst.country,
                bg: ColorConst.blueBg,
                color: ColorConst.blueAccent,
                data: provider.profile?.currency ?? TextConst.nonValue,
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 10),
              CardWidgets(
                title: TextConst.gst,
                bg: ColorConst.greenBg,
                color: ColorConst.success,
                data: provider.profile?.gstID ?? TextConst.nonValue,
                icon: Icons.description_outlined,
              ),
              const SizedBox(height: 15),
              ButtonWidget(
                icon: Icons.settings_outlined,
                title: TextConst.settings,
                color: ColorConst.black,
                iconColor: ColorConst.blackopacity,
                funtion: () {},
              ),
              const SizedBox(height: 15),
              ButtonWidget(
                icon: Icons.edit_outlined,
                title: TextConst.edit,
                color: ColorConst.black,
                iconColor: ColorConst.blackopacity,
                funtion: () {
                  // log("id - ${provider.profile?.id}");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateBusinessProfile(
                    name: provider.profile?.name?.toUpperCase() ?? TextConst.nonValue, 
                    gst: provider.profile?.gstID ?? TextConst.nonValue, 
                    id: provider.profile?.id ?? TextConst.nonValue ,
                    ),));
                },
              ),
              const SizedBox(height: 15),
              ButtonWidget(
                icon: Icons.logout_outlined,
                title: TextConst.signOut,
                color: ColorConst.danger,
                iconColor: ColorConst.danger,
                funtion: () async{
                 await provider.logout(context);

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
