import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'MorningRoutine.dart';
import 'SleepStories.dart';
import 'package:url_launcher/url_launcher.dart';
import 'MoodFood.dart';
import 'HydrationChallenge.dart';
import 'constants/colors.dart';
import 'travel.dart';
import 'exercise.dart';
import 'guthealth.dart';
import 'skincare.dart';
import 'MentalSupport.dart'; // Import for MentalSupportScreen

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  String _selectedCategory = 'Meditation';
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;

  final Map<String, List<Map<String, dynamic>>> contentData = {
    'Meditation': [
      {
        'title': '5-Min Morning Calm',
        'subtitle': 'Mindfulness',
        'icon': Icons.self_improvement_rounded,
        'color': kCardMentalTeal
      },
      {
        'title': 'Sleep Stories',
        'subtitle': 'Bedtime Relaxation',
        'icon': Icons.nights_stay_rounded,
        'color': kCardGamesPurple
      },
      {
        'title': 'Anxiety Relief',
        'subtitle': 'Quick Session',
        'icon': Icons.spa_rounded,
        'color': kPrimaryDarkPink,
      },
    ],
    'Music': [
      {
        'title': 'Focus Beats',
        'subtitle': 'Concentration',
        'icon': Icons.music_note_rounded,
        'color': kCardPodcastBlue,
        'audioUrl': 'https://cdn.pixabay.com/audio/2023/08/08/audio_b8e5865df1.mp3',
      },
      {
        'title': 'Soothing Piano',
        'subtitle': 'Relaxation',
        'icon': Icons.piano_rounded,
        'color': kCardPeriodRed,
        'audioUrl': 'https://cdn.pixabay.com/audio/2023/03/28/audio_6e5bece4f6.mp3',
      },
      {
        'title': 'Calm Nature Sounds',
        'subtitle': 'Ambient',
        'icon': Icons.forest_rounded,
        'color': kCardMentalTeal.withOpacity(0.8),
        'audioUrl': 'https://cdn.pixabay.com/audio/2022/08/02/audio_d2b76c6e95.mp3',
      },
    ],
    'Exercise': [
      {
        'title': 'Gentle Yoga Flow',
        'subtitle': 'Stress release',
        'icon': Icons.accessibility_new_rounded,
        'color': kCardPregnancyOrange
      },
      {
        'title': 'Walking Trails',
        'subtitle': 'Outdoor activity',
        'icon': Icons.directions_walk_rounded,
        'color': const Color.fromARGB(255, 195, 104, 133)
      },
      {
        'title': 'Desk Stretches',
        'subtitle': 'Quick break',
        'icon': Icons.chair_rounded,
        'color': kCardGamesPurple.withOpacity(0.9)
      },
    ],
    'Diet': [
      {
        'title': 'Mood-Boosting Foods',
        'subtitle': 'Nutrition tips',
        'icon': Icons.local_dining_rounded,
        'color': kCardBreastRed
      },
      {
        'title': 'Hydration Challenge',
        'subtitle': 'Water intake',
        'icon': Icons.water_drop_rounded,
        'color': kCardPodcastBlue.withOpacity(0.7)
      },
      {
        'title': 'Gut Health Basics',
        'subtitle': 'Wellness connection',
        'icon': Icons.healing_rounded,
        'color': kCardPeriodRed
      },
    ],
    'Travel / Tours': [
      {
        'title': 'Virtual Nature Walk',
        'subtitle': 'Forest sounds',
        'icon': Icons.terrain_rounded,
        'color': kCardMentalTeal
      },
      {
        'title': 'Visual Relaxation',
        'subtitle': 'Ocean view',
        'icon': Icons.beach_access_rounded,
        'color': kCardPregnancyOrange
      },
    ],
    'Skincare': [
      {
        'title': 'Morning Glow (SPF)',
        'subtitle': 'AM routine',
        'icon': Icons.wb_sunny_rounded,
        'color': kCardBreastRed,
      },
      {
        'title': 'Night Repair',
        'subtitle': 'PM routine',
        'icon': Icons.nightlight_round,
        'color': kCardPodcastBlue,
      },
      {
        'title': 'Hydration Boost',
        'subtitle': '5-min mask',
        'icon': Icons.opacity_rounded,
        'color': kCardMentalTeal,
      },
    ],
    // NEW: Chat with Expert category
    'Chat with Expert': [
      {
        'title': 'Mental Support',
        'subtitle': 'Get help & support',
        'icon': Icons.favorite_rounded,
        'color': kPrimaryDarkPink,
      },
    ],
  };

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(String audioUrl) async {
    try {
      if (_currentlyPlayingUrl == audioUrl && _isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        if (_currentlyPlayingUrl != audioUrl) {
          await _audioPlayer.stop();
          await _audioPlayer.play(UrlSource(audioUrl));
        } else {
          await _audioPlayer.resume();
        }
        setState(() {
          _currentlyPlayingUrl = audioUrl;
          _isPlaying = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error playing audio')),
      );
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  List<Widget> _buildCustomFields(String category) {
    List<Widget> fields = [
      TextFormField(
        decoration: const InputDecoration(labelText: 'Title'),
        onChanged: (value) => _customTitle = value,
      ),
      TextFormField(
        decoration: const InputDecoration(labelText: 'Description/Notes'),
        onChanged: (value) => _customSubtitle = value,
      ),
      const SizedBox(height: 15),
    ];

    switch (category) {
      case 'Music':
        fields.add(
          TextFormField(
            decoration: const InputDecoration(labelText: 'Audio URL (e.g., MP3 link)'),
            onChanged: (value) => _customAudioUrl = value,
          ),
        );
        break;
      case 'Travel / Tours':
        fields.add(
          TextFormField(
            decoration: const InputDecoration(labelText: 'Supporting Link'),
            onChanged: (value) => _customLink = value,
          ),
        );
        break;
      case 'Meditation':
        fields.add(
          TextFormField(
            decoration: const InputDecoration(labelText: 'Supporting Link (Optional)'),
            onChanged: (value) => _customLink = value,
          ),
        );
        fields.add(
          OutlinedButton.icon(
            icon: const Icon(Icons.camera_alt_rounded, color: kPrimaryDarkPink),
            label: const Text('Upload Image (Optional)',
                style: TextStyle(color: kPrimaryDarkPink)),
            onPressed: () {
              // Placeholder for image upload logic
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kPrimaryLightPink),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        );
        break;
      case 'Exercise':
      case 'Diet':
        fields.add(
          TextFormField(
            decoration: const InputDecoration(labelText: 'Source/Reference (Optional)'),
            onChanged: (value) => _customLink = value,
          ),
        );
        break;
    }
    return fields;
  }

  String _customTitle = '';
  String _customSubtitle = '';
  String _customAudioUrl = '';
  String _customLink = '';

  void _showCustomAddDialog(String category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Custom $category Idea",
              style: GoogleFonts.poppins(color: kAppBarTextColor)),
          content: SingleChildScrollView(
            child: ListBody(
              children: _buildCustomFields(category),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: kAppBarTextColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save',
                  style: TextStyle(
                      color: kPrimaryDarkPink, fontWeight: FontWeight.bold)),
              onPressed: () {
                if (_customTitle.isNotEmpty && _customSubtitle.isNotEmpty) {
                  if (category == 'Music' && _customAudioUrl.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Audio URL is required for Music')),
                    );
                    return;
                  }

                  IconData customIcon = Icons.help_outline;
                  Color customColor = kPrimaryDarkPink;

                  switch (category) {
                    case 'Meditation':
                      customIcon = Icons.self_improvement_rounded;
                      customColor = kCardMentalTeal;
                      break;
                    case 'Music':
                      customIcon = Icons.music_note_rounded;
                      customColor = kCardPodcastBlue;
                      break;
                    case 'Exercise':
                      customIcon = Icons.accessibility_new_rounded;
                      customColor = kCardPregnancyOrange;
                      break;
                    case 'Diet':
                      customIcon = Icons.local_dining_rounded;
                      customColor = kCardBreastRed;
                      break;
                    case 'Travel / Tours':
                      customIcon = Icons.terrain_rounded;
                      customColor = kCardMentalTeal;
                      break;
                  }

                  final newItem = {
                    'title': _customTitle,
                    'subtitle': _customSubtitle,
                    'icon': customIcon,
                    'color': customColor,
                  };

                  if (category == 'Music') {
                    newItem['audioUrl'] = _customAudioUrl;
                  }

                  setState(() {
                    contentData[category]!.insert(contentData[category]!.length - 1, newItem);
                  });
                  Navigator.of(context).pop();
                  _customTitle = '';
                  _customSubtitle = '';
                  _customAudioUrl = '';
                  _customLink = '';
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kAppBarTextColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Mental Health Hub',
            style: GoogleFonts.poppins(
                color: kAppBarTextColor, fontWeight: FontWeight.bold)),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: kAppBarTextColor),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategorySegmentedControl(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(_selectedCategory,
                        style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: kAppBarTextColor)),
                  ),
                  const SizedBox(height: 15),
                  _buildHorizontalContentList(contentData[_selectedCategory] ?? []),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySegmentedControl() {
    return Container(
      height: 50,
      color: kSectionGrey,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: contentData.keys.map((category) {
          bool isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = category;
                  if (_isPlaying) {
                    _audioPlayer.stop();
                    _isPlaying = false;
                    _currentlyPlayingUrl = null;
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? kPrimaryDarkPink : kWhiteCardColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                      color: isSelected ? kPrimaryDarkPink : Colors.grey.shade300),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: GoogleFonts.poppins(
                      color: isSelected ? kWhiteCardColor : kAppBarTextColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHorizontalContentList(List<Map<String, dynamic>> contentList) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: contentList.length,
        itemBuilder: (context, index) {
          final content = contentList[index];
          return Padding(
            padding: EdgeInsets.only(right: index == contentList.length - 1 ? 0 : 16.0),
            child: content.containsKey('isCustomAdd') && content['isCustomAdd'] == true
                ? _buildCustomAddCard(content['category'] as String)
                : _buildContentCard(content),
          );
        },
      ),
    );
  }

  Widget _buildCustomAddCard(String category) {
    return GestureDetector(
      onTap: () => _showCustomAddDialog(category),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kSectionGrey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: kPrimaryLightPink, width: 3, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kPrimaryDarkPink.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_circle_outline_rounded,
                  color: kPrimaryDarkPink, size: 36),
            ),
            const SizedBox(height: 10),
            Text(
              "Add Custom",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: kPrimaryDarkPink),
              textAlign: TextAlign.center,
            ),
            Text(
              category,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: kAppBarTextColor.withOpacity(0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard(Map<String, dynamic> content) {
    final isMusicCategory = _selectedCategory == 'Music';
    final isPlayingThis =
        isMusicCategory && _currentlyPlayingUrl == content['audioUrl'] && _isPlaying;

    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: content['color'] as Color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: (content['color'] as Color).withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kWhiteCardColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(content['icon'] as IconData, color: Colors.white, size: 36),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content['title'] as String,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                content['subtitle'] as String,
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.white70),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (isMusicCategory)
                GestureDetector(
                  onTap: () => _toggleAudio(content['audioUrl'] as String),
                  child: Row(
                    children: [
                      Icon(
                        isPlayingThis
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_filled_rounded,
                        color: kWhiteCardColor,
                        size: 24,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isPlayingThis ? 'Pause' : 'Play Now',
                        style: GoogleFonts.poppins(
                            color: kWhiteCardColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () {
                    if (_isPlaying) {
                      _audioPlayer.stop();
                      _isPlaying = false;
                      _currentlyPlayingUrl = null;
                    }

                    // Handle Chat with Expert navigation
                    if (_selectedCategory == 'Chat with Expert') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MentalSupportScreen()),
                      );
                    }
                    else if (content['title'] == '5-Min Morning Calm') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FiveMinuteMorningCalmScreen()),
                      );
                    } else if (content['title'] == 'Anxiety Relief') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnxietyReliefScreen()),
                      );
                    } else if (content['title'] == 'Sleep Stories') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SleepStoriesScreen()),
                      );
                    } else if (content['title'] == 'Mood-Boosting Foods') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MoodFoodScreen()),
                      );
                    } else if (content['title'] == 'Hydration Challenge') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HydrationChallengeScreen()),
                      );
                    }
                    else if (_selectedCategory == 'Travel / Tours' && content['title'] == 'Virtual Nature Walk') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VirtualNatureWalkPage()));
                    } else if (_selectedCategory == 'Travel / Tours' && content['title'] == 'Visual Relaxation') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const VisualRelaxationPage()));
                    }
                    else if (_selectedCategory == 'Exercise' && content['title'] == 'Gentle Yoga Flow') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GentleYogaFlowPage()));
                    } else if (_selectedCategory == 'Exercise' && content['title'] == 'Walking Trails') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const WalkingTrailsPage()));
                    } else if (_selectedCategory == 'Exercise' && content['title'] == 'Desk Stretches') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const DeskStretchesPage()));
                    }
                    else if (_selectedCategory == 'Diet' && content['title'] == 'Gut Health Basics') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GutHealthBasicsPage()));
                    }
                    else if (_selectedCategory == 'Skincare' && content['title'] == 'Morning Glow (SPF)') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MorningGlowPage()));
                    } else if (_selectedCategory == 'Skincare' && content['title'] == 'Night Repair') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const NightRepairPage()));
                    } else if (_selectedCategory == 'Skincare' && content['title'] == 'Hydration Boost') {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const HydrationBoostPage()));
                    }
                    else if (content.containsKey('link') && content['link'] != null) {
                      _launchUrl(content['link'] as String);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Coming soon: ${content['title']}')),
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        'Start Now',
                        style: GoogleFonts.poppins(
                            color: kWhiteCardColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: kWhiteCardColor, size: 14),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Rest of the code remains the same (AnxietyReliefScreen)
class AnxietyReliefScreen extends StatefulWidget {
  const AnxietyReliefScreen({super.key});

  @override
  State<AnxietyReliefScreen> createState() => _AnxietyReliefScreenState();
}

class _AnxietyReliefScreenState extends State<AnxietyReliefScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isSessionRunning = true;
  final String _audioUrl =
      'https://cdn.pixabay.com/audio/2022/08/02/audio_d2b76c6e95.mp3';
  int _breathingCycles = 0;
  String _breathingPhase = 'Inhale';
  double _progress = 0.0;
  late AnimationController _animationController;
  Timer? _breathingTimer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 19),
    )..addListener(() {
      setState(() {
        _progress = _animationController.value;
        if (_progress < 4 / 19) {
          _breathingPhase = 'Inhale';
        } else if (_progress < 11 / 19) {
          _breathingPhase = 'Hold';
        } else {
          _breathingPhase = 'Exhale';
        }
      });
    });

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _breathingCycles++;
        });
        _animationController.reset();
        if (_isSessionRunning) {
          _startBreathingCycle();
        }
      }
    });

    _startBreathingCycle();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    _breathingTimer?.cancel();
    super.dispose();
  }

  void _startBreathingCycle() {
    _breathingTimer?.cancel();
    _animationController.forward();
    setState(() {
      _isSessionRunning = true;
    });
  }

  void _resetSession() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBackgroundColor,
          title: Text(
            'Reset Session',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kAppBarTextColor,
            ),
          ),
          content: Text(
            'Are you sure you want to reset the session? This will clear all progress.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: kAppBarTextColor.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(color: kAppBarTextColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _animationController.stop();
                _animationController.reset();
                _breathingTimer?.cancel();
                if (_isPlaying) {
                  _audioPlayer.stop();
                }
                setState(() {
                  _breathingCycles = 0;
                  _progress = 0.0;
                  _breathingPhase = 'Inhale';
                  _isPlaying = false;
                  _isSessionRunning = false;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Session reset successfully',
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                    backgroundColor: kPrimaryDarkPink,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryDarkPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Reset',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _toggleAudio() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer.play(UrlSource(_audioUrl));
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error playing audio')),
      );
    }
  }

  String _getMotivationalMessage() {
    if (_breathingCycles < 2) {
      return 'Great start! Keep breathing to feel calmer.';
    } else if (_breathingCycles < 5) {
      return 'You are doing amazing! Feel the calm wash over you.';
    } else {
      return 'Wow, you are a pro! Keep it up for ultimate relaxation.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: kAppBarTextColor),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Anxiety Relief',
          style: GoogleFonts.poppins(
            color: kAppBarTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: kAppBarTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _breathingPhase,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: kPrimaryDarkPink,
              ),
            ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 10,
                    backgroundColor: kPrimaryLightPink,
                    valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryDarkPink),
                  ),
                ),
                Text(
                  '${((_progress * 19).round())}s',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    color: kAppBarTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Cycles Completed: $_breathingCycles',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: kAppBarTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _getMotivationalMessage(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: kAppBarTextColor.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kWhiteCardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryDarkPink.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleAudio,
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                      color: kPrimaryDarkPink,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _isPlaying ? 'Pause Calming Audio' : 'Play Calming Audio',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: kPrimaryDarkPink,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isSessionRunning
                      ? null
                      : () {
                    _startBreathingCycle();
                    if (_isPlaying) {
                      _audioPlayer.resume();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kCardMentalTeal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                    shadowColor: kCardMentalTeal.withOpacity(0.4),
                  ),
                  child: Text(
                    'Resume/Continue',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: kWhiteCardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryDarkPink,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5,
                    shadowColor: kPrimaryDarkPink.withOpacity(0.4),
                  ),
                  child: Text(
                    'Stop Session',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: kWhiteCardColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
