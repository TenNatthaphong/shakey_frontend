import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shakey/app_color.dart';
import 'package:shakey/models/user.dart';
import 'package:shakey/services/user_service.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _firstnameController;
  late TextEditingController _lastnameController;
  late TextEditingController _phoneController;
  late TextEditingController _birthdayController;
  DateTime? _selectedBirthday;
  bool _isLoading = false;
  final UserService _userService = UserService.instance;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _firstnameController = TextEditingController(text: widget.user.firstname);
    _lastnameController = TextEditingController(text: widget.user.lastname);
    _phoneController = TextEditingController(text: widget.user.phone);
    _selectedBirthday = widget.user.birthday;
    _birthdayController = TextEditingController(
      text: _formatDateDisplay(_selectedBirthday),
    );
  }

  String _formatDateDisplay(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateApi(DateTime? date) {
    if (date == null) return '';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> _selectDate() async {
    DateTime tempDate = _selectedBirthday ?? DateTime(2000, 1, 1);
    await showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 350,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Color(0xFFF8F8F8),
                border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const Text(
                    'Select Birthday',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedBirthday = tempDate;
                        _birthdayController.text = _formatDateDisplay(tempDate);
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: AppColor.primaryRed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                backgroundColor: Colors.white,
                initialDateTime: tempDate,
                minimumYear: 1900,
                maximumYear: DateTime.now().year,
                onDateTimeChanged: (picked) {
                  tempDate = picked;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updateData = {
      'username': _usernameController.text.trim(),
      'firstname': _firstnameController.text.trim(),
      'lastname': _lastnameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'birthday': _selectedBirthday != null
          ? _formatDateApi(_selectedBirthday)
          : null,
    };

    final success = await _userService.updateProfile(updateData);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.of(
          context,
        ).pop(true); // Return true to indicate refresh needed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildFieldLabel('Username'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _usernameController,
                hint: 'Enter username',
                validator: (v) => v!.isEmpty ? 'Please enter username' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('First Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _firstnameController,
                hint: 'Enter first name',
                validator: (v) => v!.isEmpty ? 'Please enter first name' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Last Name'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _lastnameController,
                hint: 'Enter last name',
                validator: (v) => v!.isEmpty ? 'Please enter last name' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Phone Number'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hint: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v!.isEmpty ? 'Please enter phone number' : null,
              ),
              const SizedBox(height: 20),
              _buildFieldLabel('Birthday'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: _buildTextField(
                    controller: _birthdayController,
                    hint: 'Select birthday',
                    suffixIcon: const Icon(Icons.calendar_today, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'SAVE CHANGES',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.primaryRed, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }
}
