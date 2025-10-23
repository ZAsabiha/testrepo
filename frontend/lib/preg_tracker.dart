import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  List<Map<String, dynamic>> symptoms = [];
  List<Map<String, dynamic>> appointments = [];
  List<Map<String, dynamic>> medications = [];
  Map<String, dynamic> todayMetrics = {
    'weight': '',
    'bloodPressure': '',
    'waterIntake': 0,
    'sleep': 0,
    'mood': '',
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      symptoms = _decodeList(prefs.getString('symptoms'));
      appointments = _decodeList(prefs.getString('appointments'));
      medications = _decodeList(prefs.getString('medications'));
      todayMetrics = json.decode(prefs.getString('todayMetrics') ??
          '{"weight":"","bloodPressure":"","waterIntake":0,"sleep":0,"mood":""}');
    });
  }

  List<Map<String, dynamic>> _decodeList(String? jsonString) {
    if (jsonString == null) return [];
    return List<Map<String, dynamic>>.from(json.decode(jsonString));
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('symptoms', json.encode(symptoms));
    await prefs.setString('appointments', json.encode(appointments));
    await prefs.setString('medications', json.encode(medications));
    await prefs.setString('todayMetrics', json.encode(todayMetrics));
  }

  void _addSymptom() {
    showDialog(
      context: context,
      builder: (context) {
        String symptom = '';
        String severity = 'Mild';
        return AlertDialog(
          title: const Text('Log Symptom'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Symptom'),
                onChanged: (value) => symptom = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: severity,
                decoration: const InputDecoration(labelText: 'Severity'),
                items: ['Mild', 'Moderate', 'Severe'].map((s) =>
                    DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (value) => severity = value ?? 'Mild',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (symptom.isNotEmpty) {
                  setState(() {
                    symptoms.insert(0, {
                      'symptom': symptom,
                      'severity': severity,
                      'date': DateTime.now().toIso8601String(),
                    });
                    _saveData();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addAppointment() {
    showDialog(
      context: context,
      builder: (context) {
        String doctor = '';
        DateTime selectedDate = DateTime.now();
        String notes = '';
        return AlertDialog(
          title: const Text('Add Appointment'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Doctor/Clinic'),
                  onChanged: (value) => doctor = value,
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: Text('Date: ${selectedDate.toString().split(' ')[0]}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) selectedDate = date;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Notes'),
                  onChanged: (value) => notes = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (doctor.isNotEmpty) {
                  setState(() {
                    appointments.add({
                      'doctor': doctor,
                      'date': selectedDate.toIso8601String(),
                      'notes': notes,
                    });
                    _saveData();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _updateMetrics(String key, dynamic value) {
    setState(() {
      todayMetrics[key] = value;
      _saveData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Health Tracker',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: const Color(0xFFFF69B4),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Metrics Card
            _buildCard(
              title: 'Today\'s Metrics',
              child: Column(
                children: [
                  _buildMetricRow(
                    'Weight (kg)',
                    todayMetrics['weight'] ?? '',
                        (value) => _updateMetrics('weight', value),
                  ),
                  _buildMetricRow(
                    'Blood Pressure',
                    todayMetrics['bloodPressure'] ?? '',
                        (value) => _updateMetrics('bloodPressure', value),
                  ),
                  _buildSliderMetric(
                    'Water Intake (glasses)',
                    todayMetrics['waterIntake'] ?? 0,
                    0, 12,
                        (value) => _updateMetrics('waterIntake', value.round()),
                  ),
                  _buildSliderMetric(
                    'Sleep (hours)',
                    todayMetrics['sleep'] ?? 0,
                    0, 12,
                        (value) => _updateMetrics('sleep', value.round()),
                  ),
                  _buildMoodSelector(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Symptoms Log
            _buildCard(
              title: 'Symptoms Log',
              action: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFFFF69B4)),
                onPressed: _addSymptom,
              ),
              child: symptoms.isEmpty
                  ? const Center(child: Text('No symptoms logged'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  final symptom = symptoms[index];
                  return _buildSymptomTile(symptom, index);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Appointments
            _buildCard(
              title: 'Upcoming Appointments',
              action: IconButton(
                icon: const Icon(Icons.add, color: Color(0xFFFF69B4)),
                onPressed: _addAppointment,
              ),
              child: appointments.isEmpty
                  ? const Center(child: Text('No appointments scheduled'))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointments.length,
                itemBuilder: (context, index) {
                  final apt = appointments[index];
                  return _buildAppointmentTile(apt, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, Widget? action, required Widget child}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
                if (action != null) action,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 120,
            child: TextField(
              decoration: InputDecoration(
                hintText: value.isEmpty ? 'Enter' : value,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderMetric(String label, int value, double min, double max,
      Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text('$value', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: value.toDouble(),
            min: min,
            max: max,
            divisions: max.toInt(),
            activeColor: const Color(0xFFFF69B4),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = ['😊', '😐', '😔', '😰', '😴'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Mood Today'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: moods.map((mood) => GestureDetector(
            onTap: () => _updateMetrics('mood', mood),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: todayMetrics['mood'] == mood
                    ? const Color(0xFFFF69B4).withOpacity(0.2)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(mood, style: const TextStyle(fontSize: 24)),
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildSymptomTile(Map<String, dynamic> symptom, int index) {
    return ListTile(
      leading: Icon(_getSeverityIcon(symptom['severity']),
          color: _getSeverityColor(symptom['severity'])),
      title: Text(symptom['symptom']),
      subtitle: Text('${symptom['severity']} - ${_formatDate(symptom['date'])}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          setState(() {
            symptoms.removeAt(index);
            _saveData();
          });
        },
      ),
    );
  }

  Widget _buildAppointmentTile(Map<String, dynamic> apt, int index) {
    return ListTile(
      leading: const Icon(Icons.calendar_today, color: Color(0xFFFF69B4)),
      title: Text(apt['doctor']),
      subtitle: Text('${_formatDate(apt['date'])}\n${apt['notes']}'),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          setState(() {
            appointments.removeAt(index);
            _saveData();
          });
        },
      ),
    );
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'Mild': return Icons.circle;
      case 'Moderate': return Icons.warning;
      case 'Severe': return Icons.error;
      default: return Icons.circle;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'Mild': return Colors.green;
      case 'Moderate': return Colors.orange;
      case 'Severe': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.day}/${date.month}/${date.year}';
  }
}