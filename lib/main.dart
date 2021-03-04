import 'package:flutter/material.dart';
import 'package:flutter_ads/banner_ad_widget.dart';
import 'package:flutter_ads/interstitial_ad_button.dart';
import 'package:flutter_ads/rewarded_ad_button.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ads Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Ads Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _SizeChangeableBanner(),
            InterstitialAdButton(),
            RewardedAdButton(),
          ],
        ),
      ),
    );
  }
}

class _SizeChangeableBanner extends StatefulWidget {
  @override
  _SizeChangeableBannerState createState() => _SizeChangeableBannerState();
}

class _SizeChangeableBannerState extends State<_SizeChangeableBanner> {
  AdSize _size = AdSize.banner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<AdSize>(
          value: _size,
          onChanged: (size) {
            setState(() {
              if (size != null) _size = size;
            });
          },
          items: [
            AdSize.banner,
            AdSize.fullBanner,
            AdSize.largeBanner,
            AdSize.mediumRectangle,
            AdSize.leaderboard,
          ]
              .map((size) => DropdownMenuItem(
                    value: size,
                    child: Text('${size.width}x${size.height}'),
                  ))
              .toList(),
        ),
        BannerAdWidget(size: _size),
      ],
    );
  }
}
