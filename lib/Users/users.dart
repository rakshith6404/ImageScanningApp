class UserModel{
  String? uid;
  String? email;
  String? userName;

  UserModel({this.uid , this.email , this.userName});

  //data from server
  factory UserModel.fromMap(map)
  {
    return UserModel(
    uid: map['uid'],//used to link it with ur firebase uid model
    email: map['email'],//used to link it with ur firebase email model
    userName: map['username'],//used to link it with ur firebase username model
    );
  }
  //sending data to our server
  Map<String,dynamic> toMap(){
    return{
      'uid':uid,
      'email':email,
      'username':userName,
    };
  }
}

