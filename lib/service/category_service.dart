import 'package:appfp_task_manager/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categorysCollection =
      FirebaseFirestore.instance.collection('category');

  // 所有類別
  Future<List<Category>> getCategorys() async {
    try {
      final querySnapshot = await _categorysCollection.get();

      return querySnapshot.docs
          .map((doc) =>
              Category.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error service getCategorys: $e');
      return [];
    }
  }
}
