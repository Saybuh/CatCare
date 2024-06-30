import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FoodSchedule extends StatefulWidget {
  @override
  _FoodScheduleState createState() => _FoodScheduleState();
}

class _FoodScheduleState extends State<FoodSchedule> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCatId = '';
  String _selectedMealType = 'Breakfast';
  List<Map<String, dynamic>> _cats = [];
  bool _isCalendarView = false;

  @override
  void initState() {
    super.initState();
    _fetchCats();
  }

  void _fetchCats() async {
    QuerySnapshot snapshot = await _firestore.collection('cats').get();
    List<Map<String, dynamic>> cats = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'] ?? 'Unknown',
      };
    }).toList();

    setState(() {
      _cats = cats;
    });
  }

  void _addOrUpdateFeedingTime(String? id) async {
    if (_selectedCatId.isEmpty) {
      return;
    }

    final feedingTimeData = {
      'catId': _selectedCatId,
      'time': _selectedTime.format(context),
      'mealType': _selectedMealType,
    };

    if (id == null) {
      await _firestore.collection('feeding_times').add(feedingTimeData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feeding time added successfully')));
    } else {
      await _firestore
          .collection('feeding_times')
          .doc(id)
          .update(feedingTimeData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feeding time updated successfully')));
    }

    Navigator.of(context).pop();
  }

  void _removeFeedingTime(String id) async {
    await _firestore.collection('feeding_times').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feeding time removed successfully')));
  }

  void _showFeedingTimeModal(BuildContext context,
      {String? id, String? catId, String? time, String? mealType}) {
    if (id != null) {
      _selectedCatId = catId ?? '';
      _selectedTime = time != null
          ? TimeOfDay.fromDateTime(DateFormat.jm().parse(time!))
          : TimeOfDay.now();
      _selectedMealType = mealType ?? 'Breakfast';
    } else {
      _selectedCatId = '';
      _selectedTime = TimeOfDay.now();
      _selectedMealType = 'Breakfast';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCatId.isNotEmpty ? _selectedCatId : null,
                  items: _cats.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['id'],
                      child: Text(cat['name']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCatId = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Cat'),
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _selectedMealType,
                  items:
                      ['Breakfast', 'Lunch', 'Dinner'].map((String mealType) {
                    return DropdownMenuItem<String>(
                      value: mealType,
                      child: Text(mealType),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMealType = value!;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Meal Type'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null && picked != _selectedTime) {
                      setState(() {
                        _selectedTime = picked;
                      });
                    }
                  },
                  child: Text('Select Time'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _addOrUpdateFeedingTime(id);
                  },
                  child: Text(
                      id == null ? 'Add Feeding Time' : 'Update Feeding Time'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Schedule'),
        actions: [
          IconButton(
            icon: Icon(_isCalendarView ? Icons.list : Icons.calendar_today),
            onPressed: () {
              setState(() {
                _isCalendarView = !_isCalendarView;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('feeding_times').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final feedingTimes = snapshot.data!.docs;

          if (_isCalendarView) {
            return _buildCalendarView(feedingTimes);
          } else {
            return _buildListView(feedingTimes);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFeedingTimeModal(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> feedingTimes) {
    return ListView.builder(
      itemCount: feedingTimes.length,
      itemBuilder: (context, index) {
        final feedingTime = feedingTimes[index];
        final feedingData = feedingTime.data() as Map<String, dynamic>;

        final cat = _cats.firstWhere((cat) => cat['id'] == feedingData['catId'],
            orElse: () => {'name': 'Unknown'});

        return Card(
          child: ListTile(
            title: Text('${cat['name']} - ${feedingData['time']}'),
            subtitle: Text(feedingData['mealType'] ?? 'Unknown'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showFeedingTimeModal(
                      context,
                      id: feedingTime.id,
                      catId: feedingData['catId'],
                      time: feedingData['time'],
                      mealType: feedingData['mealType'],
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeFeedingTime(feedingTime.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView(List<QueryDocumentSnapshot> feedingTimes) {
    Map<String, List<Map<String, dynamic>>> dailySchedules = {};

    for (var feedingTime in feedingTimes) {
      final feedingData = feedingTime.data() as Map<String, dynamic>;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (!dailySchedules.containsKey(date)) {
        dailySchedules[date] = [];
      }

      dailySchedules[date]!.add({...feedingData, 'id': feedingTime.id});
    }

    return ListView.builder(
      itemCount: dailySchedules.length,
      itemBuilder: (context, index) {
        final date = dailySchedules.keys.elementAt(index);
        final schedules = dailySchedules[date]!;

        return ExpansionTile(
          title: Text('Schedule for $date'),
          children: schedules.map((feedingData) {
            final cat = _cats.firstWhere(
                (cat) => cat['id'] == feedingData['catId'],
                orElse: () => {'name': 'Unknown'});

            return ListTile(
              title: Text('${cat['name']} - ${feedingData['time']}'),
              subtitle: Text(feedingData['mealType'] ?? 'Unknown'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showFeedingTimeModal(
                        context,
                        id: feedingData['id'],
                        catId: feedingData['catId'],
                        time: feedingData['time'],
                        mealType: feedingData['mealType'],
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeFeedingTime(feedingData['id']),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
