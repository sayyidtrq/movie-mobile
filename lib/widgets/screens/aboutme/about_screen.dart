import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final Map<String, dynamic> _developerInfo = {
    'name': 'Sayyid Thariq Gilang M',
    'role': 'Mobile App Developer',
    'bio': 'Mahasiwa CS UI semester 4 yang lagi seneng flutter hehe.',
    'github': 'https://github.com/johndoe',
    'favoriteMovies': ['Interstellar', 'The Pursuit of Happynes'],
    'hobbies': ['Coding', 'Hiking', 'Main basket', 'Tidur'],
    'skills': [
      'Flutter',
      'Dart',
      'Firebase',
      'Web Development',
      'Django',
      'NextJS',
      'Laravel',
      'Java (asdos DDP2)',
      'Python',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About Developer',
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDeveloperProfileSection(),
            const SizedBox(height: 32),
            const Text(
              'Developer Information',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildDeveloperInfoCard(),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Made with ❤️ using Flutter',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'YukNonton v1.0.0',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperProfileSection() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile image with gradient border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.red.shade400, Colors.orange.shade400],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      const AssetImage('assets/images/developer.jpg'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _developerInfo['name'],
              style: const TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _developerInfo['role'],
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            // Social links/contact buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.email),
                  onPressed: () {},
                  color: Colors.red,
                ),
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {},
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _buildDeveloperInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(
              icon: Icons.info_outline_rounded,
              title: 'Bio',
              content: _developerInfo['bio'],
              isText: true,
            ),
            const Divider(),
            _buildInfoSection(
              icon: Icons.movie,
              title: 'Favorite Movies',
              content: _developerInfo['favoriteMovies'],
              isText: false,
            ),
            const Divider(),
            _buildInfoSection(
              icon: Icons.sports_esports,
              title: 'Hobbies',
              content: _developerInfo['hobbies'],
              isText: false,
            ),
            const Divider(),
            _buildInfoSection(
              icon: Icons.code,
              title: 'Skills',
              content: _developerInfo['skills'],
              isText: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required dynamic content,
    required bool isText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.red, size: 24),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: isText
                ? Text(
                    content,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (content as List).map<Widget>((item) {
                      return Chip(
                        label: Text(
                          item,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        backgroundColor: Colors.red.withOpacity(0.7),
                        padding: const EdgeInsets.all(4),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
