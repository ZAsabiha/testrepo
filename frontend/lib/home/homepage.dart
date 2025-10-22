import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../signup.dart' as signup;
import '../history/history_manager.dart';
import '../../constants/colors.dart';
import 'home_app_bar.dart';
import 'wavy_header.dart';
import 'welcome_card.dart';
import 'feature_grid.dart';

class HerCareHomePage extends StatefulWidget {
  const HerCareHomePage({super.key});

  @override
  State<HerCareHomePage> createState() => _HerCareHomePageState();
}

class _HerCareHomePageState extends State<HerCareHomePage> {
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    setState(() {
      userEmail = null;
    });

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const signup.SignUpScreen()),
          (route) => false,
    );
  }

  final List<Map<String, dynamic>> landingFeatures = [
    {
      'title': 'Period Tracker',
      'subtitle': 'Track your cycle status',
      'icon': Icons.calendar_today_rounded,
      'emoji': '📅',
      'color': kCardPeriodRed,
      'category': 'Menstrual Health',
      'route': '/period',
    },
    {
      'title': 'Pregnancy Tracker',
      'subtitle': 'Monitor growth, week by week.',
      'icon': Icons.pregnant_woman_rounded,
      'emoji': '🤰',
      'color': kCardPregnancyOrange,
      'category': 'Pregnancy',
      'route': '/pregnancy',
    },
    {
      'title': 'Mental Health',
      'subtitle': 'Meditations, journal & support',
      'icon': Icons.self_improvement_rounded,
      'emoji': '🧠',
      'color': kCardMentalTeal,
      'category': 'Mental Wellness',
      'route': '/mental',
    },
    {
      'title': 'Breast Health Check',
      'subtitle': 'Self-exam guide & detection',
      'icon': Icons.visibility_rounded,
      'emoji': '🎗️',
      'color': kCardBreastRed,
      'category': 'Cancer Awareness',
      'route': '/breast',
    },

    {
      'title': 'Podcasts',
      'subtitle': 'Listen to expert wellness adv...',
      'icon': Icons.mic_external_on_rounded,
      'emoji': '🎧',
      'color': kCardPodcastBlue,
      'category': 'Education',
      'route': '/podcast',
    },
  ];

  void _onFeatureTap(Map<String, dynamic> feature, BuildContext context) {
    // Create a data map for the feature
    final featureData = {
      'title': feature['title'],
      'emoji': feature['emoji'],
      'route': feature['route'] ?? '',
    };

    // Add to history
    HistoryManager().addHistory(
      feature['category'] as String, // category
      featureData,                   // data
    );

    // Navigate or show "coming soon"
    final String route = feature['route'] as String? ?? '';
    if (route.isNotEmpty) {
      Navigator.pushNamed(context, route);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${feature['title']} - Coming Soon!'),
          backgroundColor: kPrimaryDarkPink,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 250.0;
    const double welcomeCardHeight = 150.0;
    const double overlap = welcomeCardHeight / 3;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: HomeAppBar(
        userEmail: userEmail,
        onLogout: () => _logout(context),
        onSignIn: () => Navigator.pushNamed(context, '/signup'),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WavyHeader(height: headerHeight),
            Transform.translate(
              offset: const Offset(0.0, -overlap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WelcomeCard(userEmail: userEmail),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 25, 20, 10),
                    child: Text(
                      "Choose Your Focus Today",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kAppBarTextColor),
                    ),
                  ),
                  FeatureGrid(
                    landingFeatures: landingFeatures,
                    onFeatureTap: _onFeatureTap,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
