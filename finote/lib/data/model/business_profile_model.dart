class BusinessProfileModel {
  String? name;
  String? currency;
  String? gstID;
  String? id;

  BusinessProfileModel({
    required this.name,
    required this.currency,
    this.gstID,
    this.id
  });

  factory BusinessProfileModel.fromJson(Map<String,dynamic>json){
    return (
      BusinessProfileModel(name: json['name'], currency: json['currency'],gstID: json['Gst_id'],id: json['id'])
    );
  }

  Map<String,dynamic>toJson(){
    return{
      'name':name,
      'currency':currency,
      'Gst_id':gstID,
    };
  
  }
}