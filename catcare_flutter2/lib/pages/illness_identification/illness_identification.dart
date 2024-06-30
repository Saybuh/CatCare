import 'package:flutter/material.dart';

class IllnessIdentification extends StatefulWidget {
  @override
  _IllnessIdentificationState createState() => _IllnessIdentificationState();
}

class _IllnessIdentificationState extends State<IllnessIdentification> {
  final List<String> symptoms = [
    'Vomiting',
    'Diarrhea',
    'Lethargy',
    'Loss of Appetite',
    'Coughing',
    'Sneezing',
    'Itching',
    'Weight Loss',
    'Increased Thirst',
    'Frequent Urination',
    'Difficulty Breathing',
    'Swelling/Abscess',
  ];

  final Map<String, List<String>> symptomIllnessMapping = {
    'Vomiting': [
      'Pancreatitis',
      'Kidney Disease',
      'IBD',
      'Hairballs',
      'Diabetes'
    ],
    'Diarrhea': ['Worms', 'IBD', 'FeLV', 'Cancer', 'Hyperthyroidism'],
    'Lethargy': [
      'Diabetes',
      'FeLV',
      'Heart Disease',
      'Cancer',
      'Kidney Disease'
    ],
    'Loss of Appetite': ['Dental Disease', 'Kidney Disease', 'Cancer', 'IBD'],
    'Coughing': ['Heart Disease', 'Asthma', 'Respiratory Infections'],
    'Sneezing': ['Cat Flu', 'Upper Respiratory Infection', 'Allergies'],
    'Itching': ['Fleas', 'Allergies', 'Ringworm', 'Skin Infection'],
    'Weight Loss': ['Hyperthyroidism', 'Diabetes', 'Cancer', 'Kidney Disease'],
    'Increased Thirst': ['Diabetes', 'Kidney Disease', 'Hyperthyroidism'],
    'Frequent Urination': [
      'Diabetes',
      'Kidney Disease',
      'Urinary Tract Infection'
    ],
    'Difficulty Breathing': [
      'Heart Disease',
      'Asthma',
      'Respiratory Infections'
    ],
    'Swelling/Abscess': ['Infections', 'Abscess', 'FeLV'],
  };

  final Map<String, String> illnessDefinitions = {
    'Pancreatitis':
        'Pancreatitis is inflammation of the pancreas and can cause vomiting and abdominal pain.',
    'Kidney Disease':
        'Kidney disease is a common condition in older cats and can cause increased thirst and urination.',
    'IBD':
        'Inflammatory bowel disease (IBD) is a group of chronic gastrointestinal disorders.',
    'Hairballs':
        'Hairballs are clumps of fur that can form in a cat’s stomach and cause vomiting.',
    'Diabetes':
        'Diabetes is a condition where the body cannot properly produce or respond to insulin.',
    'Worms':
        'Worms are intestinal parasites that can cause weight loss and a bloated stomach.',
    'FeLV':
        'Feline leukemia virus (FeLV) is a retrovirus that causes immunosuppression and can lead to cancer.',
    'Cancer':
        'Cancer is the uncontrolled growth of cells that can affect various parts of the body.',
    'Hyperthyroidism':
        'Hyperthyroidism is an overproduction of thyroid hormones, leading to weight loss and hyperactivity.',
    'Dental Disease':
        'Dental disease includes conditions such as gingivitis and periodontal disease.',
    'Heart Disease':
        'Heart disease encompasses various conditions affecting the heart’s function.',
    'Asthma':
        'Asthma is a condition that affects the airways and causes difficulty breathing.',
    'Respiratory Infections':
        'Respiratory infections can cause symptoms like coughing and sneezing.',
    'Cat Flu':
        'Cat flu is a common term for upper respiratory infections in cats.',
    'Allergies': 'Allergies can cause symptoms such as itching and sneezing.',
    'Ringworm':
        'Ringworm is a fungal infection that affects the skin and causes circular patches of hair loss.',
    'Skin Infection': 'Skin infections can cause itching and redness.',
    'Urinary Tract Infection':
        'A urinary tract infection (UTI) causes frequent urination and discomfort.',
    'Infections':
        'Infections can be caused by bacteria, viruses, or fungi and lead to various symptoms.',
    'Abscess':
        'An abscess is a collection of pus that can form under the skin.',
  };

  List<String> selectedSymptoms = [];
  List<String> potentialIllnesses = [];

  void _updatePotentialIllnesses() {
    potentialIllnesses.clear();

    for (String symptom in selectedSymptoms) {
      if (symptomIllnessMapping.containsKey(symptom)) {
        potentialIllnesses.addAll(symptomIllnessMapping[symptom]!);
      }
    }

    potentialIllnesses =
        potentialIllnesses.toSet().toList(); // Remove duplicates
  }

  void _showIllnessDefinition(String illness) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(illness),
          content:
              Text(illnessDefinitions[illness] ?? 'No definition available.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text('Illness Identification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Symptoms:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: symptoms.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(symptoms[index]),
                    value: selectedSymptoms.contains(symptoms[index]),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedSymptoms.add(symptoms[index]);
                        } else {
                          selectedSymptoms.remove(symptoms[index]);
                        }
                        _updatePotentialIllnesses();
                      });
                    },
                  );
                },
              ),
            ),
            Divider(),
            Text(
              'Potential Illnesses:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: potentialIllnesses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(potentialIllnesses[index]),
                    onTap: () =>
                        _showIllnessDefinition(potentialIllnesses[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
