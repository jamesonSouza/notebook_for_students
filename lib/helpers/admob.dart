import 'package:firebase_admob/firebase_admob.dart';

class Anuncio{

  Anuncio();
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  final  MobileAdTargetingInfo targetingInfo =  MobileAdTargetingInfo(
    testDevices: <String>[],
    keywords: ['Notes', 'Images','organization','data'],
    birthday: new DateTime.now(),

  );
  InterstitialAd createInterstitialAd(){
    return new InterstitialAd(
        adUnitId: "ca-app-pub-9275202133724780/2781742095",
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print ("InterstitialAd event: $event");
        }
    );

  }



  BannerAd createBannerAd(){
    return new BannerAd(adUnitId:"ca-app-pub-9275202133724780/7104130488", size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event){
          print ("Banner event: $event");
        }
    );

  }
}