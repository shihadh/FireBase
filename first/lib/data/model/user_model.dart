class UserModel {

  String? username;
  String? age;
  String? place;
  String? id;
  
  UserModel({
    required this.username,
    required this.age,
    required this.place,
    this.id
  });

  factory UserModel.fromjson(Map<String,dynamic>json,String id){
    return UserModel(username: json['username'], age: json['age'], place: json['place'],id: id);
  }

  Map<String,dynamic>tojson(){
    return {
      'username' :username,
      'age':age,
      'place':place
    };
  }
   
}