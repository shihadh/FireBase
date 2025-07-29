class TransationModel {
  String? amount;
  String? category;
  String? date;
  String? note;
  String? type;
  String? id;

  TransationModel({
    required this.amount,
    required this.category,
    required this.date,
    this.note,
    required this.type,
    this.id,

  });

  factory TransationModel.formJson(Map<String,dynamic>json,String id){
    return (
      TransationModel(amount: json['amount'], category: json['category'], date: json['date'], type: json['type'],note: json['note'],id: id)
    );
  }

  Map<String,dynamic>toJson(){
    return {
      'amount':amount,
      'category':category,
      'date':date,
      'note':note,
      'type':type,

    };
  }

}