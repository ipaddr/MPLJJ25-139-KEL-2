import 'package:flutter/material.dart';
import 'package:sekolahunggulintegrasi/presentasion/pages/role_screen.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // User profile data - in a real app, this would come from your user authentication system
  final Map<String, String> _userData = {
    'name': 'Admin Pusat',
    'organization': 'Kementerian Pendidikan',
    'email': 'admin.pusat@kemdikbud.go.id',
    'role': 'Superadmin Sistem',
    'id': 'ADM-001',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      // In a real app, you'd use a NetworkImage or AssetImage for the profile photo
                      // child: Image.asset('assets/profile_image.png'),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      _userData['name'] ?? '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // Organization
                    Text(
                      _userData['organization'] ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),

                    // Profile details
                    _buildProfileDetail('Email:', _userData['email'] ?? ''),
                    const SizedBox(height: 8),
                    _buildProfileDetail('Jabatan:', _userData['role'] ?? ''),
                    const SizedBox(height: 8),
                    _buildProfileDetail('ID Admin:', _userData['id'] ?? ''),
                    const SizedBox(height: 24),

                    // Edit Profile Button
                    _buildActionButton(
                      'Edit Profile',
                      Colors.green,
                      Icons.edit,
                      () {
                        // Add edit profile functionality here
                        debugPrint('Edit profile button pressed');
                      },
                    ),
                    const SizedBox(height: 12),

                    // Logout Button
                    _buildActionButton('Logout', Colors.blue, Icons.logout, () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => RoleScreen()),
                        (route) => false,
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build profile details
  Widget _buildProfileDetail(String label, String value) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ),
      ],
    );
  }

  // Helper method to build action buttons
  Widget _buildActionButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label),
      ),
    );
  }
}
