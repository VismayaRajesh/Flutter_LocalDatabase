class User{
  int? id;
  late String name;
  late String phonenumber;

  User({this.id, required this.name, required this.phonenumber});

   Map <String, Object?> toMap(){
     var map = <String, Object?>{
       "name": name,
       "phonenumber": phonenumber
     };

     if(id != null){
       map["id"] = id;
     }

     return map;
   }

}
