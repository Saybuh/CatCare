import 'package:flutter/material.dart';

class CareTips extends StatelessWidget {
  const CareTips({super.key});

  final List<Map<String, String>> careTips = const [
    {
      'title': 'Regular Vet Visits',
      'description':
          'Regular check-ups with a veterinarian are essential for maintaining your cat\'s health. Schedule visits at least once a year for vaccinations and health checks.'
    },
    {
      'title': 'Proper Nutrition',
      'description':
          'Provide your cat with a balanced diet appropriate for its age, health, and lifestyle. Consult your vet for recommendations on the best food for your cat.'
    },
    {
      'title': 'Hydration',
      'description':
          'Ensure your cat has access to fresh, clean water at all times. Dehydration can lead to serious health issues.'
    },
    {
      'title': 'Litter Box Maintenance',
      'description':
          'Keep the litter box clean by scooping it daily and changing the litter regularly. A clean litter box encourages good bathroom habits and prevents health issues.'
    },
    {
      'title': 'Grooming',
      'description':
          'Regular grooming helps to prevent matting, reduces shedding, and allows you to check for parasites and skin issues. Brush your cat regularly and trim its nails as needed.'
    },
    {
      'title': 'Mental Stimulation',
      'description':
          'Provide toys, scratching posts, and interactive playtime to keep your cat mentally stimulated and physically active. Rotate toys to keep your cat interested.'
    },
    {
      'title': 'Safe Environment',
      'description':
          'Ensure your home is safe for your cat by keeping hazardous items out of reach. Create a comfortable space with plenty of places to hide and climb.'
    },
    {
      'title': 'Dental Care',
      'description':
          'Oral health is important for cats. Brush your cat\'s teeth regularly with a vet-approved toothpaste, and provide dental treats to help prevent plaque buildup.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Care Tips'),
      ),
      body: ListView.builder(
        itemCount: careTips.length,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(careTips[index]['title']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(careTips[index]['description']!),
              ),
            ],
          );
        },
      ),
    );
  }
}
