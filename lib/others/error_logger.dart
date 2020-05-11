class ErrorLogger{

  static void log({String userId, String error, String context, bool throwException=true}) async{

    print(context+': '+error);

    if(throwException)
      throw Exception(context+': '+error);
      
  }

}