import 'package:flutter/material.dart';
import 'package:newjarvis/components/chat_participant.dart';

class WelcomeChatSection extends StatefulWidget {
  const WelcomeChatSection({super.key});

  @override
  State<WelcomeChatSection> createState() => _WelcomeChatSectionState();
}

class _WelcomeChatSectionState extends State<WelcomeChatSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                botParticipant.icon,
                const SizedBox(width: 5),
                Text(
                  botParticipant.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ],
            ),
            Text(
              'Hi, welcome abroad 🚀',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            // Horizontal Divider
            Divider(
              color: Theme.of(context).colorScheme.primary,
              thickness: 1,
              height: 20,
            ),

            RichText(
              text: TextSpan(
                text:
                    "Jarvis KB is a cutting-edge AI App development platform designed. With Jarvis KB, you can effortlessly create and deploy various chatbots across numerous social platforms and messaging apps like Messenger, Telegram, and Slack!",
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              "Why Choose Jarvis KB?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "We offer robust and flexible solutions to meet your chatbot development needs. Here's what makes Jarvis KB stand out:",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),

            const SizedBox(height: 16),

            _buildFeatureItem(
              icon: Icons.language,
              title: "Multi-Source Knowledge Integration 🌐",
              description:
                  "Seamlessly integrate various types of knowledge from multiple data sources such as Websites, Google Drive, GitHub, GitLab, Notion, and more. This ensures your chatbot has access to a rich repository of information.",
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(
              icon: Icons.code,
              title: "Comprehensive SDK 🛠️",
              description:
                  "Our SDK provides the tools and resources needed to integrate chatbots into your own applications with ease.",
            ),
            const SizedBox(height: 16),

            _buildFeatureItem(
              icon: Icons.face,
              title: "User-Friendly Interface 🎨",
              description:
                  "Designed with simplicity in mind, our platform allows both novice and experienced developers to create and manage chatbots without hassle.",
            ),

            const SizedBox(height: 16),

            _buildFeatureItem(
              icon: Icons.group,
              title: "Collaboration Features 🤝",
              description:
                  "Collaborate with other bots to enhance functionality and provide a richer user experience. Jarvis KB enables multiple bots to work together seamlessly.",
            ),

            const SizedBox(height: 16),

            _buildFeatureItem(
              icon: Icons.bar_chart,
              title: "Scalable Solutions 📈",
              description:
                  "Whether you're a small business or a large enterprise, our platform scales to meet your demands, ensuring reliable and efficient chatbot performance. 🌟",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      {required IconData icon,
      required String title,
      required String description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bullet
        Icon(
          Icons.brightness_1,
          size: 10,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),

        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
