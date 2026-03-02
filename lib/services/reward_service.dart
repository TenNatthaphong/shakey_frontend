import 'package:shakey/models/menu.dart';
import 'package:shakey/services/auth_service.dart';

class RewardService {
  Future<List<MenuReward>> getRewardList() async {
    try {
      final response = await AuthService.instance.dio.get('/reward');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => MenuReward.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching reward list: $e');
    }
    return [];
  }

  Future<List<UserReward>> getUserRewards() async {
    try {
      final response = await AuthService.instance.dio.get('/reward/my_rewards');

      print('Fetching My Rewards: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => UserReward.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching user rewards: $e');
    }
    return [];
  }

  Future<bool> redeemReward(String rewardId) async {
    try {
      final response = await AuthService.instance.dio.post(
        '/user/reward/redeem',
        data: {'reward_id': rewardId},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error redeeming reward: $e');
      return false;
    }
  }

  Future<bool> useReward(String userRewardId) async {
    try {
      final response = await AuthService.instance.dio.post(
        '/user/reward/use',
        data: {'user_reward_id': userRewardId},
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error using reward: $e');
      return false;
    }
  }
}
