import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdButton extends StatefulWidget {
  @override
  _InterstitialAdButtonState createState() => _InterstitialAdButtonState();
}

class _InterstitialAdButtonState extends State<InterstitialAdButton> {
  InterstitialAd _interstitialAd;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    createAd();
  }

  void createAd() {
    _interstitialAd ??= InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          print('${ad.runtimeType} loaded!');
          _isReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          print('${ad.runtimeType} failed to load.\n$error');
          ad.dispose();
          _interstitialAd = null;
          createAd();
        },
        onAdOpened: (Ad ad) => print('${ad.runtimeType} opened!'),
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed.');
          ad.dispose();
          createAd();
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _interstitialAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('show Interstitial Ad'),
      onPressed: () {
        if (!_isReady) return;
        _interstitialAd.show();
        _isReady = false;
        _interstitialAd = null;
      },
    );
  }
}
