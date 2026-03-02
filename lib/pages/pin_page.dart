import 'package:flutter/material.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/router.dart';
import 'package:shakey/services/auth_service.dart';

class PinPage extends StatefulWidget {
  final bool isSetting;

  const PinPage({super.key, this.isSetting = false});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  String _pin = '';
  String _confirmPin = '';
  String _oldPin = '';
  bool _isVerifyingOldPin = false;
  bool _isConfirming = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // If we are setting a new PIN and one already exists, we must verify the old one first.
    if (widget.isSetting && AuthService.instance.hasPin) {
      _isVerifyingOldPin = true;
    }
  }

  void _onNumberPressed(int number) {
    setState(() {
      _errorMessage = '';
      if (_isVerifyingOldPin) {
        if (_oldPin.length < 6) _oldPin += number.toString();
        if (_oldPin.length == 6) _handlePinEntry();
      } else if (_isConfirming) {
        if (_confirmPin.length < 6) _confirmPin += number.toString();
        if (_confirmPin.length == 6) _handlePinEntry();
      } else {
        if (_pin.length < 6) _pin += number.toString();
        if (_pin.length == 6) {
          if (widget.isSetting) {
            _isConfirming = true;
          } else {
            _handlePinEntry();
          }
        }
      }
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (_isVerifyingOldPin) {
        if (_oldPin.isNotEmpty) {
          _oldPin = _oldPin.substring(0, _oldPin.length - 1);
        }
      } else if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  Future<void> _handlePinEntry() async {
    if (_isVerifyingOldPin) {
      if (AuthService.instance.verifyPin(_oldPin)) {
        setState(() {
          _isVerifyingOldPin = false;
          _errorMessage = '';
        });
      } else {
        setState(() {
          _oldPin = '';
          _errorMessage = 'Incorrect old PIN. Please try again.';
        });
      }
    } else if (widget.isSetting) {
      if (_pin == _confirmPin) {
        await AuthService.instance.savePin(_pin);
        if (mounted) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
          }
        }
      } else {
        setState(() {
          _confirmPin = '';
          _errorMessage = 'PINs do not match. Try again.';
        });
      }
    } else {
      if (AuthService.instance.verifyPin(_pin)) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homePage);
        }
      } else {
        setState(() {
          _pin = '';
          _errorMessage = 'Incorrect PIN. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentCode = _isVerifyingOldPin
        ? _oldPin
        : (_isConfirming ? _confirmPin : _pin);

    String title = 'Enter your PIN';
    if (widget.isSetting) {
      if (_isVerifyingOldPin) {
        title = 'Enter your old PIN';
      } else if (_isConfirming) {
        title = 'Confirm your new PIN';
      } else {
        title = 'Set your new 6-digit PIN';
      }
    }

    return Scaffold(
      backgroundColor: AppColor.primaryRed,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                bool isFilled = index < currentCode.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isFilled ? Colors.white : Colors.white24,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                );
              }),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.yellow, fontSize: 14),
                ),
              ),
            const Spacer(),
            _buildKeypad(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [for (var j = 1; j <= 3; j++) _buildKey(i * 3 + j)],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(width: 80),
            _buildKey(0),
            _buildDeleteKey(),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(int number) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: () => _onNumberPressed(number),
          customBorder: const CircleBorder(),
          child: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: Text(
              number.toString(),
              style: const TextStyle(
                color: AppColor.primaryRed,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteKey() {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: _onDeletePressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            child: const Icon(Icons.backspace_outlined, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
