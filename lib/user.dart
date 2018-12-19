class User {
  String uuid;
  String userName;
  String email;
  String longitude;
  String latitude;
  String message;

  void setUuid(String uuid){
    this.uuid=uuid;
  }
  String getUuid(){
    return this.uuid;
  }
  void setUserName(String userName){
    this.userName=userName;
  }
  String getUserName(){
    return this.userName;
  }

  void setEmail(String email){
    this.email=email;
  }
  String getEmail(){
    return this.email;
  }
  void setLongitude(String longitude){
    this.longitude=longitude;
  }
  String getLongitude(){
    return this.longitude;
  }
  void setLatitude(String latitude){
    this.latitude=latitude;
  }
  String getLatitude(){
    return this.latitude;
  }
}