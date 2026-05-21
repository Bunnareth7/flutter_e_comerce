import 'package:e_com_app/features/profile/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_avatar.dart';
import '../bloc/profile_event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
      child: Scaffold(
        appBar: AppBar(title: const Text('My Profile')),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Profile updated')));
              context.read<ProfileBloc>().add(LoadProfile());
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileLoaded) {
              return _buildProfileContent(context, state.profile);
            } else if (state is ProfileUpdating) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, profile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          ProfileAvatar(imageUrl: profile.avatarUrl, name: profile.name),
          const SizedBox(height: 24),
          _buildInfoRow('Name', profile.name),
          _buildInfoRow('Email', profile.email),
          if (profile.phone != null) _buildInfoRow('Phone', profile.phone),
          if (profile.address != null)
            _buildInfoRow('Address', profile.address),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _showEditDialog(context, profile),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Profile'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value ?? 'Not set')),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, profile) {
    final nameCtrl = TextEditingController(text: profile.name);
    final phoneCtrl = TextEditingController(text: profile.phone ?? '');
    final addressCtrl = TextEditingController(text: profile.address ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: addressCtrl,
                decoration: const InputDecoration(labelText: 'Address'),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = UserProfile(
                id: profile.id,
                email: profile.email,
                name: nameCtrl.text.trim(),
                phone: phoneCtrl.text.trim().isEmpty
                    ? null
                    : phoneCtrl.text.trim(),
                address: addressCtrl.text.trim().isEmpty
                    ? null
                    : addressCtrl.text.trim(),
                avatarUrl: profile.avatarUrl,
              );
              context.read<ProfileBloc>().add(UpdateProfileEvent(updated));
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
