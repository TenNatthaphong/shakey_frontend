import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/menu.dart';
import 'package:shakey/pages/coupon_detail_page.dart';
import 'package:shakey/services/menu_service.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({super.key});

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage>
    with SingleTickerProviderStateMixin {
  final MenuService _menuService = MenuService();
  late TabController _tabController;

  List<MenuReward> _availableRewards = [];
  List<UserReward> _myRewards = [];
  bool _isLoading = true;
  int _userPoints = 60; // Mock points, should be from User API

  // Mock User ID for testing - Replace with real Auth ID when available
  static const String _mockUserId = '00000000-0000-0000-0000-000000000000';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final available = await _menuService.getRewardList();
      final myRewards = await _menuService.getUserRewards(_mockUserId);

      if (mounted) {
        setState(() {
          _availableRewards = available;
          _myRewards = myRewards;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPrivilegeDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gold Member Privileges'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• 10% discount on all drinks'),
            Text('• Birthday special gift'),
            Text('• Double points on weekends'),
            Text('• Exclusive early access to new menus'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E6),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildPointHeader(),
          _buildTabBar(),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [_buildRewardCards(), _buildMyRewards()],
        ),
      ),
    );
  }

  Widget _buildPointHeader() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: const BoxDecoration(
          gradient: AppColor.goldGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gold Member',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      '$_userPoints Points',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _showPrivilegeDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  child: const Text('Privilege'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _userPoints / 100,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Another 40 points to reach Platinum',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        Container(
          color: const Color(0xFFFFF7E6),
          child: TabBar(
            controller: _tabController,
            labelColor: AppColor.primaryRed,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColor.primaryRed,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [
              Tab(text: 'Available'),
              Tab(text: 'My Rewards'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardCards() {
    if (_isLoading)
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryRed),
      );
    if (_availableRewards.isEmpty)
      return const Center(child: Text('No rewards available.'));

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
        mainAxisExtent: 270,
      ),
      itemCount: _availableRewards.length,
      itemBuilder: (context, index) =>
          _buildRewardCard(_availableRewards[index]),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'No Expiry';
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _handleRedeem(MenuReward reward) async {
    if (_userPoints < reward.points) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not enough points!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await _menuService.redeemReward(_mockUserId, reward.id);
    if (success && mounted) {
      setState(() => _userPoints -= reward.points);
      _fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redeemed! Check "My Rewards" tab.'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to redeem. Try again.')),
      );
    }
  }

  Widget _buildRewardCard(MenuReward reward) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CouponDetailPage(previewReward: reward),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                height: 130,
                width: double.infinity,
                child: reward.image != null && reward.image!.startsWith('http')
                    ? Image.network(reward.image!, fit: BoxFit.cover)
                    : Image.asset(
                        'assets/images/Chocolate.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // Text info
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xFF2F2F34),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Valid until ${_formatDate(reward.expDate)}',
                    style: const TextStyle(
                      color: Color(0xFF8A909C),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${reward.points} Pts',
                    style: const TextStyle(
                      color: AppColor.primaryRed,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Floating rounded Redeem button
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: SizedBox(
                height: 36,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleRedeem(reward),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Redeem Now',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyRewards() {
    if (_isLoading)
      return const Center(
        child: CircularProgressIndicator(color: AppColor.primaryRed),
      );
    if (_myRewards.isEmpty)
      return const Center(child: Text('You don\'t have any rewards yet.'));

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _myRewards.length,
      itemBuilder: (context, index) => _buildMyRewardCard(_myRewards[index]),
    );
  }

  Widget _buildMyRewardCard(UserReward userReward) {
    final reward = userReward.reward;
    if (reward == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.primaryRed.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: reward.image != null && reward.image!.startsWith('http')
                  ? Image.network(reward.image!, fit: BoxFit.cover)
                  : Image.asset(
                      'assets/images/Chocolate.png',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Status: ${userReward.status}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 11),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _useCoupon(userReward),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFAA8515),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(0, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Use', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  void _useCoupon(UserReward userReward) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CouponDetailPage(
          userReward: userReward,
          onUsed: () => _fetchData(),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final Container _tabBar;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return _tabBar;
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
