import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WaterSchedule extends StatefulWidget {
  @override
  _WaterScheduleState createState() => _WaterScheduleState();
}

class _WaterScheduleState extends State<WaterSchedule> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedCatId = '';
  String _selectedAmount = '';
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

  void _addOrUpdateWateringTime(String? id) async {
    if (_selectedCatId.isEmpty || _selectedAmount.isEmpty) {
      return;
    }

    final wateringTimeData = {
      'catId': _selectedCatId,
      'time': _selectedTime.format(context),
      'amount': _selectedAmount,
    };

    if (id == null) {
      await _firestore.collection('watering_times').add(wateringTimeData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Watering time added successfully')));
    } else {
      await _firestore
          .collection('watering_times')
          .doc(id)
          .update(wateringTimeData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Watering time updated successfully')));
    }

    Navigator.of(context).pop();
  }

  void _removeWateringTime(String id) async {
    await _firestore.collection('watering_times').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Watering time removed successfully')));
  }

  void _showWateringTimeModal(BuildContext context,
      {String? id, String? catId, String? time, String? amount}) {
    if (id != null) {
      _selectedCatId = catId ?? '';
      _selectedTime = time != null
          ? TimeOfDay.fromDateTime(DateFormat.jm().parse(time!))
          : TimeOfDay.now();
      _selectedAmount = amount ?? '';
    } else {
      _selectedCatId = '';
      _selectedTime = TimeOfDay.now();
      _selectedAmount = '';
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
                TextField(
                  decoration:
                      InputDecoration(labelText: 'Amount of Water (ml)'),
                  onChanged: (value) {
                    _selectedAmount = value;
                  },
                  controller: TextEditingController(
                      text: _selectedAmount), // Pre-fill with current amount
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
                    _addOrUpdateWateringTime(id);
                  },
                  child: Text(id == null
                      ? 'Add Watering Time'
                      : 'Update Watering Time'),
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
        title: Text('Water Schedule'),
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
        stream: _firestore.collection('watering_times').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final wateringTimes = snapshot.data!.docs;

          if (_isCalendarView) {
            return _buildCalendarView(wateringTimes);
          } else {
            return _buildListView(wateringTimes);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWateringTimeModal(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildListView(List<QueryDocumentSnapshot> wateringTimes) {
    return ListView.builder(
      itemCount: wateringTimes.length,
      itemBuilder: (context, index) {
        final wateringTime = wateringTimes[index];
        final wateringData = wateringTime.data() as Map<String, dynamic>;

        final cat = _cats.firstWhere(
            (cat) => cat['id'] == wateringData['catId'],
            orElse: () => {'name': 'Unknown'});

        return Card(
          child: ListTile(
            title: Text('${cat['name']} - ${wateringData['time']}'),
            subtitle: Text('Amount: ${wateringData['amount']} ml'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showWateringTimeModal(
                      context,
                      id: wateringTime.id,
                      catId: wateringData['catId'],
                      time: wateringData['time'],
                      amount: wateringData['amount'],
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _removeWateringTime(wateringTime.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendarView(List<QueryDocumentSnapshot> wateringTimes) {
    Map<String, List<Map<String, dynamic>>> dailySchedules = {};

    for (var wateringTime in wateringTimes) {
      final wateringData = wateringTime.data() as Map<String, dynamic>;
      final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

      if (!dailySchedules.containsKey(date)) {
        dailySchedules[date] = [];
      }

      dailySchedules[date]!.add({...wateringData, 'id': wateringTime.id});
    }

    return ListView.builder(
      itemCount: dailySchedules.length,
      itemBuilder: (context, index) {
        final date = dailySchedules.keys.elementAt(index);
        final schedules = dailySchedules[date]!;

        return ExpansionTile(
          title: Text('Schedule for $date'),
          children: schedules.map((wateringData) {
            final cat = _cats.firstWhere(
                (cat) => cat['id'] == wateringData['catId'],
                orElse: () => {'name': 'Unknown'});

            return ListTile(
              title: Text('${cat['name']} - ${wateringData['time']}'),
              subtitle: Text('Amount: ${wateringData['amount']} ml'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showWateringTimeModal(
                        context,
                        id: wateringData['id'],
                        catId: wateringData['catId'],
                        time: wateringData['time'],
                        amount: wateringData['amount'],
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeWateringTime(wateringData['id']),
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
