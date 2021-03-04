import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdButton extends StatefulWidget {
  @override
  _RewardedAdButtonState createState() => _RewardedAdButtonState();
}

class _RewardedAdButtonState extends State<RewardedAdButton> {
  RewardedAd _rewardedAd;
  bool _isReady = false;

  num reward = 0;

  @override
  void initState() {
    super.initState();
    createAd();
  }

  void createAd() {
    _rewardedAd ??= RewardedAd(
      adUnitId: RewardedAd.testAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          print('${ad.runtimeType} loaded!');
          _isReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          print('${ad.runtimeType} failed to load.\n$error');
          ad.dispose();
          _rewardedAd = null;
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
        onRewardedAdUserEarnedReward: (ad, item) {
          print(
              '$RewardedAd with reward $RewardItem(${item.amount}, ${item.type})');
          setState(() {
            reward += item.amount;
          });
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _rewardedAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          child: Text('show Rewarded Ad'),
          onPressed: () {
            if (!_isReady) return;
            _rewardedAd.show();
            _isReady = false;
            _rewardedAd = null;
          },
        ),
        Text('Current Rewards: $reward'),
      ],
    );
  }
}
