class UserModel {
  UserModel({required this.email, required this.name, required this.username,this.account=0, this.isAdmin=false});
  String name, email, username;
  int account=0;
  bool isAdmin=false;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json['email'], username: json['username'], name: json['name'],account: json['account'],isAdmin: json['isAdmin']);
  }

  Map<String,dynamic> toJson(){
    return {
      'username':username,
      'email':email, 
      'name':name,
      'account':account.toString() 
    };
  }
}
