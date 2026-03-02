import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shakey/models/menu.dart';
import 'package:shakey/services/auth_service.dart';

class RewardService {
  static const String baseUrl = 'http://127.0.0.1:3333';

  Future<List<MenuReward>> getRewardList() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/reward'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MenuReward.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching reward list: $e');
    }
    return [];
  }

  Future<List<UserReward>> getUserRewards() async {
    try {
      final token = AuthService.instance.accessToken;
      final response = await http
          .get(
            Uri.parse('$baseUrl/reward/my_rewards'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      print('Fetching My Rewards: ${response.statusCode}');
      print('Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => UserReward.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching user rewards: $e');
    }
    return [];
  }

  Future<bool> redeemReward(String rewardId) async {
    try {
      final token = AuthService.instance.accessToken;
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/reward/redeem'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'reward_id': rewardId}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error redeeming reward: $e');
      return false;
    }
  }

  Future<bool> useReward(String userRewardId) async {
    try {
      final token = AuthService.instance.accessToken;
      final response = await http
          .post(
            Uri.parse('$baseUrl/user/reward/use'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: json.encode({'user_reward_id': userRewardId}),
          )
          .timeout(const Duration(seconds: 10));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error using reward: $e');
      return false;
    }
  }
}
