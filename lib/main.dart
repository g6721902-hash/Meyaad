
import 'package:flutter/material.dart';
import '../main.dart';

class SearchScreen extends StatefulWidget {
  final List<DemoDoctor> doctors;
  final ValueChanged<DemoDoctor> onBook;

  const SearchScreen({
    super.key,
    required this.doctors,
    required this.onBook,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  String specialty = 'الكل';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = controller.text.trim();

    final results = widget.doctors.where((doctor) {
      final matchesSpecialty =
          specialty == 'الكل' || doctor.specialty == specialty;

      final matchesQuery = query.isEmpty ||
          doctor.name.contains(query) ||
          doctor.specialty.contains(query) ||
          doctor.clinic.contains(query);

      return matchesSpecialty && matchesQuery;
    }).toList();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'البحث عن الأطباء',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: meyaadNavy,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'اسم الطبيب أو التخصص أو العيادة',
              prefixIcon: const Icon(
                Icons.search,
                color: meyaadTeal,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 7,
            runSpacing: 6,
            children: [
              'الكل',
              'باطنية',
              'أطفال',
              'أسنان',
              'جلدية',
            ].map((item) {
              return ChoiceChip(
                label: Text(item),
                selected: specialty == item,
                onSelected: (_) {
                  setState(() => specialty = item);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          Text(
            'عدد النتائج: ${results.length}',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 8),
          ...results.map((doctor) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE2F4F2),
                  child: Icon(
                    Icons.medical_services_outlined,
                    color: meyaadTeal,
                  ),
                ),
                title: Text(
                  doctor.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                subtitle: Text(
                  '${doctor.specialty} • ${doctor.clinic}\n'
                  '${doctor.address}\n'
                  'التقييم ${doctor.rating} • ${doctor.fee}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_left),
                onTap: () => widget.onBook(doctor),
              ),
            );
          }),
          if (results.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'ما لقينا طبيب يطابق البحث.',
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
