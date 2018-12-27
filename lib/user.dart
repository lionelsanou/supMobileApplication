class User {
  User({this.uuid,this.userName,this.email,this.longitude,this.latitude,this.message});

  final String uuid;
  final String userName;
  final String email;
  final String longitude;
  final String latitude;
  final String message;

  User.fromJson(Map<String,dynamic> json):
      uuid=json['uuid'],
      userName=json['userName'],
      email=json['email'],
      longitude=json['longitude'],
      latitude=json['latitude'],
      message=json['message'];

  Map<String,dynamic> toJson(){
    return {"uuid":uuid, "username":userName, "email":email, "logitude":longitude,"latitide":latitude};
  }
}