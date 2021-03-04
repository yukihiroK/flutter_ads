import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  BannerAdWidget({@required this.size});

  final AdSize size;

  @override
  _BannerAdWidgetState createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd _bannerAd;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), createAd);
  }

  createAd() {
    _bannerAd = BannerAd(
      size: widget.size,
      adUnitId: BannerAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          print('${ad.runtimeType} loaded!');
          setState(() {
            _isReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('${ad.runtimeType} failed to load.\n$error');
          ad.dispose();
          _bannerAd = null;
        },
        onApplicationExit: (Ad ad) =>
            print('${ad.runtimeType} onApplicationExit.'),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BannerAdWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _bannerAd?.dispose();
    _bannerAd = null;
    createAd();
    setState(() {
      _isReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orange,
      width: widget.size.width.toDouble(),
      height: widget.size.height.toDouble(),
      child: _isReady
          ? AdWidget(ad: _bannerAd)
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
