import 'package:shakey/config.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BannerService extends ChangeNotifier {
  static final BannerService instance = BannerService._internal();
  BannerService._internal();

  List<String> _banners = [];
  List<String> get banners => _banners;

  final String _cacheKey = 'cached_banners';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getStringList(_cacheKey);
    if (cached != null) {
      _banners = cached;
      notifyListeners();
    }
    // Fetch in background after init
    getBanners();
  }

  Future<List<String>> getBanners() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConfig.baseUrl}/banner'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> newBanners = data
            .map((url) => url.toString())
            .toList();

        if (!listEquals(_banners, newBanners)) {
          _banners = newBanners;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setStringList(_cacheKey, _banners);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error fetching banners in BannerService: $e');
    }
    return _banners;
  }
}
