import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigApi{

  static RemoteConfigApi _singleton = RemoteConfigApi._internal();

  RemoteConfigApi._internal();

  factory RemoteConfigApi.instance(){
    return _singleton;
  }

  RemoteConfig rc;

  Future<void> initialize() async{
    rc = await RemoteConfig.instance;
    
    // For debugging purposes, the expiration time has been set to 1 second.
    await rc.fetch(expiration: Duration(seconds: 1));
    await rc.activateFetched();

  }

  String get serverURL => rc.getString('server_url');

  int get serverPort => rc.getInt('server_port');

}