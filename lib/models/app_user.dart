class AppUser{
  String? id;
  String? name,email,phone,password;
  AppUser({this.id,this.email,this.name,this.phone,this.password});
  AppUser.fromJSON(Map<String,dynamic> user){
    id=user["id"];
    name=user["name"];
    email=user["email"];
    phone=user["phone"];

  }
  Map<String,dynamic>toJSON(){
    return {"id":id,"name":name,"email":email,"phone":phone};
  }
}