import 'package:flutter/material.dart';

class AwarenessPage extends StatelessWidget {
  const AwarenessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Pregnancy Awareness',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFFF69B4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategoryCard(
            context,
            'Nutrition & Diet',
            Icons.restaurant,
            Colors.green,
            _getNutritionContent(),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context,
            'Exercise & Fitness',
            Icons.fitness_center,
            Colors.blue,
            _getExerciseContent(),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context,
            'Warning Signs',
            Icons.warning_amber_rounded,
            Colors.red,
            _getWarningContent(),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context,
            'Mental Health',
            Icons.psychology,
            Colors.purple,
            _getMentalHealthContent(),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context,
            'Baby Development',
            Icons.child_care,
            Colors.pink,
            _getBabyDevelopmentContent(),
          ),
          const SizedBox(height: 16),
          _buildCategoryCard(
            context,
            'Prenatal Care',
            Icons.medical_services,
            Colors.teal,
            _getPrenatalCareContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, IconData icon,
      Color color, List<Map<String, String>> content) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(
                title: title,
                icon: icon,
                color: color,
                content: content,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getNutritionContent() {
    return [
      {
        'title': 'Essential Nutrients',
        'content': 'Folic acid (400-800 mcg daily) helps prevent neural tube defects. Iron (27 mg daily) supports increased blood volume. Calcium (1000 mg daily) builds baby\'s bones. Protein (70-100g daily) supports tissue growth. DHA omega-3 fatty acids support brain development.'
      },
      {
        'title': 'Foods to Include',
        'content': 'Leafy greens, lean proteins, whole grains, dairy products, fruits, legumes, nuts, and fortified cereals. Aim for colorful variety to ensure diverse nutrients.'
      },
      {
        'title': 'Foods to Avoid',
        'content': 'Raw or undercooked meat/eggs/fish, unpasteurized dairy, high-mercury fish (shark, swordfish), deli meats, excessive caffeine (limit to 200mg/day), alcohol, raw sprouts.'
      },
      {
        'title': 'Hydration',
        'content': 'Drink 8-12 glasses of water daily. Proper hydration prevents constipation, reduces swelling, and maintains amniotic fluid levels.'
      },
      {
        'title': 'Managing Nausea',
        'content': 'Eat small, frequent meals. Try ginger tea, crackers before rising, avoid spicy/fatty foods, and stay hydrated with small sips throughout the day.'
      },
    ];
  }

  List<Map<String, String>> _getExerciseContent() {
    return [
      {
        'title': 'Benefits of Exercise',
        'content': 'Regular exercise reduces back pain, improves mood, promotes better sleep, prepares body for labor, helps manage weight gain, and reduces risk of gestational diabetes.'
      },
      {
        'title': 'Safe Exercises',
        'content': 'Walking, swimming, prenatal yoga, stationary cycling, low-impact aerobics, and pelvic floor exercises (Kegels). Aim for 30 minutes most days.'
      },
      {
        'title': 'Exercises to Avoid',
        'content': 'Contact sports, activities with fall risk, hot yoga, lying flat on back after first trimester, scuba diving, and exercises causing abdominal trauma.'
      },
      {
        'title': 'Warning Signs to Stop',
        'content': 'Stop exercising if you experience: vaginal bleeding, dizziness, chest pain, headache, muscle weakness, calf swelling, contractions, or decreased fetal movement.'
      },
      {
        'title': 'Pelvic Floor Exercises',
        'content': 'Kegel exercises strengthen pelvic muscles. Contract for 5-10 seconds, relax, repeat 10-15 times, 3 times daily. Helps prevent incontinence and aids postpartum recovery.'
      },
    ];
  }

  List<Map<String, String>> _getWarningContent() {
    return [
      {
        'title': '🚨 Call Doctor Immediately',
        'content': 'Vaginal bleeding, severe abdominal pain, sudden swelling of face/hands, severe headache with vision changes, high fever (>101°F), painful urination, decreased fetal movement after 28 weeks.'
      },
      {
        'title': 'Signs of Preterm Labor',
        'content': 'Regular contractions before 37 weeks, lower back pain, pelvic pressure, vaginal discharge changes, cramping similar to menstruation. Call your healthcare provider immediately.'
      },
      {
        'title': 'Preeclampsia Warning Signs',
        'content': 'Severe headaches, vision problems (blurriness, seeing spots), upper right abdominal pain, sudden weight gain, swelling of hands/face. Requires immediate medical attention.'
      },
      {
        'title': 'Gestational Diabetes Risks',
        'content': 'Excessive thirst, frequent urination, fatigue, blurred vision. Screening typically done at 24-28 weeks. Can be managed with diet, exercise, and sometimes medication.'
      },
      {
        'title': 'When to Go to ER',
        'content': 'Heavy bleeding with clots, water breaking before 37 weeks, severe persistent pain, signs of infection with fever, severe swelling with headache, or if you feel something is seriously wrong.'
      },
    ];
  }

  List<Map<String, String>> _getMentalHealthContent() {
    return [
      {
        'title': 'Emotional Changes',
        'content': 'Mood swings are normal due to hormonal changes. You may experience anxiety about pregnancy, delivery, or parenthood. These feelings are common and valid.'
      },
      {
        'title': 'Managing Stress',
        'content': 'Practice deep breathing, prenatal meditation, maintain social connections, get adequate rest, talk about your feelings, and establish a self-care routine.'
      },
      {
        'title': 'Prenatal Depression',
        'content': 'Affects 10-20% of pregnant women. Symptoms: persistent sadness, loss of interest, appetite changes, sleep problems, difficulty concentrating. Seek help if symptoms persist.'
      },
      {
        'title': 'Partner & Family Support',
        'content': 'Communicate your needs clearly, involve partner in pregnancy journey, accept help from family/friends, join support groups, and educate loved ones about pregnancy.'
      },
      {
        'title': 'When to Seek Help',
        'content': 'If you experience: persistent anxiety/sadness lasting 2+ weeks, thoughts of self-harm, difficulty bonding with pregnancy, panic attacks, or inability to function daily.'
      },
    ];
  }

  List<Map<String, String>> _getBabyDevelopmentContent() {
    return [
      {
        'title': 'First Trimester (Weeks 1-12)',
        'content': 'Baby develops major organs, brain, spinal cord, heart begins beating, limbs form, facial features develop. By week 12, baby is about 2.5 inches long.'
      },
      {
        'title': 'Second Trimester (Weeks 13-26)',
        'content': 'Baby starts moving, hearing develops, gender becomes visible on ultrasound, practices breathing movements, develops sleep-wake cycles, grows hair and fingernails.'
      },
      {
        'title': 'Third Trimester (Weeks 27-40)',
        'content': 'Rapid weight gain, lungs mature, brain develops rapidly, bones harden, baby positions head-down for birth, accumulates fat for temperature regulation.'
      },
      {
        'title': 'Fetal Movement',
        'content': 'First movements felt around 18-25 weeks (earlier in second pregnancies). Count kicks after 28 weeks: 10 movements in 2 hours. Decreased movement requires immediate attention.'
      },
      {
        'title': 'Developmental Milestones',
        'content': 'Heartbeat detectable (6 weeks), movement begins (8 weeks), sucking reflex (10 weeks), hearing sounds (18 weeks), eyes open (26 weeks), full-term (39 weeks).'
      },
    ];
  }

  List<Map<String, String>> _getPrenatalCareContent() {
    return [
      {
        'title': 'Regular Checkups Schedule',
        'content': 'Monthly visits until 28 weeks, every 2 weeks until 36 weeks, then weekly until delivery. More frequent visits for high-risk pregnancies.'
      },
      {
        'title': 'Important Tests',
        'content': 'First trimester screening (weeks 11-14), anatomy ultrasound (weeks 18-22), glucose screening (weeks 24-28), Group B strep test (weeks 35-37), regular blood pressure and urine checks.'
      },
      {
        'title': 'Vaccinations',
        'content': 'Tdap vaccine (whooping cough) recommended during each pregnancy at 27-36 weeks. Flu vaccine recommended during flu season. Discuss other vaccines with your provider.'
      },
      {
        'title': 'Birth Plan Preparation',
        'content': 'Discuss pain management options, labor preferences, delivery positions, newborn procedures, breastfeeding plans, and who you want present during delivery.'
      },
      {
        'title': 'Hospital Bag Checklist',
        'content': 'Pack by week 36: ID/insurance cards, comfortable clothes, toiletries, nursing bras, baby clothes, car seat, phone charger, snacks, birth plan copies, entertainment items.'
      },
    ];
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<Map<String, String>> content;

  const DetailPage({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: color,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: content.length,
        itemBuilder: (context, index) {
          final item = content[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ExpansionTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                title: Text(
                  item['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      item['content']!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}