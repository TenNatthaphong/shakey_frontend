import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';

class MemberCardPage extends StatefulWidget {
  const MemberCardPage({super.key});

  @override
  State<MemberCardPage> createState() => _MemberCardPageState();
}

class _MemberCardPageState extends State<MemberCardPage> {
  void _showAddCardOverlay() {
    // TODO(backend): Submit member card ID to backend and refresh card state.
    final cardIdController = TextEditingController();

    showDialog<void>(
      context: context,
      barrierColor: Colors.black54,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8EFD8),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.close, size: 22, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Add card',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColor.primaryRed,
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3D000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextField(
                    controller: cardIdController,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: 'Enter card ID here...',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB1B1B1),
                        fontSize: 12,
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: const Color(0xFFDDDDDD),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF9D9D9D)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFF9D9D9D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColor.primaryRed),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SizedBox(
                  height: 24,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryRed,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      elevation: 8,
                      shadowColor: const Color(0x61000000),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('ADD'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) => cardIdController.dispose());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFD8),
      appBar: AppBar(
        backgroundColor: AppColor.primaryRed,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left),
        ),
        title: const Text(
          'Member Card',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 32,
            decoration: TextDecoration.underline,
            decorationColor: Color(0xFF6FD4FF),
            decorationThickness: 2,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _showAddCardOverlay,
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 205,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFD4CEC8),
                        Color(0xFFB18E85),
                        Color(0xFF4B3D4A),
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Shakey',
                    style: TextStyle(
                      color: AppColor.primaryRed,
                      fontWeight: FontWeight.w500,
                      fontSize: 72,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // TODO(backend): Replace all member profile and privileges data with API response.
                      _MemberInfoLine(label: "Card's ID", value: '0123456789'),
                      SizedBox(height: 12),
                      _MemberInfoLine(label: 'Expired Date', value: '30/12/2569'),
                      SizedBox(height: 14),
                      Text(
                        'Privileges',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColor.primaryRed,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Gold member',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFC59D32),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 12),
                      _MemberInfoLine(
                        label: 'From regular price',
                        value: '10% Discount',
                      ),
                      SizedBox(height: 12),
                      _MemberInfoLine(
                        label: 'Every Flavor',
                        value: 'Birtday 50% Discount',
                      ),
                      SizedBox(height: 12),
                      _MemberInfoLine(label: 'On Sunday', value: 'Free Topping'),
                      SizedBox(height: 12),
                      _MemberInfoLine(
                        label: 'When purchase member card',
                        value: 'Get Free 1 Shake',
                        drawDivider: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberInfoLine extends StatelessWidget {
  const _MemberInfoLine({
    required this.label,
    required this.value,
    this.drawDivider = true,
  });

  final String label;
  final String value;
  final bool drawDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF9A9A9A),
            fontSize: 20,
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 32,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        if (drawDivider) ...[
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1.6, color: Color(0xFFCBCBCB)),
        ],
      ],
    );
  }
}
