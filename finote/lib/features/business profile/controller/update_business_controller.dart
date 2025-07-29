import 'package:finote/features/business%20profile/model/business_profile_model.dart';
import 'package:finote/features/shared/service/business_profile_service.dart';
import 'package:flutter/material.dart';

class UpdateBusinessController extends ChangeNotifier{
  final TextEditingController updateNameController = TextEditingController();
  final TextEditingController updateGstController = TextEditingController();
  BusinessProfileService profileService = BusinessProfileService();
  String? error;
  bool loading =false;
  bool success =false;

  String selectedCurrency = '₹ Indian Rupee (INR)';

  void updateCurrency(String? newCurrency) {
    if (newCurrency != null) {
      selectedCurrency = newCurrency;
      notifyListeners();
    }
}

Future<void> updateData(String id)async{
      String contry;
      contry =selectedCurrency;
      loading = true;

      notifyListeners();
      if(contry == '₹ Indian Rupee (INR)' ){
        contry = 'INDIA';
      }
      else if(contry == "\$ US Dollar (USD)" ){
        contry = "USA";
      }else if(contry == "€ Euro (EUR)"){
        contry = "EUROPE";
      }
      BusinessProfileModel model = BusinessProfileModel(
        name: updateNameController.text.trim(), 
        currency: contry,
        gstID: updateGstController.text.trim().isNotEmpty ? updateGstController.text.trim() : 'N/N'
        );
      var (stat,errors) = await profileService.update(model,id);
      if(errors != null){
        error =errors;
      }
      if(stat == true){

        success = true;
      }
      loading = false;
      notifyListeners();
    } 
}