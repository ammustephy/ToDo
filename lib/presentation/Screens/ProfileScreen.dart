// lib/presentation/screens/profile_settings_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../bloc/UserBloc/user_bloc.dart';
import '../bloc/UserBloc/user_event.dart';
import '../bloc/UserBloc/user_state.dart';
import 'SplashScreen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  final String userId;

  const ProfileSettingsScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _imageFile;
  String? _photoUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserBloc>().state;
      if (userState is UserLoaded && mounted) {
        setState(() {
          _nameController.text = userState.user.name;
          _phoneController.text = userState.user.phone;
          _photoUrl = userState.user.photoUrl;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _isUploading = true;
      });

      try {
        final bytes = await File(pickedFile.path).readAsBytes();
        final fileExt = path.extension(pickedFile.path);
        final fileName = '${widget.userId}_${DateTime.now().millisecondsSinceEpoch}$fileExt';
        final filePath = fileName;

        if (_photoUrl != null && _photoUrl!.contains('avatars/')) {
          try {
            final oldFileName = _photoUrl!.split('avatars/').last.split('?').first;
            await Supabase.instance.client.storage
                .from('avatars')
                .remove([oldFileName]);
          } catch (e) {
            print('Error deleting old avatar: $e');
          }
        }

        await Supabase.instance.client.storage
            .from('avatars')
            .uploadBinary(
          filePath,
          bytes,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: false,
          ),
        );

        final newUrl = Supabase.instance.client.storage
            .from('avatars')
            .getPublicUrl(filePath);

        if (mounted) {
          setState(() {
            _photoUrl = newUrl;
            _imageFile = null;
            _isUploading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Upload failed';

          if (e.toString().contains('already exists')) {
            errorMessage = 'File already exists. Try again.';
          } else if (e.toString().contains('not found')) {
            errorMessage = 'Storage bucket not found. Please check Supabase configuration.';
          } else if (e.toString().contains('permission')) {
            errorMessage = 'Permission denied. Please check storage policies.';
          } else {
            errorMessage = 'Upload failed: ${e.toString()}';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );

          setState(() {
            _imageFile = null;
            _isUploading = false;
          });

          print('Upload error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'Assets/Images/leftArrow.png',
            width: 24,
            height: 24,
            color: Colors.black, // Optional: tint if needed
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: isPortrait ? 20 : 18,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF2D3142),
          ),
        ),
      ),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoaded) {
            setState(() {
              _photoUrl = state.user.photoUrl;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isPortrait ? 24 : size.width * 0.1),
          child: Column(
            children: [
              SizedBox(height: isPortrait ? 20 : 16),
              GestureDetector(
                onTap: _isUploading ? null : _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: isPortrait ? 60 : 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (_photoUrl != null && _photoUrl!.isNotEmpty
                          ? NetworkImage(_photoUrl!)
                          : null) as ImageProvider?,
                      child: _imageFile == null && (_photoUrl == null || _photoUrl!.isEmpty)
                          ? Icon(
                        Icons.person,
                        size: isPortrait ? 60 : 50,
                        color: Colors.white,
                      )
                          : null,
                    ),
                    if (_isUploading)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color(0xFF7C6CF5), width: 2),
                        ),
                        child: _isUploading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                            : const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Color(0xFF7C6CF5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isPortrait ? 40 : 30),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7C6CF5)),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF7C6CF5)),
                  ),
                  prefixIcon: const Icon(Icons.phone_outlined),
                ),
              ),
              SizedBox(height: isPortrait ? 40 : 30),
              SizedBox(
                width: double.infinity,
                height: isPortrait ? 56 : 48,
                child: ElevatedButton(
                  onPressed: _isUploading
                      ? null
                      : () {
                    if (_nameController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty) {
                      context.read<UserBloc>().add(
                        UpdateUser(
                          widget.userId,
                          _nameController.text,
                          _phoneController.text,
                          _photoUrl,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C6CF5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isUploading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: isPortrait ? 18 : 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: isPortrait ? 20 : 16),
              TextButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('user_id');

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    ),
                        (route) => false,
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: isPortrait ? 16 : 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}