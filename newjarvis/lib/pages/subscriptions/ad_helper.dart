import 'dart:io';

class AdHelper {

  static String get BannerAdUnitId {
    
    if(Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/9214589741';
    } else if(Platform.isIOS) {
      return 'yourbannerid';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get InterstatialAdUnitId {
    
    if(Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if(Platform.isIOS) {
      return 'yourbannerid';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}