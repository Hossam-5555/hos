import 'package:flutter/material.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class EnglishAbout extends StatelessWidget {
  const EnglishAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Appbarbackicon(title: "About us", herotag: ""),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Name',
             style: TextStyle(color: Colors.black,
                fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'App Name is a smart and user-friendly application designed to provide a smooth experience through a clean interface and high performance. The app is built to meet daily user needs securely.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            const Text(
              'App Features',
               style: TextStyle(color: Colors.black,
                fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            const Text('• Simple and easy-to-use interface'),
            const Text('• Fast and smooth performance'),
            const Text('• Data security and privacy'),
            const Text('• Modern and responsive design'),
            const Text('• Continuous updates'),

            const SizedBox(height: 20),
            const Text(
              'Technologies Used',
              style: TextStyle(color: Colors.black,
                fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Flutter'),
            const Text('• Firebase'),
            const Text('• REST API'),
            const Text('• Laravel / PHP'),

            const SizedBox(height: 20),
            const Text(
              'Contact Us',
              style: TextStyle(color: Colors.black,
                fontSize: 18, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 8),
            TextButton(
              child: const Text('Email: example@email.com'),
              onPressed: () {},
            ),
             TextButton(
              child: const Text('Email: example@email.com'),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
