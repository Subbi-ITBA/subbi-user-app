class ErrorLogger{

  static void log({String userId, String error, String context}) async{

    print(context+': '+error);

    throw Exception(context+': '+error);     
      
  }

}