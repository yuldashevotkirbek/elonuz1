import 'package:flutter/material.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tips = <String>[
      'Ekran vaqtini 2-3 soatga cheklang va dam oling.',
      'Har kuni 6-8 ming qadam maqsad qiling.',
      'Uxlashdan 1 soat oldin ekranlardan uzoqlashing.',
      'Suv ichishni unutmang va qisqa tanaffuslar qiling.',
      'Tongda quyosh nuri uyqu siklini yaxshilaydi.',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Tavsiyalar')),
      body: ListView.separated(
        itemCount: tips.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.check_circle_outline),
          title: Text(tips[index]),
        ),
      ),
    );
  }
}

