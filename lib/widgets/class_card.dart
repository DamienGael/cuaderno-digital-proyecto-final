import 'package:flutter/material.dart';
import '../models/class_model.dart';
import '../views/class_detail_view.dart';

class ClassCard extends StatelessWidget {
  final ClassModel classModel;
  const ClassCard({super.key, required this.classModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(classModel.name),
        subtitle: Text(classModel.subject),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ClassDetailView(classModel: classModel)));
        },
      ),
    );
  }
}
